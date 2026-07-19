# phpMyAdmin timepicker test stack

This stack starts phpMyAdmin from your local source tree and three database servers:

- MySQL 8.0 (`mysql80`)
- MySQL 8.4 (`mysql84`)
- MariaDB 11.4 (`mariadb114`)

## Start

```bash
docker compose -f docker-compose.timepicker.yml up -d --build
```

Open: <http://localhost:8080>

Login options:

- Server: `MySQL 8.0`, `MySQL 8.4`, or `MariaDB 11.4` from the drop-down
- Username: `root`
- Password: `root`

## Stop

```bash
docker compose -f docker-compose.timepicker.yml down
```

## Reset all DB data

```bash
docker compose -f docker-compose.timepicker.yml down -v
```

## Notes for timepicker work

- JS assets are built in the `phpmyadmin-dev` container on first start.
- If you edit files under `resources/js/`, rebuild assets:

```bash
docker compose -f docker-compose.timepicker.yml exec phpmyadmin-dev yarn run build
```

- If needed, force a clean rebuild of JS dependencies:

```bash
docker compose -f docker-compose.timepicker.yml exec phpmyadmin-dev rm -rf node_modules
docker compose -f docker-compose.timepicker.yml exec phpmyadmin-dev yarn install --frozen-lockfile
docker compose -f docker-compose.timepicker.yml exec phpmyadmin-dev yarn run build
```
