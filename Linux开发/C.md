# C 开发

## GCC

### 编译工具链

头文件展开，宏替换，注释去掉（实际调用预处理器 cpp）：

```bash
gcc -E hello.c -o hello.i
```

C 文件变成汇编文件（实际调用编译器 gcc）：

```bash
gcc -S hello.i -o hello.s
```

汇编文件变成二进制文件（实际调用汇编器 as）：

```bash
gcc -c hello.s -o hello.o
```

将函数库中相应代码组合到目标文件中（实际调用链接器 ld）：

```bash
gcc hello.o -o hello
```

### 常用参数

|      参数      |                    意义                     |
| :------------: | :-----------------------------------------: |
|      `-l`      |               指定头文件目录                |
|      `-L`      |               指定动态库目录                |
| `-l<动态库名>` |               链接指定动态库                |
|      `-o`      |           后面加想要生成的文件名            |
|      `-O`      | 后面紧跟数字 1~3，指定优化等级，默认 `-O0`  |
|      `-g`      |          在生成程序中加入调试信息           |
|    `-Wall`     |              输出所有警告信息               |
|   `-D<宏名>`   | 相当于在 .c 文件中加了一句 `#define <宏名>` |

### 查看带源代码的汇编代码

先生成带调试信息的 .o 文件：

```bash
gcc -c main.c -g
```

查看汇编代码：

```bash
objdump -S main.o
```

## 静态库

### 命名规则

  lib + 库名 + .a，如 `libtest.a`，库名就是 test 。

### 制作步骤

生成对应的 .o 文件：

```bash
gcc -c test.c -o <生成文件名>
```

将生成的 .o 文件打包：

```bash
ar rcs <静态库名> <.o文件>
```

### 查看静态库

```bash
nm <静态库名> 
```

## 动态库

### 命名规则

lib + 库名 + .so，如 `libtest.so`，库名就是 test 。

### 制作步骤

生成与位置无关的.o文件：

```bash
gcc -c test.c -o test.o -fPIC
```

将生成的.o文件打包：

```bash
gcc -shared test.o -o libtest.so
```

### 设置全局调用

1. 设置用户头文件位置

   修改 `.bashrc`，添加下面一行：

   ```bash
   export C_INCLUDE_PATH=$HOME/Documents/share/include
   ```

   这样编译时可不指定头文件目录（`-I<目录>`）。

2. 设置用户动态库位置

   修改 `.bashrc`，添加下面两行：

   ```bash
   export LIBRARY_PATH=$HOME/Documents/share/mylib  # gcc 编译链接时查找路径
   export LD_LIBRARY_PATH=$HOME/Documents/share/mylib  # 运行时查找路径
   ```

   这样编译时只需指定 `-l<动态库名>`，不需要指定 `-L<目录>` 。

### 查看程序使用了哪些动态库

```bash
ldd <程序名>
```

## Makefile

### 注意

`makefile` 中必须用真正的 `tab`，可以在 `vim` 中 `Ctrl` + `v`，再按 `tab` 按出。

### 例子

```makefile
CC=gcc # 指定编译器
CFLAGS=-g
target=app
src=$(wildcard src/*.c) # 查找指定目录下所有.c文件, 返回字符串
obj=$(patsubst %.c, %.o, $(src)) # 把字符串中的.c替换.o, 返回字符串

# 找不到.o依赖时, 自动执行下面语句, 逐个生成.o文件
$(target):$(obj)
	$(CC) $(obj) lib$(mylib).so -o $(target) -Wall $(CFLAGS)

# $@: 规则中的目标
# $<: 规则中的第一个依赖
# $^: 规则中的所有依赖
%.o:%.c
	$(CC) -c $< -o $@ -Wall

clean:
	rm src/*.o
```

## GDB

### 命令

```bash
l # 查看源代码
l <文件名:函数名> # 查看指定函数源代码
disas /m <函数名> # 显示汇编代码
b <行号> # 打断点
b <行号> if i==10 # 设置一个条件断点, 在变量i=10时停下
i b # 查看断点信息
d <断点编号> # 删除断点

run # 完整运行程序, 直至断点
start # 开始调试, 只执行一步, 在此期间:
	# n: 单步调试
	# ni: 汇编级别单步调试
	# s: 单步调试, 遇函数会进入
	# finish: 跳出函数
	# u: 跳出循环
	# c: 跑完程序

p <变量名> # 查看变量值
ptype <变量名> # 查看变量类型
display <变量名> # 追踪变量
i display # 显示追踪变量编号
undisplay <变量编号> # 取消追踪变量
set var <变量名>=10 # 设置某个变量值
i r # 查看寄存器值
i local # 显示栈中变量
i f # 查看当前栈信息
x <内存地址>|$<寄存器名>|&<变量名> # 查看内存地址值

q # 退出gdb
```

### 调试动态库

1. 生成带调试信息（gcc 加 `-g` 参数）的 .so 文件。
2. gdb 中打断点在动态库的函数上, 要用 `b <函数名>`，会出现提示，不能用 `b <行号>`。
3. `run ` 会自动进入函数内部，或者 `start`，再 `s` 进入函数内部。

### 追踪段错误

`run` 命令运行后，会自动追踪段错误。
