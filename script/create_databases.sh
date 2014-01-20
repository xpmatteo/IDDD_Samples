#!/bin/bash

set -e
cd "$(dirname $0)/.."

dbuser=iddd
dbpassword=iddd

read -s -p "mysql root password? (type return for no password) " MYSQL_ROOT_PASSWORD
if [ "$MYSQL_ROOT_PASSWORD" != "" ]; then
    MYSQL_ROOT_PASSWORD=-p$MYSQL_ROOT_PASSWORD
fi

function drop_create_database() {
	dbname=$1
	shift
	sources=$*
	mysqladmin -uroot $MYSQL_ROOT_PASSWORD --force drop $dbname || true
	echo "create database $dbname default charset utf8;" | mysql -uroot $MYSQL_ROOT_PASSWORD
	echo "grant all on $dbname.* to '$dbuser'@localhost identified by '$dbpassword';" \
	     | mysql -uroot $MYSQL_ROOT_PASSWORD
	cat $sources | mysql -u$dbuser "-p$dbpassword" $dbname
	echo "$dbname created"
}

drop_create_database iddd_common_test   iddd_common/src/main/mysql/test_common.sql iddd_common/src/main/mysql/common.sql
drop_create_database iddd_collaboration iddd_collaboration/src/main/mysql/collaboration.sql
drop_create_database iddd_iam           iddd_identityaccess/src/main/mysql/iam.sql iddd_common/src/main/mysql/common.sql
