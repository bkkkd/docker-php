FROM ubuntu:focal

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y software-properties-common libzbar-dev zbar-tools imagemagick &&\
    add-apt-repository -y ppa:ondrej/php &&\
    apt-get -y install wget tar supervisor net-tools php5.6-bcmath php5.6-bz2 php5.6-cli php5.6-common php5.6-curl php5.6-fpm php5.6-gd php5.6-mbstring php5.6-mysql  php5.6-sqlite3 php5.6-zip php5.6-xml php5.6-opcache php5.6-dev php5.6-imagick  php5.6-redis nginx vim gnupg2 curl git cron p7zip-full zip&& \
    /usr/bin/ln -sf /usr/sbin/php-fpm5.6 /usr/sbin/php-fpm  && \
    php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer && \
    apt-get update && \
    apt-get -y full-upgrade && apt-get clean && rm -rf /var/lib/apt/lists/* &&\
    sed -i '/server_tokens off;/aclient_max_body_size 500m;\n' /etc/nginx/nginx.conf && \
    sed -i '/keepalive_timeout/ckeepalive_timeout 600;' /etc/nginx/nginx.conf &&\
    sed -i '/max_execution_time/cmax_execution_time=600' /etc/php/5.6/fpm/php.ini &&\
    sed -i '/max_input_time/cmax_input_time=600' /etc/php/5.6/fpm/php.ini &&\
    sed -i '/memory_limit/cmemory_limit=512M' /etc/php/5.6/fpm/php.ini &&\
    sed -i '/upload_max_filesize/cupload_max_filesize=512M' /etc/php/5.6/fpm/php.ini &&\
    sed -i '/post_max_size/cpost_max_size=512M' /etc/php/5.6/fpm/php.ini &&\
    sed -i '/max_execution_time/cmax_execution_time=600' /etc/php/5.6/cli/php.ini &&\
    sed -i '/max_input_time/cmax_input_time=600' /etc/php/5.6/cli/php.ini &&\
    sed -i '/memory_limit/cmemory_limit=512M' /etc/php/5.6/cli/php.ini &&\
    sed -i '/upload_max_filesize/cupload_max_filesize=512M' /etc/php/5.6/cli/php.ini &&\
    sed -i '/post_max_size/cpost_max_size=512M' /etc/php/5.6/cli/php.ini &&\
    mkdir -p /app/public && \
    echo "<?php phpinfo();" >/app/public/index.php && \
    chown www-data:www-data -R /app 
    
  
ADD supervisord-phpfpm.conf /etc/supervisor/conf.d/supervisord-phpfpm.conf
ADD nginx-default /etc/nginx/sites-available/default

WORKDIR /app

VOLUME ["/app"]

EXPOSE 80

CMD ["/usr/bin/supervisord"]
