# Vim

## 一些操作

### Tips

1、查看指定 C 函数 man 文档，将光标放到想查的函数上面，然后按下：

```bash
K  # 大写
```

2、查看指定头文件，则使用：

```bash
gf
```

按下 Ctrl+o 可以返回源文件。

3、查看宏定义：

```bash
[d
```

4、格式化代码（四个按键）：

```bash
gg=G
```

5、交换两个字符，先移动光标到前一个字符，然后按下：

```bash
xp
```

### 查找

按下 `/`，然后输要查找内容，按 `n` 切换到下一处。

### 替换

```bash
# 把光标所在行的第一个 tom 替换成 jack
:s/tom/jack
# 把光标所在行的所有 tom 替换成 jack
:s/tom/jack/g
# 把所有行的第一个 tom 替换成 jack
:%s/tom/jack
# 把所有 tom 替换成 jack
:%s/tom/jack/g
# 把 10 到 20 行的所有 tom 替换成 jack
:10,20s/tom/jack/g
```

## 插件相关

### 实现函数跳转功能

1、安装 vim 的 vim-gutentags 插件，会自动创建函数索引（需要先安装 Ctags）。

2、在 vim 中, 将光标移至指定函数，按 `Ctrl+]` 跳转到指定函数；按 `Ctrl+o` 跳回原来位置。

### NERDTree

  ```bash
  T   # 打开一个标签页
  gt  # 在标签页中切换
  ```
