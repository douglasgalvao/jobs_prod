# Use a imagem oficial do PHP com Alpine
FROM php:8.2-fpm-alpine

# Instale dependências do sistema (etapa dividida para melhor cache)
RUN apk add --no-cache \
    git \
    curl \
    zip \
    unzip \
    postgresql-dev \
    libzip-dev \
    libxml2-dev \
    oniguruma-dev

# Dependências específicas para MongoDB (instaladas separadamente)
RUN apk add --no-cache --virtual .build-deps \
    autoconf \
    g++ \
    make \
    openssl-dev

# Instale extensão MongoDB via PECL
RUN pecl install mongodb \
    && docker-php-ext-enable mongodb \
    && apk del .build-deps

# Instale extensões PHP essenciais
RUN docker-php-ext-install \
    pdo \
    pdo_pgsql \
    zip \
    bcmath \
    opcache

# Instale o Composer globalmente
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Configure o diretório de trabalho
WORKDIR /var/www/html

# 1. Copie apenas os arquivos necessários para instalação inicial
COPY composer.json composer.lock ./

# 2. Instale dependências SEM executar scripts
RUN composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader --no-scripts --ignore-platform-reqs

# 3. Copie o resto da aplicação
COPY . .

# 4. Execute scripts pós-instalação
RUN composer run-script post-autoload-dump

# Ajuste permissões
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 storage bootstrap/cache

# Porta de exposição
EXPOSE 8080


RUN echo "Preparando para executar migrações..."

# Script de entrypoint para controle de migrações
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh


# Comando de inicialização
CMD ["sh", "-c", "php artisan migrate:fresh --force && php artisan queue:work --tries=3 --timeout=30 & php artisan serve --host=0.0.0.0 --port=8080"]