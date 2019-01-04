# MySQL

## 基本

### 初始化

初始化数据库，第一次安装需运行：

```bash
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
```

设置密码：

```bash
mysqladmin -u root password "newpass"
```

若要修改密码，登录 MySQL 后，输入：

```mysql
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('newpass');
```

### 启动

后台启动：

```bash
sudo systemctl start mysqld
```

### 命令行客户端

启动客户端：

```bash
mysql -u root -p
```

命令：

```mysql
# 创建数据库
create database <数据库名>;
# 显示可用数据库
show database; 
# 切换数据库
use <数据库名>;
# 显示可用表
show tables; 
# 显示指定表信息
describe <表名>; 
```

### 还原数据

创建数据库，默认编码 `utf8mb4`：

```mysql
create database if not exists <数据库名>;
```

切换数据库：

```mysql
use <数据库名>;
```

设置数据库编码（可选，不建议修改）：

```mysql
set names utf8mb4;
```

目前安装的 MariaDB 默认 `utf8mb4`，占4个字节，为了支持移动端的一些表情，而 utf8 占三个字节，无法放下某些表情，所以坚持使用 utf8mb4 。

导入 sql 文件：

```mysql
source /home/abc/abc.sql;
```

## 一些常见问题

### 「default collation」和「default characterset」是什么?

- 「defalut characterse」就是 schema 或 table 用的字符集，建议使用 `utf8mb4` 。
- 「default collation」影响字符串的排序规则，一般使用 `utf8mb4_general_ci` 。
    - utf8mb4_unicode_ci 是基于标准的 Unicode 来排序和比较，能够在各种语言之间精确排序。
    - utf8mb4_general_ci 没有实现 Unicode 排序规则，在遇到某些特殊语言或者字符集，排序结果可能不一致。
    - ci 是 case insensitive，即 「大小写不敏感」, a 和 A 会在字符判断中会被当做一样的。

## 几条值得参考的sql语句

```mysql
# 两条语句功能一样
select biz, max(publish_time) from wechat.post_list GROUP by biz HAVING MAX(publish_time) < date("2018-01-01")
select * from (select biz, max(publish_time) as publish_time from wechat.post_list GROUP by biz) as t1 where publish_time < date("2018-01-01");

# 时间转换例子，结果为今天零点的时间，datetime 类型
# unix_timestamp 是 mysql 独有函数
select from_unixtime(unix_timestamp(date(now())))
```

## 其他

Windows 下，可在 *my.ini* 中加一行 `skip-grant-tables`，然后重启 mysql 服务，可跳过所有密码验证。

## Python连接

### 安装驱动

```bash
pip install pymysql
```

### 连接数据库

```python
MYSQL_HOST = 'localhost'
MYSQL_PORT = 3306
MYSQL_USER = 'root'
MYSQL_PWD = '123456'
MYSQL_DB = 'wechat'
MYSQL_TABLE = 'post_list'

import pymysql

conn = pymysql.connect(
    host=MYSQL_HOST, port=MYSQL_PORT,
    user=MYSQL_USER, password=MYSQL_PWD,
    db=MYSQL_DB, autocommit=True
)
cursor = conn.cursor()
```

### 插入数据

设置了 `autocommit`：

```python
try:
    cursor.execute("INSERT INTO test (name) VALUES ('xiaoming')")
except pymysql.IntegrityError:
    print('重复')
```

没设置 `autocommit`：

```python
try:
    cursor.execute('insert into NewTable (name) values (\'xiaoming\')')
    conn.commit()
except pymysql.IntegrityError:
    conn.rollback()  # 回滚到上一次提交时
    print('重复')
```

根据一个字典构建插入语句：

```python
MYSQL_TABLE = 'review'

item = {
    'user_id': 'user_id',
    'user_name': 'user_name',
    'text': 'text',
    'rating': 'rating',
    'time': 'time'
}

insert_sql_temp = 'INSERT INTO %s ({}) VALUES ({})' % MYSQL_TABLE
sql = insert_sql_temp.format(
    ', '.join(item),
    ', '.join(f'%({k})s' for k in item)
)
print(sql)

cursor.execute(sql, item)
```

结果：

```sql
INSERT INTO review (user_id, user_name, text, rating, time) VALUES (%(user_id)s, %(user_name)s, %(text)s, %(rating)s, %(time)s)
```

### 更新数据

根据一个字典构建更新语句：

```python
MYSQL_TABLE = 'review'

item = {
    'user_name': 'user_name',
    'text': 'text',
    'rating': 'rating',
    'time': 'time'
}
user_id = 'user_id'

update_sql_temp = 'UPDATE %s SET {} WHERE {}' % MYSQL_TABLE
sql = update_sql_temp.format(
    ', '.join(f'{k} = %({k})s' for k in item),
    'user_id = \'{}\''
)
print(sql.format(user_id))

cursor.execute(sql.format(user_id), item)
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