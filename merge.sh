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
    git commit
    git push
done
git checkout ${br/* /}