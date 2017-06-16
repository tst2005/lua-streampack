

local function getsegment_from(data, pos, marklen)
	local mark = data:sub(pos, pos+marklen-1)
--print("mark=", mark)
	local b, e = string.find(data, mark, pos+marklen, true)
	if not b or not e then
		return nil, pos
	end
	return string.sub(data, (pos or 1)+marklen, b-1), e
end



local function decode(data, marklen, out)
	marklen = marklen or 1
	out = out or {}
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

for _, data in ipairs{"AbbABcccB", "AbbABcccBCC"} do
	local t,pos = decode( data )
	print(require"mini.tprint.better"(t,{inline=false}))
end
for _, data in ipairs{"AAbbAABBcccBB", "AbbAbBcccBcCxx"} do
	local t,pos = decode( data, 2 )
	if pos<#data then
		t.trailing = data:sub(pos,-1)
	end
	print(require"mini.tprint.better"(t,{inline=false}))
end
