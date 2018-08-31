## 基本

### 设置密码(可选)

1. 修改配置文件：

   ```bash
   sudo vim /etc/redis.conf
   ```

2. 取消 requirepass 的注释, 后面加上密码。

3. 重启 Redis 。

### 启动

后台启动：

```bash
sudo systemctl start redis
```

前台启动：

```bash
sudo -u redis redis-server /etc/redis.conf
```

### 命令行客户端

启动客户端：

```bash
redis-cli
```

命令：

```bash
# redis默认连接db0, 默认16个数据库
select 2 # 切换第三个数据库db2

# 获取所有配置
config get *

# 查看所有已有key
keys *

# 获取key的数量
dbsize

# 立即保存所有数据到磁盘
save

# 字符串
# Redis中的字符串是一个字节序列。Redis中的字符串是二进制安全的，这意味着它们的长度不由任何特殊的终止字符决定。因此，可以在一个字符串中存储高达512兆字节的任何内容。
set name "xiaoming" # 设置名字, 不存在创建, 存在覆盖
get name # 获取对应值
del name # 删除键

# 散列/哈希
# Redis散列/哈希(Hashes)是键值对的集合。Redis散列/哈希是字符串字段和字符串值之间的映射。因此，它们用于表示对象。
hmset myhash field1 "Hello" field2 "World" # 可以同时设置多个键值对
hget myhash field1 # 获取键对应值
hetall myhash # 获取所有值

# 列表
# Redis列表只是字符串列表，按插入顺序排序。您可以向Redis列表的头部或尾部添加元素。
lpush alist "redis" # 在头部压入"redis"字符串
rpush alist "redis" # 在尾部压入"redis"字符串
lpop alist # 在头部弹出元素, 并返回它
rpop alist # 在尾部弹出元素, 并返回它
llen alist # 返回列表长度
lrange alist 0 10 # 返回列表中这个范围所有值, 第二个数字用-1代表最后一个, 两点都会取到

# 集合
# Redis集合是字符串的无序集合。在Redis中，您可以添加，删除和测试成员存在的时间O(1)复杂性。
sadd runoob "redis" # 添加成员
srem runoob "redis" # 移除成员
sismember runoob "redis" # 判断是不是该集合成员
smembers runoob # 输出成员
scard runoob # 集合元素个数
sunion superpowers birdpowers # 组合集合, 自动去重

# 可排序集合
# Redis可排序集合类似于Redis集合，是不重复的字符集合。 不同之处在于，排序集合的每个成员都与分数相关联，这个分数用于按最小分数到最大分数来排序的排序集合。虽然成员是唯一的，但分数值可以重复。
zadd runoob 0 "redis" # 0是redis的分数
zrangebyscore runoob 0 1000 # 排序输入

# 事务
# Redis事务允许在单个步骤中执行一组命令
multi # 创建事务
/* list of command */
exec # 开始执行
```

### 配置文件 `/etc/redis.conf` 参数说明

