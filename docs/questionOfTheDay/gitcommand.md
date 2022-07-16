##	git常用命令
	
## git对一个目录进行版本控制需要一下步骤

- 进入要管理的文件夹
-	执行初始化命令
```bash
git init
```
- 管理目录下的文件状态
```bash
git status
#	新增的文件和修改后的文件都是红色
```
-	管理指定文件（红变绿）
```bash
git add 文件名
git add .			# . 表示全部文件
```
-	生成版本
```bash
git commit -m "描述信息"
```
- 查看版本记录
```bash
git log
```

##	扩展功能
-	回滚至之前版本
```bash
git log
git reset --hard 版本号
```
-	回滚至之后的版本
```bash
git reflog
git reset --hard 版本号
```

##	分支相关
```bash
git branch		# 查看分支
git branch  分支名称		#创建分支
git checkout 分支名称		#切换分支
git merge  要合并的分支名称		#合并分支
//	合并分支前要切换要主分支，在进行合并
git branch -d 分支名称		#删除分支
	
```

##	工作流
-	推荐开发时至少用两个分支 master & dev 
-	开发时用dev分支， master分支存储正常代码


## 远程仓库
```bash

git remote -v   # 查看添加的远程仓库

git remote add origin git@github.com:Spiderwe/comments.git      #origin是远程源的名字

git push -u origin 分支名称		#向远程推送代码
git push -u origin master    origin是远程源的源名，可以自定义；master是分支名，是默认的主分支

git clone 远程仓库地址		#克隆远程仓库(内部以实现 git remote add origin url)

git checkout		#切换分支
```


##	两地开发
-	在公司开发
```bash
1.切换到dev分支，进行开发(参考上述工作流)
	git checkout dev
2.把 master分支 合并到 dev (仅一次)
	git merge master
3.编辑代码
4.提交代码
	git add .
	git commit -m 'xxxxx'
	git pubash origin dev
```
-	回家继续写代码
```bash
1.切换到dev分支，
	git checkout dev
2.拉取代码
	git pull origin dev
3.继续开发
4.提交代码
	git add .
	git commit -m "xxxx"
	git pubash origin dev
```
-	在公司继续开发，步骤同上

-	开发完毕，需要上线
```bash
1.将dev分支合并到master，进行上线
git checkout master
git merge dev
git pubash origin master

2.把dev分支也推送到远程
git checkout dev
git merge master
git pubash origin dev
```

## 两地开发中，在公司的代码忘记推送到远程仓库
-	解决办法
-	在家开发其他功能
-	回到公司后，
-	git pull origin dev
-	如果有冲突，则进行解决
-	提交代码到暂存区。。。

```bash
git pull origin dev		# 这个命令相当于下面两个命令结合
git fetch origin dev
git merge origin/dev
```

## rebase(变基) 
-	简洁提交记录
-	注意：合并时不要合并已经push到远程的

- git log 的图形记录展示
```bash
git log --graph --pretty=format:"%h %s"
```

##	beyond compare	解决merge时的冲突的app
-	1.在git中配置
```bash
# --local 参数是只在当前项目生效
git config --local merge.tool bc3
git config --local mergetool.path "beyond compare的安装路径"
git config --local mergetool.keepBackuup false		#解决冲突后不保留备份
```

-	2.应用beyond compare解决冲突
```bash
git mergetool
```

##	多人协同
-	master分支放生产代码
-	dev分支放开发代码
-	多人开发时，从dev分支开始 branch 出自己的分支
-	多人协同时，可以通过‘组织' 创建项目
-	而后给项目打上标签
```bash
git tag -a v1 -m "第一版"

git pubash orign --tags		#提交至远程仓库(github的分支下拉菜单上也会显示tag)
```
-	开发前的步骤

```bash
git branch -b dev		#	创建dev分支并进行切换
git pubash origin dev		#	将本地dev分支推送到远程(github分支下拉菜单显示2个分支，tag还是同一个)
```
-	邀请开发人员加入组织(邮件形式)
-	组织内可以有很多项目，刚加入的成员，默认权限为只读
-	邀请刚加入组织的成员加入	需要开发的项目
-	成员从dev分支创建新分支,进行需要开发的功能
-	开发完成后，需要进行 Code review (代码检查) 
-	在github仓库页面，settings => Branches => 设置review的规则
-	开发人员github页面有New pull request 按钮，选择分支进行merge, 写入描述信息
-	组长github的Pull request中，有成员的 code review 请求， 点击 Add your review 验证


##	给开源项目贡献代码
-	1.先Fork看中的仓库 (拷贝到自己的仓库)
-	2.在自己的仓库修改代码
-	3.给源码作者提交申请(pull request)(选择分支，添加描述信息)
-	4.如果源码作者同意，会接受这次pull request


##	其他

- 配置文件

```bash
#	当前项目配置文件: 当前项目/.git/config
git config --local user.name 'test'
git config --local user.email 'test@gmail.com'

#	全局配置文件: ~/.gitconfig
git config --global user.name 'test'
git config --global user.email 'test@gmail.com'

#	系统配置文件：	/etc/.gitconfig		需要root
git config --system user.name 'test'
git config --system user.email 'test@gmail.com'


git remote add origin url		#	默认添加在本地配置文件中(相当于--local) 
```



## git忽略文件	.gitignore

```bash
test/		#忽略test/文件夹
*.h			#忽略所有.h结尾的文件
更多参考	https://github.com/github/gitignore
```


## 任务管理

```bash
issues: 文档，提问，bug汇总等		#可以给相应的问题打标签(例如bug,doc...)
wiki: 项目文档
```
