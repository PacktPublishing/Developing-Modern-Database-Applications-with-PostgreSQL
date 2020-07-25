[root@ip-172-31-95-213 src]# mkdir postgrest
[root@ip-172-31-95-213 src]# cd postgrest
[root@ip-172-31-95-213 postgrest]# vi tutorial.conf
------------------------------------------
db-uri = "postgres://dba:bookdemo@atm.ck5074bwbilj.us-east-1.rds.amazonaws.com/atm"
db-schema = "public"
db-anon-role = "web_anon"
------------------------------------------
[root@ip-172-31-95-213 postgrest]# postgrest tutorial.conf
