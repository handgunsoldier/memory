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

假设a是一维的：

```python
# 选取第4个元素
a[3]  
# 完全支持切片操作
a[1:10:2]
```

假设a是三维的：

```python
"""选取单个数据"""
a[1, 2, 3]  # 选取 3 维第 2 号，2 维第 3 号，3 维第 4 号元素
a[1][2][3]  # 另一种选取方式，但不推荐，实测比上面慢 3 倍左右
a[-1, -2, -3]  # 支持负索引

"""选取多个数据"""
a[:, -1, 3]  # 支持多维切片
a[:, 1:3, :]
a[:, :, ::2]
```

无论a是几维的：

```python
# 选取所有大于 10 的数据
a[a>10]  
# 选取所有大于 10 小于 20 的数据
a[(a>10)&(a<20)]  
# 选取所有小于等于 10 或大于等于 20 的数据
a[(a<=10)|(a>=20)]  
```

用方法选取元素：

```python
# 选取第 10 个元素
a.item(10)  
# 选取 3 维第 2 号，2 维第 3 号，3 维第 4 号元素
a.item((1,2,3))  
```

那么该方法选取与索引选取的区别是什么呢？索引选取出来的元素，原先是什么类型就是什么类型，item 选取出来的类型会转换成 Python 原生类型，所以合理使用这两种选取方式，能提高性能，如你需要与 Python 的 int 类型做计算时，你应该用 item 取元素。

### 数据存取相关

csv 存取，只能存储一维和二维数据：

```python
# 写入数据
np.savetxt('a.csv', a, fmt='%.1f', delimiter=',')
# 读取数据，默认 float
np.loadtxt('a.csv', dtype=np.float, delimiter=',')  
```

另一种存储方式, 能存储多维数据：

```python
# 这种存储方式会丢失维度信息
b.tofile('b.dat', sep=',', format='%d')
# 需用 reshape 还原
np.fromfile('b.dat', dtype=np.int, sep=',').reshape(5, 10, 2)
# 不指定 sep 会生成二进制文件
b.tofile('b.dat', format='%d')  
# 需用 reshape 还原
np.fromfile('b.dat', dtype=np.int).reshape(5, 10, 2)  
```

Numpy 便捷文件存取, 会保存维度, 元素类型信息：

```python
# 正常存储，默认 .npy 格式
np.save('b', b)
# 压缩存储，默认 .npz 格式
np.savez('b', b)
# 读取
np.load('b.npy')
```

### Numpy 中的重要统计函数

```python
# 返回 a 中元素的梯度
np.gradient(a)  
# 返回数组 a 最大值
np.max(a)  
# 返回数组 a 最小值
np.min(a)  
# 返回数组 a 最大值的降成一维后的坐标
np.argmax(a)  
# 返回数组 a 最小值的降成一维后的坐标
np.argmin(a)  
# 根据 shape 将一维下标 index 转换成多维下标
np.unravel_index(index, shape)  
# 返回 a 中最大值与最小值的差
np.ptp(a)  
# 返回 a 中元素的中位数
np.median(a)  
# 返回 a 去重后的数组，类似 set()
np.unique(a)  
# 根据给定轴 axis 计算相关元素之和，axis 是整数或元组
np.sum(a, axis)  
# 根据给定轴 axis 计算相关元素的期望，axis 是整数或元组
np.mean(a, axis)  
# 根据给定轴 axis 计算相关元素的加权平均值，axis 是整数或元组
np.average(a, axis, weights)  
# 根据给定轴 axis 计算相关元素标准差，axis 是整数或元组
np.std(a, axis)  
# 根据给定轴 axis 计算相关元素方差，axis 是整数或元组
np.var(a, axis)  
# 以一维数组的形式返回矩阵的对角线元素
np.diag(a)
# 计算对角线元素的和
np.trace(a)  
```

### Numpy 中的重要运算函数

一元运算：

```python
# 求数组各元素的绝对值
np.abs(x)  
# 求数组各元素的绝对值
np.fabs(x)  
# 求数组各元素的平方根
np.sqrt(x)  
# 求数组各元素的平方
np.square(x)  
# 求数组各元素的自然对数
np.log(x)  
# 求数组各元素的 2 底对数
np.log2(x)  
# 求数组各元素的 10 底对数
np.log10(x)  
# 求数组各元素的 ceiling 值
np.ceil(x)  
# 求数组各元素的 floor 值
np.floor(x)  
# 求数组各元素的四舍五入值
np.rint(x)  
# 将数组各元素的整数和小数部分以两个独立数组形式返回
np.modf(x)  
# 求数组各元素的 cos 值
np.cos(x)  
# 求数组各元素的 sin 值
np.sin(x)  
# 求数组各元素的 tan 值
np.tan(x)  
# 求数组各元素的 e^n 值
np.exp(x)  
# 求数组各元素的符号值，1（+），0，-1（-）
np.sign(x)  
```

二元运算：

```python
# 两个数组各元素间加减乘除指数运算
+ - * / **  
# 算数比较，产生布尔型数组
> < >= <= == !=  
# 两个数组各元素进行比较，取大的那个，返回数组
np.maximum(a, b)  
# 两个数组各元素进行比较，取大的那个
np.fmax(a, b)  
# 两个数组各元素进行比较，取小的那个，返回数组
np.minimum(a, b)  
# 两个数组各元素进行比较，取小的那个
np.fmin(a, b)  
# 两个数组各元素进行求模运算
np.mod(a, b)  
# 将 b 中各元素的符号赋值给 a 中各元素
np.copysign(a, b)
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