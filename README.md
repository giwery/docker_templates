## Шаблоны для запуска RoR/PHP приложений в docker/docker-swarm

Для запуска приложения вам нужно установить:

* [Docker](https://docs.docker.com/install/)
* [docker-compose](https://docs.docker.com/compose/install/)

## Traefik

Для проксирования приложения в мир мы используем [traefik](https://traefik.io/). Так же это удобный иструмент для получения и обновления SSL сертификатов.
Для запуска достаточно выполнить команды:

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

Далее нужно залогиниться на свой [regestry](https://docs.docker.com/registry/):

```
docker login -u USER -p PASS REGISTRY_DOMAIN
```
Теперь мы можем отправить собраный образ контейнера в ваш registry:

```
docker push REGESTRY/PROJECT_NAME
```
