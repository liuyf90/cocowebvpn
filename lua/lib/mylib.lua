--[[
  Author:liuyf
  Email:liuyf90@gmail.com
  Time:Dec 13, 2022 at 10:44

  some other tools or methods

--]]
local _M={}

local ips = ngx.shared.ips
local keys = ips:get_keys(0)
local cjson = require "cjson"

function _M.getExtra_shared(inner)
    for _,v in ipairs(keys) do
          local t = cjson.decode(v)
       -- ngx.log(ngx.ALERT,"^^^^^^^v= "..v.."  inner ="..inner)
        --判断是否包含inner，按字符串判断就行，这样少好多循环
        local m, err = ngx.re.match(t, inner)
        if m then 
            --ngx.log(ngx.ALERT,"^^^^^^^&&&&&&&%%%%%%%%%%m="..m[0])
            --m 确认了存在inner
            --用正则表达式扣出来key值（因为table不会处理）
            local cap,err = ngx.re.match(t,[[^{"(.*?)"]])
            if cap ~=nil then
              --ngx.log(ngx.ALERT,"^^^^^^^cap[1]="..cap[1])
              return cap[1] --return extra url 
            end
        end

    end

    return nil

end 

return _M
