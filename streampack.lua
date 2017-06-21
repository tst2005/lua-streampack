
pcall(require,"rand")

local function decode(data, marklen, out)
	if type(data) ~= "string" then
		data = tostring(data)
	end
local marks = {}
	marklen = marklen or 1
	out = out or {}
	local function getsegment_from(data, pos, marklen)
		local mark = data:sub(pos, pos+marklen-1)
marks[#marks+1]=mark
		local b, e = string.find(data, mark, pos+marklen, true)
		if not b or not e then
			return nil, pos
		end
		return string.sub(data, (pos or 1)+marklen, b-1), e
	end
	local segment
	local pos = 1
	while pos < #data do
		segment, pos = getsegment_from(data, pos, marklen)
		if not segment then break end
		table.insert(out, segment)
		pos=pos+1
	end
	if pos < #data then
		out.trailing = data:sub(pos,-1)
	end
out.marks=marks
	setmetatable(out, {__tostring=function(self) return table.concat(self,"") end})
	return out, pos
end



-- simple random mark
local function newmark_rand(alphabet, marklen)
	local mark = ""
	local n
	local rand = math.random
	for i=1,assert(marklen) do
		n = rand(1,#alphabet)
		mark = mark .. alphabet:sub(n,n)
	end
	return mark
end
local function safe_newmark_rand(alphabet, marklen, nomark)
	if not nomark or #nomark < 1 then
		return newmark_rand(alphabet, marklen)
	end
	local nochar = nomark:sub(1,1)
	local safealphabet = alphabet:gsub(".", function(c) return (c == nochar) and "" or c end)
	if not(#safealphabet > 0 and (#safealphabet == #alphabet-1)) then print("safealphabet=", safealphabet, "alphabet", alphabet, "nomark=", nomark, "nochar=", nochar) end
	assert(#safealphabet > 0 and (#safealphabet == #alphabet-1))
	return newmark_rand(safealphabet, 1)..newmark_rand(alphabet, marklen-1)
end


local function encode(data, marklen, alphabet, debug)
	assert(marklen, "missing marklen")
	local r = {}
	local pos = 1
	local table_insert = table.insert
	while true do
		-- begin of segment is the forbidden mark value
		local nomark = data:sub(pos,pos+marklen-1)

		-- get a new random mark
		local mark
--		for try=1,10 do
			mark = safe_newmark_rand(alphabet, marklen, nomark)
--print("mark=", mark, "nomark=", nomark)
--			if mark~=nomark then break end
--			if try > 1 then
--				print("safe fail")
--			end
--		end
		assert(#mark == marklen, "internal error, the generated mark does not fit the expected size")
		assert(not(mark==nomark), "unable to get a appropriate mark")
		-- simple find the mark on data segment
		local b = mark.find(data, mark, pos, true)

		-- if the simple find didn't match, try harder
		-- there exists some issue with marklen >1
		if not b and marklen >= 2 then
			-- the issue only happens at the end of the data
			-- when the begining of the mark and the end of data are the same
			-- data = "abcde" with mark = "ee"
			-- detect bug of "ee".."abcde".."ee" => decode will cut mark "abcd" mark "e"
			local data2 = data..mark
			local b2 = mark.find(data2, mark, pos, true)
			assert(b2)
			if b2 <= #data then -- bug detected, the mark will be decoded into the data
--print("bug detected and fixed")
				b = b2

				-- extract the reminding data part...
				local partial = data:sub(pos, -1):sub(-marklen,-1) -- get the last marklen-th chars of data
				local b2 = (partial..mark):find(mark, nil, true)
				assert(b2) -- should always match
				if b2 <= marklen then -- the beginning of mark is inside the data not at the expected position
					local b3 = #data -#partial +b2
					if b ~= b3 then
						print("fix1", b, "fix2", b3)
						print("data=", data)
						print("mark=", mark)
						print("partial=", partial)
						print("b2", b2)
					end
				end
			end
		end

		--for debug:
		if debug then mark = debug(mark) end

		table_insert(r, mark)
		table_insert(r, data:sub(pos,not b and -1 or (b-1)) )
		table_insert(r, mark)
		pos=b
		if not pos then break end
	end
	setmetatable(r,{__tostring=function(self) return table.concat(self,"") end})
	return r
end

return {
	decode = decode,
	encode = encode,
}
