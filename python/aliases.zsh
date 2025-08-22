#!/bin/zsh
alias nukedb="docker compose run --rm web dropdb -h postgres -U postgres db && docker compose run --rm web createdb -h postgres -U postgres db"
alias cover="coverage erase && coverage run setup.py test && coverage html"
