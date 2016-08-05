FROM ubuntu:xenial
MAINTAINER Enric Mieza <enric@enricmieza.com>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
apt-get install -y curl \
	apache2 \
	libapache2-mod-php \
	php-mysql \
	php-gd \
	php-mbstring \
	mysql-server && \
apt-get clean && apt-get autoclean && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /var/www/html/* && \
curl -o /zenphoto.tgz https://codeload.github.com/zenphoto/zenphoto/tar.gz/master && \
sed -i "/upload_max_filesize/c\upload_max_filesize = 20M" /etc/php/7.0/apache2/php.ini

ADD run.sh /run.sh
RUN chmod 755 /run.sh

EXPOSE 80

VOLUME ["/var/lib/mysql"]

CMD ["/bin/bash","/run.sh"]
