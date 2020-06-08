#!/usr/bin/sh
yum -y update
yum -y install initscripts
yum -y install gcc gcc-c++ gcc-g77
yum -y install autoconf
yum -y install pcre pcre-devel
yum -y install openssl
yum -y install openssl-devel
yum -y install wget
yum -y install kernel-devel-3.10.0-862.14.4.el7.x86_64
yum -y install libxml2
yum -y install libxml2-devel
yum -y install openssl
yum -y install openssl-devel
yum -y install curl
yum -y install curl-devel
yum -y install libjpeg
yum -y install libjpeg-devel
yum -y install libpng
yum -y install libpng-devel
yum -y install freetype
yum -y install freetype-devel
yum -y install pcre
yum -y install pcre-devel
yum -y install libxslt
yum -y install libxslt-devel
yum -y install bzip2
yum -y install bzip2-devel
yum -y install libsqlite3x-devel
yum -y install sqlite-devel
yum -y install postgresql-devel
yum -y install http://rpms.remirepo.net/enterprise/7/remi/x86_64//oniguruma5-6.9.4-1.el7.remi.x86_64.rpm
yum -y install http://rpms.remirepo.net/enterprise/7/remi/x86_64//oniguruma5-devel-6.9.4-1.el7.remi.x86_64.rpm
wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -ivh epel-release-latest-7.noarch.rpm
yum -y install aria2
touch /etc/aria2.conf
echo "dir=/opt/lnmp" >> /etc/aria2.conf

mkdir -p /opt/lnmp/
aria2c -c -x16 -s20 -j20 --conf-path=/etc/aria2.conf https://openresty.org/download/openresty-1.15.8.3.tar.gz -o openresty-1.15.8.3.tar.gz
tar xf /opt/lnmp/openresty-1.15.8.3.tar.gz -C /usr/src/ && cd /usr/src/openresty-1.15.8.3/
./configure --prefix=/opt/openresty --prefix=/opt/openresty --with-luajit --without-http_redis2_module --with-http_iconv_module --with-http_postgres_module
make -j4 && make install
echo "export PATH=$PATH:/opt/openresty/nginx/sbin" >> /etc/profile
source /etc/profile
wget https://gitee.com/wangkaihui/codes/63qhf2edmi0vu9gkpl1rt63/raw?blob_name=openresty -O /opt/lnmp/openresty
sed -i -e 's/\r//g' /opt/lnmp/openresty
\cp -rf /opt/lnmp/openresty /etc/init.d/openresty
chmod u+x /etc/init.d/openresty
chkconfig --add /etc/init.d/openresty
chkconfig openresty on

mv /opt/openresty/nginx/conf/nginx.conf /opt/openresty/nginx/conf/nginx.conf.back
wget https://gitee.com/wangkaihui/codes/ful0k3ajqdi75mn28b14v29/raw?blob_name=nginx.conf -O /opt/openresty/nginx/conf/nginx.conf
sed -i -e 's/\r//g' /opt/openresty/nginx/conf/nginx.conf
mkdir -p /opt/openresty/nginx/conf/vhost

aria2c -c -x16 -s20 -j20 --conf-path=/etc/aria2.conf https://www.php.net/distributions/php-7.4.6.tar.gz -o php-7.4.6.tar.gz
tar xf /opt/lnmp/php-7.4.6.tar.gz -C /usr/src/ && cd /usr/src/php-7.4.6/
./configure --prefix=/opt/php --with-curl --enable-gd --with-gettext --with-iconv-dir --with-kerberos --with-libdir=lib64  --with-mysqli --with-openssl --with-pdo-mysql --disable-ipv6 --with-pear --with-xmlrpc --with-xsl --with-zlib --with-bz2 --with-mhash --enable-fpm --enable-bcmath --enable-inline-optimization  --enable-mbregex --enable-mbstring --enable-opcache --enable-pcntl --enable-shmop --enable-soap --enable-sockets --enable-sysvsem --enable-sysvshm --enable-xml
make -j4 && make install

mkdir -p /opt/php/var/session
mkdir -p /opt/php/log/
ln -s /opt/php/bin/php /usr/bin/php
echo 'export PATH="/opt/php/bin:$PATH"'>>/etc/profile
source /etc/profile

curl -sS https://getcomposer.org/installer | php
aria2c -c -x16 -s20 -j20 --conf-path=/etc/aria2.conf https://getcomposer.org/installer -o composer_installer
php /opt/lnmp/composer_installer
mv composer.phar /usr/local/bin/composer
chmod a+x /usr/local/bin/composer

\cp -rf /usr/src/php-7.4.6/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod u+x /etc/init.d/php-fpm
chkconfig --add /etc/init.d/php-fpm
chkconfig php-fpm on
\cp -rf /opt/php/etc/php-fpm.conf.default /opt/php/etc/php-fpm.conf
\cp -rf /opt/php/etc/php-fpm.d/www.conf.default /opt/php/etc/php-fpm.d/www.conf


aria2c -c -x16 -s20 -j20 --conf-path=/etc/aria2.conf http://pecl.php.net/get/swoole-4.5.2.tgz -o swoole-4.5.2.tgz
tar xf /opt/lnmp/swoole-4.5.2.tgz -C /usr/src/ && cd /usr/src/swoole-4.5.2/
/opt/php/bin/phpize
./configure --with-php-config=/opt/php/bin/php-config --enable-openssl --disable-http2 --disable-sockets --enable-mysqlnd
make -j4 && make install
echo 'extension="swoole.so"' >>/opt/php/lib/php.ini

aria2c -c -x16 -s20 -j20 --conf-path=/etc/aria2.conf http://pecl.php.net/get/redis-5.2.2.tgz -o redis-5.2.2.tgz
tar xf /opt/lnmp/redis-5.2.2.tgz -C /usr/src/ && cd /usr/src/redis-5.2.2/
/opt/php/bin/phpize
./configure --with-php-config=/opt/php/bin/php-config
make -j4 && make install
echo 'extension="redis.so"' >>/opt/php/lib/php.ini

groupadd www-data
useradd -g www-data www-data

rm -rf /opt/lnmp /usr/src/openresty-1.15.8.3/  /usr/src/php-7.4.6/ /usr/src/swoole-4.5.2/ /usr/src/redis-5.2.2/

#service php-fpm start
#service openresty start
