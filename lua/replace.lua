ngx.log(ngx.INFO,"replace resp body :")
-- body_filter_by_lua, body filter模块，ngx.arg[1]代表输入的chunk，ngx.arg[2]代表当前chunk是否为last
local chunk, eof = ngx.arg[1], ngx.arg[2]
local buffered = ngx.ctx.buffered
if not buffered then
   buffered = {}  -- XXX we can use table.new here 
   ngx.ctx.buffered = buffered
end
if chunk ~= "" then
   buffered[#buffered + 1] = chunk
   ngx.arg[1] = nil
end
if eof then
   local whole = table.concat(buffered)
   ngx.ctx.buffered = nil
   -- try to unzip
   -- local status, debody = pcall(com.decode, whole) 
   -- if status then whole = debody end
   -- try to add or replace response body
   -- local js_code = ...
   -- whole = whole .. js_code
   whole = string.gsub(whole, "max%-width%:1632px%;",  "")
   ngx.arg[1] = whole
end

