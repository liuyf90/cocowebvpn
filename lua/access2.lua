--[[
    @author liuyf
    Time:Nov 22, 2022 at 09:35

    this is proxy transition section,It loops http in ips and translates to proxy address
--]]


local ips = ngx.shared.ips
local ip = ngx.var.remote_addr


-- this is target ip or domainName ,proxy these in here 
if ips:get(ip) then
    ngx.var.proxy = '218.9.68.192:8093'
    ngx.req.read_body() --will be directly forwarded to the subrequest without copying the whole request body data when creating the subrequest
    local req = require "lua.lib.req"
    req.print_req_headers()
end




