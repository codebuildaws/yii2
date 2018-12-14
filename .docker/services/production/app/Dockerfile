FROM ubuntu:14.04
COPY ./.ssh /root/.ssh
COPY ./01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc

RUN locale-gen en_US.UTF-8 && chown -R root:root /root/.ssh && chmod 600 /root/.ssh/id_rsa && chmod 644 /root/.ssh/id_rsa.pub

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV TERM xterm
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update && apt-get install -y ca-certificates wget curl git software-properties-common python-software-properties mc libossp-uuid-perl

ENV EDITOR /usr/bin/mcedit

# Install nodejs and npm
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - && apt-get install -y nodejs

# Install tools
RUN npm install -g stylus && npm install --unsafe-perm -g minifier && npm install -g less && npm install -g gulp && npm install -g supervisor

# Install ruby and sass
RUN apt-get install -y ruby && gem install sass -v 3.4.25

# Add repositories
RUN add-apt-repository -y ppa:ondrej/nginx-mainline && add-apt-repository -y ppa:ondrej/php && apt-get update

# Install PHP
RUN apt-get install -y php7.1 php7.1-bcmath php7.1-bz2 php7.1-cli php7.1-common php7.1-curl php7.1-dev php7.1-fpm \
    && apt-get install -y php7.1-gd php7.1-intl php7.1-json php7.1-mbstring php7.1-mysql php7.1-opcache \
    && apt-get install -y php7.1-pgsql php7.1-readline php7.1-recode php7.1-soap php7.1-sqlite3 php7.1-xml \
    && apt-get install -y php7.1-xmlrpc php7.1-zip php-memcache php-igbinary php-redis

# Allow php-fpm execution as root
RUN sed -i 's/--daemonize /--daemonize -R /' /etc/init.d/php7.1-fpm

# Install composer & plugins
COPY ./.composer /root/.composer
RUN cd /bin; curl -sS https://getcomposer.org/installer | php && mv /bin/composer.phar /bin/composer
RUN composer global require "fxp/composer-asset-plugin:1.4.*"

# Install nginx
RUN apt-get install -y nginx nginx-extras
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

# Install supervisor
RUN apt-get install -y supervisor

#Install nightmare
RUN apt-get install -y libgtk2.0-0 libgconf2-dev libnss3 libasound2 libxtst-dev \
    && apt-get install -y libx11-xcb-dev libxss-dev xvfb
RUN apt-get install -y xorg openbox
RUN npm install --unsafe-perm -g xvfb
ENV DISPLAY :9.0

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

WORKDIR /app

EXPOSE 80 443 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/bin/bash"]

# Install application
RUN mkdir /app; mkdir /logs
RUN git clone git@github.com:codebuildaws/yii2.git /app && cd /app && git checkout master

# Install application dependencies and build necessary files
RUN cd /app/src && composer install --prefer-dist --optimize-autoloader
RUN cd /app/src/node-apps/websocket-proxy && npm install
RUN cd /app/src/node-apps/msgs-proxy && npm install
RUN cd /app/src/node-apps/msgs-proxy-lite && npm install
RUN cd /app/src/node-apps/nightmarejs && npm install

# Build number
RUN cd /app && echo "define('BUILD_NUMBER', '`git rev-parse HEAD`');" >> /app/src/common/config/constants.php
RUN cd /app && echo "define('YII_ACCEPTANCE_TEST', false);" >> /app/src/common/config/constants.php
RUN cd /app && echo "define('YII_BETA_TEST', false);" >> /app/src/common/config/constants.php

VOLUME /app/logs
