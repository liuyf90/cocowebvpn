# cocowebvpn
the cocowebvpn is  one that customer's project.It will servername convert to url in inside net。 It is created based on openresty

# 1.主要模块
---
## 1.1 busi模块
----

该模块为cocowebvpn的核心部分，根据业务逻辑进行请求的路由，及处理返回的响应头。
### 1.1.1 location / 

拦截从端口进入的各种请求，并按照[[openresty阶段]]进行处理：

*  access_by_lua_file 阶段 lua/access.lua

	该阶段主要通过查询lua_shared_dict中在启动阶段注入的ips列表数据，根据子域名作为key值查询ips中的web地址，并调用ngx.exec()方法，内部重定向到@download_server中，在重定向前，将web地址作为@download_server的proxy_pass地址。

* rewrite 指令

	该指令巧妙的利用了rewrite指令在所有阶段前执行的规则，通过正则表达式识别请求是由下游应用发出cas进行鉴权的,识别后讲HOST头替换为cas服务的server端口，重定向到casserver模块。需要注意的是使用了break参数，否则依然会执行openresty的其他阶段。

### 1.1.2 @download_server

动态代理上游服务，处理响应头

* proxy_pass \$scheme://\$proxy$request_uri;

	通过业务逻辑处理access.lua动态的将代理地址注入$proxy[[nginx内置绑定变量｜变量|变量]]，当重定向到@downland_server内部地址时，将代理到被代理业务的地址。

* header_filter_by_lua_file 阶段 lua/resp_header_filter.lua

	这个模块在整个[[openresty阶段]]用于处理响应头，当执行到这个阶段时，判断响应头中是否有Location头，如果有Location头并且首部为302等3xx跟重定向相关，那么拦截这个响应，重写Location内容，将http://xxxx:aaa这个部分用正则表达式扣出来，替换为cocowebvpn的busi模块的domainname。

## 1.2 cas代理模块
---
由于被代理的应用可能存在cas鉴权的情况，这个cas代理模块负责将内网中的cas服务器反向代理。只有代理了cas服务，才会使重定向到cas的请求不会脱管。因为如果不代理cas服务，由应用发出的回调请求在cas服务中会被回调到内网地址中，导致了webvpn的脱管。

* proxy_pass 

	就是普通的反向代理，将cas代理模块反向代理到cas服务地址。

*  header_filter_by_lua_file 阶段 lua/resp_header_filter.lua;

	这个模块复用了resp_header_filter.lua,当cas服务鉴权成功后，会返回302重定向请求重定向到被代理的应用地址，此时重写Location内容，将http://xxxx:aaa这个部分用正则扣出来，替换为cocowebvpn的busi模块的domainname，这个请求被busi模块的/ 拦截，再次按照业务规则导航到对应的被代理应用中，至此，一个完整的代理完成。

# 2 流程
----
![[https://tva1.sinaimg.cn/large/008vxvgGgy1h8u2u9koggj30h00m0gmw.jpg]]

