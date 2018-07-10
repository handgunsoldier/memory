### 版本管理: pyenv

- 命令

```shell
# 显示可下载内容
pyenv install --list
# 下载指定版本python
pyenv install <版本> 
# 显示所有已安装环境
pyenv versions 
# 切换版本
pyenv global <版本> 
# 刷新数据, 在pip安装新包后使用
pyenv rehash 
# 卸载环境
pyenv uninstall <版本>
```

- 更新

```shell
# git pull下来的是master版本, 不稳定, 需切换到指定标签
cd .pyenv
git pull origin master:master
git tag # 检查可用版本
git checkout <tag名> # 切换
```

### 虚拟环境: pyenv-virtualenv

- 命令

```bash
# 用当前环境创建虚拟容器
pyenv virtualenv <name>
# 查看已有容器, 注意多个s
pyenv virtualenvs
# 切换到容器
pyenv activate <name>
# 退出容器
pyenv deactivate
# 卸载容器
pyenv uninstall <name>
```

- 更新

```shell
cd .pyenv/plugins/pyenv-virtualenv
git pull origin master:master
git tag # 检查可用版本
git checkout <tag名> # 切换
```

### 包管理: pip

- 命令

```shell
# 列出所有库
pip list 
# 列出所有过期库
pip list --outdate 
# 列出所有安装的库, requirements.txt格式
pip freeze
# 只下载该库
pip download <PACKAGE_NAME> 
# 下载安装该库
pip install <PACKAGE_NAME> 
# 升级该库
pip install --upgrade <PACKAGE_NAME> 
# 安装指定版本包
pip install "requests==2.8.7" 
# 安装小于版本2的最新包
pip install "django<2" 
# 安装requirements.txt文件中指定的拓展库
pip install -r requirements.txt
# 用指定源安装包, 这里是清华大学源
pip install -i https://pypi.tuna.tsinghua.edu.cn/simple <PACKAGE_NAME> 
# 卸载该库
pip uninstall <PACKAGE_NAME> 
```

### pipenv

- 命令

```shell
# pipenv有两个条目: 普通和dev, 根据开发需求选择包安装条目
pipenv install # 仅初始化环境, 如果目录下有Pipfile文件, 则根据其内容生成环境
pipenv install flask # 初始化环境并在普通条目安装flask
pipenv install flask --dev # 初始化环境并在dev条目安装flask

# 列出pip包之间依赖关系
pipenv graph

# 更新生成Pipfile.lock文件
pipenv lock

# 显示虚拟环境所在目录
pipenv --venv

# 启用虚拟环境
pipenv shell

# 删除环境
pipenv uninstall --all-dev # 卸载dev条目所有包, 注意虚拟环境还在
pipenv uninstall --all # 卸载所有包, 注意虚拟环境还在
pipenv --rm # 完全删除虚拟环境, 只需这一条指令
```

