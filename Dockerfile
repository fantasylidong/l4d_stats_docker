FROM php:7.4.12-fpm-alpine


RUN apt-get update && \
    apt-get install -y git p7zip-full nano \
        wget \
    && \
    rm -rf /var/lib/apt/lists/*
    
RUN mkdir /usr/src/l4dstats/ && \
    git clone https://github.com/fantasylidong/l4dstatsweb.git /l4dstats/ && \
    mkdir /docker/

# Install Composer
#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN savedAptMark="$(apt-mark showmanual)" && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        libgmp-dev \
    && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure gmp && \
    docker-php-ext-install gmp mysqli pdo_mysql bcmath && \
    apt-mark auto '.*' > /dev/null && \
    apt-mark manual $savedAptMark && \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false
#RUN cd /l4dstats/ && composer install

COPY docker-l4dstats-entrypoint.sh /docker/docker-l4dstats-entrypoint.sh
COPY l4dstats.ini /usr/local/etc/php/conf.d/l4dstats.ini

RUN chmod +x /docker/docker-l4dstats-entrypoint.sh

ENTRYPOINT ["/docker/docker-l4dstats-entrypoint.sh"]
CMD ["apache2-foreground"]
