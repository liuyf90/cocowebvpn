--[[
--
    @author liuyf
    Time:Nov 22, 2022 at 09:35

    this is proxy transition section,It loops http in ips and translates to proxy address
--]]


local ips = ngx.shared.ips
--local ip = ngx.var.remote_addr
local web="my.webvpn.com"

<<<<<<< HEAD
    --set cookie when success logined    SSO
local function get_cookie()
    local castgc=ngx.var.cookie_CASTGC

    if castgc ~= nil then
        local data = require "lua.init_data"
        ngx.header['Set-Cookie'] = 'CASTGC='..castgc..';'.." Domain="..data.get("domainName")..";".." Expires="..ngx.cookie_time(ngx.time()+300)..";".." Path=/"
    --else
    --    ngx.redirect("http://webvpn2.hrbfu.edu.cn", 301)
    end

   -- local flag = ngx.var.cookie_flag
   --     if flag == nil  then
   --     --ngx.log(ngx.ALERT,"*****flagnew="..flag)
   -- end
end

local function is_referer()
  local headers = ngx.req.get_headers()
  if not headers["Referer"] then
    ngx.exit(403)   
  end
end

local function proxy_to()
    --get_cookie()
    is_referer()
=======

--set cookie when success logined    SSO
local function get_cookie()
    local castgc=ngx.var.cookie_CASTGC

    if castgc ~= nil then
        local data = require "lua.init_data"
        ngx.header['Set-Cookie'] = 'CASTGC='..castgc..';'.." Domain="..data.get("domainName")..";".." Path=/"
    end
end

local function proxy_to()
    get_cookie()
>>>>>>> a542e94bf21249f2112f7525465ff1025f2c6250
    local req = require "lua.lib.req"
    req.set_req_headers()
    ngx.exec('@download_server')    
    return ngx.exit(ngx.status)
end


<<<<<<< HEAD
=======


>>>>>>> a542e94bf21249f2112f7525465ff1025f2c6250
local keys = ips:get_keys(0)
--ngx.log(ngx.ALERT,"*****keys="..table.concat(keys))

local cjson = require "cjson"
ngx.req.read_body() --will be directly forwarded to the subrequest without copying the whole request body data when creating the subrequest

-- get sub_domain_name automatically
local domain = require "lua.lib.domain"
local subdomain = domain.get_sub_domain()


-- sub_json's  data like "sadd ips:url '{"oa":{"url":"10.49.2.5","port":"8080","web":"oa.web.com"}}'"
for _,v in ipairs(keys) do
    local json = cjson.decode(v)
    local sub_json=cjson.decode(json)
    local t = sub_json[subdomain]
    if t ~= nil then
        --ngx.log(ngx.ALERT,"*****$sub_json:"..type(sub_json))
        --ngx.log(ngx.ALERT,"*****$proxy="..t.web)
        if t then
               --ngx.var.proxy = 'oa.hrbfu.edu.cn'
               --proxy_to()
               --capture domainName form t.web
               local captures, err =ngx.re.match(t.web,"[^/]+","jo")
               if captures then
                   local domainName= captures[0]
<<<<<<< HEAD
    --               ngx.log(ngx.ALERT,"*****$domainName="..domainName)
                   --ngx.var.proxy = domainName
                   ngx.var.proxy = domainName..":"..t.port
                   --update scheme 
                   ngx.var.cscheme= t.scheme
=======
                   --ngx.log(ngx.ALERT,"*****$domainName="..domainName)
                   --ngx.var.proxy = domainName
                   ngx.var.proxy = domainName..":"..t.port
>>>>>>> a542e94bf21249f2112f7525465ff1025f2c6250
                   proxy_to()
               else
                   if err then
                       ngx.log(ngx.ERR, "error: ", err)
                       return
                   end
               end           
        end
    end
end







