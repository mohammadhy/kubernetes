echo "Hello From Github" > /usr/share/message
#! /bin/bash
server_id=`echo $HOSTNAME | cut -d- -f2`
#echo $server_id

if [[ server_id -eq 1 ]]; then
    mysql -uroot -ppassword -e "create user 'replica'@'%' identified with mysql_native_password by 'passwprd';"
    mysql -uroot -ppassword -e "grant replication slave on *.* to 'replica'@'%';"
    mysql -uroot -ppassword -e "flush privileges;"
    echo "Done Configuration Master"
else
   mysql -uroot -ppassword -e " change replication source to source_host='mysql-0.mysql', source_user='replica_user', source_password='password';"
   echo "Done Configuration Slave"
fi
