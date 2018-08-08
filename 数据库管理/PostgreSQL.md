## postgresql

### 初始化数据库

```bash
su - postgres -c "initdb --locale en_US.UTF-8 -D '/var/lib/postgres/data'"

# 注意这里输入的是postgres用户的密码, 默认为postgres
```

### 启动

```bash
# 后台
sudo systemctl start postgresql
```

### 客户端命令

```bash
# 启动客户端
psql 

# 列出所有数据库
\l
```

##  psycopg2

### 连接数据库

```python
import psycopg2

conn = psycopg2.connect(user='postgres', dbname='postgres')
conn.autocommit = True  # 开启自动提交
cursor = conn.cursor()
```

### 其他操作

参考 mysql 的 pymysql 库。