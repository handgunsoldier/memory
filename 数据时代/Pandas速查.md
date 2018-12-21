# Pandas 速查手册

## 相关链接

- 官方API：[pandas](https://pandas.pydata.org/pandas-docs/stable/)

## 基础概念

- `import pandas as pd`，是 Pandas 库约定的导入方式。

- Pandas 库的两种重要数据类型：`Series` 类型（对应一维）和 `DataFrame` 类型（对应二维）。

- `DataFrame` 类型的每一列对应着一个 `Series` 类型。

- Pandas 数据类型：

  |        类型        |                  含义                   |
  | :----------------: | :-------------------------------------: |
  |       float        |                                         |
  |        int         |                                         |
  |        bool        |                                         |
  |       object       | python 的类型，如 str，可以使用相关方法 |
  |   datetime64[ns]   |       时间类型，不带时区，即 UTC        |
  | datetime64[ns, tz] |    时间类型，带时区（tz，time zone）    |
  |   timedelta[ns]    |                                         |
  |      category      |                                         |

## 相关操作

### 创建基本对象

`Series` 对象的几种创建方式：

```python
# 不指定索引，也会有默认的位置索引（0...n），从 0 开始
pd.Series(range(5))
# 加上自定义索引，会和默认索引共存
pd.Series([9, 8, 7, 6], ['a', 'b', 'c', 'd'])
# 字典形式创建
pd.Series({'a':1, 'b':2, 'c':3})
# 根据索引选择字典中的值，不存在返回 NaN
pd.Series({'a':8, 'b':9, 'c':7}, ['c', 'b', 'd', 'a'])
# 和 Numpy 完美兼容
pd.Series(np.arange(3), ['one', 'two', 'three'])
```

`DataFrame` 对象的几种创建方式：

```python
# 用 ndarray 对象创建
pd.DataFrame(np.arange(10).reshape(2, 5))
# 用 Series 对象创建
dt = {
'one': pd.Series([1, 2, 3], ['a', 'b', 'c']),
'two': pd.Series([9, 8, 7, 6], ['a', 'b', 'c', 'd']),
}
pd.DataFrame(dt)
# 用字典组成的列表创建
lst = [{'one':1}, {'one':2}, {'one':3}]
pd.DataFrame(lst)
# 指定行列
dates = pd.date_range('20180101', periods=6)  # 创建一个长度为 6 的时间序列，单位天
pd.DataFrame(np.random.randn(6,4), index=dates, columns=list('ABCD'))
```

### `Series` 对象元素的选取方式

注意位置索引和自定义索引不能混用。

位置索引：

```python
# 选取第 2 行元素
s[1]
# 选取第 2 到第 9 行元素
s[1:9]
# 选取第 2 到最后，每隔 2 行的元素
s[1::2]
```

自定义索引：

```python
# 选取 one 行的元素
s['one']
# 选取 one 到 three 行元素
s['one':'three']
# 选取开头到 three 行，每隔 2 行的元素
s[:'three':2]
```

布尔索引：

```python
# 选取所有 value 小于 10 的 s
s[s<10]
# 选取所有 value 大于等于 10，小于 20 的 s
s[s.between(10, 20)]
```

### `DataFrame` 对象元素的选取方式

注意位置索引和自定义索引不能混用。

要选取列，用这种方式，快很多（但不支持位置索引和切片）：

```python
# 选择 xm 这一列，是 Series 类型
df['xm']
# 选择 xm 这一列，是 DataFrame 类型
df[['xm']]
# 选择 xm, csrq 两列，是 DataFrame 类型
df[['xm','csrq']]
# 列顺序会根据输入顺序返回，所以这种方法可以改变列顺序
df = df[['xm','csrq']]
```

位置索引：

```python
# 选择第二行所有数据，是 Series 类型
df.iloc[2]
# 选择第二行所有数据，是 DataFrame 类型
df.iloc[[2]]
# 选择第二列所有数据，是 Series 类型
df.iloc[:, 2]
# 选择第二列所有数据，是 DataFrame 类型
df.iloc[:, [2]]
# 选择 0 到 2 列所有数据
df.iloc[:, 0:2]
# 选择 2 和 3 行，0 到 2 列所有数据
df.iloc[[2,3], 0:2]
# 根据位置快速取出数据，获取单个数据推荐这种方法
df.iat[1, 1]
```

自定义索引：

```python
# 选择指定行数据，是 Series 类型
df.loc['top']
# 选择指定行数据，是 DataFrame 类型
df.loc[['top']]
# 选择指定列数据，是 Series 类型（不推荐）
df.loc[:, 'xm']
# 选择指定列数据，是 DataFrame 类型（不推荐）
df.loc[:, ['xm']]
# 选择多列数据（不推荐）
df.loc[:, ['bj','xm']]
# 选择多列之间所有数据，列切片只能用这种方法
df.loc[:, 'bj':'xb']
# 选择指定行，指定列数据
df.loc[['top','count'], 'bj':'xb']
# 根据自定义索引快速取出数据，获取单个数据推荐这种方法
df.at['top', 'xm']
```

在有多重索引的情况下进行选取：

```python
# 一级索引，二级索引
df.loc[('state', 'city')]
# 上面的省略写法
df.loc['state', 'city']
# 同时指定列
df.loc[('state', 'city'), ['name']]
```

布尔索引：

```python
# 选取所有出生日期大于等于 1998 年的数据，这里是字符串比较
df[df['csrq']>='1998']
# 选取所有出生日期大于等于 1997 年小于 1999 年的数据
df[(df['csrq']>='1997')&(data['csrq']<'1999')]
# 选取所有出生日期大于等于 1997 年小于 1999 年的数据
df[df['csrq'].between('1997', '1999')]
# 选取所有出生日期大于等于 1997 年或者姓名为张三的数据
df[(df['csrq']>='1997')|(data['xm']=='张三')]
# 另一种选取方式（不推荐，实测效率比上面低）
df[df.csrq>='1998']
# 选择字段值为指定内容的数据
df[df['xm'].isin(['张三','李四'])]
```

### `Series` 对象的使用实例：

重要属性：

```python
# 所有元素的 value，ndarray 类型
s.values
# 元素类型
s.dtype
# 元素的数量
s.size
# 每个元素的大小，字节为单位
s.itemsize
# 所有数据占用的大小，字节为单位，等于 `s.size * s.itemsize`
s.nbytes
```

常用方法：

```python
# 返回一个去重后的 ndarray 数组
s.unique()
# 显示唯一值和计数，dropna=False 代表不包含 NaN
s.value_counts(dropna=False)
# 删除第一行，非原地
s.drop(0)
# 在行尾添加数据，s 是 Series 对象
s.append(s)
# 将 func 作用在 s 所有值上
s.apply(func)
# 根据 s 的 value 排序，可传入 ascending 参数决定升序降序
s.sort_values()
# 根据 s 的 index 排序，可传入 ascending 参数决定升序降序
s.sort_index()
# 改变类型，非原地
s.astype()
```

`str` 系列方法：

```python
# 和 Python 原生字符串操作基本一致，只不过作用于所有元素
s.str.xxx()
# 支持切片，同样作用于所有元素
s.str[1, -1]
```

`dt` 系列方法， 先要用 `pd.to_datetime(s['time']) ` 或 `s.astype('datetime64[ns]')` 把 `Series` 对象元素类型转成 `datetime64[ns]` 类型：

```python
# 取出年月日
s.dt.date()
# 取出时间
s.dt.time()
# 取出年
s.dt.year()
# 取出月
s.dt.month()
# 取出日
s.dt.day()
# 取出时
s.dt.hour()
# 取出分
s.dt.minute()
# 取出秒
s.dt.second()
```

相关运算：

```python
# 所有元素加 1，原地
s += 1
```

其他符号的运算与此类似。

### `DataFrame` 对象的使用实例

大部分也适用 `Series` 类型。

重要属性：

```python
# 查看所有元素的 value
df.values
# 查看所有元素的类型
df.dtypes
# 查看所有行名，后加 `.tolist()`，可以返回列表
df.index
# 重命名行名
df.index = ['总数', '不同', '最多', '频率']
# 查看所有列名，后加 `.tolist()`，可以返回列表
df.columns
# 重命名列名
df.columns = ['班级', '姓名', '性别', '出生日期']
# 转置后的 df，非原地
df.T
```

查看数据：

```python
# 查看 df 前 n 条数据, 默认 5 条
df.head(n)
# 查看 df 后 n 条数据, 默认 5 条
df.tail(n)
# 查看行数和列数
df.shape()
# 查看索引，数据类型和内存信息
df.info()
```

数据统计：

```python
# 查看数据值列的汇总统计，是 DataFrame 类型
df.describe()
# 返回每一列中的非空值的个数
df.count()
# 返回每一列的和，无法计算返回空，下同
df.sum()
# `numeric_only=True` 代表只计算数字型元素，下同
df.sum(numeric_only=True)
# 返回每一列的最大值
df.max()
# 返回每一列的最小值
df.min()
# 返回最大值所在的自动索引位置
df.argmax()
# 返回最小值所在的自动索引位置
df.argmin()
# 返回最大值所在的自定义索引位置
df.idxmax()
# 返回最小值所在的自定义索引位置
df.idxmin()
# 返回每一列的均值
df.mean()
# 返回每一列的中位数
df.median()
# 返回每一列的方差
df.var()
# 返回每一列的标准差
df.std()
# 检查 df 中空值，NaN 为 True，否则 False，返回一个布尔数组
df.isnull()
# 检查 df 中空值，非 NaN 为 True，否则 False，返回一个布尔数组
df.notnull()
```

数据处理：

```python
# 改变列顺序
df = df[['xm','csrq']]
# 改变指定列元素类型，非原地
df.astype({'xh':'int', 'csrq':'datetime64[ns]'})
# 根据 xm 和 xh 去重，默认保留第一个数据，非原地
df.drop_duplicates(['xm', 'xh'])
# 不传入参数，所有列相同才会去重，保留最后一个数据，非原地
df.drop_duplicates(keep='last')
# 不保留重复项（求差集），非原地
df.drop_duplicates(keep=False)
# 根据 csrq 排序，默认升序，非原地
df.sort_values(by='csrq')
# ascending 决定升序降序
df.sort_values(['col1', 'col2'], ascending=[True, False])
# 用 'one' 代替所有等于 1 的值
df.replace(1,'one')
# 用 'one' 代替 1，用 'three' 代替 3
df.replace([1,3], ['one','three'])
# 用 x 替换 df 中所有的空值，非原地
df.fillna(x)
# 用 x 替换 df 的 xh 列中所有的空值
df.fillna({'xh':0})
# 删除所有包含空值的行
df.dropna()
# 删除所有包含空值的列
df.dropna(axis=1)
# 删除某列含有空值的行
df.dropna(subset=['nj'])
# 分组功能
df.groupby(['nj', 'bj'])
# 设置多索引，并排序索引
df.set_index(['state', 'city']).sort_index()
# 把相关函数作用在所有 df 成员上
df.applymap(func)
# 根据其他列处理某列
df.apply(lambda x: func(x['sell sku'], x['shape']), axis = 1)
```

添加和删除：

```python
# 假设 cj 列本来不存在，这样会在列尾添加新的一列 cj，值为 s（Series 对象），原地
df['cj'] = s
# 添加或修改一个列表在指定行，原地
df.iloc[0] = lst
# 在第 1 列位置插入一列 dz（地址），值为 s，原地
df.insert(0, 'dz', s)
# 在 df 中添加内容为 df2 （必须是 DataFrame 对象）的新列（添加列），非原地
df.join(df2)
# 将 df2 中的行添加到 df 的尾部（添加行），非原地
df.append(df2)
# 删除单列，并返回删除的列，原地
df.pop('xm')
# 删除指定行，非原地
df.drop(1)
# 删除指定列，axis=1 指第 2 维（列），axis 默认 0（行），非原地
df.drop(['xm', 'xh'], axis=1)
```

相关运算：

```python
# age 列所有元素加 1，原地
df['age'] += 1
```

其他符号运算与此类似。

### 数据存取相关

SQLite 存取：

```python
# 先要连接当前目录下的 sqlite3 数据库，不存在则创建
db = sqlite3.connect('data.sqlite')
# 导出数据到数据库指定表，不包含索引
df.to_sql('table_name', index=False, con=db)
# 从数据库指定表导入指定列数据
pd.read_sql('select * from table_name', con=db)
```

CSV 存取：

```python
# 导出数据到 CSV 文件，不包含索引
df.to_csv('example.csv', index=False)
# 从 CSV 文件导入数据
pd.read_csv('example.csv')
```

Excel 存取：

```python
# 导出数据到 Excel 文件，指定 Excel engine
# 这个 engine 更快
df.to_excel('example.xlsx', engine='xlsxwriter')
# 从 Excel 文件导入数据
pd.read_excel('example.xlsx')
```

存 Excel 的高级用法，可以指定 sheet：

```python
writer = pd.ExcelWriter(
    'example.xlsx',
    engine='xlsxwriter',
    options={'strings_to_urls': False}  # 直接存 url 会有 6w 的上限，改成字符串形式
)
df.to_excel(writer, sheet_name='Sheet1')
df2.to_excel(writer, sheet_name='Sheet2')
writer.save()
```

存入 MonogDB：

```python
# 先生成以 column 为 key 的字典组成的列表
records = df.to_dict(orient='records')
# 存入 MonogDB
collection.insert_many(records)
```

### Pandas 常用函数

```python
# 将 Series 对象转换成时间类型，可以用相关方法
pd.to_datetime(s)

# 生成一个时间列表，periods 决定数量，freq 决定单位，比如这里 'D' 是指天
# 成员是 Timestamp 类型，可以使用相关方法
pd.date_range('2017-7-27', periods=15, freq='D')

# 判断某个值是否为 NAN
# 也可判断 df, 返回一个 bool 类型的 df
pd.isna(df)
```

