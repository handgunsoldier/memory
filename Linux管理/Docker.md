# Docker

## Docker 的安装

Docker 是一个开源的商业产品，有两个版本：社区版（Community Edition，缩写为 CE）和企业版（Enterprise Edition，缩写为 EE）。企业版包含了一些收费服务，个人开发者一般用不到。下面的介绍都针对社区版。

安装完成后，运行下面的命令，验证是否安装完成。

```bash
docker version
# 或者
docker info
```

Docker 需要用户具有 sudo 权限，为了避免每次命令都输入`sudo`，可以把用户加入 Docker 用户组（[官方文档](https://docs.docker.com/install/linux/linux-postinstall/#manage-docker-as-a-non-root-user)），步骤如下：

1. 创建 docker 组：

   ```bash
   sudo groupadd docker
   ```

2. 把当前用户加入 docker 组：

   ```bash
   sudo usermod -aG docker $USER
   ```

3. 检查是否加入成功：

   ```bash
   groups $USER
   ```

4. 注销并重新登录当前用户。

Docker 是服务器-客户端架构。命令行运行 `docker` 命令的时候，需要本机有 Docker 服务。使用如下命令运行：

```bash
sudo systemctl start docker
```

接下来测试 docker 是否完全安装正确，运行一个经典的 hello word：

```bash
docker run hello-world
```

若能运行，则 docker 已准备就绪。

## Image 文件

Docker 把应用程序及其依赖，打包在 image 文件里面。只有通过这个文件，才能生成 Docker 容器。image 文件可以看作是容器的模板。Docker 根据 image 文件生成容器的实例。同一个 image 文件，可以生成多个同时运行的容器实例。

image 是二进制文件。实际开发中，一个 image 文件往往通过继承另一个 image 文件，加上一些个性化设置而生成。举例来说，你可以在 Ubuntu 的 image 基础上，往里面加入 Apache 服务器，形成你的 image。

```bash
# 列出本机的所有 image 文件。
docker image ls

# 删除 image 文件
docker image rm [imageName]
```

image 文件是通用的，一台机器的 image 文件拷贝到另一台机器，照样可以使用。一般来说，为了节省时间，我们应该尽量使用别人制作好的 image 文件，而不是自己制作。即使要定制，也应该基于别人的 image 文件进行加工，而不是从零开始制作。

为了方便共享，image 文件制作完成后，可以上传到网上的仓库。Docker 的官方仓库 [Docker Hub](https://hub.docker.com/) 是最重要、最常用的 image 仓库。此外，出售自己制作的 image 文件也是可以的。

## 常用命令

```bash
# 搜索镜像
docker search <关键字>

# 下载镜像
docker pull <镜像名>

# 执行镜像，每次都会创建一个新容器，注意区别容器和镜像
# 容器需要手工删除
docker run <镜像名>

# 运行一个已经存在的容器
docker start <容器ID>

# 停止一个正在运行的容器，相当于向容器里面的主进程发出 SIGTERM 信号
docker stop <容器ID>

# 查看 docker 容器的输出，即容器里面 Shell 的标准输出。
# 如果docker run命令运行容器的时候，没有使用-it参数，就要用这个命令查看输出。
docker container logs <容器ID>

# 用于进入一个正在运行的 docker 容器。
# 如果 `docker run` 命令运行容器的时候，没有使用-it参数，就要用这个命令进入容器。
# 一旦进入了容器，就可以在容器的 Shell 执行命令了。
docker container exec -it <容器ID> /bin/bash

# 从正在运行的 Docker 容器里面，将文件拷贝到本机。下面是拷贝到当前目录的写法。
docker container cp <容器ID>:</path/to/file>

# 列出所有正在执行的容器
docker container ls
# 列出所有容器，即使不在执行的（或使用 `docker ps -a`）
docker container ls -a
```

 
