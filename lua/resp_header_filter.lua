--[[
    @author liuyf
    Time:Nov 25, 2022 at 11:17
<<<<<<< HEAD
=======
    edit by dec 27 ,2022
>>>>>>> a542e94bf21249f2112f7525465ff1025f2c6250

    repalce resp header
    Rewrite location header when status is 3xx and location header is present
--]]


require"cjson".encode(ngx.resp.get_headers())
<<<<<<< HEAD
--    ngx.header["content-type"]='text/html;charset=UTF-8'
ngx.header.content_length = nil
=======
ngx.header.content_length = nil 
--    ngx.header["content-type"]='text/html;charset=UTF-8'
>>>>>>> a542e94bf21249f2112f7525465ff1025f2c6250
local resp = require "lua.lib.resp"
--get 3xx location uri
local redirect_target=resp.get_resp_headers_Location()                    
-- get 1st subdomain that whole part
local domain =require "lua.lib.domain"
local subdomain = domain.get_sub_domain()..'.'
--ngx.log(ngx.ALERT,'subdomain='..subdomain)


ngx.log(ngx.ALERT,'ngx.status='..ngx.status)

-- rewrite location is changed busi'url when status is 3xx and
-- owned location header
if redirect_target and ngx.status > 300 and ngx.status <309 then
    --ngx.log(ngx.ALERT,'location='..redirect_target)
    --ngx.log(ngx.ALERT,'redirect_target:'..redirect_target)
    local data = require "lua.init_data"
<<<<<<< HEAD
=======
    --如果$1等于subdomainname，例如：web2vpn==web2vpn 那么只有一种情况就是此时的请求是来自于门户webvpn2.hrbfu.edu.cn,此时取它的子域名就是webvpn2,因为此时没有子域名。
>>>>>>> a542e94bf21249f2112f7525465ff1025f2c6250
    local redirect_target_changed,n,err=ngx.re.gsub(redirect_target, '^(https?)[:][/][/][^/]+', '$1://'..subdomain..data.get("domainName"))
    local redirect_target_changed_riddouble,n,err=ngx.re.gsub(redirect_target_changed, [[(\w+\.)(\1)]], '$2')
    --ngx.log(ngx.ALERT, 'redirect_target_changed: '..redirect_target_changed)
    ngx.header.Location = redirect_target_changed_riddouble
elseif ngx.status == 500 then
    return ngx.exit(500)
end
