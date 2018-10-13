# Python 爬虫速查

## 常用HTTP状态码

- **200 Ok**：请求成功

- **301 Moved Permanently**：永久重定向

- **302 Moved Temporarily**：临时重定向

- **303 See Other**：资源 url 已经更新，和 302 的区别是，明确应当采用 get 请求该资源

- **400 Bad Request**：客户端请求有语法错误，不能被服务器理解

- **401 Unauthorized**：请求未经授权

- **403 Forbidden**：服务器收到请求，但拒绝提供服务

- **404 Not Found**：请求资源不存在

- **500 Internal Server Error**：表明服务器本身发生错误

- **503 Server Unavailable**：服务器当前不能处理客户端请求，一段时间后可能恢复

## 重要HTTP请求头

- **Cookies**：用于辨别用户身份、进行 session 跟踪

- **Refer**：表示从哪个网址访问当前网址的

- **User-Agent**：客户端系统，浏览器等信息，可以用于区分 PC 端、移动端、和爬虫

## Requests

### 用法

get 方法常用参数：

```python
params   # dict, url参数, 会自动构建url
headers  # dict, 定制向服务器提交的HTTP请求头
cookies  # dict, 定制向服务器提交的cookie
timeout  # int, 设置超时时间, 单位为秒, 设为None, 则永不超时
proxies  # dict, 设置代理服务器
allow_redirects  # bool, 默认True, 重定向开关, 如遇3XX, 自动跳转
stream  # bool, 默认False, 是否立即下载请求内容, 请求视频等大内容时应设为True
verify  # bool, 默认True, 开启ssl验证, 关闭可跳过ssl错误
```
post 方法常用参数（拥有 get 方法以上的所有参数，并增加了以下参数）：

```python
data  # dict, 你要想提交的表单, 如{"user": "hello", "passwd": "123"}
file  # dict, 你要想提交的文件, 如{"file": open("1.txt", "rb")}
```

令 `r = requests.get(url)`，下面是返回的 Response 对象的常用属性和方法：

```python
r.text  # 返回文本
r.content  # 返回二进制流
r.json()  # 把r.text当作json解析，返回字典, 无法解析则抛出JSONDecodeError
r.encoding  # 返回根据HTTP协议头判定的编码, 可以改写
r.apparent_encoding  # 返回根据实际文本内容判定的编码, 实测会耗费性能
r.request.url  # 最初请求的url
r.url  # 最终请求的url, 如重定向后的url, 和参数中的url不一定相同
r.request.headers # 请求头
r.headers  # 响应头，类型是不区分大小写的字典
r.cookies  # 返回响应的cookies
r.history  # 重定向历史
r.status_code  # 返回http状态码
r.raise_for_status()  # 如果返回的http状态码在400和500或500和600之间, 抛出HTTPError异常
```

### 注意点

- 如果不传入 headers 参数，requests 会采用一个默认的 headers，为 `{'User-Agent': 'python-requests/x.x.x', 'Accept-Encoding': 'gzip, deflate', 'Accept': '*/*', 'Connection': 'keep-alive'}` 。传入 headers 参数后，会在默认 headers 的基础上更新，即字典的 `update()` 方法。
- `proxies`参数接受一个字典, 该字典一般有两个key, "http"和"https", 如果是https请求就会使用https对应的代理, 否则使用http对应的. 如果与协议对应的key不存在, 那么会不使用代理(即其实使用的是**你真实主机IP**), 这点很坑, 会让人误以为当前代理是可用的.
- `s = requests.Session()`创建一个会话对象, 支持上下文管理器. 会话对象让你能够跨请求保持某些参数, 它也会在同一个Session实例发出的所有请求之间保持cookie, 所以如果你向同一主机发送多个请求, 底层的 TCP 连接将会被重用, 从而带来显著的性能提升.
- `from requests.exceptions import RequestException`, 引入requests所有异常的基类, except该异常, 可以捕获所有requests的异常.

## lxml

### Python 使用 xpath

```python
from lxml import etree

selector = etree.HTML(r.text)  # 会自动补全丢失的标签，并且加上 <html> 和 <body> 标签
container = selector.xpath('./div')  # 使用 xpath，返回一个列表
element = container[0]  # 获取一个标签
```

### xpath 语法

- 选取节点：

XPath 使用路径表达式在 XML 文档中选取节点。节点是通过沿着路径或者 step 来选取的。

下面列出了最有用的路径表达式：

| 表达式   | 描述                                                       |
| -------- | ---------------------------------------------------------- |
| nodename | 选取此节点的所有子节点。                                   |
| /        | 从根节点选取。                                             |
| //       | 从匹配选择的当前节点选择文档中的节点，而不考虑它们的位置。 |
| .        | 选取当前节点。                                             |
| ..       | 选取当前节点的父节点。                                     |
| @        | 选取属性。                                                 |

在下面的表格中，我们已列出了一些路径表达式以及表达式的结果：