```bash
# Redis默认不是以守护进程的方式运行，可以通过该配置项修改，使用yes启用守护进程
daemonize no
    
# 当Redis以守护进程方式运行时，Redis默认会把pid写入/var/run/redis.pid文件，可以通过pidfile指定
pidfile /var/run/redis.pid
    
# 指定Redis监听端口，默认端口为6379，作者在自己的一篇博文中解释了为什么选用6379作为默认端口，因为6379在手机按键上MERZ对应的号码，而MERZ取自意大利歌女Alessia Merz的名字
port 6379
    
# 绑定的主机地址
bind 127.0.0.1

# 当客户端闲置多长时间后关闭连接，如果指定为0，表示关闭该功能
timeout 300

# 指定日志记录级别，Redis总共支持四个级别：debug、verbose、notice、warning，默认为verbose
loglevel verbose

# 日志记录方式，默认为标准输出，如果配置Redis为守护进程方式运行，而这里又配置为日志记录方式为标准输出，则日志将会发送给/dev/null
logfile stdout

# 设置数据库的数量，默认数据库为0，可以使用SELECT <dbid>命令在连接上指定数据库id
databases 16

# 指定在多长时间内，有多少次更新操作，就将数据同步到数据文件，可以多个条件配合
save <seconds> <changes>
# Redis默认配置文件中提供了三个条件：
# save 900 1
# save 300 10
# save 60 10000
# 分别表示900秒（15分钟）内有1个更改，300秒（5分钟）内有10个更改以及60秒内有10000个更改。

# 指定存储至本地数据库时是否压缩数据，默认为yes，Redis采用LZF压缩，如果为了节省CPU时间，可以关闭该选项，但会导致数据库文件变的巨大
rdbcompression yes

# 指定本地数据库文件名，默认值为dump.rdb
dbfilename dump.rdb

# 指定本地数据库存放目录
dir /var/lib/redis/

# 设置当本机为slav服务时，设置master服务的IP地址及端口，在Redis启动时，它会自动从master进行数据同步
slaveof <masterip> <masterport>

# 当master服务设置了密码保护时，slav服务连接master的密码
masterauth <master-password>

# 设置Redis连接密码，如果配置了连接密码，客户端在连接Redis时需要通过AUTH <password>命令提供密码，默认关闭
requirepass foobared

# 设置同一时间最大客户端连接数，默认无限制，Redis可以同时打开的客户端连接数为Redis进程可以打开的最大文件描述符数，如果设置 maxclients 0，表示不作限制。当客户端连接数到达限制时，Redis会关闭新的连接并向客户端返回max number of clients reached错误信息
maxclients 128

# 指定Redis最大内存限制，Redis在启动时会把数据加载到内存中，达到最大内存后，Redis会先尝试清除已到期或即将到期的Key，当此方法处理 后，仍然到达最大内存设置，将无法再进行写入操作，但仍然可以进行读取操作。Redis新的vm机制，会把Key存放内存，Value会存放在swap区
maxmemory <bytes>

# 指定是否在每次更新操作后进行日志记录，Redis在默认情况下是异步的把数据写入磁盘，如果不开启，可能会在断电时导致一段时间内的数据丢失。因为 redis本身同步数据文件是按上面save条件来同步的，所以有的数据会在一段时间内只存在于内存中。默认为no
appendonly no

# 指定更新日志文件名，默认为appendonly.aof
appendfilename appendonly.aof

# 指定更新日志条件，共有3个可选值： 
# no：表示等操作系统进行数据缓存同步到磁盘（快） 
# always：表示每次更新操作后手动调用fsync()将数据写到磁盘（慢，安全） 
# everysec：表示每秒同步一次（折衷，默认值）
appendfsync everysec

# 指定是否启用虚拟内存机制，默认值为no，简单的介绍一下，VM机制将数据分页存放，由Redis将访问量较少的页即冷数据swap到磁盘上，访问多的页面由磁盘自动换出到内存中（在后面的文章我会仔细分析Redis的VM机制）
vm-enabled no

# 虚拟内存文件路径，默认值为/tmp/redis.swap，不可多个Redis实例共享
vm-swap-file /tmp/redis.swap

# 将所有大于vm-max-memory的数据存入虚拟内存,无论vm-max-memory设置多小,所有索引数据都是内存存储的(Redis的索引数据 就是keys),也就是说,当vm-max-memory设置为0的时候,其实是所有value都存在于磁盘。默认值为0
vm-max-memory 0

# Redis swap文件分成了很多的page，一个对象可以保存在多个page上面，但一个page上不能被多个对象共享，vm-page-size是要根据存储的 数据大小来设定的，作者建议如果存储很多小对象，page大小最好设置为32或者64bytes；如果存储很大大对象，则可以使用更大的page，如果不 确定，就使用默认值
vm-page-size 32

# 设置swap文件中的page数量，由于页表（一种表示页面空闲或使用的bitmap）是在放在内存中的，，在磁盘上每8个pages将消耗1byte的内存。
vm-pages 134217728

# 设置访问swap文件的线程数,最好不要超过机器的核数,如果设置为0,那么所有对swap文件的操作都是串行的，可能会造成比较长时间的延迟。默认值为4
vm-max-threads 4

# 设置在向客户端应答时，是否把较小的包合并为一个包发送，默认为开启
glueoutputbuf yes

# 指定在超过一定的数量或者最大的元素超过某一临界值时，采用一种特殊的哈希算法
hash-max-zipmap-entries 64
hash-max-zipmap-value 512

# 指定是否激活重置哈希，默认为开启（后面在介绍Redis的哈希算法时具体介绍）
activerehashing yes

# 指定包含其它的配置文件，可以在同一主机上多个Redis实例之间使用同一份配置文件，而同时各个实例又拥有自己的特定配置文件
include /path/to/local.conf
```

