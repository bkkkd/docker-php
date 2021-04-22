FROM ubuntu:focal

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y install wget tar supervisor net-tools fluxbox php7.4-bcmath php7.4-bz2 php7.4-cli php7.4-common php7.4-curl php7.4-fpm php7.4-gd php7.4-mbstring php7.4-mysql  php7.4-sqlite3 php7.4-zip php7.4-xml php7.4-opcache nginx vim gnupg2 curl && \
    php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer && \  
    curl -sSL https://packages.microsoft.com/config/ubuntu/20.04/prod.list | tee /etc/apt/sources.list.d/microsoft-prod.list &&\
    curl -sSL https://packages.microsoft.com/keys/microsoft.asc |  apt-key add - &&\
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools unixodbc-dev &&\
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc &&\
    apt-get -y full-upgrade && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN sed -i '/server_tokens off;/aclient_max_body_size 500m;\n' /etc/nginx/nginx.conf && \
    sed -i '/keepalive_timeout/ckeepalive_timeout 600;' /etc/nginx/nginx.conf &&\
    sed -i '/max_execution_time/cmax_execution_time=600' /etc/php/7.4/fpm/php.ini &&\
    sed -i '/max_input_time/cmax_input_time=600' /etc/php/7.4/fpm/php.ini &&\
    sed -i '/memory_limit/cmemory_limit=512M' /etc/php/7.4/fpm/php.ini &&\
    sed -i '/upload_max_filesize/cupload_max_filesize=512M' /etc/php/7.4/fpm/php.ini &&\
    sed -i '/post_max_size/cpost_max_size=512M' /etc/php/7.4/fpm/php.ini &&\
    sed -i '/max_execution_time/cmax_execution_time=600' /etc/php/7.4/cli/php.ini &&\
    sed -i '/max_input_time/cmax_input_time=600' /etc/php/7.4/cli/php.ini &&\
    sed -i '/memory_limit/cmemory_limit=512M' /etc/php/7.4/cli/php.ini &&\
    sed -i '/upload_max_filesize/cupload_max_filesize=512M' /etc/php/7.4/cli/php.ini &&\
    sed -i '/post_max_size/cpost_max_size=512M' /etc/php/7.4/cli/php.ini &&\
    mkdir -p /app/public && \
    echo "<?php phpinfo();" >/app/public/index.php && \
    chown www-data:www-data -R /app
  
ADD supervisord-phpfpm.conf /etc/supervisor/conf.d/supervisord-phpfpm.conf
ADD nginx-default /etc/nginx/sites-available/default

WORKDIR /app

VOLUME ["/app"]

EXPOSE 80

CMD ["/usr/bin/supervisord"]
