FROM postgres:9.5

ADD create-cyclosdb.sh /docker-entrypoint-initdb.d/

ADD pgpass /var/lib/pgsql/.pgpass

RUN chmod 600 /var/lib/pgsql/.pgpass
