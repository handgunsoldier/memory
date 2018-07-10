### git

-  建议

```bash
# 推荐使用这种方法更新本地分支
git fetch origin <远程分支名> # 拉取指定远程分支到本地, 远程分支在本地名为origin/master
git branch -a # 查看所有分支
git merge orgin/<远程分支名> # 合并到当前分支

# 推荐使用这种方法推送本地分支
git push origin <远程分支名> # 推送当前分支到指定远程分支
```

-  初始准备

```bash
# 设置所有git仓库的提交者和邮箱, 必须
git config --global user.name "zzzzer"
git config --global user.email "zzzzer91@gmail.com"

# 生成密钥, 把.ssh中的id_rsa.pub的内容添加到github, 就可以上传了
ssh-keygen -t rsa -C "zzzzer91@gmail.com"
```

- 基本命令

```bash
# 把当前文件夹变为git可以管理的仓库
git init
# 把文件提交到暂存区, 可用"."代表当前目录下所有文件
git add <file_name>
# 把暂存区文件正式提交, 形成一个版本, "xxx" 是本次提交描述
git commit -m "xxx"
# 停止追踪某文件
git rm --cached <file_name>
# 撤销工作区内容
# 若暂存区有相应内容, 则工作区回到暂存区内容, 暂存区内容还会存在
# 若暂存区无相应内容, 则回到版本库
git checkout -- <file_name>
# 撤销add
git reset # 丢弃整个add
git reset HEAD <file_name> # 撤销add中指定文件
# 版本回退, add内容会丢弃, 加 --hard 会使工作区变成commit内容(工作区已修改的丢弃)
git reset HEAD^ # 版本变为上上一次commit的内容, 在此之后的commit会从log上消失, 但其实还在
git reset <commit_id> # 回到指定id的commit内容
# 查看仓库当前状态
git status
# 查看哪些内容被修改
git diff <file_name>
# 显示版本记录, --pretty=one 一行输出, --abbrev-commit 简短输出commit_id
git log --pretty=one --abbrev-commit
# 显示操作记录, 可用`git reset <id>`回到指定操作时的状态
git reflog
# 在commit上添加标签, 可以用来代替commit_id
git tag <tag_name> # 默认打在最新提交的commit上
git tag <tag_name> <commit_id> # 打在指定commit上
# 查看本地标签, 注意不是按时间顺序给出, 而是按字母排序
git tag
# 查看指定标签信息
git show <tag_name>
# 删除commit上的标签
git tag -d <tag_name>
```

- 分支命令

```bash
# 如当前分支有修改, 还没提交, 要把当前现场状态储存起来, 这样才能切换分支
git slash # 储存当前工作状态
git slash list # 查看所有存储起来到状态
git slash apply # 恢复之前状态, 但slash的内容不删除
git slash pip # 恢复之前状态,slash的内容删除

# 创建并切换到dev分支, 相当于 git brach dev;git checkout dev
git checkout -b dev
# 切换回master分支
git checkout master
# checkout也可切换到指定tag或commit_id, 这会创建一个临时分支, 一旦切换, 就会消失
# 加上 -b 参数, 则创建一个永久分支
git checkout <tag_name>
# 查看所有本地分支
git branch
# 查看所有远程分支
git branch -r
# 删除dev分支
git branch -d dev
# 强制删除dev分支
git branch -D dev
# 合并dev分支到当前分支, 当前分支工作区和add会丢弃
git merge dev
```

- 远程仓库

```bash
# 从目标克隆所有分支到本地, 除了HEAD分支, 其他分支以origin/<分支名>形式命名
git clone <版本库的网址>
# 把本地仓库和远程仓库关联, origin是给远程仓库起的别名
git remote add origin git@github.com:zzzzer91/<远程仓库名.git>
# 第一次向远程仓库推送用这条, 以后推送master可简化只用`git push`
git push -u origin master
# 把当前分支推送到远程的dev分支
git push origin dev
# 拉取远程仓库内容(所有分支), 合并到本地
git pull
# 拉取远程next分支, 合并到本地master分支
# 等同于`git fetch origin; git merge origin/master`
git pull origin next:master
# 只拉取(所有分支), 不合并
# 所取回的更新, 在本地主机上要用"远程主机名/分支名"的形式读取. 比如origin主机的master, 就要用origin/master读取
# 用`git branch -r`查看
git fetch
# 拉取指定分支
git fetch origin master
# 合并取回的分支
git merge origin/master
# 根据远程分支创建本地分支
git checkout <本地分支名> origin/<远程分支名>
# 查看远程仓库
git remote -v
# 删除与远程仓库关联
git remote rm origin
```

