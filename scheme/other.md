### restful API风格约束
---

1. uri规范
使用名词,如:
```
http://api.example.com/class-management/students
http://api.example.com/device-management/managed-devices/{device-id}
http://api.example.com/user-management/users/
http://api.example.com/user-management/users/{id}
```

2. http method对应不同的请求动作
`GET`:查询
`POST`:新增
`PUT`:更新(全部)
`PATCH`:更新(部分)
`DELETE`:删除

3. 使用连字符(-)而不是下划线(_)来提高uri的可读性
```
http://api.example.com/inventory-management/managed-entities/{id}/install-script-location //更易读
http://api.example.com/inventory_management/managed_entities/{id}/install_script_location //更容易出错
```

4. 在uri中使用小写字母

5. 不使用文件扩展名
```
http://api.example.com/device-management/managed-devices.xml / 不要使用它 /
http://api.example.com/device-management/managed-devices / *这是正确的URI * /
```

6. 使用查询组件过滤uri集合
```
http://api.example.com/device-management/managed-devices
http://api.example.com/device-management/managed-devices?region=USA
http://api.example.com/device-management/managed-devices?region=USA&brand=XYZ
http://api.example.com/device-management/managed-devices?region=USA&brand=XYZ&sort=installation-date
```

7. 不要在末未使用`/`

8. 使用http状态码定义api执行结果
`2xx`:成功
`3xx`:重定向相关
`4xx`:客户端错误
`5xx`:服务端错误

9. 版本定义
uri版本控制:
```
http://api.example.com/v1
http://apiv1.example.com
```

使用自定义请求标头进行版本控制
```
Accept-version：v1
Accept-version：v2
```
使用Accept header进行版本控制:
```
Accept:application / vnd.example.v1 + json
Accept:application / vnd.example + json; version = 1.0
```

10. 尽量将api部署在专用域名下
```
https://api.example.com
//除非确定api很简单,不会有进一步扩展,则可以放在主域名下
https://example.org/api/
```