--domainngx.say("this is the ip")
--local ips = ngx.shared.ips
----jump to the ip
--ngx.say(ips:get(ngx.ctx.domain))


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
 --the life time identical to the current request 
 ngx.ctx.domain = m[0]
 ngx.say(ngx.ctx.domain)




--  Author:liuyf
--  Email:liuyf90@gmail.com
--  Time:Jun 27, 2022 at 16:01

local mysql = require "mysqlconnect"
mysql.connect()
local db=mysql.db
-- run a select query, expected about 10 rows in
-- the result set:
res, err, errcode, sqlstate =
db:query("select * from urls order by id asc", 10)
if not res then
    ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
    return
end

local cjson = require "cjson"
local ips = ngx.shared.ips
--ngx.say(type(res["result"]))
for k,v in ipairs(res) do
   -- ngx.say(res[k].server_name)
   -- ngx.say(res[k].dest_ip)
    --insert ngx.shared.dict to ips
    ips:set(res[k].server_name,res[k].dest_ip);
end

ngx.say("result: ", cjson.encode(res))


ngx.say("this is content")
local ips = ngx.shared.ips
--jump to the ip
ngx.say(ips:get(ngx.ctx.domain))
