local _M={}
function _M.test()
    ngx.say("this is a call")
    _M.db="test db"
end 
return _M
