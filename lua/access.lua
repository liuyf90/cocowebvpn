--[[
    @author liuyf
    Time:Nov 5, 2022 at 09:35

    this is proxy transition section,It loops http in ips and translates to proxy address
--]]


local black_list = {
    ["192.168.1.101"] = true,
    ["192.168.1.102"] = true,
    ["192.168.1.103"] = true,
    ["192.168.1.104"] = true,
    --["127.0.0.1"] = true,
}

local ip = ngx.var.remote_addr

if black_list[ip] then
    return ngx.exit(ngx.HTTP_FORBIDDEN)
end

