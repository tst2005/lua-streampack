local str2fd = require "str2fd"

local a = str2fd("abcd")
assert(a:read(1)=="a")
assert(a:read(2)=="bc")
a:append("ef")
assert(a:read(4)=="def")
assert(a:read(1)=="")