| 路径表达式      | 结果                                                         |
| --------------- | ------------------------------------------------------------ |
| bookstore       | 选取 bookstore 元素的所有子节点。                            |
| /bookstore      | 选取根元素 bookstore。注释：假如路径起始于正斜杠( / )，则此路径始终代表到某元素的绝对路径！ |
| bookstore/book  | 选取属于 bookstore 的子元素的所有 book 元素。                |
| //book          | 选取所有 book 子元素，而不管它们在文档中的位置。             |
| bookstore//book | 选择属于 bookstore 元素的后代的所有 book 元素，而不管它们位于 bookstore 之下的什么位置。 |
| //@lang         | 选取名为 lang 的所有属性。                                   |

- 谓语（Predicates）：

谓语用来查找某个特定的节点或者包含某个指定的值的节点。

谓语被嵌在方括号中。

在下面的表格中，我们列出了带有谓语的一些路径表达式，以及表达式的结果：

| 路径表达式                         | 结果                                                         |
| ---------------------------------- | ------------------------------------------------------------ |
| /bookstore/book[1]                 | 选取属于 bookstore 子元素的第一个 book 元素。                |
| /bookstore/book[last()]            | 选取属于 bookstore 子元素的最后一个 book 元素。              |
| /bookstore/book[last()-1]          | 选取属于 bookstore 子元素的倒数第二个 book 元素。            |
| /bookstore/book[position()<3]      | 选取最前面的两个属于 bookstore 元素的子元素的 book 元素。    |
| //title[@lang]                     | 选取所有拥有名为 lang 的属性的 title 元素。                  |
| //title[@lang='eng']               | 选取所有 title 元素，且这些元素拥有值为 eng 的 lang 属性。   |
| /bookstore/book[price>35.00]       | 选取 bookstore 元素的所有 book 元素，且其中的 price 元素的值须大于 35.00。 |
| /bookstore/book[price>35.00]/title | 选取 bookstore 元素中的 book 元素的所有 title 元素，且其中的 price 元素的值须大于 35.00。 |

- 选取未知节点：

XPath 通配符可用来选取未知的 XML 元素。

| 通配符 | 描述                 |
| ------ | -------------------- |
| *      | 匹配任何元素节点。   |
| @*     | 匹配任何属性节点。   |
| node() | 匹配任何类型的节点。 |

在下面的表格中，我们列出了一些路径表达式，以及这些表达式的结果：

| 路径表达式   | 结果                              |
| ------------ | --------------------------------- |
| /bookstore/* | 选取 bookstore 元素的所有子元素。 |
| //*          | 选取文档中的所有元素。            |
| //title[@*]  | 选取所有带有属性的 title 元素。   |

- 选取若干路径：

通过在路径表达式中使用“|”运算符，您可以选取若干个路径。

在下面的表格中，我们列出了一些路径表达式，以及这些表达式的结果：

| 路径表达式                       | 结果                                                         |
| -------------------------------- | ------------------------------------------------------------ |
| //book/title \| //book/price     | 选取 book 元素的所有 title 和 price 元素。                   |
| //title \| //price               | 选取文档中的所有 title 和 price 元素。                       |
| /bookstore/book/title \| //price | 选取属于 bookstore 元素的 book 元素的所有 title 元素，以及文档中所有的 price 元素。 |

## BeautifulSoup4

令 `soup = BeautifulSoup(html, 'lxml')`，下面是 `BeautifulSoup` 对象的常用属性和方法：

```python
soup.prettify() # 格式化html
soup.title # 直接打印标签，查找的是在所有内容中的第⼀个符合要求的标签
soup.new_tag('h2') # 创建一个新标签, 但还需选择一个tag插入
soup.select('xxx') # 我最喜欢用的定位标签的方法
```

下面是 `select()` 方法的使用实例，返回的是一个包含 `bs4.element.Tag` 对象的**列表**：

```python
soup.select('div.main-title') # 选择所有<div class="main-title">标签
soup.select('#main-content') # 选择所有id="main-content"标签
soup.select('div a') # 选择所有div的后代a标签
soup.select('div > a') # 选择所有div的子代a标签(注意区分子代和后代)
soup.select('div.main > a.hello') # 选择所有div.main的子代a.hello标签
soup.select('[target=_blank]') # 选择所有target="_blank"的标签
soup.select('[title~=flower]') #选择所有title属性包含单词"flower"的标签
soup.select('[lang|=en]') # 选择所有lang属性值以"en"开头的标签
```

令 `tag = soup.select('div')[0]`，下面是 `bs4.element.Tag` 对象的常用属性和方法：

```python
tag.get_text()  # 获取标签内所有文字(包括子标签的)
tag.get_text('|')  # 将获取的文字用指定字符串分隔, 如这里的'|'
tag['href']  # 获取标签某一属性, 如href
tag.get('href')  # 获取标签某一属性, 如href
tag.contents  # 获取标签中的内容, 返回一个列表
tag.parent.name  # 获取一个标签父亲名
tag.insert(1, other_tag)  # 在标签内部的第1个位置插入other_tag标签
tag.decompose()  # 销毁该标签
tag.select('[target=_blank]')  # tag可以继续使用select方法
```

