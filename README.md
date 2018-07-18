## Шаблоны для запуска RoR/PHP приложений в docker/docker-swarm

Для запуска приложения вам нужно установить:

* [Docker](https://docs.docker.com/install/)
* [docker-compose](https://docs.docker.com/compose/install/)

## Traefik

Для проксирования приложения в мир мы используем [traefik](https://traefik.io/). Так же это удобный иструмент для получения и обновления SSL сертификатов.
Для запуска нужно создать файл `acme.json` в котором будут храниться сертификаты. Далее выполнить команду:

```
cd traefik && docker-compose up -d
```

## Подготовка приложения

В случаее с RoR приложением достаточно отредактировать файл database.yml чтобы параметры подключения брались с переменных окружения.

```
default: &default
  adapter: postgresql
  host: <%= ENV["POSTGRES_HOST"] %>
  port: <%= ENV["POSTGRES_PORT"] || 5432 %>
  user: <%= ENV["POSTGRES_USER"] %>
  database: <%= ENV["POSTGRES_DB"] %>
  password: <%= ENV["POSTGRES_PASSWORD"] %>
  pool: <%= ENV["DB_POOL"] || ENV["RAILS_MAX_THREADS"] || 5 %>
  encoding: unicode

development:
  <<: *default

test: &test
  <<: *default

production:
  <<: *default

staging:
  <<: *default
```

Для PHP приложения нужно в файле application/configs/base/application.ini указать переменные:

```
;Database

resources.db.adapter                               = "mysqli"
resources.db.params.host                           = MYSQL_HOST
resources.db.params.username                       = MYSQL_USER
resources.db.params.password                       = MYSQL_PASSWORD
resources.db.params.dbname                         = MYSQL_DATABASE
resources.db.params.charset                        = "utf8"
resources.db.isDefaultTableAdapter                 = true
```
И передать эти переменные из переменных окружения через файл index.php:

```
define('MYSQL_HOST', getenv('MYSQL_HOST'));
define('MYSQL_USER', getenv('MYSQL_USER'));
define('MYSQL_PASSWORD', getenv('MYSQL_PASSWORD'));
define('MYSQL_DATABASE', getenv('MYSQL_DATABASE'));
```

## Сборка контейнера приложения

Для того, чтобы собрать контейнер с приложеним достаточно поместить файл Dockerfile в корневую директорию приложения и выполнить команду:

```
docker build . -t REGESTRY/PROJECT_NAME
```

Далее нужно залогиниться на свой [registry](https://docs.docker.com/registry/):

```
docker login -u USER -p PASS REGISTRY_DOMAIN
```
Теперь отправляем собраный образ контейнера в registry:

```
docker push REGESTRY/PROJECT_NAME
```
## Docker swarm

Для запуска приложения в [docker swarm](https://docs.docker.com/engine/swarm/) изначально нужно добавить в окружение переменные из файла `.env`, для этого нужно выполнить команду:

```
set -a && source .env
```
Значение переменной `APP_ENV` должно быть `production` или `staging`. От этого зависит на каком сервере будет запущенно приложение.

Далее мы можем запустить [docker stack](https://docs.docker.com/get-started/part5/#introduction):

```
docker login -u USER -p PASS REGISTRY_DOMAIN
docker stack deploy -c docker-cloud.yml --prune --with-registry-auth $PROJECT_NAME
```
_NOTE: В swarm кластере не нужно запускать traefik._

## Standalone docker

Для запуска приложения на одном сервере с установленым докером нужно сначала запустить traefik, а далее выполнить команды:

```
docker login -u USER -p PASS REGISTRY_DOMAIN
docker-compose up -d
```

