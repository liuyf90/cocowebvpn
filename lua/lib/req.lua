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

function _M.set_req_body_data()
    ngx.req.read_body()
    local args,err = ngx.req.get_post_args()
    if err == "truncated" then
                     -- one can choose to ignore or reject the current request here
    end
    if not args then
        ngx.say("failed to get post args: ", err)
        return
    end
    for key, val in pairs(args) do
        if type(val) == "table" then
            ngx.log(ngx.INFO,key, ": ", table.concat(val, ", "))
        else
            ngx.log(ngx.INFO,key, ": ", val)
        end
    end
--    local body = ngx.req.get_body_data()     
--    if body then
--      ngx.req.set_body_data(body)
--    end
end

return _M
