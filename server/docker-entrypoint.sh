#!/bin/sh
set -e

# 1. Executa migrações APENAS se a variável RUN_MIGRATIONS estiver definida como "true"
if [ "$RUN_MIGRATIONS" = "true" ]; then
    echo "Executando migrações..."
    php artisan migrate --force
else
    echo "RUN_MIGRATIONS não está definido como 'true'. Pulando migrações."
fi

# 2. Inicia o serviço principal (seu comando original)
echo "Iniciando aplicação..."
exec "$@"