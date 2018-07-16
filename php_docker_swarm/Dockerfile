FROM php:7.0-fpm

RUN apt-get update && apt-get install -y git libmagickwand-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*

COPY . /app

RUN chown www-data:www-data -R /app/public

RUN git clone https://github.com/Rademade/RM.git && mv RM /app/library \
&& git clone https://github.com/zendframework/zf1.git && mv zf1/library/Zend /app/library \
&& docker-php-ext-install -j$(nproc) mysqli gd \
&& pecl install imagick && docker-php-ext-enable imagick

WORKDIR /app

EXPOSE 9000

CMD ["php-fpm"]
