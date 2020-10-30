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
    echo -e  `${GREEN_COLOR}======正在merge${${array[$i]}}分支======`
    git checkout ${array[$i]}
    git pull
    git merge ${br/* /}
    if [ $? == 0 ]
    then 
    git commit
    git push
    echo -e  `${GREEN_COLOR}======${${array[$i]}}分支merge成功======`
    else
    echo -e  `${RED_COLOR}======请处理冲突后切回原分支重新merge======`
    fi
done
git checkout ${br/* /}
echo -e  `${YELOW_COLOR}======bash执行结束======`