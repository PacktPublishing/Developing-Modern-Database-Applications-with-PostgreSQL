[centos@ip-172-31-95-213 ~]$ sudo su
[root@ip-172-31-95-213 centos]# cd /usr/local/src/
[root@ip-172-31-95-213 src]# yum install -y yum-utils device-mapper-persistent-data lvm2
[root@ip-172-31-95-213 src]# yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
[root@ip-172-31-95-213 src]# yum install docker-ce
[root@ip-172-31-95-213 src]# usermod -aG docker $(whoami)
[root@ip-172-31-95-213 src]# systemctl enable docker.service
[root@ip-172-31-95-213 src]# systemctl start docker.service
[root@ip-172-31-95-213 src]# docker run --name tutorial -p 5432:5432 -e POSTGRES_PASSWORD=mysecretpassword      -d postgres
[root@ip-172-31-95-213 src]# docker exec -it tutorial psql -U postgres
