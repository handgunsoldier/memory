### mitmproxy

-  安装

```bash
pip install mitmproxy
```

- 运行

```bash
# 默认监听127.0.0.1:8080, 需把请求转发到这个端口
# 在安卓中, 设置wifi的代理为这个地址, 即可抓包
mitmproxy

# 参数
-s <python脚本>  # 载入脚本, 修改脚本后, 不用重启mitmproxy, 会自动重新载入
```

- 命令

```bash
# 通用
# 类似vim的操作
O  # 设置界面
C  # 查看命令

# 列表界面
?  # 查看帮助
F  # 追踪http(就是有请求产生, 会跳到这个请求)
f  # 设置过滤规则
i  # 设置拦截规则
I  # 开关拦截
a  # 放行某个拦截
A  # 放行所有拦截
D  # 复制某个流
d  # 删除选中的流
Z  # (大写)清空不在视线范围内的流
z  # (小写)清空所有流
m  # 标记某个流
M  # 查看所有被标记的流
U  # 取消所有标记
b  # 保存响应body到文件
E  # 查看事件窗口
B  # 打开浏览器

# 具体流界面
e  # 修改参数
V  # 撤销对某个流的修改

# 参数修改界面
a  # 追加参数
d  # 删除参数
```

- 代理模式

```bash
# Transparent Proxying（透明代理）
# 透明代理的意思是客户端根本不需要知道有代理服务器的存在，它改变你的request fields（报文），并会传送真实IP，多用于路由器的NAT转发中。注意，加密的透明代理则是属于匿名代理，意思是不用设置使用代理了
```

- 证书(必须在对应系统设置, 否则报错)

```bash
mitmproxy-ca.pem # PEM格式的私钥和证书。
mitmproxy-CA-cert.pem # PEM格式的证书。使用此分发大多数非Windows平台。
mitmproxy-CA-cert.p12 # 在PKCS12格式的证书。在Windows上使用。
mitmproxy-CA-cert.cer # 相同的文件质子交换膜，但预计一些Android设备的扩展。
```

