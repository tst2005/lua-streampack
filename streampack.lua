
pcall(require,"rand")

local function decode(data, marklen, out)
	marklen = marklen or 1
	out = out or {}
	local function getsegment_from(data, pos, marklen)
		local mark = data:sub(pos, pos+marklen-1)
--print("mark=", mark)
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
	return out, pos
end



-- 123456789
-- ABCDEFHGI
--  12345678
-- !D  <=> !4
-- 3

-- 123_56789
-- 4 => 9 ?

local function newmark1_for_segment(alphabet, no_char)
	local b = no_char and no_char.find(alphabet, no_char, nil, true) -- support no_char to be a special utf8 object with utf8 find method...
	local setlen = #alphabet
	if b then
		setlen = setlen -1
	end
	local n = math.random(1,setlen)
--print("rand[1.."..setlen.."]", n)
	if b and n >= b then
		n = n+1
	end
--print("n:",n) 
	return alphabet:sub(n,n), b
end

local function newmark_for_segment(alphabet, nomark, marklen)
	local collision = true
	local mark = ""
	for i=1,marklen do
		local no_char = nomark:sub(i,i)
		local c,b = newmark1_for_segment(alphabet, no_char)
		if c and (not b or c ~= no_char) then
			collision = false
		end
		mark = mark..(c or "")
	end
	return not collision, mark
end

local function newmark_for_segment(alphabet, nomark, marklen)
	local mark = ""
	local c,b
	for i=1,marklen do
		c,b = newmark1_for_segment(alphabet, nil)
		mark = mark..(c or "")
	end
	assert(#mark==marklen, "wrong size for mark, expected "..marklen.." got "..#mark)
	return not (mark==nomark), mark, b
end

local function table_inserts(t, a, ...)
	table.insert(t, a)
	if ... then
		return table_inserts(t, ...)
	end
	return t
end


local function newmark_rand(alphabet)
	local n = math.random(1,#alphabet)
	return alphabet:sub(n,n)
end


local function encode(data, alphabet, marklen)
	local r = {}
	local pos = 1
	while true do
		-- begin of segment is the forbidden mark value
		local nomark = data:sub(pos,pos+marklen-1)

		-- get a new random mark
		local mark = newmark_rand(alphabet, marklen)
		print("mark=", mark, "nomark=", nomark)
		assert(#mark == marklen)
		assert(not(mark==nomark), "the mark is the forbidden one")

		-- find the mark on data segment
		local b = mark.find(data, mark, pos, true)

		--for debug:
		mark=mark:upper()
		table_inserts(r, mark, data:sub(pos,not b and -1 or (b-1)), mark)
		pos=b
		if not pos then break end
	end
	return table.concat(r,"")
end
do
	print(encode("abcdeabcde", "abcde", 1))
end

return {
	decode = decode,
	encode = encode,
}