## Python连接

### 安装驱动

```bash
pip install redis
```

### Redis、StrictRedis

RedisPy 库提供两个类 Redis 和 StrictRedis 用于实现 Redis 的命令操作。

StrictRedis 实现了绝大部分官方的命令，参数也一一对应，比如 set() 方法就对应 Redis 命令的 set 方法。而Redis 是 StrictRedis 的子类，它的主要功能是用于向后兼容旧版本库里的几个方法，为了做兼容，将方法做了改写，比如 lrem() 方法就将 value 和 num 参数的位置互换，和Redis 命令行的命令参数不一致。

官方推荐使用 StrictRedis，所以本节我们也用 StrictRedis类的相关方法作演示。

### 连接Redis

当前在本地我已经安装了 Redis 并运行在 6379 端口，密码设置为 foobared。

那么可以用如下示例连接 Redis 并测试：

```python
from redis import StrictRedis

redis = StrictRedis(host='localhost', port=6379, db=0, password='foobared')
redis.set('name', 'Bob')
print(redis.get('name'))
```

在这里我们传入了 Redis 的地址，运行端口，使用的数据库，密码信息。在默认不传的情况下，这四个参数分别为 localhost、6379、0、None。现在我们声明了一个StrictRedis 对象，然后接下来调用了 set() 方法，设置一个键值对，然后在将其获取打印。

运行结果：

```python
b'Bob'
```

这样就说明我们连接成功，并可以执行 set()、get() 操作了。

当然我们还可以使用 ConnectionPool 来连接，示例如下：

```python
from redis import StrictRedis, ConnectionPool

pool = ConnectionPool(host='localhost', port=6379, db=0, password='foobared')
redis = StrictRedis(connection_pool=pool)
```

这样的连接效果是一样的，观察源码可以发现 StrictRedis内其实就是用 host、port 等参数又构造了一个 ConnectionPool，所以我们直接将 ConnectionPool 当参数传给 StrictRedis 也是一样的。

另外 ConnectionPool 还支持通过 URL 来构建，URL 的格式支持如下三种：

```
redis://[:password]@host:port/db
rediss://[:password]@host:port/db
unix://[:password]@/path/to/socket.sock?db=db
```

这三种 URL 分别表示创建 Redis TCP 连接、Redis TCP+SSL 连接、Redis Unix Socket 连接，我们只需要构造上面任意一种连接 URL 即可，其中 password 部分如果有则可以写，没有可以省略，下面我们再用URL连接演示一下：

```python
url = 'redis://:foobared@localhost:6379/0'
pool = ConnectionPool.from_url(url)
redis = StrictRedis(connection_pool=pool)
```

在这里我们使用了第一种连接字符串进行连接，我们首先声明了一个 Redis 连接字符串，然后调用 from_url() 方法创建一个 ConnectionPool，然后将其传给 StrictRedis 即可完成连接，所以使用 URL 的连接方式还是比较方便的。

### Key 操作

在这里主要将 Key 的一些判断和操作方法做下总结：

