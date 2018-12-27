FROM php:7.1-fpm

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        zlib1g-dev libpng-dev gnupg libgmp-dev

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

RUN docker-php-ext-install mysqli pdo pdo_mysql zip gd bcmath gmp

RUN apt-get autoclean && rm -rf /var/lib/apt/lists/*

RUN echo 'expose_php = off' > /usr/local/etc/php/conf.d/hideheader.ini

RUN echo 'pm.max_children = 50' > /usr/local/etc/php-fpm.d/zz-max_children.conf

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --install-dir=/usr/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

CMD php-fpm
