# 自动部署脚本  

# 构建

npm run build

# 导航到构建输出目录，每次都需要重新把dist目录初始化为Git项目

cd docs/.vuepress/dist
git init
git add -A
git commit -m 'deploy'

# 关联并推送到GitHub远程仓库上

git remote add github/master https://github.com/ZJianYa/ZJianYa.github.io.git
git push --set-upstream github/master master
git push 