| 方法               | 作用                                      | 参数说明                   | 示例                               | 示例说明                      | 示例结果  |
| ------------------ | ----------------------------------------- | -------------------------- | ---------------------------------- | ----------------------------- | --------- |
| exists(name)       | 判断一个key是否存在                       | name: key名                | `redis.exists('name')`             | 是否存在name这个key           | True      |
| delete(name)       | 删除一个key                               | name: key名                | `redis.delete('name')`             | 删除name这个key               | 1         |
| type(name)         | 判断key类型                               | name: key名                | `redis.type('name')`               | 判断name这个key类型           | b'string' |
| keys(pattern)      | 获取所有符合规则的key                     | pattern: 匹配规则          | `redis.keys('n*')`                 | 获取所有以n开头的key          | [b'name'] |
| randomkey()        | 获取随机的一个key                         |                            | `randomkey()`                      | 获取随机的一个key             | b'name'   |
| rename(src, dst)   | 将key重命名                               | src: 原key名 dst: 新key名  | `redis.rename('name', 'nickname')` | 将name重命名为nickname        | True      |
| dbsize()           | 获取当前数据库中key的数目                 |                            | `dbsize()`                         | 获取当前数据库中key的数目     | 100       |
| expire(name, time) | 设定key的过期时间，单位秒                 | name: key名 time: 秒数     | `redis.expire('name', 2)`          | 将name这key的过期时间设置2秒  | True      |
| ttl(name)          | 获取key的过期时间，单位秒，-1为永久不过期 | name: key名                | `redis.ttl('name')`                | 获取name这key的过期时间       | -1        |
| move(name, db)     | 将key移动到其他数据库                     | name: key名 db: 数据库代号 | `move('name', 2)`                  | 将name移动到2号数据库         | True      |
| flushdb()          | 删除当前选择数据库中的所有key             |                            | `flushdb()`                        | 删除当前选择数据库中的所有key | True      |
| flushall()         | 删除所有数据库中的所有key                 |                            | `flushall()`                       | 删除所有数据库中的所有key     | True      |

### String操作

Redis 中存在最基本的键值对形式存储，用法总结如下：

| 方法                          | 作用                                                         | 参数说明                                                    | 示例                                                         | 示例说明                                         | 示例结果                    |
| ----------------------------- | ------------------------------------------------------------ | ----------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------ | --------------------------- |
| set(name, value)              | 给数据库中key为name的string赋予值value                       | name: key名 value: 值                                       | `redis.set('name', 'Bob')`                                   | 给name这个key的value赋值为Bob                    | True                        |
| get(name)                     | 返回数据库中key为name的string的value                         | name: key名                                                 | `redis.get('name')`                                          | 返回name这个key的value                           | b'Bob'                      |
| getset(name, value)           | 给数据库中key为name的string赋予值value并返回上次的value      | name: key名 value: 新值                                     | `redis.getset('name', 'Mike')`                               | 赋值name为Mike并得到上次的value                  | b'Bob'                      |
| mget(keys, *args)             | 返回多个key对应的value                                       | keys: key的列表                                             | `redis.mget(['name', 'nickname'])`                           | 返回name和nickname的value                        | [b'Mike', b'Miker']         |
| setnx(name, value)            | 如果key不存在才设置value                                     | name: key名                                                 | `redis.setnx('newname', 'James')`                            | 如果newname这key不存在则设置值为James            | 第一次运行True，第二次False |
| setex(name, time, value)      | 设置可以对应的值为string类型的value，并指定此键值对应的有效期 | name: key名 time: 有效期 value: 值                          | `redis.setex('name', 1, 'James')`                            | 将name这key的值设为James，有效期1秒              | True                        |
| setrange(name, offset, value) | 设置指定key的value值的子字符串                               | name: key名 offset: 偏移量 value: 值                        | `redis.set('name', 'Hello') redis.setrange('name', 6, 'World')` | 设置name为Hello字符串，并在index为6的位置补World | 11，修改后的字符串长度      |
| mset(mapping)                 | 批量赋值                                                     | mapping: 字典                                               | `redis.mset({'name1': 'Durant', 'name2': 'James'})`          | 将name1设为Durant，name2设为James                | True                        |
| msetnx(mapping)               | key均不存在时才批量赋值                                      | mapping: 字典                                               | `redis.msetnx({'name3': 'Smith', 'name4': 'Curry'})`         | 在name3和name4均不存在的情况下才设置二者值       | True                        |
| incr(name, amount=1)          | key为name的value增值操作，默认1，key不存在则被创建并设为amount | name: key名 amount:增长的值                                 | `redis.incr('age', 1)`                                       | age对应的值增1，若不存在则会创建并设置为1        | 1，即修改后的值             |
| decr(name, amount=1)          | key为name的value减值操作，默认1，key不存在则被创建并设置为-amount | name: key名 amount:减少的值                                 | `redis.decr('age', 1)`                                       | age对应的值减1，若不存在则会创建并设置为-1       | -1，即修改后的值            |
| append(key, value)            | key为name的string的值附加value                               | key: key名                                                  | `redis.append('nickname', 'OK')`                             | 向key为nickname的值后追加OK                      | 13，即修改后的字符串长度    |
| substr(name, start, end=-1)   | 返回key为name的string的value的子串                           | name: key名 start: 起始索引 end: 终止索引，默认-1截取到末尾 | `redis.substr('name', 1, 4)`                                 | 返回key为name的值的字符串，截取索引为1-4的字符   | b'ello'                     |
| getrange(key, start, end)     | 获取key的value值从start到end的子字符串                       | key: key名 start: 起始索引 end: 终止索引                    | `redis.getrange('name', 1, 4)`                               | 返回key为name的值的字符串，截取索引为1-4的字符   | b'ello'                     |

