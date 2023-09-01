echo "Hello From Github" > /usr/share/message
#! /bin/bash
server_id=`echo $HOSTNAME | cut -d- -f2`
#echo $server_id

if [[ server_id -eq 1 ]]; then
    mysql -uroot -proot -e "create user 'replica_user'@'%' identified with mysql_native_password by 'passwprd';"
    mysql -uroot -proot -e "grant replication slave on *.* to 'replica_user'@'%';"
    mysql -uroot -proot -e "flush privileges;"
else
   mysql -uroot -proot -e " change replication source to source_host='mysql-0.mysql', source_user='replica_user', source_password='password';"
fi
