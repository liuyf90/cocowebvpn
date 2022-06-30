--
--  Author:liuyf
--  Email:liuyf90@gmail.com
--  Time:Jun 30, 2022 at 15:27
--


-- ngx.var.xx  xx is nginx's inner variable， ex: $host
-- According to the pertinent internet recommendations (RFC3986 section 2.2)
local subdomain = "([A-Za-z0-9](?:[A-Za-z0-9\\-]{0,61}[A-Za-z0-9])?)"  
local m, err = ngx.re.match(ngx.var.host, subdomain, "i")

if not m then
    ngx.log(ngx.ERR, "error: ", err)
    return
end
ngx.say(m[0])
