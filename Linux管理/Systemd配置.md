# Systemd配置

### 服务配置文件

- 把配置文件放在 `/usr/lib/systemd/system/ ` 目录。

- Systemd 默认从目录 `/etc/systemd/system/` 读取配置文件。

- 执行 `systemctl enable <服务名>` 后，相当于在上面两个目录之间，建立符号链接。

- 此时就会自动开机启动服务。

### 配置文件的区块

- `[Unit]`区块通常是配置文件的第一个区块，用来定义 Unit 的元数据，以及配置与其他 Unit 的关系。它的主要字段如下：

```bash
Description # 简短描述
Documentation # 文档地址
Requires # 当前 Unit 依赖的其他 Unit，如果它们没有运行，当前 Unit 会启动失败
Wants # 与当前 Unit 配合的其他 Unit，如果它们没有运行，当前 Unit 不会启动失败
BindsTo # 与Requires类似，它指定的 Unit 如果退出，会导致当前 Unit 停止运行
Before # 如果该字段指定的 Unit 也要启动，那么必须在当前 Unit 之后启动
After # 如果该字段指定的 Unit 也要启动，那么必须在当前 Unit 之前启动
Conflicts # 这里指定的 Unit 不能与当前 Unit 同时运行
Condition... # 当前 Unit 运行必须满足的条件，否则不会运行
Assert... # 当前 Unit 运行必须满足的条件，否则会报启动失败
```

- `[Service]`区块用来 Service 的配置，只有 Service 类型的 Unit 才有这个区块。它的主要字段如下：

```bash
Type=simple # 默认值, systemd认为该服务将立即启动。服务进程不会fork。如果该服务要启动其他服务，不要使用此类型启动，除非该服务是socket激活型。
Type=forking # systemd认为当该服务进程fork，且父进程退出后服务启动成功。对于常规的守护进程（daemon），除非你确定此启动方式无法满足需求，使用此类型启动即可。使用此启动类型应同时指定 PIDFile=，以便systemd能够跟踪服务的主进程。
Type=oneshot # 这一选项适用于只执行一项任务、随后立即退出的服务。可能需要同时设置 RemainAfterExit=yes使得systemd在服务进程退出之后仍然认为服务处于激活状态
Type=notify # 与 Type=simple相同，但约定服务会在就绪后向systemd发送一个信号。这一通知的实现由 libsystemd-daemon.so提供。
Type=dbus # 若以此方式启动，当指定的 BusName 出现在DBus系统总线上时，systemd认为服务就绪。

ExecStart # 启动当前服务的命令
ExecStartPre # 启动当前服务之前执行的命令
ExecStartPost # 启动当前服务之后执行的命令
ExecReload # 重启当前服务时执行的命令
ExecStop # 停止当前服务时执行的命令
ExecStopPost # 停止当其服务之后执行的命令

Restart # 定义服务退出后, 何种情况 Systemd 会自动重启当前服务，可能的值包括always（总是重启）、on-success(正常退出则重启)、on-failure(非正常退出后重启)、on-abnormal、on-abort、on-watchdog
RestartSec # 自动重启当前服务间隔的秒数

TimeoutSec # 定义 Systemd 停止当前服务之前等待的秒数
Environment # 指定环境变量
RemainAfterExit=yes # 表示进程退出以后，服务仍然保持执行

KillMode=process # 只杀主进程
KillMode=mixed # 主进程将收到 SIGTERM 信号，子进程收到 SIGKILL 信号
KillMode=control-group # 默认值, 当前控制组里面的所有子进程，都会被杀掉
KillMode=none # 没有进程会被杀掉，只是执行服务的 stop 命令

PrivateTmp=True # 表示给服务分配独立的临时空间, nginx和gunicorn配合使用时, 不要开启
```

- `[Install]`通常是配置文件的最后一个区块，用来定义如何启动，以及是否开机启动。它的主要字段如下：

```bash
WantedBy # 常用的 Target 有两个：一个是multi-user.target，表示多用户命令行状态；另一个是graphical.target，表示图形用户状态，它依赖于multi-user.target
RequiredBy # 它的值是一个或多个 Target，当前 Unit 激活时，符号链接会放入/etc/systemd/system目录下面以 Target 名 + .required后缀构成的子目录中
Alias # 当前 Unit 可用于启动的别名
Also # 当前 Unit 激活（enable）时，会被同时激活的其他 Unit
```

