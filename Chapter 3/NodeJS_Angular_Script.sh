
[centos@ip-172-31-95-213 ~]$ sudo su 
[root@ip-172-31-95-213 centos]# cd /usr/local/src/ 

# Install NodeJS
[root@ip-172-31-95-213 src]# yum install wget 
Please enter 'y' for yes when asked 
[root@ip-172-31-95-213 src]# yum install -y gcc-c++ make 

[root@ip-172-31-95-213 src]# curl -sL https://rpm.nodesource.com/setup_10.x | sudo -E bash 

[root@ip-172-31-95-213 src]# yum install nodejs 
Please enter 'y' for yes when asked 

[root@ip-172-31-95-213 src]# node -v 
v10.15.3 
[root@ip-172-31-95-213 src]# npm -v 
6.4.1 

# Create API project folder
[root@ip-172-31-95-213 src]# mkdir node-api-postgres 
[root@ip-172-31-95-213 src]# cd node-api-postgres 
[root@ip-172-31-95-213 node-api-postgres]# 

# Install Express
[root@ip-172-31-95-213 node-api-postgres]# npm install express-generator -g 
[root@ip-172-31-95-213 node-api-postgres]# npm install express -g 
[root@ip-172-31-95-213 node-api-postgres]# express node-api 

[root@ip-172-31-95-213 node-api-postgres]# cd node-api 
[root@ip-172-31-95-213 node-api]# npm install 

# Install pg-promise and bluebird
[root@ip-172-31-95-213 node-api]# npm install pg-promise -g 
[root@ip-172-31-95-213 node-api]# npm install bluebird -g 

[root@ip-172-31-95-213 node-api]# npm install serve-favicon 

[root@ip-172-31-95-213 node-api]# npm install --save bluebird 
[root@ip-172-31-95-213 node-api]# npm install --save pg-promise

# Install Angular
[root@ip-172-31-95-213 node-api]# npm install -g @angular/cli 
