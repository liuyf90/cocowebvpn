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
    local ok, err = red:connect("127.0.0.1",6379)   
    if err then
        ngx.log(ngx.ERR, "redis connect error: "..err)
        return
    end
    local res, err = red:auth("GoodLan@123")
    if not res then
        ngx.say("failed to authenticate: ", err)
        return
    end
    local res,err = red:smembers("ips:url")
    if err then
        ngx.log(ngx.ERR, "redis read smembers error: " ..err)
        return
    end
    ips:flush_all()
    local cjson = require "cjson"
    for _, k in pairs(res) do
        ips:set(cjson.encode(k),true)
    end
    ngx.timer.at(5, update_ips)
end

--ever 5 sec to flush datas in sharedict
ngx.timer.at(5, update_ips)



