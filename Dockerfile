FROM php:5.6-apache
MAINTAINER adamwolak0501@gmail.com
#php config
COPY php.ini /usr/local/etc/php/php.ini
#install php ext
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
    libicu-dev \
     libxml2-dev \
     libpq-dev \
     libaio1 \
     libcurl4-gnutls-dev \
    vim \
        wget \
        unzip \
        git \
        curl \
    && docker-php-ext-install -j$(nproc) iconv gettext intl xml soap opcache pdo pdo_mysql mcrypt mysqli pdo_pgsql mbstring curl zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd
#RUN pecl install mcrypt-1.0.1
RUN docker-php-ext-enable mcrypt
RUN pecl install xdebug-2.5.5 && docker-php-ext-enable xdebug
RUN echo 'zend_extension="/usr/local/lib/php/extensions/no-debug-non-zts-20151012/xdebug.so"' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_port=9000' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_enable=1' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_connect_back=1' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_autostart=1' >> /usr/local/etc/php/php.ini
#INSTALL COMPOSER.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
#allow .htaccess
RUN a2enmod rewrite
#fix permission (why not?)
RUN usermod -u 1000 www-data
RUN usermod -G staff www-data
RUN ln -fs /usr/share/zoneinfo/Europe/Warsaw /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

