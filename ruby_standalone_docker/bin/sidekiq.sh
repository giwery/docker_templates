#!/bin/sh

bundle exec sidekiq -C config/sidekiq.yml -e $RAILS_ENV
