name=$1
br=`git branch | grep "*"`
array=('dev')
if [ $name == 'test' ]
then 
    array+=('test')
elif [ $name == 'pre' ]
then
    array+=('test' 'pre')
elif [ $name == 'master' ]
then
    array+=('test' 'pre' 'master')
fi
len=${#array[@]}
for ((i=0;i<$len;i++));do
    echo "\033[32m 正在merge：${array[$i]}分支\033[0m"
    git checkout ${array[$i]}
    git pull
    git merge ${br/* /}
    if [ $? == 0 ]
    then 
    git commit
    git push
    echo "\033[32m ${array[$i]}分支merge完成\033[0m"
    echo "\033[37m ##########################################\033[0m"
    else
    echo "\033[31m 请解决完冲突后checkout回原分支重新merge\033[0m"
    fi
done
git checkout ${br/* /}
echo "\033[33m ======bash执行结束======\033[0m"