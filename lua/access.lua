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
--    return ngx.exit(ngx.HTTP_OK)
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
    if t then
         --ngx.var.proxy = t.url..':'..t.port  
--         ngx.var.proxy = t.web
 --        ngx.log(ngx.ALERT,"*****$proxy="..t.web)
         ngx.var.proxy = 'oa.hrbfu.edu.cn'
         proxy_to()
    end
end


-- this is target ip or domainName ,proxy these in here 
--if ips:get(web) then
--    ngx.var.proxy = '218.9.68.192:8093'
--    ngx.req.read_body() --will be directly forwarded to the subrequest without copying the whole request body data when creating the subrequest
--    proxy_to()
--end
--local json =[[ {"oa.webvpn.com":["10.49.2.5","8080","oa.web.com"]} ]]
--ngx.log(ngx.ALERT,"****json="..json)
--local key = cjson.decode(json)
--ngx.log(ngx.ALERT,"*****key="..key["oa.webvpn.com"][1])


--local json =[[ {"oa.webvpn.com":{"url":"10.49.2.5","port":"8080","web":"oa.web.com"}} ]]
--local sub_json=cjson.decode(json)["oa.webvpn.com"]
--ngx.log(ngx.ALERT,"*****key="..sub_json.url)






