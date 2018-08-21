# Rust 笔记

 ## Cargo

### 创建项目

```bash
cargo new hello_cargo --bin
```

第一行命令新建了名为 *hello_cargo* 的二进制可执行程序。传递给 `cargo new` 的 `--bin` 参数生成一个可执行程序（通常就叫做 **二进制文件**，*binary*），而不是一个库。项目的名称被定为 `hello_cargo`，同时 Cargo 在一个同名目录中创建项目文件。

进入 *hello_cargo* 目录并列出文件。将会看到 Cargo 生成了两个文件和一个目录：一个 *Cargo.toml* 文件和一个 *src* 目录，*main.rs* 文件位于 *src* 目录中。它也在 *hello_cargo* 目录初始化了一个 git 仓库，以及一个 *.gitignore* 文件。

### 构建并运行 Cargo 项目

```bash
$ cargo build
   Compiling hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 2.85 secs
```

这这个命令会创建 *target/debug/hello_cargo*可执行文件，而不是在目前目录。

可以通过这个命令运行可执行文件：

```
$ ./target/debug/hello_cargo # or .\target\debug\hello_cargo.exe on Windows
Hello, world!
```

如果一切顺利，`Hello, world!` 应该打印在终端上。首次运行 `cargo build` 时也会使 Cargo 在项目根目录创建一个新文件：*Cargo.lock* 。这个文件记录项目依赖的实际版本。这个项目并没有依赖，所以其内容比较少。你自己永远也不需要碰这个文件，让 Cargo 处理它就行了。

也可以使用 `cargo run` 在一个命令中同时编译并运行生成的可执行文件。Cargo 发现文件并没有被改变，就直接运行了二进制文件。如果修改了源文件的话，Cargo 会在运行之前重新构建项目。

```
$ cargo run
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/hello_cargo`
Hello, world!
```

Cargo 还提供了一个叫 `cargo check` 的命令。该命令快速检查代码确保其可以编译但并不产生可执行文件：

```bash
$ cargo check
   Compiling hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 0.32 secs
```

### 发布（release）构建

当项目最终准备好发布了，可以使用 `cargo build --release` 来优化编译项目。这会在 *target/release* 而不是 *target/debug* 下生成可执行文件。这些优化可以让 Rust 代码运行的更快，不过启用这些优化也需要消耗更长的编译时间。这也就是为什么会有两种不同的配置：一种为了开发，你需要经常快速重新构建；另一种为了构建给用户最终程序，它们不会经常重新构建，并且希望程序运行得越快越好。如果你在测试代码的运行时间，请确保运行 `cargo build --release` 并使用 *target/release* 下的可执行文件进行测试。

### 把 Cargo 当作习惯

对于简单项目， Cargo 并不比 `rustc` 提供了更多的优势，不过随着开发的深入终将证明其价值。对于拥有多个 crate 的复杂项目，让 Cargo 来协调构建将简单的多。

即便 `hello_cargo` 项目十分简单，它现在也使用了很多你之后的 Rust 生涯将会用得上的实用工具。其实对于任何你想要从事的项目，可以使用如下命令通过 Git 检出代码，移动到该项目目录并构建：

```
$ git clone someurl.com/someproject
$ cd someproject
$ cargo build
```

### 快速查阅文档

你不可能凭空就知道应该 use 哪个 trait 以及该从 crate 中调用哪个方法。crate 的使用说明位于其文档中。Cargo 有一个很棒的功能是：运行 `cargo doc --open` 命令来构建所有本地依赖提供的文档，并在浏览器中打开。例如，假设你对 `rand` crate 中的其他功能感兴趣，你可以运行 `cargo doc --open` 并点击左侧导航栏中的 `rand`。

关于更多 Cargo 的信息，请查阅 [其文档](https://doc.rust-lang.org/cargo/)。