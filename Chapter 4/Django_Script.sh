[centos@ip-172-31-95-213 ~]$ sudo su
[root@ip-172-31-95-213 centos]# cd /usr/local/src/

# Install Python
[root@ip-172-31-95-213 src]# yum install gcc openssl-devel bzip2-devel libffi-devel
[root@ip-172-31-95-213 src]# wget https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tgz
[root@ip-172-31-95-213 src]# tar xzf Python-3.7.3.tgz
[root@ip-172-31-95-213 src]# cd Python-3.7.3
[root@ip-172-31-95-213 Python-3.7.3]# ./configure --enable-optimizations
[root@ip-172-31-95-213 Python-3.7.3]# make altinstall
[root@ip-172-31-95-213 Python-3.7.3]# rm /usr/local/src/Python-3.7.3.tgz
[root@ip-172-31-95-213 Python-3.7.3]
[root@ip-172-31-95-213 Python-3.7.3]# python3.7 -V

# Create a virtual environment for our Django application.

[root@ip-172-31-95-213 src]# mkdir django_app
[root@ip-172-31-95-213 src]# cd django_app
[root@ip-172-31-95-213 django_app]
[root@ip-172-31-95-213 django_app]# python3.7 -m venv venv
[root@ip-172-31-95-213 django_app]# ls
[root@ip-172-31-95-213 django_app]# source venv/bin/activate
(venv) [root@ip-172-31-95-213 django_app]# echo $PATH

# Install Django

(venv) [root@ip-172-31-95-213 django_app]# pip3 install django
(venv) [root@ip-172-31-95-213 django_app]# python3.7 -m django --version

# Create a Django Project

(venv) [root@ip-172-31-95-213 django_app]# django-admin startproject atmproject
(venv) [root@ip-172-31-95-213 django_app]# yum install tree -y
(venv) [root@ip-172-31-95-213 django_app]# tree atmproject

# Create the ATM app

(venv) [root@ip-172-31-95-213 django_app]# cd atmproject
(venv) [root@ip-172-31-95-213 atmproject]# python3.7 manage.py startapp atmapp
(venv) [root@ip-172-31-95-213 atmproject]# tree atmapp

# Django Database Settings with PostgreSQL

(venv) [root@ip-172-31-95-213 atmproject]# pip3 install psycopg2-binary
(venv) [root@ip-172-31-95-213 atmproject]# vi atmproject/settings.py
------------------------------------------
DATABASES = {
        'default': {
                'ENGINE': 'django.db.backends.postgresql_psycopg2',
                'NAME': 'atm',
                'USER': 'dba',
                'PASSWORD': 'bookdemo',
                'HOST': 'atm.c3qdepivtce8.us-east-1.rds.amazonaws.com',
                'PORT': '5432',
        }
}
------------------------------------------

(venv) [root@ip-172-31-95-213 atmproject]# python3.7 manage.py migrate

# Create super user

(venv) [root@ip-172-31-95-213 atmproject]# python3.7 manage.py createsuperuser
(venv) [root@ip-172-31-95-213 atmproject]# vi atmproject/settings.py
------------------------------------------
ALLOWED_HOSTS = ['3.209.184.46', 'ec2-3-209-184-46.compute-1.amazonaws.com']
AUTHENTICATION_BACKENDS = (
        ('django.contrib.auth.backends.ModelBackend'),
)
------------------------------------------

(venv) [root@ip-172-31-95-213 atmproject]# python3.7 manage.py runserver 0:8000

# Database model

(venv) [root@ip-172-31-95-213 atmproject]# vi atmapp/models.py
------------------------------------------
from django.db import models

# Create your models here.
class ATMlocations(models.Model):
        ID = models.AutoField(primary_key=True)
        BankName = models.CharField(max_length=60)
        Address = models.CharField(max_length=50)
        County = models.CharField(max_length=15)
        City = models.CharField(max_length=15)
        State = models.CharField(max_length=2)
        ZipCode = models.IntegerField()

        class Meta:
                db_table = 'ATM locations'
                verbose_name = 'ATM location'
                verbose_name_plural = 'ATM locations'
------------------------------------------

(venv) [root@ip-172-31-95-213 atmproject]# cat atmapp/apps.py
------------------------------------------
from django.apps import AppConfig

class AtmappConfig(AppConfig):
        name = 'atmapp'
------------------------------------------

# Migrating the Database

(venv) [root@ip-172-31-95-213 atmproject]# python3.7 manage.py makemigrations atmapp
(venv) [root@ip-172-31-95-213 atmproject]# python3.7 manage.py sqlmigrate atmapp 0001
(venv) [root@ip-172-31-95-213 atmproject]# python3.7 manage.py migrate

[root@ip-172-31-95-213 atmproject]# vi atmapp/admin.py
------------------------------------------
from django.contrib import admin

# Register your models here.

from .models import ATMlocations

admin.site.register(ATMlocations)
------------------------------------------

(venv) [root@ip-172-31-95-213 atmproject]# python3.7 manage.py runserver 0:8000

