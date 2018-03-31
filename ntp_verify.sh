#!bin/bash

STRING=$(diff /etc/ntp.conf.bak /etc/ntp.conf)
if [ -z $(pgrep ntp) ]
then
	service ntp start
fi

if [ -n "$STRING"  ]
then
echo "NOTICE: /etc/ntp was changed. Calculated diff:" 
diff -u0 /etc/ntp.conf.bak /etc/ntp.conf 
cp /etc/ntp.conf.bak /etc/ntp.conf
service ntp restart
fi
