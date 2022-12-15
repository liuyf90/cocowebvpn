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


function _M.get_resp_headers_Location()
    local h, err = ngx.resp.get_headers()
    if err == "truncated" then
        -- one can choose to ignore or reject the current request here
    end
    local location = h["Location"]
   -- for k,v in pairs(h) do
   --     ngx.log(ngx.INFO,'***resp_headers***='..' key: '..k..'value: '..require"cjson".encode(v))
   -- end
    if location ~= nil then
     ngx.log(ngx.ALERT, 'resp_location='..location)
     return location
    end
    return nil
--    return nil
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
   --按正则表达式扣出来href,http(s)的url，然后获得1st子域名，查询内存数据库，反查出外网域名，再替换掉内网域名
   --local urls, err = ngx.re.gmatch(whole, [[href=\"((https?)\:\/\/([^\/]*)\/.*\")]], "i")
--   local urls, err = ngx.re.gmatch(whole, [[\"((https?)\:\/\/([^\/"]*)[^,\s]*\")]], "i")
   local urls, err = ngx.re.gmatch(whole, [[[\"\']((https?)\:\/\/([^\/"]*)[^,\s]*[\"\'])]], "i")
   if not urls then
       ngx.log(ngx.ERR, "error: ", err)
       return
   end
   while true do
       local url, err = urls()
       if err then
           ngx.log(ngx.ERR, "error: ", err)
           return
       end

       if not url then
           -- no match found (any more)
           break
       end
      -- found a match
      --反查外网域名后重写
       --ngx.log(ngx.ALERT,"*&*&*&*&*&*url="..url[3])
       local tools = require "lua.lib.mylib"
       local inner = url[3]
       local extra = tools.getExtra_shared(inner)

       if extra ~= nil then
          local init= require "lua.init_data"
          whole = string.gsub(whole, inner, extra..'.'..init.get("domainName"))
       end
       
       --ngx.say(url[0])
   end 
   --whole = string.gsub(whole, "my.hrbfu.edu.cn", "my.proxyman.com:8888")
   return whole
end

return _M

