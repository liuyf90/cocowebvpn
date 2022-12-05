--[[
    @author liuyf
    Time:Nov 13, 2022 at 10:25

    Request related tools are packaged here
--]]

local _M={_VERSION = '0.12'}
function _M.print_req_headers()
    local h, err = ngx.req.get_headers()
    if err == "truncated" then
        -- one can choose to ignore or reject the current request here
    end
    local i=0;
    for k, v in pairs(h) do
       i=i +1
       ngx.log(ngx.INFO,"req_header["..i.."]:"..k..':'..v)
    end
end

-- set req headers in here
function _M.set_req_headers()
    --set resquest header
    --ngx.header.Expires= -1 
end


return _M
