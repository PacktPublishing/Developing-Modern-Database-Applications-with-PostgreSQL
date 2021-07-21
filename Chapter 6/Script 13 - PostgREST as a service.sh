[root@ip-172-31-95-213 postgrest]# mkdir /etc/postgrest
[root@ip-172-31-95-213 postgrest]# vi /etc/postgrest/config
------------------------------------------
db-uri = "postgres://dba:bookdemo@atm.c3qdepivtce8.us-east-1.rds.amazonaws.com/atm"
db-schema = "public"
db-anon-role = "web_anon"
db-pool = 10

server-host = "127.0.0.1"
server-port = 3000

jwt-secret = "DFZ49GQGubpzcSbt3t2uMIiBF6pU4PJ8"
------------------------------------------

[root@ip-172-31-95-213 postgrest]# ln -s /usr/local/bin/postgrest /bin/postgrest
[root@ip-172-31-95-213 postgrest]# vi /etc/systemd/system/postgrest.service
------------------------------------------
[Unit]
Description=REST API for any Postgres database
After=postgresql.service

[Service]
ExecStart=/bin/postgrest /etc/postgrest/config
ExecReload=/bin/kill -SIGUSR1 $MAINPID

[Install]
WantedBy=multi-user.target
------------------------------------------

[root@ip-172-31-95-213 postgrest]# systemctl enable postgrest
[root@ip-172-31-95-213 postgrest]# systemctl start postgrest
