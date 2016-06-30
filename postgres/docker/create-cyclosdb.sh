#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1  --host stolon-proxy-service postgres --port 5432 -U stolon <<-EOSQL
    password1
    CREATE ROLE cyclos WITH LOGIN SUPERUSER PASSWORD 'cyclos';
    CREATE DATABASE cyclos;
    GRANT ALL PRIVILEGES ON DATABASE cyclos TO cyclos;
    CREATE EXTENSION unaccent;
    CREATE EXTENSION postgis;
    CREATE EXTENSION cube;
    CREATE EXTENSION earthdistance;
EOSQL
