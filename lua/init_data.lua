--[[
    @author liuyf
    Time: Dec 4, 2022 at 13:20

    init data
--]]

local _M = {} 
local data = { 
    casport = 7777, --代理的cas端口号
    --domainName = 'proxyman.com:8888', --busi模块的servername
    domainName = 'webvpn2.hrbfu.edu.cn', --busi模块的servername
    cas = "ids.hrbfu.edu.cn"
} 
function _M.get(name) 
  return data[name] 
end 

return _M


