--  Author:liuyf
--  Email:liuyf90@gmail.com
--  Time:Jun 27, 2022 at 15:30

local mysql = require "resty.mysql"
local _mysql={}


function _mysql.connect()
    local db, err = mysql:new()
    if not db then
        ngx.say("failed to instantiate mysql: ", err)
        return
    end
    
    db:set_timeout(1000) -- 1 sec
    
    -- or connect to a unix domain socket file listened
    -- by a mysql server:
    --     local ok, err, errcode, sqlstate =
    --           db:connect{
    --              path = "/path/to/mysql.sock",
    --              database = "ngx_test",
    --              user = "ngx_test",
    --              password = "ngx_test" }
    
    local ok, err, errcode, sqlstate = db:connect{
        host = "127.0.0.1",
        port = 3306,
        database = "ngx_test",
        user = "root",
        password = "123456",
        charset = "utf8",
        max_packet_size = 1024 * 1024,
    }
    
    if not ok then
        ngx.say("failed to connect: ", err, ": ", errcode, " ", sqlstate)
        return
    end
   _mysql.db=db 
    
end
return _mysql
-- run a select query, expected about 10 rows in
-- the result set:
--res, err, errcode, sqlstate =
--db:query("select * from urls order by id asc", 10)
--if not res then
--    ngx.say("bad result: ", err, ": ", errcode, ": ", sqlstate, ".")
--    return
--end
--
--local cjson = require "cjson"
--
