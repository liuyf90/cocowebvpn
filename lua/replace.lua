--[[
    @author liuyf
    Time:Nov 10, 2022 at 15:17

    replace the content of the resp body  returned by the sub-request
--]]


local resp = require "lua.lib.resp"
<<<<<<< HEAD
=======

>>>>>>> a542e94bf21249f2112f7525465ff1025f2c6250
--ngx.log(ngx.INFO,"replace resp body :")
-- body_filter_by_lua, body filter模块，ngx.arg[1]代表输入的chunk，ngx.arg[2]代表当前chunk是否为last
local chunk, eof = ngx.arg[1], ngx.arg[2]
-- 定义全局变量，收集全部响应
if ngx.ctx.buffered == nil then
    ngx.ctx.buffered = {}
end
-- 如果非最后一次响应，将当前响应赋值
if chunk ~= "" and not ngx.is_subrequest then
    table.insert(ngx.ctx.buffered, chunk)

    -- 将当前响应赋值为空，以修改后的内容作为最终响应
    ngx.arg[1] = nil
end
-- 如果为最后一次响应，对所有响应数据进行处理
if eof then
    -- 获取所有响应数据
    local whole = table.concat(ngx.ctx.buffered)
    -- 进行改写
    --
    whole= resp.rewrite_whole(whole) 
    --ngx.log(ngx.ALERT,"whole :"..whole)
    -- 重新赋值响应数据，以修改后的内容作为最终响应
    ngx.arg[1] = whole
end
