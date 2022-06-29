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

ngx.say("result: ", cjson.encode(res))