### List操作

List，即列表。Redis 还提供了列表存储，列表内的元素可以重复，而且可以从两端存储，用法总结如下：

| 方法                     | 作用                                                         | 参数说明                                         | 示例                               | 示例说明                                                     | 示例结果             |
| ------------------------ | ------------------------------------------------------------ | ------------------------------------------------ | ---------------------------------- | ------------------------------------------------------------ | -------------------- |
| rpush(name, *values)     | 在key为name的list尾添加值为value的元素，可以传多个           | name: key名 values: 值                           | `redis.rpush('list', 1, 2, 3)`     | 给list这个key的list尾添加1、2、3                             | 3，list大小          |
| lpush(name, *values)     | 在key为name的list头添加值为value的元素，可以传多个           | name: key名 values: 值                           | `redis.lpush('list', 0)`           | 给list这个key的list头添加0                                   | 4，list大小          |
| llen(name)               | 返回key为name的list的长度                                    | name: key名                                      | `redis.llen('list')`               | 返回key为list的列表的长度                                    | 4                    |
| lrange(name, start, end) | 返回key为name的list中start至end之间的元素                    | name: key名 start: 起始索引 end: 终止索引        | `redis.lrange('list', 1, 3)`       | 返回起始为1终止为3的索引范围对应的list                       | `[b'3', b'2', b'1']` |
| ltrim(name, start, end)  | 截取key为name的list，保留索引为start到end的内容              | name:key名 start: 起始索引 end: 终止索引         | `ltrim('list', 1, 3)`              | 保留key为list的索引为1到3的元素                              | True                 |
| lindex(name, index)      | 返回key为name的list中index位置的元素                         | name: key名 index: 索引                          | `redis.lindex('list', 1)`          | 返回key为list的列表index为1的元素                            | b'2'                 |
| lset(name, index, value) | 给key为name的list中index位置的元素赋值，越界则报错           | name: key名 index: 索引位置 value: 值            | `redis.lset('list', 1, 5)`         | 将key为list的list索引1位置赋值为5                            | True                 |
| lrem(name, count, value) | 删除count个key的list中值为value的元素                        | name: key名 count: 删除个数 value: 值            | `redis.lrem('list', 2, 3)`         | 将key为list的列表删除2个3                                    | 1，即删除的个数      |
| lpop(name)               | 返回并删除key为name的list中的首元素                          | name: key名                                      | `redis.lpop('list')`               | 返回并删除名为list的list第一个元素                           | b'5'                 |
| rpop(name)               | 返回并删除key为name的list中的尾元素                          | name: key名                                      | `redis.rpop('list')`               | 返回并删除名为list的list最后一个元素                         | b'2'                 |
| blpop(keys, timeout=0)   | 返回并删除名称为在keys中的list中的首元素，如果list为空，则会一直阻塞等待 | keys: key列表 timeout: 超时等待时间，0为一直等待 | `redis.blpop('list')`              | 返回并删除名为list的list的第一个元素                         | [b'5']               |
| brpop(keys, timeout=0)   | 返回并删除key为name的list中的尾元素，如果list为空，则会一直阻塞等待 | keys: key列表 timeout: 超时等待时间，0为一直等待 | `redis.brpop('list')`              | 返回并删除名为list的list的最后一个元素                       | [b'2']               |
| rpoplpush(src, dst)      | 返回并删除名称为src的list的尾元素，并将该元素添加到名称为dst的list的头部 | src: 源list的key dst: 目标list的key              | `redis.rpoplpush('list', 'list2')` | 将key为list的list尾元素删除并返回并将其添加到key为list2的list头部 | b'2'                 |

