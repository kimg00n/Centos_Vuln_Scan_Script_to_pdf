#!/bin/bash
yum install python3
python3 -m pip install --upgrade pip
python3 -m pip install markdown matplotlib pdfkit

wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox-0.12.6-1.centos7.x86_64.rpm
yum localinstall wkhtmltox-0.12.6-1.centos7.x86_64.rpm

rm wkhtmltox-0.12.6-1.centos7.x86_64.rpm