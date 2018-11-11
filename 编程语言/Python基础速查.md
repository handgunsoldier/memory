# Python 基础速查

## 基本数据类型

### str（字符串）

对字符串的任何修改操作都是非原地的，因为字符串是不可变对象。

常用方法：

```python
"""查找"""
# 返回子串 sub 在 s 中出现的次数，可指定范围
s.count(sub, start=None, end=None)
# 返回子串 sub 的索引，找不到返回 -1
s.find(sub, start=None, end=None)
# 从右侧开始查找
s.rfind(sub, start=None, end=None)
# 与 find 一样，只不过找不到会抛出异常
s.index(sub, start=None, end=None)
# 从右侧开始查找
s.rindex(sub, start=None, end=None)

"""替换"""
# 从左到右替换，count 指定最大次数，非原地
s.replace(old, new, count=None)
# 把字符串中的制表符转换为指定长度（默认 8）的空格
s.expandtabs(tabsize=8)

"""删减"""
# 默认去除字符串两边的空白字符，
# 空白字符由 string.whitespace 常量定义，
# 或删除两边指定字符
s.strip()
# 同上，但只删左边
s.lstrip()
# 同上，但只删右边
s.rstrip()

"""填充"""
# 居中对齐，width 指定长度，fillchar 指定填充字符，不指定默认空白字符
s.center(width, fillchar)
# 左对齐
s.ljust(width, fillchar)
# 右对齐
s.rjust(width, fillchar)
# 右对齐，前面用零填充
s.zfill(width)

"""分切"""
# 根据 sep 切割字符串，maxsplit 指定最大次数，返回列表，
# 默认切割空白字符，并且字符串两边的空白字符会被忽略
s.split(sep, maxsplit)
# 根据行分割，keepends 决定是否保留换行符
s.splitlines(keepends)
# 将字符串 s 切割成三部分：sep 前，sep，sep 后
s.partition(sep)
# 从右往左分割
s.rpartition(sep)

"""连接"""
# 将可迭代对象（成员必须都是字符串，int 也不行）连接成字符串，成员之间填入 s
s.join(iterable)

"""变形"""
# 把字符串中所有字母转小写
s.lower()
# 把字符串中所有字母转大写
s.upper()
# 字符串首字母转大写，必须是第一个字符
s.capitalize()
# 把字符串中所有字母大写转小写，小写转大写
s.swapcase()
# 每个单词的第一个字母转换成大写
s.title()

"""判定"""
# 是否都是数字或字母
s.isalnum()
# 是否都是字母
s.isalpha()
# 是否都是数字
s.isdigit()
# 如果包含字母，是否都是小写
s.islower()
# 如果包含字母，是否都是大写
s.isupper()
# 是否只包含空格
s.isspace()
# 是否是标题化的（首字母大小，其他小写）
s.istitle()
# 字符串是否可以作为变量名
s.isidentifer()
# 字符串是否全部可打印，包含不可打印字符（如转义字符） 返回 False
s.isprintable()

"""编码"""
# 编码成 bytes
s.encode(encoding='utf-8', errors='strict')
```

### list（列表）

对列表的任何修改操作都是原地的。

常用方法：

```python
# 将元素 x 添加到列表 lst 尾部
lst.append(x)
# 在下标 index 处添加元素 x，原来该位置元素及之后元素后移
lst.insert(index, x)
# 将列表 L 中元素添加到列表 lst 末尾，原地
lst.extend(L)
# 删除并返回下标为 index（默认 -1）到元素
lst.pop(index)
# 删除列表中第一个值为 x 的元素，其之后的元素前移
lst.remove(x)
# 清空列表，但保留列表对象
lst.clear()
# 返回第一个值为 x 的元素下标，不存在则抛出异常
lst.index(x)
# 返回元素 x 在列表中出现的次数
lst.count(x)
# 逆转列表，原地
lst.reverse()
# 根据 key 排序，可打开逆序开关，原地
lst.sort(key=None, reverse=False)
# 返回列表的浅拷贝
# 浅拷贝指，列表对象不同，但成员指向同一块内存
lst.copy()
```

### dict（字典）

对字典的任何修改操作都是原地的。

常用方法：

```python
# 返回字典的键构成的列表
d.keys()
# 返回字典的值构成的列表
d.values()
# 返回一个元组（键，值）构成的列表
d.items()
# 返回指定键的值，不存在则返回 default 的值
d.get(key, default=None)
# 返回指定键的值，不存在则添加值为 default 的键，再返回
d.setdefault(key, default=None)
# 将 iterable 中的元素做键，值都为 default，会覆盖已有的键
d.fromkeys(iterbale, default=None)
# 把字典 dict2 中的键值更新到字典 d 中，会覆盖已有的键
d.update(dict2)
# 弹出指定元素，并返回值，若不存在，则抛出 KeyError
# 若指定 d 参数，则不存在返回 d
d.pop(k, d)
# 弹出字典末尾元素，返回一个二元组
d.popitem()
# 清空字典，但会保留字典对象
d.clear()
# 返回一个字典的浅拷贝
d.copy()
```

### set（集合）

对集合的任何修改操作都是原地的。

常用方法：

```python
# 添加成员，自动去重
s.add(k)
# 添加一个对象到当前集合，自动去重
s.update([1, 2, 3])
# 弹出一个随机 key
s.pop()
# 弹出一个指定 key
s.remove(k)
# 清空集合
s.clear()
# 返回集合的浅拷贝
s.copy()
```

集合的差，并，交操作：

```python
# 在 a 中的成员, 但不在 b 中
a - b
# 在 a 或 b 中的成员
a | b
# 在 a 和 b 中都有的成员
a & b
# 在 a 或 b 中的成员，但不同时在 a 和 b 中
a ^ b
```

## 内置函数

```python
# 返回数字 x 的绝对值或复数 x 的模
abs(x)
# 判断真假
bool(x)
# 返回复数
complex([real[, imag]])
# 返回 x 除 y 的商和余数
divmod(x, y)
# 返回 x 的 y 次方, 等价于 `x**y` 或 `(x**y)%z`
pow(x, y, z=None)
# 对 x 四舍五入，若不指定小数位数，则返回整数
round(x[, 小数位数])

# 把整数 x 转换成二进制
bin(x)
# 把整数 x 转换成八进制
oct(x)
# 把整数 x 转换成十六进制
hex(x)

# 返回字符 c 的 Unicode 编码
ord(c)
# 返回 Unicode 编码为 i 的字符
chr(i)

# 如果 iterable 的每个元素是真值，返回 True；`all([])` 返回 True
all(iterable)
# 只要 iterable 中有元素是真值，就返回True；`any([])`返回 False
any(iterable)

max(iterable)
min(iterable)
sum(iterable)

sorted(iterable)
reversed(iterable)

# 下面 3 个函数，既可用于类，又可用于模块
hasattr(obj)
getattr(obj, name[, default])
delattr(obj, name)

# 类型判断
type(obj)
isinstance(obj, classinfo)  # 判断是不是某个类
issubclass(obj, classinfo)  # 判断是不是某个类的子类

# 返回当前环境下的全局变量
globals()
# 返回当前环境下的局部变量
locals()
```




