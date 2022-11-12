

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

return _M
