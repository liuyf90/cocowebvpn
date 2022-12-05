--[[
    @author liuyf
    Time: Dec 4, 2022 at 13:20

    init data
--]]

local _M = {} 
local data = { 
    casport = 7777, 
} 
function _M.get(name) 
  return data[name] 
end 

return _M


