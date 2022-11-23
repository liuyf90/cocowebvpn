--[[
    @author liuyf
    Time:Nov 5, 2022 at 09:35

    this is proxy transition section,It loops http in ips and translates to proxy address
--]]


local ips = ngx.shared.ips
local ip = ngx.var.remote_addr
local url = "/download_server"..ngx.var.request_uri
local my_scheme='http'
local my_host='proxy.com:8888'
local ziel= my_scheme.."://"..my_host
ngx.log(ngx.INFO,"****url****="..url)

local function proxy_to()
    local map = {
        GET = ngx.HTTP_GET,
        POST = ngx.HTTP_POST,
    }
    local res = ngx.location.capture('/redirect_checker',
    {method = map[ngx.var.request_method], body = ngx.var.request_body})
    ngx.log(ngx.INFO,"localtion.capture status: "..res.status)
    --set sub restquest header
    for k, v in pairs(res.header) do
        ngx.header[k] = v
    end

    --Detect/change redirect
    local redirect_target = res.header.Location
    if redirect_target and res.status > 300 and res.status <309 then
        ngx.log(ngx.ALERT,'redirect_target:'..redirect_target)
        local redirect_target_changed,n,err=ngx.re.gsub(redirect_target, '^https?[:][/][/][^/]+', ziel)
        ngx.log(ngx.ALERT, 'redirect_target_changed: '..redirect_target_changed)
        return ngx.redirect(redirect_target_changed, 303)
    elseif res.status == 500 then
        return ngx.exit(500)
    else
        ngx.exec('@download_server')
        return ngx.exit(ngx.HTTP_OK)
    end

end

   --ngx.say(res.body)

-- this is target ip or domainName ,proxy these in here 
if ips:get(ip) then
    ngx.var.proxy = '218.9.68.192:8093'
    ngx.log(ngx.INFO, "access-proxy-ip: "..ngx.var.proxy)
    ngx.req.read_body() --will be directly forwarded to the subrequest without copying the whole request body data when creating the subrequest
    local req = require "lua.lib.req"
    req.print_req_headers()
    req.set_req_body_data()
    proxy_to()

end




