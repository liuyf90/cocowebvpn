--  Author:liuyf
--  Email:liuyf90@gmail.com
--  Time:Jun 27, 2022 at 15:30

local require = require
local _M={} -- use table mock an class 
local ngx = require "ngx"
local ngx_say = ngx.say
local mysql = require "resty.mysql"

function _M.connect()
    local db, err = mysql:new()
    if not db then
        ngx_say("failed to instantiate mysql: ", err)
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
         ngx_say("failed to connect: ", err, ": ", errcode, " ", sqlstate)
         return
     end
     ngx_say("connected to mysql.")
     
     _M.db=db
     return _M
end
return _M