### Set操作

Set，即集合。Redis 还提供了集合存储，集合中的元素都是不重复的，用法总结如下：

| 方法                           | 作用                                           | 参数说明                              | 示例                                             | 示例说明                                                | 示例结果                     |
| ------------------------------ | ---------------------------------------------- | ------------------------------------- | ------------------------------------------------ | ------------------------------------------------------- | ---------------------------- |
| sadd(name, *values)            | 向key为name的set中添加元素                     | name: key名 values: 值，可为多个      | `redis.sadd('tags', 'Book', 'Tea', 'Coffee')`    | 向key为tags的set中添加Book、Tea、Coffee三个内容         | 3，即插入的数据个数          |
| srem(name, *values)            | 从key为name的set中删除元素                     | name: key名 values: 值，可为多个      | `redis.srem('tags', 'Book')`                     | 从key为tags的set中删除Book                              | 1，即删除的数据个数          |
| spop(name)                     | 随机返回并删除key为name的set中一个元素         | name: key名                           | `redis.spop('tags')`                             | 从key为tags的set中随机删除并返回该元素                  | b'Tea'                       |
| smove(src, dst, value)         | 从src对应的set中移除元素并添加到dst对应的set中 | src: 源set dst: 目标set value: 元素值 | `redis.smove('tags', 'tags2', 'Coffee')`         | 从key为tags的set中删除元素Coffee并添加到key为tags2的set | True                         |
| scard(name)                    | 返回key为name的set的元素个数                   | name: key名                           | `redis.scard('tags')`                            | 获取key为tags的set中元素个数                            | 3                            |
| sismember(name, value)         | 测试member是否是key为name的set的元素           | name:key值                            | `redis.sismember('tags', 'Book')`                | 判断Book是否为key为tags的set元素                        | True                         |
| sinter(keys, *args)            | 返回所有给定key的set的交集                     | keys: key列表                         | `redis.sinter(['tags', 'tags2'])`                | 返回key为tags的set和key为tags2的set的交集               | {b'Coffee'}                  |
| sinterstore(dest, keys, *args) | 求交集并将交集保存到dest的集合                 | dest:结果集合 keys:key列表            | `redis.sinterstore('inttag', ['tags', 'tags2'])` | 求key为tags的set和key为tags2的set的交集并保存为inttag   | 1                            |
| sunion(keys, *args)            | 返回所有给定key的set的并集                     | keys: key列表                         | `redis.sunion(['tags', 'tags2'])`                | 返回key为tags的set和key为tags2的set的并集               | {b'Coffee', b'Book', b'Pen'} |
| sunionstore(dest, keys, *args) | 求并集并将并集保存到dest的集合                 | dest:结果集合 keys:key列表            | `redis.sunionstore('inttag', ['tags', 'tags2'])` | 求key为tags的set和key为tags2的set的并集并保存为inttag   | 3                            |
| sdiff(keys, *args)             | 返回所有给定key的set的差集                     | keys: key列表                         | `redis.sdiff(['tags', 'tags2'])`                 | 返回key为tags的set和key为tags2的set的差集               | {b'Book', b'Pen'}            |
| sdiffstore(dest, keys, *args)  | 求差集并将差集保存到dest的集合                 | dest:结果集合 keys:key列表            | `redis.sdiffstore('inttag', ['tags', 'tags2'])`  | 求key为tags的set和key为tags2的set的差集并保存为inttag   | 3                            |
| smembers(name)                 | 返回key为name的set的所有元素                   | name: key名                           | `redis.smembers('tags')`                         | 返回key为tags的set的所有元素                            | {b'Pen', b'Book', b'Coffee'} |
| srandmember(name)              | 随机返回key为name的set的一个元素，但不删除元素 | name: key值                           | `redis.srandmember('tags')`                      | 随机返回key为tags的set的一个元素                        |                              |

