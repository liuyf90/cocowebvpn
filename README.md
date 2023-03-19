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

![流程图](https://tva1.sinaimg.cn/large/008vxvgGgy1h8u2yreacxj30sd0a174z.jpg)
# 谷兰科技WEBVPN安装说明

## 后端代理安装说明

后端代理是webvpn的代理逻辑核心部分，是将外部请求按照配置规则进行路由的系统。

###依赖系统

	* redis数据库
	* openresty代理
	* centos7或Ubuntu
	
###安装过程


#### 1. redis数据库安装：（centos）
	

1. 安装gcc依赖，执行命令 `yum install -y gcc`
2. 下载并解压Redis安装包，执行命令 `wget http://download.redis.io/releases/redis-5.0.3.tar.gz` 和 `tar -zxvf redis-5.0.3.tar.gz`
3. 切换到Redis解压目录下，执行编译，执行命令 `cd redis-5.0.3` 和 `make`
4. 安装并指定安装目录，执行命令 `make install PREFIX=/usr/local/redis`
5. 启动服务，可以选择前台启动或后台启动。前台启动执行命令 `cd /usr/local/redis/bin` 和 `./redis-server`；后台启动需要修改配置文件，在 `/usr/local/redis/bin` 目录下执行命令 `cp redis.conf /etc/redis.conf` ，然后编辑 `/etc/redis.conf` 文件，将 `daemonize no` 改为 `daemonize yes` ，保存退出后，在 `/usr/local/redis/bin` 目录下执行命令 `./redis-server /etc/redis.conf`
6. 设置密码，编辑 `/etc/redis.conf` 文件，找到 `#requirepass foobared` 这一行，去掉前面的注释符号，并将 foobared 改为自己的密码。保存退出后，在 `/usr/local/redis/bin` 目录下执行命令 `./redis-cli shutdown`
7. 重启服务，在 `/usr/local/redis/bin` 目录下执行命令 `./redis-server /etc/redis.conf`
8. 验证密码，在 `/usr/local/redis/bin` 目录下执行命令 `./redis-cli -a 密码`

#### 2.openresty的安装：（centos）

1. 添加Openresty仓库，执行命令 `sudo yum install yum-utils` 和 `sudo yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo`
2. 安装Openresty，执行命令 `sudo yum install openresty`
3. 启动Openresty，执行命令 `sudo /usr/local/openresty/nginx/sbin/nginx`
4. 验证Openresty是否运行成功，访问 http://127.0.0.1:80/ ，如果看到欢迎页面，则说明安装成功

###webvpn配置

1. 在home目录下，新建cocoWebvpn 目录

1. 将全部文件copy到目录下，目录结构如下图

	```
  |- conf.d
  |	\- proxy.conf
  |	\- proxy2.conf
  |	|- appcert
  |	|	\- global.certificate.cet
  |	|	\- global.certificate.key
  |	|- webcert
  |	|	\- local.private.crt
  |	|	\- local.private.key
  |	|-webcert
  |- logs
  |	\- access.log
  |	\- error.log
  |	\- info.log
  |	\- nginx.log
  |	\- proxy_access.log
  |	\- rewritre_error.log
  |	\- upstream_access.log
  |- lua
  |	\- access.lua
  |	\- init.lua
  |	\- init_data.lua
  |	\- replace.lua
  |	\- resp_header_filter.lua
  |	|-lib	
  |	|	\- decode_info.lua
  |	|	\- domain.lua
  |	|	\- get_random_string.lua
  |	|	\- mylib.lua
  |	|	\- req.lua
  |	|	\- resp.lua
  \- nginx.conf
```

1. 主要涉及到配置如下：

 	1. 配置dns域名服务器
 	
 	 * 在/nginx.conf和/conf.d/proxy.nginx配置文件里，所有resolver 配置项需要指向dns域名解析服务器地址:
 	     
	 ```nginx
 	    	resolver 172.16.17.23; #请按实际地址填写
 	    	
 	  ```
 	
	1. 配置webvpn后台程序的ssl证书
	
		在/nginx.conf配置文件中找到注释
 		
 		```nginx
 		 #proxy webvpn entrance (apps list.html)
 		```
 		
 		   在下面的server块中找到下面两行，如果要替换谷兰webvpn后台管理的ssl证书，请根据实际情况修改如下两行配置。
 		
 		```
 		11          ssl_certificate     conf.d/webcert/local.private.crt;
 		 
 		12          ssl_certificate_key conf.d/webcert/local.private.key;
 		```
 	1. 配置代理应用的ssl证书
 		
 		在/conf.d/proxy.conf文件中找到如下注释
 		
 		```nginx
 			  #配置appbvpn证书
 		```
 		在下面的代码行中，修改如下两行代码配置，指定替换的代理应用的ssl证书位置
 		
 		```nginx
 			  ssl_certificate     conf.d/appcert/global.certificate.crt;
  			  ssl_certificate_key conf.d/appcert/global.certificate.key;
 		```

	1. 指定webvpn后台管理程序的代理地址
	
		在/nginx.conf配置文件中找到注释
 		
 		```nginx
 		 #proxy webvpn entrance (apps list.html)
 		```
 		在下面的代码块中找到
 		
 		```
 		  location / {
              proxy_pass http://localhost:8088;
           }
 		```
 		修改proxy_pass的内容为webvpn后台管理程序的地址：端口即可。
 		
 	1. 指定cas服务器地址
 	
 		在nginx.conf文件中找到注释
 		
 		```
 		  #proxy cas server path
 		```
 		在配置块中找到如下配置
 		
 		```
 		 set $backend_servers ids.hrbfu.edu.cn;
 		```
 		
 		将$backend_servers地址改为生产环境的cas服务器域名
 		
 		在/lua/init_data.lua文件中，找到如下配置
 		
 	 	```
 	 	  cas = "ids.hrbfu.edu.cn"
 	 	```
 	 	将cas变量的值改为同上$backend_servers变量的值即可
 		
 	2. 代理cas服务器的端口号设置
 		
 	 默认为7777端口，如修改，请在lua/init_data.lua文件中，找到如下配置进行修改
 	 
 	 ```
 	       casport = 7777, --代理的cas端口号
 	 ```
 	 在nginx.conf文件中，找到如下配置，同步修改
 	 
 	 ```
 	     #proxy cas server path
      		 server{
          		 listen 7777;
 	 ```
 	 
	1. 代理域名设置
	
		请在lua/init_data.lua文件中，找到如下配置进行修改
		
		```
		       domainName = 'webvpn2.hrbfu.edu.cn', --busi模块的servername
		
		```
		然后在nginx.conf和/conf.d/proxy.nginx配置文件中，替换全部 server_name配置的值
		
	     ```
	      server_name *.webvpn2.hrbfu.edu.cn;
	     ```
	     注意保留原配置中的*号不要删除。
	     
		
	2. 	redis配置
		
		在lua/init.lua文件中进行配置，主要涉及如下几行
		
		```
		  local ok, err = red:connect("127.0.0.1",6379) #redis服务的ip地址及端口
		  local res, err = red:auth("GoodLan@123") #redis服务的密码
		   22     ngx.timer.at(5, update_ips)  #刷新redis的频率，默认5秒，下面同步修改
		   26     ngx.timer.at(5, update_ips）#刷新redis的频率，默认5秒，上面同步修改
		```
		
	
###webvpn的运行

进入/home/cocowebvpn 目录，在目录下执行

```shell
➜   openresty -p . -c ./nginx.conf 
```

如果要重启服务，同样进入/home/cocowebvpn 目录，在目录下执行

```shell
➜   openresty -p . -c ./nginx.conf -s reload
```

日志文件在/home/cocowebvpn/logs下，日常记录在info.log中







