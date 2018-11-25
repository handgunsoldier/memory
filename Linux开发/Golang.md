# Go 开发 

### go build 不同系统下的可执行文件

Golang 支持在一个平台下生成另一个平台可执行程序的交叉编译功能。

1.Mac 下编译 Linux，Windows 平台的 64 位可执行程序：

```bash
# Linux
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build test.go
# Winddos
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build test.go
```

2.Linux 下编译 Mac，Windows 平台的 64 位可执行程序：

```bash
# Mac
CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build test.go
# Windows
CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build test.go
```

3.Windows 下编译 Mac，Linux 平台的 64 位可执行程序：

```bash
# Mac
SET CGO_ENABLED=0SET GOOS=darwin3 SET GOARCH=amd64 go build test.go
# Linux
SET CGO_ENABLED=0 SET GOOS=linux SET GOARCH=amd64 go build test.go`
```

