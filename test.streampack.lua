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

for marklen = 1,3 do
	local x = encode(w, marklen, alphabet)
	local y = decode(x, marklen)
	--print(x)
	--for k,v in pairs(y) do print(k,v)end

	assert(tostring(y) == w)
end
print("OK")
