br=`git branch | grep "*"`
git checkout test
git pull
git merge ${br/* /}
git commit
git push
git checkout ${br/* /}
