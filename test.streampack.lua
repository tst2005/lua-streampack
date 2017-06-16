local decode = require "streampack".decode

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
