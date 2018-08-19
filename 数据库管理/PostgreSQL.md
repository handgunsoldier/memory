## 基本

### 初始化数据库

```bash
su - postgres -c "initdb --locale en_US.UTF-8 -D '/var/lib/postgres/data'"
```

注意这里输入的是 postgres 用户的密码，默认为 postgres 。

### 启动

后台启动：

```bash
sudo systemctl start postgresql
```

### 命令行客户端

启动客户端：

```bash
psql 
```

命令：

```bash
# 列出所有数据库
\l
```

### 注意点

- PostgreSQL 中插入的数据必须用**单引号**引起来，而不能使用双引号，MySQL 中可以。
- 创建约束（Constraints）也会自动创建索引（Index），所以不必特意创建索引了。

### 字符串操作函数

| **函数**                                                     | **返回类型** | **描述**                                                     | **例子**                                       | **结果**                           |
| ------------------------------------------------------------ | ------------ | ------------------------------------------------------------ | ---------------------------------------------- | ---------------------------------- |
| string \|\| string                                           | text         | 字串连接                                                     | 'Post' \|\| 'greSQL'                           | PostgreSQL                         |
| bit_length(string)                                           | int          | 字串里二进制位的个数                                         | bit_length('jose')                             | 32                                 |
| char_length(string)                                          | int          | 字串中的字符个数                                             | char_length('jose')                            | 4                                  |
| convert(string using conversion_name)                        | text         | 使用指定的转换名字改变编码。                                 | convert('PostgreSQL' using iso_8859_1_to_utf8) | 'PostgreSQL'                       |
| lower(string)                                                | text         | 把字串转化为小写                                             | lower('TOM')                                   | tom                                |
| octet_length(string)                                         | int          | 字串中的字节数                                               | octet_length('jose')                           | 4                                  |
| overlay(string placing string from int [for int])            | text         | 替换子字串                                                   | overlay('Txxxxas' placing 'hom' from 2 for 4)  | Thomas                             |
| position(substring in string)                                | int          | 指定的子字串的位置                                           | position('om' in 'Thomas')                     | 3                                  |
| substring(string [from int]\[for int])                       | text         | 抽取子字串                                                   | substring('Thomas' from 2 for 3)               | hom                                |
| substring(string from pattern)                               | text         | 抽取匹配 POSIX 正则表达式的子字串                            | substring('Thomas' from '...$')                | mas                                |
| substring(string from pattern for escape)                    | text         | 抽取匹配SQL正则表达式的子字串                                | substring('Thomas' from '%#"o_a#"_' for '#')   | oma                                |
| trim([leading \| trailing \| both]\[ characters] from string) | text         | 从字串string的开头/结尾/两边/ 删除只包含characters(缺省是一个空白)的最长的字串 | trim(both 'x' from 'xTomxx')                   | Tom                                |
| upper(string)                                                | text         | 把字串转化为大写。                                           | upper('tom')                                   | TOM                                |
| ascii(text)                                                  | int          | 参数第一个字符的ASCII码                                      | ascii('x')                                     | 120                                |
| btrim(string text [, characters text])                       | text         | 从string开头和结尾删除只包含在characters里(缺省是空白)的字符的最长字串 | btrim('xyxtrimyyx','xy')                       | trim                               |
| chr(int)                                                     | text         | 给出ASCII码的字符                                            | chr(65)                                        | A                                  |
| convert(string text, [src_encoding name,] dest_encoding name) | text         | 把字串转换为dest_encoding                                    | convert( 'text_in_utf8', 'UTF8', 'LATIN1')     | 以ISO 8859-1编码表示的text_in_utf8 |
| initcap(text)                                                | text         | 把每个单词的第一个子母转为大写，其它的保留小写。单词是一系列字母数字组成的字符，用非字母数字分隔。 | initcap('hi thomas')                           | Hi Thomas                          |
| length(string text)                                          | int          | string中字符的数目                                           | length('jose')                                 | 4                                  |
| lpad(string text, length int [, fill text])                  | text         | 通过填充字符fill(缺省时为空白)，把string填充为长度length。 如果string已经比length长则将其截断(在右边)。 | lpad('hi', 5, 'xy')                            | xyxhi                              |
| ltrim(string text [, characters text])                       | text         | 从字串string的开头删除只包含characters(缺省是一个空白)的最长的字串。 | ltrim('zzzytrim','xyz')                        | trim                               |
| md5(string text)                                             | text         | 计算给出string的MD5散列，以十六进制返回结果。                | md5('abc')                                     |                                    |
| repeat(string text, number int)                              | text         | 重复string number次。                                        | repeat('Pg', 4)                                | PgPgPgPg                           |
| replace(string text, from text, to text)                     | text         | 把字串string里出现地所有子字串from替换成子字串to。           | replace('abcdefabcdef', 'cd', 'XX')            | abXXefabXXef                       |
| rpad(string text, length int [, fill text])                  | text         | 通过填充字符fill(缺省时为空白)，把string填充为长度length。如果string已经比length长则将其截断。 | rpad('hi', 5, 'xy')                            | hixyx                              |
| rtrim(string text [, character text])                        | text         | 从字串string的结尾删除只包含character(缺省是个空白)的最长的字 | rtrim('trimxxxx','x')                          | trim                               |
| split_part(string text, delimiter text, field int)           | text         | 根据delimiter分隔string返回生成的第field个子字串(1 Base)。   | split_part('abc~@~def~@~ghi', '~@~', 2)        | def                                |
| strpos(string, substring)                                    | text         | 声明的子字串的位置。                                         | strpos('high','ig')                            | 2                                  |
| substr(string, from [, count])                               | text         | 抽取子字串。                                                 | substr('alphabet', 3, 2)                       | ph                                 |
| to_ascii(text [, encoding])                                  | text         | 把text从其它编码转换为ASCII。                                | to_ascii('Karel')                              | Karel                              |
| to_hex(number int/bigint)                                    | text         | 把number转换成其对应地十六进制表现形式。                     | to_hex(9223372036854775807)                    | 7fffffffffffffff                   |
| translate(string text, from text, to text)                   | text         | 把在string中包含的任何匹配from中的字符的字符转化为对应的在to中的字符。 | translate('12345', '14', 'ax')                 | a23x5                              |

