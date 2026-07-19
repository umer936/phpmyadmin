#!/usr/bin/env bash
set -euo pipefail

cd /var/www/html

if [ ! -f vendor/autoload.php ]; then
    composer install --no-interaction --prefer-dist
fi

if [ "${PMA_BUILD_ASSETS:-1}" = "1" ] && [ ! -x node_modules/.bin/webpack ]; then
    yarn install --frozen-lockfile
fi

if [ "${PMA_BUILD_ASSETS:-1}" = "1" ] && [ ! -f public/js/dist/datetimepicker.js ]; then
    yarn run build
fi

if [ ! -f config.inc.php ]; then
    BLOWFISH_SECRET="$(php -r 'echo bin2hex(random_bytes(16));')"
    cat > config.inc.php <<EOF
<?php
declare(strict_types=1);

\$cfg['blowfish_secret'] = '${BLOWFISH_SECRET}';

\$i = 0;

\$i++;
\$cfg['Servers'][\$i]['auth_type'] = 'cookie';
\$cfg['Servers'][\$i]['host'] = 'mysql80';
\$cfg['Servers'][\$i]['port'] = 3306;
\$cfg['Servers'][\$i]['verbose'] = 'MySQL 8.0';
\$cfg['Servers'][\$i]['compress'] = false;
\$cfg['Servers'][\$i]['AllowNoPassword'] = false;

\$i++;
\$cfg['Servers'][\$i]['auth_type'] = 'cookie';
\$cfg['Servers'][\$i]['host'] = 'mysql84';
\$cfg['Servers'][\$i]['port'] = 3306;
\$cfg['Servers'][\$i]['verbose'] = 'MySQL 8.4';
\$cfg['Servers'][\$i]['compress'] = false;
\$cfg['Servers'][\$i]['AllowNoPassword'] = false;

\$i++;
\$cfg['Servers'][\$i]['auth_type'] = 'cookie';
\$cfg['Servers'][\$i]['host'] = 'mariadb114';
\$cfg['Servers'][\$i]['port'] = 3306;
\$cfg['Servers'][\$i]['verbose'] = 'MariaDB 11.4';
\$cfg['Servers'][\$i]['compress'] = false;
\$cfg['Servers'][\$i]['AllowNoPassword'] = false;

// Force HTTP for local development
\$cfg['PmaAbsoluteUri'] = 'http://localhost:8080/public/';
EOF
fi

exec apache2-foreground
