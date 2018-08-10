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

1. PostgreSQL 中插入的数据必须用**单引号**引起来，而不能使用双引号，MySQL 中可以。
2. 创建约束（Constraints）也会自动创建索引（Index），所以不必特意创建索引了。

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

item = dict()
item['user_id'] = 'user_id'
item['user_name'] = 'user_name'
item['text'] = 'text'
item['rating'] = 'rating'
item['time'] = 'time'

query_temp = 'INSERT INTO %s ({}) VALUES ({})' % POSTGRESQL_TABLE
query = query_temp.format(
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