echo "\033[33m commit信息：$1\033[0m" 
git add .
git commit -m "$1"
git push
echo "\033[32m push成功\033[0m"