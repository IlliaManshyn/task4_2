#!bin/bash


way="$( cd "$( dirname "$0" )" && pwd )"

CHECK=$(dpkg -s ntp | grep -o "install ok installed")
TEXT="install ok installed"
STRING=$(grep "ua.pool.ntp.org" /etc/ntp.conf )
CHEKCRON=$(pgrep cron)
CHNTPVERIF=$( grep "$way/ntp_verify.sh" /etc/crontab)

if [ "$CHECK" != "$TEXT" ]
then
apt-get install ntp -y
service ntp start
fi

if [ -z "$STRING" ]
then
sed 's/0.ubuntu.pool.ntp.org/ua.pool.ntp.org/' /etc/ntp.conf > /etc/ntp.conf.bak
grep -v "ubuntu.pool.ntp" /etc/ntp.conf.bak > /etc/ntp.conf
cp /etc/ntp.conf /etc/ntp.conf.bak
fi
service ntp restart

if [ -n "$CHECKCRON" ]
then
service cron start
fi

if [ -z "$CHNTPVERIF" ]
then
sed '$d'  /etc/crontab > /etc/crontab.bak.1
echo "*/5 * * * *  root bash $way/ntp_verify.sh MAILTO=root@localhost" >> /etc/crontab.bak.1
echo "#" >> /etc/crontab.bak.1
cp /etc/crontab.bak.1 /etc/crontab
service cron restart
fi