##  psycopg2

### 安装驱动

```bash
pip install psycopg2-binary
```

### 连接数据库

```python
import psycopg2

conn = psycopg2.connect(user='postgres', dbname='postgres')
conn.autocommit = True  # 开启自动提交
cursor = conn.cursor()
```

这里设置 `autocommit` ，提高插入速度，主要用在插入频繁的爬虫项目中。注意 psycopg2 不能在connect 函数参数中设置 `autocommit` 。

### 插入数据

设置了 `autocommit`：

```python
try:
    cursor.execute("INSERT INTO test (name) VALUES ('xiaoming')")
except psycopg2.IntegrityError:
    print('重复')
```

没设置 `autocommit`：

```python
try:
    cursor.execute('insert into NewTable (name) values (\'xiaoming\')')
    conn.commit()
except psycopg2.IntegrityError:
    conn.rollback()
    print('重复')
```

根据一个字典构建插入语句：

```python
POSTGRESQL_TABLE = 'review'

item = {
    'user_id': 'user_id',
    'user_name': 'user_name',
    'text': 'text',
    'rating': 'rating',
    'time': 'time'
}

insert_query_temp = 'INSERT INTO %s ({}) VALUES ({})' % POSTGRESQL_TABLE
query = insert_query_temp.format(
    ', '.join(item),
    ', '.join(f'%({k})s' for k in item)
)
print(query)

cursor.execute(query, item)
```

结果：

```sql
INSERT INTO review (user_id, user_name, text, rating, time) VALUES (%(user_id)s, %(user_name)s, %(text)s, %(rating)s, %(time)s)
```

### 更新数据

根据一个字典构建更新语句：

```python
POSTGRESQL_TABLE = 'review'

item = {
    'user_name': 'user_name',
    'text': 'text',
    'rating': 'rating',
    'time': 'time'
}
user_id = 'user_id'

update_query_temp = 'UPDATE %s SET {} WHERE {}' % POSTGRESQL_TABLE
query = update_query_temp.format(
    ', '.join(f'{k} = %({k})s' for k in item),
    'user_id = \'{}\''
)
print(query.format(user_id))

cursor.execute(query.format(user_id), item)
```

结果：

```sql
UPDATE review SET user_name = %(user_name)s, text = %(text)s, rating = %(rating)s, time = %(time)s WHERE user_id = 'user_id'
```

### 查询数据

用 `while` 循环加 `fetchone()` 的方法来获取所有数据，而不是用 `fetchall()` 全部一起获取出来，`fetchall()` 会将结果以元组组成的列表形式全部返回，如果数据量很大，那么占用的开销会非常高。所以推荐使用如下的方法来逐条取数据：

```python
sql = 'SELECT * FROM students WHERE age >= 20'
try:
    cursor.execute(sql)
    print('Count:', cursor.rowcount)
    row = cursor.fetchone()
    while row:
        print('Row:', row)
        row = cursor.fetchone()
except:
    print('Error')
```

这样每循环一次，指针就会偏移一条数据，随用随取，简单高效。