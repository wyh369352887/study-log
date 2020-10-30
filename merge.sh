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
    git checkout ${array[$i]}
    git pull
    git merge ${br/* /}
    if [ $? == 0 ]
    then 
    git commit
    git push
    else
    echo `请解决冲突后切回开发分支重新merge`
done
git checkout ${br/* /}