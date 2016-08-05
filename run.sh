#!/bin/bash

BASEDIR=/var/www/html
# extract and initialize zenphoto if not present
if [ ! -d $BASEDIR/zp-core ]
then
	rm $BASEDIR/index.html
	# extract zenphoto files
	/bin/tar xfz /zenphoto.tgz -C $BASEDIR --strip-components=1
	# create config
	/bin/cp $BASEDIR/zp-core/zenphoto_cfg.txt $BASEDIR/zp-data/zenphoto.cfg.php
	sed -i "/mysql_user/c\$conf['mysql_user'] = 'root';" $BASEDIR/zp-data/zenphoto.cfg.php
	sed -i "/mysql_database/c\$conf['mysql_database'] = 'zenphoto';" $BASEDIR/zp-data/zenphoto.cfg.php
	mkdir $BASEDIR/cache
	mkdir $BASEDIR/cache_html
	chown www-data $BASEDIR/albums
	chown www-data $BASEDIR/uploaded
	chown www-data $BASEDIR/zp-data
	chown www-data $BASEDIR/plugins
	chown www-data $BASEDIR/cache
	chown www-data $BASEDIR/cache_html
fi

# initialize mysql files 
if [ ! -d /var/lib/mysql/mysql ]
then
	mysqld --initialize-insecure
fi

# run mysql daemon
/usr/bin/mysqld_safe > /dev/null 2>&1 &
# wait for daemon to be up
RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done
# create db
mysql -uroot -e "CREATE DATABASE zenphoto;"

# run apache in foreground
/usr/sbin/apachectl -D FOREGROUND

