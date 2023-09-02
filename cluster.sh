#! /bin/bash
echo "Hello From Github" > /usr/share/message
server_id=`echo $HOSTNAME | cut -d- -f2`
#echo $server_id

if [[ $server_id -eq 0 ]]; then
    mysql -uroot -p123 -e "create user 'replica'@'%' identified with mysql_native_password by '123';"
    mysql -uroot -p123 -e "grant replication slave on *.* to 'replica'@'%';"
    mysql -uroot -p123 -e "flush privileges;"
    echo "Done Configuration Master"
else
   mysql -uroot -p123 -e " change replication source to source_host='mysql-0.mysql', source_user='replica', source_password='123';"
   echo "Done Configuration Slave"
fi
