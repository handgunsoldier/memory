# Manjaro KDE版安装后配置

### pacman换源

- 生成可用中国镜像站列表:

```bash
sudo pacman-mirrors -i -c China -m rank
# 会弹出选项框, 选清华大学源
```

- 刷新缓存:

```bash
sudo pacman -Syy # 两个yy代表强制刷新, 即使已经是最新的
```

### 卸载不需要软件

```bash
# 仅供参考
# 删除指定软件包，及所有没有被其他已安装软件包使用的依赖关系(s)，及配置文件(n)
sudo pacman -Rsn steam-manjaro ms-office-online hplip firefox manjaro-settings-manager-knotifier octopi-notifier-frameworks manjaro-hello manjaro-documentation-en konversation thunderbird kget cantata vlc bluedevil pulseaudio-bluetooth kwalletmanager kwallet-pam user-manager
# vlc用mpv代替
```

### 更新系统

```bash
sudo pacman -Syu # 同步源(y), 并更新系统(u)

# 更新完, 可能会生成*.pacnew的新配置文件, 必须手动覆盖旧的, 
# 可以用pacdiff工具, 搜索所有电脑中*.pacnew
sudo pacdiff
```

### zsh

```bash
# 它的配置文件为~/.zshrc
sudo pacman -S zsh manjaro-zsh-config
```

### git

```bash
# 1.安装
sudo pacman -S git
# 2.配置
git config --global user.name "zzzzer"
git config --global user.email "zzzzer91@gmail.com"
# 3.生成ssh密钥
ssh-keygen -t rsa -C "zzzzer91@gmail.com"
# 4.在github上更新密钥
# 5.设置, 防止`git status`中文乱码
git config –global core.quotepath false 

# 可选, 设置使用socks5代理
git config --global http.proxy 'socks5://127.0.0.1:1080'
git config --global https.proxy 'socks5://127.0.0.1:1080'
```

### vim

```bash
# 1.安装
sudo pacman -S vim 
# 2.先把已经配置好的.vimrc放到家目录下
# 3.下载vim插件管理器
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
# 4.进入vim后, 执行PluginInstall安装相关插件
# 5.起别名, `vim ~/.zshrc`, 添加:
alias vi='vim' 
```

### pyenv

``` bash
# 1.安装
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
# 2.切换到最新版本(git clone下来的是master版本, 不稳定)
cd .pyenv
git tag # 检查可用版本
git checkout <tag名> # 切换
# 3.配置(自动补全功能等)
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo -e 'if command -v pyenv 1>/dev/null 2>&1; then\n  eval "$(pyenv init -)"\nfi' >> ~/.zshrc
# 4.下载指定版本python
pyenv install <版本>
# 5.切换环境
pyenv global <版本>
```

### shadowsocks

```bash
# 1.安装
pip install git+https://github.com/shadowsocks/shadowsocks.git@master
# 2.在 .zshrc 中设置命令, 方便使用
alias sss="ss-local -c /etc/shadowsocks.json"
alias setproxy="export ALL_PROXY=socks5://127.0.0.1:1080"
alias unsetproxy="unset ALL_PROXY"
```

### 中文输入法

```bash
# 1.安装fcitx
sudo pacman -S fcitx-im # 选择全部安装
sudo pacman -S fcitx-configtool # 图形化配置工具
# 2.修改~/.xprofile, 添加:
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"
# 3.在fcitx输入法选项中添加pinyin
```

### chromium

```bash
sudo pacman -S chromium
```

### 网络工具包

```bash
sudo pacman -S net-tools # ifconfig
sudo pacman -S dnsutils # nslookup
```

### 数据库

- mongodb

```bash
sudo pacman -S mongod
```

- redis

```bash
sudo pacman -S redis
```

- postgresql

```bash
sudo pacman -S postgresql

# 初始化数据库, 第一次使用必须
sudo -u postgres initdb --locale en_US.UTF-8 -D '/var/lib/postgres/data'
```

- mysql(arch下用mariadb代替)

```bash
sudo pacman -S mariadb

# 初始化数据库
sudo mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# 设置密码
mysqladmin -u root password "newpass"

# 安装GUI管理工具
sudo pacman -S dbeaver
```

### AUR

- 安装

```bash
sudo pacman -S yaourt
```

- 换源

```bash
# 修改 /etc/yaourtrc，去掉 # AURURL 的注释，修改为
AURURL="https://aur.tuna.tsinghua.edu.cn"
```

- 必装

```bash
yaourt -S typora # 很好用的markdown编辑器, 支持导出PDF
yaourt -S visual-studio-code-bin # vscode
yaourt -S wps-office ttf-wps-fonts # wps
yaourt -S robo3t-bin # mongodb gui工具
yaourt -S genymotion # 安卓模拟器
```

- **注意**: 命令台用yaourt安装时不需加sudo, 否则报错
- 出现`one or more PGP signatures could not be verified!` , 则检查`PKGBUILD` 中的key, 导入key, `gpg --recv-keys <KEYID - See validpgpkeys array in PKGBUILD>`

### pip必装

```bash
pip install ipython
pip install jupyter # jupyter notebook
pip install requests requests[socks] # http请求
pip install bs4 lxml # html解析
pip install numpy pandas matplotlib scipy # 科学计算
pip install pillow # 图像处理
pip install pipenv # 包虚拟环境
pip install aiohttp # 异步网络框架
pip install aiodns # 异步解析DNS
pip install cchardet # 更快的编码探测
pip install mitmproxy # 交互式命令行http抓包工具

# 数据库
pip install pymongo # mongodb
pip install redis # redis
pip install psycopg2 # postgresql
pip install pymysql # mysql
```

### jupyter的配置

- 先生成配置文件
```bash
jupyter notebook --generate-config
```
- 配置修改(别忘去掉注释)
```python
# 修改初始目录
修改c.NotebookApp.notebook_dir = '/home/zzzzer/Documents/code/jupyter'
# 不自动打开浏览器
c.NotebookApp.open_browser = False
```

### 其他

- 选择bash下默认编辑器

```bash
# 在.zshrc下添加如下一行
EDITOR="/usr/bin/vim"
```

- 安装Windows字体

```bash
# 先将windows字体放入该目录
cd /usr/share/fonts/winfonts
# 在该目录执行如下命令
sudo mkfontscale
sudo mkfontdir
sudo fc-cache -fv
```

