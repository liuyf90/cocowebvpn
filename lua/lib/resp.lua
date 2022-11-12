--[[
    @author liuyf
    Time:Nov 12, 2022 at 10:25

    Response related tools are packaged here
--]]

local _M={_VERSION = '0.12'}

--内容过滤改写,是否为js,css,html
function _M.isTextHtml(head_type)
	--ngx.log(ngx.INFO, 'head_type ==> '..head_type)
	local htmlTypeFind = string.find(head_type,"text/html")
	local jsTypeFind = string.find(head_type,"application/javascript")
	local xjsTypeFind = string.find(head_type,"application/x[-]javascript")
	local cssTypeFind = string.find(head_type,"text/css")
	if htmlTypeFind ~= nil or jsTypeFind ~= nil or cssTypeFind ~= nil or xjsTypeFind ~= nil then
		return true
	end
	return false
end

function _M.rewrite_whole(whole)
    ngx.ctx.buffered = nil
    -- 进行你所需要进行的处理
    -- try to unzip
    if ngx.header.content_encoding == "gzip" then
         --解压压缩过的网页内容
         local zlib = require "zlib"
         local gzip = zlib.inflate()
         whole = gzip(whole)
    end

    -- local status, debody = pcall(com.decode, whole) 
    -- if status then whole = debody end
    -- try to add or replace response body
    -- local js_code = ...
    -- whole = whole .. js_code
   whole = string.gsub(whole, "max%-width%:1632px%;",  "")
   return whole
end

return _M

