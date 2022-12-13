--[[
    @author liuyf
    Time: Dec 4, 2022 at 13:20

    init data
--]]

local _M = {} 
local data = { 
    casport = 7777, --代理的cas端口号
    domainName = 'proxyman.com:8888', --busi模块的servername
    cas = "ids.hrbfu.edu.cn" --cas服务的原始地址
} 
function _M.get(name) 
  return data[name] 
end 

return _M

