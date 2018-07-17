#!/bin/sh

rm -rf ./static/*
cp -R ./public/* ./static/

wait-for "${POSTGRES_HOST}:5432" -- bundle exec rake db:migrate
wait-for "${POSTGRES_HOST}:5432" -- bundle exec puma -C config/puma.rb

