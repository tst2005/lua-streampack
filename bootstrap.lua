#!/usr/bin/env lua

local len = function(x) return #x end

local read, read_until
do
	local str2fd = require "str2fd"

	local _data_ = io.stdin:read("*a"):gsub("(.-)%-%-[^\n]-\n","%1\n") :gsub("%s+","")
--	print(_data_)
	local fd = str2fd(_data_)


	function read(n)
		return fd:read(n)
	end

	function read_until(value)
print("", "debug:", fd:seek(), value, fd:dump())
		return fd:read_until(value)
	end
end

local mark1=read(1)
local value=''

local function getthenewmark(lastmark)
	local bootstrap = true

	while bootstrap do
		value=read_until(lastmark)
		if len(value) <= len(lastmark) then
			bootstrap = false
		end
		lastmark=value
	end
	return lastmark
end
local function getthenewmark_simple(lastmark)
	return read(len(lastmark))
end

mark1 = getthenewmark(mark1)
-----------------------------
print("ENJOY mark1 found is", mark1)
-- ENJOY, we have the mark1 !
-----------------------------

--local v1 = read_until(mark)
--print("ENJOY value is", v1)

local context = {}

local mark

while true do
	mark = getthenewmark_simple(mark1)
	if mark == mark1 then
		print("mark1 found, stop context")
		break
	end
	mark = read_until(mark)
	context[#context+1]=read_until(mark, context)
	print("context size:", #context)
end

print("context:", table.concat(context, " ; "))