### Sorted Set操作

Sorted Set，即有序集合，它相比集合多了一个分数字段，利用它我们可以对集合中的数据进行排序，其用法总结如下：

| 方法                                                         | 作用                                                         | 参数说明                                                     | 示例                                          | 示例说明                                                     | 示例结果                            |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | --------------------------------------------- | ------------------------------------------------------------ | ----------------------------------- |
| zadd(name, *args, \**kwargs)                                 | 向key为name的zset中添加元素member，score用于排序。如果该元素存在，则更新其顺序 | name: key名 args: 可变参数                                   | `redis.zadd('grade', 100, 'Bob', 98, 'Mike')` | 向key为grade的zset中添加Bob，score为100，添加Mike，score为98 | 2，即添加的元素个数                 |
| zrem(name, *values)                                          | 删除key为name的zset中的元素                                  | name: key名 values: 元素                                     | `redis.zrem('grade', 'Mike')`                 | 从key为grade的zset中删除Mike                                 | 1，即删除的元素个数                 |
| zincrby(name, value, amount=1)                               | 如果在key为name的zset中已经存在元素value，则该元素的score增加amount，否则向该集合中添加该元素，其score的值为amount | name: key名 value: 元素 amount: 增长的score值                | `redis.zincrby('grade', 'Bob', -2)`           | key为grade的zset中Bob的score减2                              | 98.0，即修改后的值                  |
| zrank(name, value)                                           | 返回key为name的zset中元素的排名（按score从小到大排序）即下标 | name: key名 value: 元素值                                    | `redis.zrank('grade', 'Amy')`                 | 得到key为grade的zset中Amy的排名                              | 1                                   |
| zrevrank(name, value)                                        | 返回key为name的zset中元素的倒数排名（按score从大到小排序）即下标 | name: key名 value: 元素值                                    | `redis.zrevrank('grade', 'Amy')`              | 得到key为grade的zset中Amy的倒数排名                          | 2                                   |
| zrevrange(name, start, end, withscores=False)                | 返回key为name的zset（按score从大到小排序）中的index从start到end的所有元素 | name: key值 start: 开始索引 end: 结束索引 withscores: 是否带score | `redis.zrevrange('grade', 0, 3)`              | 返回key为grade的zset前四名元素                               | [b'Bob', b'Mike', b'Amy', b'James'] |
| zrangebyscore(name, min, max, start=None, num=None, withscores=False) | 返回key为name的zset中score在给定区间的元素                   | name:key名 min: 最低score max:最高score start: 起始索引 num: 个数 withscores: 是否带score | `redis.zrangebyscore('grade', 80, 95)`        | 返回key为grade的zset中score在80和95之间的元素                | [b'Amy', b'James']                  |
| zcount(name, min, max)                                       | 返回key为name的zset中score在给定区间的数量                   | name:key名 min: 最低score max: 最高score                     | `redis.zcount('grade', 80, 95)`               | 返回key为grade的zset中score在80到95的元素个数                | 2                                   |
| zcard(name)                                                  | 返回key为name的zset的元素个数                                | name: key名                                                  | `redis.zcard('grade')`                        | 获取key为grade的zset中元素个数                               | 3                                   |
| zremrangebyrank(name, min, max)                              | 删除key为name的zset中排名在给定区间的元素                    | name:key名 min: 最低位次 max: 最高位次                       | `redis.zremrangebyrank('grade', 0, 0)`        | 删除key为grade的zset中排名第一的元素                         | 1，即删除的元素个数                 |
| zremrangebyscore(name, min, max)                             | 删除key为name的zset中score在给定区间的元素                   | name:key名 min: 最低score max:最高score                      | `redis.zremrangebyscore('grade', 80, 90)`     | 删除score在80到90之间的元素                                  | 1，即删除的元素个数                 |

