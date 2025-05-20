# Use uma imagem oficial com PHP e FPM
FROM php:8.2-fpm

# Instale dependências do sistema e extensões PHP
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libpq-dev \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libmongoc-dev \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
    && docker-php-ext-install \
        pdo \
        pdo_pgsql \
        zip \
        bcmath \
        opcache

# Instale o Composer globalmente
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configure o diretório de trabalho (use caminho padrão)
WORKDIR /var/www/html

# Copie apenas os arquivos necessários inicialmente (para cache otimizado)
COPY composer.json composer.lock ./

# Instale dependências (ignorando extensões faltantes temporariamente)
RUN composer install --no-interaction --prefer-dist --optimize-autoloader --ignore-platform-reqs

# Copie o resto da aplicação
COPY . .

# Ajuste permissões
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 storage bootstrap/cache

# Porta de exposição
EXPOSE 8080

# Comando de inicialização
CMD ["sh", "-c", "php artisan migrate --force && php artisan queue:work --tries=3 --timeout=30 & php artisan serve --host=0.0.0.0 --port=8080"]