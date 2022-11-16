--[[
    @author liuyf
    Time:Nov 5, 2022 at 09:35

    this is proxy transition section,It loops http in ips and translates to proxy address
--]]


local ips = ngx.shared.ips
local ip = ngx.var.remote_addr
local url = "/download_server"..ngx.var.request_uri
ngx.log(ngx.INFO,"****url****="..url)

local function proxy_to()
    local res = ngx.location.capture(url,
             { copy_all_vars = true,always_forward_body = true })
    ngx.log(ngx.INFO,"localtion.capture status: "..res.status)
    for k, v in pairs(res.header) do
           ngx.header[k] = v
    end
    --if res.status ~= ngx.HTTP_OK then
  
    --    ngx.log(ngx.INFO, "get sub_rquest res.status:"..res.status)
    --    ngx.say('Failed to process, please try again in some minutes.')
    --    ngx.exit(403)
    --end
   ngx.say(res.body)
end

-- this is target ip or domainName ,proxy these in here 
if ips:get(ip) then
    proxy_to()
    ngx.log(ngx.INFO, "access-proxy-ip: "..ngx.var.proxy)
    ngx.req.read_body() --will be directly forwarded to the subrequest without copying the whole request body data when creating the subrequest
    local req = require "lua.lib.req"
    req.print_req_headers()

end