### Hash操作

Hash，即哈希。Redis 还提供了哈希表的数据结构，我们可以用name指定一个哈希表的名称，然后表内存储了各个键值对，用法总结如下：

| 方法                         | 作用                                            | 参数说明                                  | 示例                                             | 示例说明                                      | 示例结果                                                     |
| ---------------------------- | ----------------------------------------------- | ----------------------------------------- | ------------------------------------------------ | --------------------------------------------- | ------------------------------------------------------------ |
| hset(name, key, value)       | 向key为name的hash中添加映射                     | name: key名 key: 映射键名 value: 映射键值 | `hset('price', 'cake', 5)`                       | 向key为price的hash中添加映射关系，cake的值为5 | 1，即添加的映射个数                                          |
| hsetnx(name, key, value)     | 向key为name的hash中添加映射，如果映射键名不存在 | name: key名 key: 映射键名 value: 映射键值 | `hsetnx('price', 'book', 6)`                     | 向key为price的hash中添加映射关系，book的值为6 | 1，即添加的映射个数                                          |
| hget(name, key)              | 返回key为name的hash中field对应的value           | name: key名 key: 映射键名                 | `redis.hget('price', 'cake')`                    | 获取key为price的hash中键名为cake的value       | 5                                                            |
| hmget(name, keys, *args)     | 返回key为name的hash中各个键对应的value          | name: key名 keys: 映射键名列表            | `redis.hmget('price', ['apple', 'orange'])`      | 获取key为price的hash中apple和orange的值       | [b'3', b'7']                                                 |
| hmset(name, mapping)         | 向key为name的hash中批量添加映射                 | name: key名 mapping: 映射字典             | `redis.hmset('price', {'banana': 2, 'pear': 6})` | 向key为price的hash中批量添加映射              | True                                                         |
| hincrby(name, key, amount=1) | 将key为name的hash中映射的value增加amount        | name: key名 key: 映射键名 amount: 增长量  | `redis.hincrby('price', 'apple', 3)`             | key为price的hash中apple的值增加3              | 6，修改后的值                                                |
| hexists(name, key)           | key为namehash中是否存在键名为key的映射          | name: key名 key: 映射键名                 | `redis.hexists('price', 'banana')`               | key为price的hash中banana的值是否存在          | True                                                         |
| hdel(name, *keys)            | key为namehash中删除键名为key的映射              | name: key名 key: 映射键名                 | `redis.hdel('price', 'banana')`                  | 从key为price的hash中删除键名为banana的映射    | True                                                         |
| hlen(name)                   | 从key为name的hash中获取映射个数                 | name: key名                               | `redis.hlen('price')`                            | 从key为price的hash中获取映射个数              | 6                                                            |
| hkeys(name)                  | 从key为name的hash中获取所有映射键名             | name: key名                               | `redis.hkeys('price')`                           | 从key为price的hash中获取所有映射键名          | [b'cake', b'book', b'banana', b'pear']                       |
| hvals(name)                  | 从key为name的hash中获取所有映射键值             | name: key名                               | `redis.hvals('price')`                           | 从key为price的hash中获取所有映射键值          | [b'5', b'6', b'2', b'6']                                     |
| hgetall(name)                | 从key为name的hash中获取所有映射键值对           | name: key名                               | `redis.hgetall('price')`                         | 从key为price的hash中获取所有映射键值对        | {b'cake': b'5', b'book': b'6', b'orange': b'7', b'pear': b'6'} |

