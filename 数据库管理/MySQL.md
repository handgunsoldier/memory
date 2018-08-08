## MySQL

### 初始化

```bash
# 初始化数据库, 第一次安装需运行
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# 设置密码
mysqladmin -u root password "newpass"

# 修改密码, 登录mysql后, 输入
mysql> SET PASSWORD FOR 'root'@'localhost' = PASSWORD('newpass');
```

### 启动

```bash
# 后台
sudo systemctl start mysqld
```

### 客户端命令

```mysql
# 启动客户端
mysql -u root -p

# 创建数据库
create database <数据库名>;
# 显示可用数据库
show database; 
# 切换数据库
use <数据库名>;
# 创建表
create table <表名>;
# 显示可用表
show tables; 
# 显示指定表信息
describe <表名>; 
```

### 导入数据

```mysql
# 1.创建数据库, 默认utf8mb4
create database if not exists <数据库名>;
# 2.切换数据库
use <数据库名>;
# 3.设置数据库编码(可选, 不建议修改)
# 目前安装的mariadb默认utf8mb4,
# 占4个字节, 为了支持移动端的一些表情,
# 而utf8占三个字节, 无法放下某些表情,
# 所以坚持使用utf8mb4
set names utf8mb4;
# 4.导入
mysql>source /home/abc/abc.sql;
```

### 一些常见问题

```bash
# 1.default collation 和 default characterset 是什么?
#   defalut characterse 就是schema或table用的字符集, 默认utf8mb4,
#   default collation 影响字符串的排序规则, 默认utf8mb4_unicode_ci,
#   ci 是 case insensitive, 即 "大小写不敏感", a 和 A 会在字符判断中会被当做一样的

# 2.workbench 创建表时, 后面的字段意义
#   PK: primary key  主键
#   NN: not null  非空
#   UQ: unique  唯一
#   AI: auto increment  自增
#   BIN: binary  二进制(比text更大的二进制数据)
#   UN: unsigned  无符号整数
#   ZF: zero fill 填充0位(例如指定3位小数，整数18就会变成18.000)
#   G : Generated column  基于其他列的公式生成值的列
```

### 几条值得参考的sql语句

```mysql
# 两条语句功能一样
select biz, max(publish_time) from wechat.post_list GROUP by biz HAVING MAX(publish_time) < date("2018-01-01")
select * from (select biz, max(publish_time) as publish_time from wechat.post_list GROUP by biz) as t1 where publish_time < date("2018-01-01");

# 时间转换例子, 结果为今天零点的时间, datetime类型
select from_unixtime(unix_timestamp(date(now())))
```

## Pymysql

### 连接数据库

```python
import pymysql

db = pymysql.connect(user='root', password='123456', autocommit=True)
cursor = db.cursor()
```

这里设置 `autocommit` ，提高插入速度，主要用在插入频繁的爬虫项目中。

### 插入数据

设置了 `autocommit`：

```python
try:
    cursor.execute("INSERT INTO test (name) VALUES ('小明')")
except pymysql.IntegrityError:
    print('重复')
```

没设置 `autocommit`：

```python
try:
    cursor.execute('insert into NewTable (name) values ("xiaoming")')
    conn.commit()
except pymysql.IntegrityError:
    conn.rollback()
    print('重复')
```

### 查询数据

用 `while` 循环加 `fetchone()` 的方法来获取所有数据，而不是用 `fetchall()` 全部一起获取出来，`fetchall()` 会将结果以元组形式全部返回，如果数据量很大，那么占用的开销会非常高。所以推荐使用如下的方法来逐条取数据：

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
