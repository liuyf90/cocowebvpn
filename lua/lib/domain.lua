--[[
  Author:liuyf
  Email:liuyf90@gmail.com
  Time:Nov 8, 2022 at 16:40

  ngx.var.xx  xx is nginx's inner variable， ex: $host
  According to the pertinent internet recommendations (RFC3986 section 2.2)
--]]

local _M={_VERSION = '0.12'}
function _M.get_sub_domain(url)
    local subdomain = "([A-Za-z0-9](?:[A-Za-z0-9\\-]{0,61}[A-Za-z0-9])?)"  
    if not url  then
        url = ngx.var.host
    end
    local m, err = ngx.re.match(url, subdomain, "i")
    local ngx_say = ngx.say
    if not m then
        ngx.log(ngx.ERR, "error: ", err)
        return
    end
    --the life time identical to the current request 
   -- ngx.ctx.domain = m[0]
    return m[0]
 end

return _M


