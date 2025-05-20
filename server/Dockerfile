# Use a imagem oficial do PHP com Alpine
FROM php:8.2-fpm-alpine

# 1. Instale dependências do sistema
RUN apk add --no-cache \
    git \
    curl \
    zip \
    unzip \
    postgresql-dev \
    libzip-dev \
    libxml2-dev \
    oniguruma-dev

# 2. Instale extensões PHP (removi MongoDB conforme solicitado)
RUN docker-php-ext-install \
    pdo \
    pdo_pgsql \
    zip \
    bcmath \
    opcache

# 3. Instale o Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 4. Configure diretório de trabalho
WORKDIR /var/www/html

# 5. Copie arquivos do composer primeiro (otimização de cache)
COPY composer.json composer.lock ./

# 6. Instale dependências (sem scripts)
RUN composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader --no-scripts --ignore-platform-reqs

# 7. Copie todo o código fonte
COPY . .

# 8. Execute scripts pós-instalação
RUN composer run-script post-autoload-dump

# 9. Ajuste permissões
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 storage bootstrap/cache

# 10. Exponha a porta
EXPOSE 8080

CMD sh -c "php artisan migrate --force && php artisan queue:work --tries=3 --timeout=30 & php artisan serve --host=0.0.0.0 --port=8080"