FROM ruby:2.3-jessie

RUN apt-get update && \
    apt-get install -qq -y netcat openssh-client build-essential apt-utils imagemagick libmagickwand-dev libcurl4-openssl-dev libssl-dev --fix-missing --no-install-recommends && \
    (curl -sS https://deb.nodesource.com/setup_8.x | bash -) && \
    (curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -) && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
    echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    (curl -sS https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -) && \
    apt-get update && apt-get install -y yarn nodejs libpq-dev postgresql-client-9.6 --no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV NODE_ENV staging
ENV RAILS_ENV staging
ENV RACK_ENV staging
ENV INSTALL_PATH /app

RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

COPY ./bin/wait-for.sh /bin/wait-for
RUN chmod 755 /bin/wait-for

COPY . .

RUN bundle install --without development test

EXPOSE 3000

ENTRYPOINT ./bin/entrypoint.sh
