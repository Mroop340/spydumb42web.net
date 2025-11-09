FROM php:8.2-apache

# تثبيت المكتبات المطلوبة
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpng-dev libonig-dev libxml2-dev libpq-dev \
    && docker-php-ext-install pdo_pgsql mbstring exif pcntl bcmath gd

# تثبيت Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# نسخ ملفات المشروع
COPY . /var/www/html
WORKDIR /var/www/html

# تثبيت الاعتمادات
RUN composer install --optimize-autoloader --no-dev

# ضبط DocumentRoot إلى مجلد public
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# تفعيل mod_rewrite (مهم للـ Laravel)
RUN a2enmod rewrite

# ضبط صلاحيات الملفات
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

EXPOSE 80
