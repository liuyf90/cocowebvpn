--
--  Author:liuyf
--  Email:liuyf90@gmail.com
--  Time:Jul 2, 2022 at 10:18
--

local ngx_say = ngx.say
local get_subdomain= require "get_subdomain"


function connect()
    local mysql = require "resty.mysql"
    local db, err = mysql:new()
    if not db then
        --ngx_say("failed to instantiate mysql: ", err)
        return nil,err
    end

    
    db:set_timeout(1000) -- 1 sec
    
   local ok, err, errcode, sqlstate =  db:connect{
         host = "127.0.0.1",
         port = 3306,
         database = "ngx_test",
         user = "root",
         password = "123456",
         charset = "utf8",
         max_packet_size = 1024 * 1024,
     }
     if not ok then
         --ngx_say("failed to connect: ", err, ": ", errcode, " ", sqlstate)
         return
     end
     --ngx_say("connected to mysql.")
     
     return db 
end


local function set_ips(db)
    -- run a select query, expected about 10 rows in
    -- the result set:
    local res, err, errcode, sqlstate =
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
    
    --ngx_say("result: ", cjson.encode(res))
    return res
end

-- First judge sharedict that doesn't contain this data,and then query the mysql data
local ips = ngx.shared.ips
local domain_name = ngx.ctx.domain
--ngx_say("domain_name = " .. domain_name)
local dest_ip = ips:get("test1.china.com")
if not dest_ip then
    local db = connect()
    local res = set_ips(db)
    dest_ip = ips:get("test1.china.com")
end


ngx.var.proxy =  dest_ip
--ngx_say("dest_ip = " .. dest_ip)


--ngx.status = ngx.HTTP_MOVED_TEMPORARILY
--local ngx_resp = require "ngx.resp"
--ngx_resp.add_header("Location", "http://" .. dest_ip)
--ngx_say("dest_ip= " .. dest_ip)
--return ngx.var.jumpip=dest_ip
--return ngx.redirect("http://" .. dest_ip)




--ngx.req.read_body()
--local args, err = ngx.req.get_uri_args()
--local http = require "resty.http"   -- ①
--local httpc = http.new()
--local res, err = httpc:request_uri( -- ②
--"http://" .. dest_ip,
--{
--    method = "GET"
--}
--)
--if not res then
--    ngx.log(ngx.ERR, "request failed: ", err)
--    return
--end
---- At this point, the entire request / response is complete and the connection
---- will be closed or back on the connection pool.
--
---- The `res` table contains the expeected `status`, `headers` and `body` fields.
--local status = res.status
--local length = res.headers["Content-Length"]
--local body   = res.body

