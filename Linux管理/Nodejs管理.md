## Node.js 管理

### 版本管理：Nvm

命令：

```bash
# 安装指定版本的 Node.js
nvm install  --lts  # 安装一个长期支持版本

# 切换 Node.js 版本
nvm use  --lts

# 查看当前使用的 Node.js 版本
nvm current

# 查看当前已安装的版本列表
nvm list

# 查看指定版本的安装位置
nvm which  --lts

# 取消激活一个版本，卸载前必须
nvm deactivate --lts

# 卸载一个版本
nvm uninstall  --lts
```

更新：

```shell
cd .nvm
# git fetch下来的是master版本, 不稳定, 需切换到指定标签版本
git fetch origin master  # 更新 origin/master 分支内容
git checkout master  # 切换到主分支
git merge origin/master  # 合并 origin/master 分支到 master 分支
git tag  # 检查可用版本
git checkout <tag名>  # 切换
```

### 包管理：Npm

