name=$1
br=`git branch | grep "*"`
branch=('dev')
if [ $name == 'test' ]
then 
    branch+=('test')
elif [ $name == 'pre' ]
then
    branch+=('test' 'pre')
elif [ $name == 'master' ]
then
    branch+=('test' 'pre' 'master')
fi
len=${#branch[@]}
for ((i=0;i<$len;i++));do
    echo ${branch[$i]}
    git checkout ${branch[$i]}
    git pull
    git merge ${br/* /}
    git commit
    git push
done
git checkout ${br/* /}