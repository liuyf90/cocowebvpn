--[[
    @author liuyf
    Time:Nov 4, 2022 at 16:45

    this is initize section,it loops to get redis datas to sharedict zone
--]]

--Create sharedict zone on first worker creation
if 0~= ngx.worker.id() then
    return
end

--from redis get datas and put sharedict zone
local redis = require "resty.redis"

local ips = ngx.shared.ips

local function update_ips()
    local red = redis:new()
    local ok, err = red:connect("127.0.0.1",7000)   
    if err then
        ngx.log(ngx.ERR, "redis connect error: "..err)
        return
    end
    local res,err = red:smembers("ips")
    if err then
        ngx.log(ngx.ERR, "redis read smembers error: " ..err)
        return
    end
    ips:flush_all()
    for _, k in paris(res) do
        ips:set(k,true)
    end
end

--ever 5 sec to flush datas in sharedict
ngx.timer.at(5, update_ips)



