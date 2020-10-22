
-- convert a string data to a file descriptor
local function str2fd(data)
	data = data or ""
        local fd = {pos=1}
        function fd:read(len)
                local pos = self.pos
                local seg = data:sub(pos,pos+len-1)
                self.pos=pos+#seg
                return seg
        end
        function fd:read_until(mark)
--print("find", mark, "in", data, "after", self.pos)
                local b,e = data:find(mark, self.pos, true)
                assert(b, "read_until: mark not found (mark="..mark..")")
                -- XXXXXXX MARK YYYY
                --         b  e
                local seg = data:sub(self.pos, b-1)
                local markfound = data:sub(b, e)
                self.pos = e+1
                return seg, markfound
        end
        function fd:seek(whence, offset)
                if whence == nil and offset == nil then
                        return self.pos-1
                end
                if whence == "set" and offset == 0 then
                        self.pos = offset+1
                        return self.pos-1
                end
                error("unsupported/unimplemented seek request")
        end
	function fd:append(newdata)
		assert(type(newdata)=="string")
		data = data .. newdata
	end
	function fd:dump()
		return data
	end
        return fd
end

return str2fd
