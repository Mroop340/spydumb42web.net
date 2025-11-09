FROM php:8.2-apache

# ✅ تثبيت المكتبات المطلوبة
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpng-dev libonig-dev libxml2-dev libpq-dev libzip-dev \
    && docker-php-ext-install pdo_pgsql mbstring exif pcntl bcmath gd zip

# ✅ تثبيت Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# ✅ ضبط ServerName لتفادي تحذير Apache
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# ✅ نسخ ملفات المشروع
COPY . /var/www/html
WORKDIR /var/www/html

# ✅ تثبيت الاعتمادات (Composer)
RUN composer install --optimize-autoloader --no-dev

# ✅ ضبط DocumentRoot إلى مجلد public
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# ✅ تفعيل mod_rewrite (مهم للـ Laravel)
RUN a2enmod rewrite

# ✅ السماح لـ .htaccess بالعمل
RUN sed -i '/DocumentRoot \/var\/www\/html\/public/a <Directory /var/www/html/public>\n    AllowOverride All\n</Directory>' /etc/apache2/sites-available/000-default.conf

# ✅ ضبط صلاحيات الملفات
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

# ✅ أوامر Laravel (مهمة بعد نسخ الملفات)
RUN php artisan config:clear
RUN php artisan cache:clear
RUN php artisan config:cache
RUN php artisan route:cache


EXPOSE 80
