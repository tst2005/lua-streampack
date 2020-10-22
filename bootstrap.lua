#!/usr/bin/env lua

local len = function(x) return #x end

local read, read_until
do
	local str2fd = require "str2fd"

	local _data_ = io.stdin:read("*a"):gsub("%s+","")
	local fd = str2fd(_data_)


	function read(n)
		return fd:read(n)
	end

	function read_until(value)
print(fd:seek(), value, fd:dump())
		return fd:read_until(value)
	end
end

local mark=read(1)
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

mark = getthenewmark(mark)

print("ENJOY mark found is", mark)
-- ENJOY, we have the mark !
----------------------------


local v1 = read_until(mark)
print("ENJOY value is", v1)

--local function getthenewmark(lastmark)
--	return read(len(lastmark))
--end
local newmark = getthenewmark

----------------------------

--[[

local context = {}

local CLOSE = read_until(mark, context)
context[1]=CLOSE
mark = newmark(mark)

local NEXT = read_until(mark, context)
context[2]=NEXT
mark = newmark(mark)

local SUB = read_until(mark, context)
context[3]=SUB
mark = newmark(mark)
]]--
