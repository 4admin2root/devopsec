# ansible-cmdb
https://github.com/fboender/ansible-cmdb  
# install
sudo pip install ansible-cmdb
# usage
1. run ansible setup module
```
mkdir out
ansible -m setup --tree out/ all
```
2. 
```
ansible-cmdb out/ > overview.html
```

