name=$1
GREEN_COLOR='\E[1;32m' #绿
RED_COLOR='\E[1;31m'  #红
YELOW_COLOR='\E[1;33m' #黄
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
    echo -e "\033[32m 正在merge${array[$i]}分支\033[0m"
    git checkout ${array[$i]}
    git pull
    git merge ${br/* /}
    if [ $? == 0 ]
    then 
    git commit
    git push
    echo -e "\033[32m ${array[$i]}分支merge完成\033[0m"
    echo -e "\033[32m ##########################################\033[0m"
    else
    echo -e "\033[31m 请解决完冲突后checkout回原分支重新merge\033[0m"
    fi
done
git checkout ${br/* /}
echo "\033[33m ======bash执行结束======\033[0m"