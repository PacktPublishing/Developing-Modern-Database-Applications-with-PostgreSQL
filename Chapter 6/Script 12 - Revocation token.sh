[centos@ip-172-31-95-213 ~]$ export BADTOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYXRtX3VzZXIiLCJlbWFpbCI6Im5vdC5nb29kQG15cG9zdGdyZXN0LmNvbSJ9.Alz9Wm7oQ4igcZA9mr-OjgwPJ_d3PisvmKAnb29xLMQ"

[centos@ip-172-31-95-213 ~]$ curl http://localhost:3000/ATM%20locations -X POST -H "Authorization: Bearer $BADTOKEN" -H "Content-Type: application/json" -d '{"BankName":"Test Bank 2","Address":"100 Test way","County":"New York","City":"New York","State":"NY","ZipCode":10272}'

