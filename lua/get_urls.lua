--  Author:liuyf
--  Email:liuyf90@gmail.com
--  Time:Jun 27, 2022 at 16:01

local require = require
local ngx = require "ngx"
--local require = require 
local ngx_say = ngx.say

local _M={}

function _M.set_dict()
    local mysql = require "mysqlconnect"
    mysql.connect()
    local db=mysql.db
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
    
    ngx_say("result: ", cjson.encode(res))
    return _M
end 
return _M
