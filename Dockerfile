# Use the official PHP image with FPM support
FROM php:8.2-fpm

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    git \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip pdo pdo_mysql

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www

# Copy application files into the container
COPY . .

# Set permissions for the application files and ensure write access to storage, cache, and logs
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache /var/www/storage/logs

# Install Laravel dependencies (will create the vendor directory)
RUN composer install --no-dev --optimize-autoloader

# Expose port 9000
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
