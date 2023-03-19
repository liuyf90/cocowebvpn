--[[
    @author liuyf
    Time: Dec 4, 2022 at 13:20

    init data
--]]

local _M = {} 
local data = { 
    casport = 7777, --代理的cas端口号
    --domainName = 'proxyman.com:8888', --busi模块的servername
<<<<<<< HEAD
    domainName = 'webvpn2.hrbfu.edu.cn', --busi模块的servername
=======
    domainName = 'proxyman.com', --busi模块的servername
>>>>>>> a542e94bf21249f2112f7525465ff1025f2c6250
    cas = "ids.hrbfu.edu.cn"
} 
function _M.get(name) 
  return data[name] 
end 

return _M


