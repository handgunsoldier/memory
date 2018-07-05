### postgresql

- 启动

```bash
sudo -u postgres postgres -D /var/lib/postgres/data
```

- 命令

```bash
# 连接
psql 

# 列出所有数据库
\l

# 创建数据库
create database <数据库名>;
# 删除数据库
drop database <数据库名>;

# 创建表
CREATE TABLE table_name(  
   column1 datatype,  
   column2 datatype,  
   column3 datatype,  
   .....  
   columnN datatype,  
   PRIMARY KEY( one or more columns )  
);
# 删除表

```

 