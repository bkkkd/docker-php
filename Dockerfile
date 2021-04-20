FROM ubuntu:focal

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y install wget tar supervisor net-tools fluxbox php7.4-bcmath php7.4-bz2 php7.4-cli php7.4-common php7.4-curl php7.4-fpm php7.4-gd php7.4-mbstring php7.4-mysql  php7.4-sqlite3 php7.4-zip php7.4-xml php7.4-opcache nginx && \
    php -r "copy('https://install.phpcomposer.com/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer && \
    apt-get -y full-upgrade && apt-get clean && rm -rf /var/lib/apt/lists/*
ADD supervisord-phpfpm.conf /etc/supervisor/conf.d/supervisord-phpfpm.conf


WORKDIR /root/

EXPOSE 80

CMD ["/usr/bin/supervisord"]
