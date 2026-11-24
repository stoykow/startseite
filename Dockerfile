FROM php:8.3-apache

RUN docker-php-ext-install pdo_mysql \
    && install -d -o www-data -g www-data /var/www/html/assets/uploads/icons
