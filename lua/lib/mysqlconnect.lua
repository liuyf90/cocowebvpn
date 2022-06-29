--  Author:liuyf
--  Email:liuyf90@gmail.com
--  Time:Jun 27, 2022 at 15:30

local _M={} -- 使⽤ table 模拟类

function _M.connect()
    local mysql = require "resty.mysql"
    local db, err = mysql:new()
    if not db then
        ngx.say("failed to instantiate mysql: ", err)
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
         ngx.say("failed to connect: ", err, ": ", errcode, " ", sqlstate)
         return
     end
     ngx.say("connected to mysql.")
     
     _M.db=db
end
return _M

