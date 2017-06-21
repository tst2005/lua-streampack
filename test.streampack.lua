local sp = require "streampack"
local decode,encode = sp.decode,sp.encode

--[[
for _, data in ipairs{"AbbABcccB", "AbbABcccBCC"} do
	local t,pos = decode( data )
	print(data)
	print(require"mini.tprint.better"(t,{inline=false}))
end
for _, data in ipairs{"AAbbAABBcccBB", "AbbAbBcccBcCxx"} do
	local t,pos = decode( data, 2 )
	if pos<#data then
		t.trailing = data:sub(pos,-1)
	end
	print(data)
	print(require"mini.tprint.better"(t,{inline=false}))
end
]]--
--print(encode("foo", 1, "AB"))
--print(encode("abcdeabcde", 2, "abcde", function(mark) return "["..mark.."]" end))

local alphabet = "abcde"
local w = "abcdeabcde"

local marklen = 3
for _loop = 1,1000000 do
	local x = encode(w, marklen, alphabet)
	local y = decode(x, marklen)
	--print(x)

	if tostring(y) ~= w then
		print("--------")
		print("try to encode", w)
		print("---- encoded: ----")
		print(x)
		print("----")
		for i,v in ipairs(y) do
			print(i,v, "mark=", y.marks[i])
		end
		print("trailing:", y.trailing or "NO")
		print("y", tostring(y))
		print("w", w)
		print("---- ERROR ----")
		os.exit(1)
	end
	--assert(tostring(y) == w)
end
--print("OK")
