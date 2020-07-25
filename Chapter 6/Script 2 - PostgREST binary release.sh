[root@ip-172-31-95-213 src]# yum install postgresql-libs
[root@ip-172-31-95-213 src]# wget https://github.com/PostgREST/postgrest/releases/download/v6.0.1/postgrest-v6.0.1-centos7.tar.xz
[root@ip-172-31-95-213 src]# tar xfJ postgrest-v6.0.1-centos7.tar.xz
[root@ip-172-31-95-213 src]# mv postgrest /usr/local/bin/
[root@ip-172-31-95-213 src]# rm postgrest-v6.0.1-centos7.tar.xz
