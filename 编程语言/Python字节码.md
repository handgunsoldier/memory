# Python 字节码

Python 源文件要先翻译成字节码，再交给 Python 虚拟机执行。理解字节码内幕，可以帮助写出性能更好的 Python 程序。

但不可过于纠结，因为提升有限。除非是在一个循环很多次的循环中或用到很多次的函数，可以带来一定提升。

## 虚拟机内幕

CPython 使用一个基于栈的虚拟机。也就是说，它完全面向栈数据结构的（你可以 “推入” 一个东西到栈 “顶”，或者，从栈 “顶” 上 “弹出” 一个东西来）。

CPython 使用三种类型的栈：

1. *调用栈(call stack)*。这是运行 Python 程序的主要结构。它为每个当前活动的函数调用使用了一个东西 —— “ *帧(frame)*”，栈底是程序的入口点。每个函数调用推送一个新的帧到调用栈，每当函数调用返回后，这个帧被销毁。
2. 在每个帧中，有一个 *计算栈(evaluation stack)* （也称为 *数据栈(data stack)*）。这个栈就是 Python 函数运行的地方，运行的 Python 代码大多数是由推入到这个栈中的东西组成的，操作它们，然后在返回后销毁它们。
3. 在每个帧中，还有一个 *块栈(block stack)*。它被 Python 用于去跟踪某些类型的控制结构：循环、`try` / `except` 块、以及 `with` 块，全部推入到块栈中，当你退出这些控制结构时，块栈被销毁。这将帮助 Python 了解任意给定时刻哪个块是活动的，比如，一个 `continue` 或者 `break` 语句可能影响正确的块。

## 例子

一个斐波那契函数：

```python
def fib(n):
    if n < 2:
        return n
    current, next = 0, 1
    while n:
        current, next = next, next + current
        n -= 1
    print(current)
```

使用 `dis.dis(fib)` 查看其字节码：

```
  2           0 LOAD_FAST                0 (n)
              2 LOAD_CONST               1 (2)
              4 COMPARE_OP               0 (<)
              6 POP_JUMP_IF_FALSE       12

  3           8 LOAD_FAST                0 (n)
             10 RETURN_VALUE

  4     >>   12 LOAD_CONST               2 ((0, 1))
             14 UNPACK_SEQUENCE          2
             16 STORE_FAST               1 (current)
             18 STORE_FAST               2 (next)

  5          20 SETUP_LOOP              30 (to 52)
        >>   22 LOAD_FAST                0 (n)
             24 POP_JUMP_IF_FALSE       50

  6          26 LOAD_FAST                2 (next)
             28 LOAD_FAST                2 (next)
             30 LOAD_FAST                1 (current)
             32 BINARY_ADD
             34 ROT_TWO
             36 STORE_FAST               1 (current)
             38 STORE_FAST               2 (next)

  7          40 LOAD_FAST                0 (n)
             42 LOAD_CONST               3 (1)
             44 INPLACE_SUBTRACT
             46 STORE_FAST               0 (n)
             48 JUMP_ABSOLUTE           22
        >>   50 POP_BLOCK

  8     >>   52 LOAD_GLOBAL              0 (print)
             54 LOAD_FAST                1 (current)
             56 CALL_FUNCTION            1
             58 POP_TOP
             60 LOAD_CONST               0 (None)
             62 RETURN_VALUE
```

- 第一列指源码所在行数。

- 第二列的 `>>` 标记指，其他地方会有跳转指令跳到这里来。

- 第三列的数字，是 Python 字节码所在位置。可以发现都是偶数，因为 3.6 开始，Python 字节码都占两个字节，前一个字节是指令，后一个字节是其参数。

- 第四列就是字节码对应人类可阅读的指令。可以通过下面代码查看一个函数的原始字节码：

  ```python
  fib.__code__.co_code
  ```

  结果：

  ```python
  b'|\x00d\x01k\x00r\x0c|\x00S\x00d\x02\\\x02}\x01}\x02x\x1e|\x00r2|\x02|\x02|\x01\x17\x00\x02\x00}\x01}\x02|\x00d\x038\x00}\x00q\x16W\x00|\x01S\x00'
  ```

  第一个字符是 `|` ，Python 会把能显示为 ASCII 码的十六进制显示为其对应的 ASCII 码，它其实是 `LOAD_FAST` 的指令序列号，可以通过 `dis.opname[ord('|')]` 验证。后面的 `\x00` 就是 `LOAD_FAST` 的参数 `0` 。以此类推。

- 第五列是指令的参数。

  如第一行 `LOAD_FAST`  的参数为 0，这是一个索引，是指将函数中第一个（0 为第一个）本地变量 `n` 的值压入计算栈中。

  每个函数都维护着三个元祖，分别存储了函数中用到的所有常量、本地变量、全局变量，通过索引取出相应内容，具体是从哪个元组取和指令有关：`LOAD_CONST` 就是从常量元组中取值，压入计算栈中；`LOAD_FAST` 就是从本地变量元组中取值，压入计算栈中；`LOAD_GLOBAL` 就是从全局变量元组中取值，压入计算栈中。可以通过以下代码查看三个元组：

  ```python
  # 函数中用到的所有常量
  print(fib.__code__.co_consts)
  # 函数中用到的所有本地变量名
  print(fib.__code__.co_varnames)
  # 函数中用到的所有全局变量名
  print(fib.__code__.co_names)
  ```

  结果：

  ```python
  (None, 2, (0, 1), 1)
  ('n', 'current', 'next')
  ('print',)
  ```

  可以发现，每个函数维护的常量元组中，第一个永远是 `None`，因为一个函数如果没有指定返回值，它会隐式的返回一个 `None`，而 Python 是无法得知一个函数有没有返回值的，所以 `None` 必须有。

- 第六列是参数对应的内容。
