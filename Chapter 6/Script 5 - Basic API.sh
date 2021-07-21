[root@ip-172-31-95-213 centos]# curl http://localhost:3000/ATM%20locations
[root@ip-172-31-95-213 centos]# curl http://localhost:3000/ATM%20locations -X POST -H "Content-Type: application/json" -d '{"BankName":"Test Bank","Address":"99 Test way","County":"New York","City":"New York","State":"NY","ZipCode":10271}'
