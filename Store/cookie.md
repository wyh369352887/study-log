### 生存周期

`Expires`:过期时间

`Max-Age`:最大生存时间,单位是秒,从浏览器收到报文开始计算

---

### 作用域

`Domain`:给cookie绑定域名

`path`:给cookie绑定路径,值为`/`表示域名下的所有路径都可以使用cookie

---

### 安全相关

`secure`:只能通过HTTPS传输cookie

`HttpOnly`:只能通过HTTP传输,不能通过JS访问,是预防XSS(跨站脚本攻击)的重要手段

`SameSite`:预防CSRF(跨站请求伪造)。有三个值`Strict`、`Lax`、`None`

	Strict:浏览器完全禁止第三方请求携带cookie
	
	Lax:只能在get方法提交表单或者a标签发送get请求的情况下携带cookie
	
	None:默认,所有请求会自动携带cookie
	
---

### 缺陷

1.容量缺陷：cookie的体积上限只有4kb

2.性能缺陷：cookie紧跟域名,不管域名下面的某一个地址需不需要这个cookie,请求都会携带完整的cookie。但可以通过`domain`和`path`指定作用域来解决。

3.安全缺陷：cookie纯文本的形式很容易被非法用户截获、篡改。可以设置`HttpOnly`为`true`来拒绝JS脚本读取cookie

