FROM dunglas/frankenphp

# 1. Install Node.js (Required for pnpm and the Octane Watcher)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# 2. Install pnpm globally
RUN npm install -g pnpm

# 3. Install PHP Extensions
RUN install-php-extensions \
    pcntl \
    pdo_mysql \
    curl \
    mbstring \
    zip \
    xml \
    gd \
    intl \
    opcache \
    redis

# 4. Grab Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app

# 5. Copy pnpm files and install dependencies FIRST (Caches the node_modules layer)
# The asterisk (*) ensures the build doesn't crash if a pnpm-lock.yaml hasn't been generated yet
COPY package.json pnpm-lock.yaml* ./
RUN pnpm install

# 6. Copy Composer files and install dependencies NEXT (Caches the vendor layer)
COPY composer.json composer.lock ./
RUN composer install --no-interaction --prefer-dist --optimize-autoloader --no-dev --no-scripts

# 7. Copy the rest of the application code
COPY . .

# 8. Generate autoloader and fix permissions
RUN composer dump-autoload --optimize && \
    chown -R www-data:www-data /app/storage /app/bootstrap/cache

# 9. Set the base Octane command
ENTRYPOINT ["php", "artisan", "octane:frankenphp", "--host=0.0.0.0", "--port=80" , "--max-requests=500", "--workers=1"]
