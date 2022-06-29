--  Author:liuyf
--  Email:liuyf90@gmail.com
--  Time:Jun 29, 2022 at 14:03

--  query ip path by domain name 
--  example：
--      test1.webvpn.com -> 10.0.0.1:9090

local _m = {}


function _m.getIp(url){
    local domain = ngx.re.match(url, [[//([\S]+?)/]])
    domain = (domain and 1 == #domain and domain[1]) or nil
    if not domain then
        ngx.log(ngx.ERR, "get the domain fail from url:", url)
        return {status=ngx.HTTP_BAD_REQUEST}
    end
    return domain
    
}


return _m

