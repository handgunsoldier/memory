# 汇编程序

## AT&T格式汇编

### 使用 as

汇编，`-g` 加入调试信息：

```bash
as hello.s -o hello.o -g
```

链接：

```bash
ld hello.o -o hello
```

## Intel格式汇编

### 使用 nasm

汇编，`-f` 指定格式，`-g` 加入调试信息：

```bash
nasm -f elf64 hello.asm -o hello.o -g
```

链接：

```bash
ld hello.o -o hello
```

