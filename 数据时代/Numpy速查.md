# Numpy 速查手册

## 相关链接

- 官方API：[Numpy](https://docs.scipy.org/doc/numpy/reference/arrays.ndarray.html#array-attributes)

## 基本概念

- `import numpy as np`，是 Numpy 库约定的导入方式。

- `ndarray` 类型是 Numpy 最主要的类型。

- `ndarray` 对象的元素具有相同的类型，并且一般是 Numpy 自定义的一些类型，如下：

  | Data type  | Description                                                  |
  | :--------: | :----------------------------------------------------------- |
  |  `bool_`   | Boolean (True or False) stored as a byte                     |
  |   `int_`   | Default integer type (same as C `long`; normally either `int64` or `int32`) |
  |    intc    | Identical to C `int` (normally `int32` or `int64`)           |
  |    intp    | Integer used for indexing (same as C `ssize_t`; normally either `int32`or `int64`) |
  |    int8    | Byte (-128 to 127)                                           |
  |   int16    | Integer (-32768 to 32767)                                    |
  |   int32    | Integer (-2147483648 to 2147483647)                          |
  |   int64    | Integer (-9223372036854775808 to 9223372036854775807)        |
  |   uint8    | Unsigned integer (0 to 255)                                  |
  |   uint16   | Unsigned integer (0 to 65535)                                |
  |   uint32   | Unsigned integer (0 to 4294967295)                           |
  |   uint64   | Unsigned integer (0 to 18446744073709551615)                 |
  |  `float_`  | Shorthand for `float64`.                                     |
  |  float16   | Half precision float: sign bit, 5 bits exponent, 10 bits mantissa |
  |  float32   | Single precision float: sign bit, 8 bits exponent, 23 bits mantissa |
  |  float64   | Double precision float: sign bit, 11 bits exponent, 52 bits mantissa |
  | `complex_` | Shorthand for `complex128`.                                  |
  | complex64  | Complex number, represented by two 32-bit floats (real and imaginary components) |
  | complex128 | Complex number, represented by two 64-bit floats (real and imaginary components) |

- `ndarray` 对象的元素的类型也可以不相同，但这会降低性能。

- 如果创建 `ndarray` 对象时，不指定元素的类型，那么会自动判断。

## 相关操作

### 创建 `ndarray` 对象

1、用列表，元组等创建：

```python
# 根据传入的类型，自动判断 dtype
np.array([1, 2, 3, 4])
# 指定 dtype
np.array((1, 2, 3, 4), dtype=np.int16)  
# 支持列表，元组混合
np.array([[1,2], [3,4], (0.5,0.6)])  
```

2、用 Numpy 中的函数创建：

```python
# 类似 range，但返回 ndarray 类型
np.arange([start,] stop[, step,], dtype=None)  
# 根据 shape 生成全为 1 的数组，这里指定了数据类型
np.ones((3, 6), dtype=np.int32)  
# 根据 shape 生成全为 0 的数组
np.zeros(3)  
# 根据 shape 生成全为 10 的数组
np.full((3,3,3), 10)  
# 创建一个 5*5 的单位矩阵，对角线为 1，其余为 0
np.eye(5)  
# 1 到 10 之间（包括 10），均匀选取 4 个数据
np.linspace(1, 10, 4)  
# 此时不包括 10
np.linspace(1, 10, 4, endpoint=False)  
# 合并 a，b 两个数组，返回一个新数组
np.concatenate((a, b))  
# 生成和 x 相同 shape 的全 1 数组
np.ones_like(x)  
# 生成和 x 相同 shape 的全 0 数组
np.zeros_like(x)  
# 生成和 x 相同 shape 的全 3 数组
np.full_like(x, 3)  
```

### `ndarray` 对象的重要属性

```python
# 维度数，等同 `len(a.shape)`
a.ndim
# 各个维度的长度，是个元组
a.shape
# 所有维度的总元素数量
a.size
# 元素的类型
a.dtype
# 元素类型占用大小
a.itemsize
# 所有数据占用的大小，字节为单位，等于 a.size*a.itemsize
a.nbytes  
```

### `ndarray` 对象的使用实例

转置：

```python
# 返回转置后的 a，非原地
a.T
```

数组维度的变换：

```python
# 转为 3 行 4 列的数组，非原地
a.reshape(3, 4)  
# -1 指根据数组元素个数自动分配
a.reshape(3, -1)  
# 跟 .reshape() 功能一致，但属原地操作
a.resize(3, 4)  
# 降维成一维数组，非原地
a.flatten()  
# 将 1（0+1）维和 2（1+1）维交换，有点难理解，配合实例去理解
a.swapaxes(0, 1)  
```

数组元素类型的变换：

```python
# 改变数组元素的类型, 非原地
a.astype(np.int32)
```

数组转列表：

```python
# 转成列表后就无法发挥numpy的性能优势了, 非原地
a.tolist() 
```

数组拷贝：

```python
# 返回一个新数组, 与a共用数据
a.view()
# 返回数组的深拷贝
a.copy()
```

### `ndarray` 对象的选取方式

对象在选取后也可进行修改。

```python
"""假设a是一维的"""
"""选取单个数据"""
a[3]  # 选取第4个元素
"""选取多个数据"""
a[1:10:2]  # 完全支持切片操作

"""假设a是三维的"""
"""选取单个数据"""
a[1, 2, 3]  # 选取3维第2号, 2维第3号, 3维第4号元素
a[1][2][3]  # 另一种选取方式, 但不推荐, 实测比上面慢3倍左右
a[-1, -2, -3]  # 支持负索引
"""选取多个数据"""
a[:, -1, 3]  # 支持多维切片
a[:, 1:3, :]
a[:, :, ::2]

"""无论a是几维的"""
a[a>10]  # 选取所有大于10的数据
a[(a>10)&(a<20)]  # 选取所有大于10小于20的数据
a[(a<=10)|(a>=20)]  # 选取所有小于等于10或大于等于20的数据

"""用方法选取元素"""
a.item(10)  # 选取第10个元素
a.item((1,2,3))  # 选取3维第2号, 2维第3号, 3维第4号元素
"""
那么该方法与索引选取的区别是什么呢?
索引选取出来的元素, 原先是什么类型就是什么类型,
item选取出来的类型会转换成python原生类型,
所以合理使用这两种选取方式, 能提高性能,
如你需要与python的int类型做计算时, 你应该用item取元素.
"""
```

### 数据存取相关

```python
"""csv文件只能存储一维和二维数据"""
np.savetxt('a.csv', a, fmt='%.1f', delimiter=',')  # 写入数据
np.loadtxt('a.csv', dtype=np.float, delimiter=',')  # 读取数据, 默认float

"""另一种存储方式, 能存储多维数据"""
b.tofile('b.dat', sep=',', format='%d')  # 这种存储方式会丢失维度信息
np.fromfile('b.dat', dtype=np.int, sep=',').reshape(5, 10, 2)  # 需用reshape还原
b.tofile('b.dat', format='%d')  # 不指定sep会生成二进制文件
np.fromfile('b.dat', dtype=np.int).reshape(5, 10, 2)  # 需用reshape还原

"""Numpy 便捷文件存取, 会保存维度, 元素类型信息"""
np.save('b', b)  # 正常存储,默认.npy格式
np.savez('b', b)  # 压缩存储, 默认.npz格式
np.load('b.npy')
```

### Numpy 中的重要统计函数

```python
np.gradient(a)  # 返回a中元素的梯度
np.max(a)  # 返回数组a最大值
np.min(a)  # 返回数组a最小值
np.argmax(a)  # 返回数组a最大值的降成一维后的坐标
np.argmin(a)  # 返回数组a最小值的降成一维后的坐标
np.unravel_index(index, shape)  # 根据shape将一维下标index转换成多维下标
np.ptp(a)  # 返回a中最大值与最小值的差
np.median(a)  # 返回a中元素的中位数
np.unique(a)  # 返回a去重后的数组, 类似set()
np.sum(a, axis)  # 根据给定轴axis计算相关元素之和, axis整数或元组
np.mean(a, axis)  # 根据给定轴axis计算相关元素的期望, axis整数或元组
np.average(a, axis, weights)  # 根据给定轴axis计算相关元素的加权平均值 axis整数或元组
np.std(a, axis)  # 根据给定轴axis计算相关元素标准差, axis整数或元组
np.var(a, axis)  # 根据给定轴axis计算相关元素方差, axis整数或元组
np.diag(a)  # 以一维数组的形式返回矩阵的对角线元素
np.trace(a)  # 计算对角线元素的和
```

### Numpy 中的重要运算函数

一元运算：

```python
np.abs(x)  # 求数组各元素的绝对值
np.fabs(x)  # 求数组各元素的绝对值
np.sqrt(x)  # 求数组各元素的平方根
np.square(x)  # 求数组各元素的平方
np.log(x)  # 求数组各元素的自然对数
np.log2(x)  # 求数组各元素的2底对数
np.log10(x)  # 求数组各元素的10底对数
np.ceil(x)  # 求数组各元素的ceiling值
np.floor(x)  # 求数组各元素的floor值
np.rint(x)  # 求数组各元素的四舍五入值
np.modf(x)  # 将数组各元素的整数和小数部分以两个独立数组形式返回
np.cos(x)  # 求数组各元素的cos值
np.sin(x)  # 求数组各元素的sin值
np.tan(x)  # 求数组各元素的tan值
np.exp(x)  # 求数组各元素的e^n值
np.sign(x)  # 求数组各元素的符号值, 1(+), 0, -1(-)
```

二元运算：

```python
+ - * / **  # 两个数组各元素间加减乘除指数运算
> < >= <= == !=  # 算数比较, 产生布尔型数组
np.maximum(a, b)  # 两个数组各元素进行比较, 取大的那个, 返回数组
np.fmax(a, b)  # 两个数组各元素进行比较, 取大的那个, 返回数组
np.minimum(a, b)  # 两个数组各元素进行比较, 取小的那个, 返回数组
np.fmin(a, b)  # 两个数组各元素进行比较, 取小的那个
np.mod(a, b)  # 两个数组各元素进行求模运算
np.copysign(a, b)  # 将b中各元素的符号赋值给a中各元素
```

### Numpy 中的重要随机函数

```python
# 生成 0 到 1 之间随机浮点数，shape 为 (3, 4, 5) 
np.random.rand(3, 4, 5) 
# 生成 -1 到 1 之间随机浮点数，shape 为 (3, 4, 5) 
np.random.randn(3, 4, 5) 
# 根据 shape 生成 x 到 y 之间随机整数
np.random.randint(x, y, shape) 
# 指定随机数种子，相同的随机数种子，生成相同的随机数
np.random.seed(10) 
# 将数组 a 的第 1 轴重新随机排序，改变原数组
np.random.shuffle(a)
# 根据数组 a 的第 1 轴产生一个新的乱序数组
np.random.permutation(a) 
# 从一维数组 a 以概率 p 取元素，形成 size 大小的新数组，replace 表示是否可以重用元素，默认 False
np.random.choice(a[, size, replace, p])
# 产生具有泊松分布的数组，lam 随机事件发生率，size 数量
np.random.poisson(lam, size)
# 产生具有均匀分布的数组，low 起始值，high 结束值，size 数量
np.random.uniform(low, high, size)
# 产生具有正态分布的数组，loc 均值，scale 标准差，size 数量
np.random.normal(loc, scale, size)
```

### Numpy 中其他重要函数

```python
# 当 condtiion 为真时返回 true_value，否则返回 false_value，返回一个新数组
np.where(condition, true_value, false_value)
```

### Numpy 与线性代数

```python
# 计算行列式
np.linalg.det(A)  
# 计算矩阵的特征值和特征向量
np.linalg.eig(A)  
# 计算矩阵的逆
np.linalg.inv(A)  
# 计算矩阵的 Moore-Penrose 伪逆
np.linalg.pinv(A)  
# 计算 qr 分解
np.linalg.qr(A)  
# 计算奇异值分解
np.linalg.svd(A)  
# 矩阵乘法，等同 `A @ b`
np.linalg.dot(A, b)  
# 解线性方程组 AX=b
np.linalg.solve(A, b)  
# 计算 AX=b 的最小二乘解
np.linalg.lstsq(A, b)  
```