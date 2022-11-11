--[[
    @author liuyf
    Time:Nov 10, 2022 at 15:17

    replace the content of the resp body  returned by the sub-request
--]]

ngx.log(ngx.INFO,"replace resp body :")
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
    ngx.ctx.buffered = nil

    -- 进行你所需要进行的处理
    -- try to unzip
    -- local status, debody = pcall(com.decode, whole) 
    -- if status then whole = debody end
    -- try to add or replace response body
    -- local js_code = ...
    -- whole = whole .. js_code
    --whole = string.gsub(whole, "max%-width%:1632px%;",  "")

    -- 重新赋值响应数据，以修改后的内容作为最终响应
    ngx.arg[1] = whole
end
