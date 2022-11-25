--[[
    @author liuyf
    Time:Nov 25, 2022 at 11:17

    repalce resp header
--]]


require"cjson".encode(ngx.resp.get_headers())
--    ngx.header["content-type"]='text/html;charset=UTF-8'
local resp = require "lua.lib.resp"
--get 3xx location uri
local redirect_target=resp.get_resp_headers_Location()                    
ngx.log(ngx.ALERT,'ngx.status='..ngx.status)
if redirect_target and ngx.status > 300 and ngx.status <309 then
    ngx.log(ngx.ALERT,'location='..redirect_target)
    ngx.log(ngx.ALERT,'redirect_target:'..redirect_target)
    local redirect_target_changed,n,err=ngx.re.gsub(redirect_target, '(^http?[:][/][/][^/]+)', 'http://proxyman.com:8888')
    ngx.log(ngx.ALERT, 'redirect_target_changed: '..redirect_target_changed)
    --return ngx.redirect(redirect_target_changed, ngx.status)
    ngx.header.Location = redirect_target_changed
elseif ngx.status == 500 then
    return ngx.exit(500)
end
