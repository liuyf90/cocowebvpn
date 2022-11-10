--[[
    @author liuyf
    Time:Nov 5, 2022 at 09:35

    this is proxy transition section,It loops http in ips and translates to proxy address
--]]


local ips = ngx.shared.ips
local ip = ngx.var.remote_addr
local function proxy_to()
    local res = ngx.location.capture("/download_server",
             { share_all_vars = true });
    if res.status ~= ngx.HTTP_OK then
    ngx.log(ngx.INFO, "get sub_rquest res.status:"..res.status)
        ngx.say('Failed to process, please try again in some minutes.')
        ngx.exit(403);
    end
    ngx.print(res.body)
end


-- this is target ip or domainName ,proxy these in here 
if ips:get(ip) then
    ngx.var.proxy = "127.0.0.1:7777"--..ngx.var.uri
    ngx.log(ngx.INFO, "access-proxy-ip: "..ngx.var.proxy)
    proxy_to()
end

