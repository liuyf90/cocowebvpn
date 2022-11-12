--[[
    @author liuyf
    Time:Nov 5, 2022 at 09:35

    this is proxy transition section,It loops http in ips and translates to proxy address
--]]


local ips = ngx.shared.ips
local ip = ngx.var.remote_addr
local function proxy_to()
    local res = ngx.location.capture("/download_server",
             { copy_all_vars = true,always_forward_body = true })
    if res.status ~= ngx.HTTP_OK then
    ngx.log(ngx.INFO, "get sub_rquest res.status:"..res.status)
        ngx.say('Failed to process, please try again in some minutes.')
        ngx.exit(403)
    end
   ngx.say(res.body)
end


function print_req_headers()
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

-- this is target ip or domainName ,proxy these in here 
if ips:get(ip) then
    ngx.var.proxy = "127.0.0.1:7777"--..ngx.var.uri
    ngx.log(ngx.INFO, "access-proxy-ip: "..ngx.var.proxy)
    ngx.req.read_body() --will be directly forwarded to the subrequest without copying the whole request body data when creating the subrequest
    print_req_headers()
    proxy_to()
end





