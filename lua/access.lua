--[[
    @author liuyf
    Time:Nov 22, 2022 at 09:35

    this is proxy transition section,It loops http in ips and translates to proxy address
--]]


local ips = ngx.shared.ips
--local ip = ngx.var.remote_addr
local web="my.webvpn.com"



local function proxy_to()
    local req = require "lua.lib.req"
    req.set_req_headers()
    ngx.exec('@download_server')    
    return ngx.exit(ngx.status)
end


local keys = ips:get_keys(0)
--ngx.log(ngx.ALERT,"*****keys="..table.concat(keys))

local cjson = require "cjson"
ngx.req.read_body() --will be directly forwarded to the subrequest without copying the whole request body data when creating the subrequest

-- sub_json's  data like "sadd ips:url '{"oa.webvpn.com":{"url":"10.49.2.5","port":"8080","web":"oa.web.com"}}'"
for _,v in ipairs(keys) do
    local json = cjson.decode(v)
    local sub_json=cjson.decode(json)
    local t = sub_json["oa.webvpn.com"] 
    --ngx.log(ngx.ALERT,"*****$sub_json:"..type(sub_json))
    --ngx.log(ngx.ALERT,"*****$proxy="..t.web)
    if t then
           --ngx.var.proxy = 'oa.hrbfu.edu.cn'
           --proxy_to()
           --capture domainName form t.web
           local captures, err =ngx.re.match(t.web,"[^/]+","jo")
           if captures then
               local domainName= captures[0]
               --ngx.log(ngx.ALERT,"*****$domainName="..domainName)
               ngx.var.proxy = domainName
               proxy_to()
           else
               if err then
                   ngx.log(ngx.ERR, "error: ", err)
                   return
               end
           end           
    end
end







