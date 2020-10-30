echo "\033[32m 请输入当前分支:"
read submit 
git checkout test
git pull
git merge $submit
git commit
git push