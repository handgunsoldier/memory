 ### mongodb

- 启动

```bash
sudo -u mongodb mongod -f /etc/mongodb.conf
```

- 命令

```bash
# 获取帮助
db.help()

# 显示所有数据库
show dbs
# 切换到指定db, 不存在则创建
use db
# 显示当前db下所有collection
show tables

# 获取当前colletcion名
db.getName()
# 获取当前colletcion状态
db.stats()

# 查找所有name是D或E开头的记录, 斜杆不能少
# 后加.pretty()格式化输出
# 后加.sort({'要排序的key':1})排序, 1指升序, -1指降序
db.collection.find({name:{/^D|E/}})
# 过滤指定字段, 1显示, 0不显示
db.collection.find({}, {'name':1})
# 查询age字段不包括21, 22的记录, nin改in就是包括
db.collection.find({age:{$nin:[21,22]}})

# 删除指定条目, {}中为空, 则删除所有
db.collection.remove({'title':'xxx'})
# 删除指定colletcion
db.collection.drop()
# 删除当前数据库
db.dropDatabase()

# 备份数据库, -d省略则备份所有
mongodump -h 127.0.0.1 -d dbname -o ~/Documents/backup
# 从当前目录读取(.), 恢复数据库
mongorestore -h 127.0.0.1 -d dbname .
```

- 配置文件/etc/mongodb.conf参数说明

```bash
# 数据库数据存放目录
dbpath=/var/lib/mongodb/data
# 数据库日志存放目录
logpath=/var/log/mongodb/mongodb.log 
# 以追加的方式记录日志
logappend = true
# 端口号 默认为27017
port=27017 
# 以后台方式运行进程
fork=true 
# 开启用户认证
auth=true
# 关闭http接口，默认关闭http端口访问
nohttpinterface=true
# mongodb所绑定的ip地址
bind_ip = 127.0.0.1 
# 启用日志文件，默认启用
journal=true 
# 这个选项可以过滤掉一些无用的日志信息，若需要调试使用请设置为false
quiet=true 
```

