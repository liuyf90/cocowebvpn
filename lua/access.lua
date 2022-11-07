--[[
    @author liuyf
    Time:Nov 5, 2022 at 09:35

    this is proxy transition section,It loops http in ips and translates to proxy address
--]]


local ips = ngx.shared.ips
local ip = ngx.var.remote_addr
if ips:get(ip) then
    return ngx.exit(ngx.HTTP_FORBIDDEN)
end

