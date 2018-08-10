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
# 创建表
create table <表名>;
# 显示可用表
show tables; 
# 显示指定表信息
describe <表名>; 
```

### 还原数据

1. 创建数据库，默认编码 `utf8mb4`：

```mysql
create database if not exists <数据库名>;
```

2. 切换数据库：

```mysql
use <数据库名>;
```

3. 设置数据库编码(可选, 不建议修改)：

```mysql
set names utf8mb4;
```

目前安装的 MariaDB 默认 `utf8mb4`，占4个字节，为了支持移动端的一些表情，而 utf8 占三个字节，无法放下某些表情，所以坚持使用utf8mb4。

4. 导入

```mysql
source /home/abc/abc.sql;
```

### 一些常见问题

1. 「default collation」和「default characterset」是什么?

「defalut characterse」就是 schema 或 table 用的字符集，默认 `utf8mb4`；「default collation」影响字符串的排序规则，默认 `utf8mb4_unicode_ci`，ci 是 case insensitive，即 「大小写不敏感」, a 和 A 会在字符判断中会被当做一样的。

### 几条值得参考的sql语句

```mysql
# 两条语句功能一样
select biz, max(publish_time) from wechat.post_list GROUP by biz HAVING MAX(publish_time) < date("2018-01-01")
select * from (select biz, max(publish_time) as publish_time from wechat.post_list GROUP by biz) as t1 where publish_time < date("2018-01-01");

# 时间转换例子，结果为今天零点的时间，datetime 类型
# unix_timestamp 是 mysql 独有函数
select from_unixtime(unix_timestamp(date(now())))
```

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

### 其他操作

参考 PostgreSQL 的 psycopg2 库。

### 