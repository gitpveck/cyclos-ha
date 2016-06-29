CREATE USER cyclos;
CREATE DATABASE cyclos;
GRANT ALL PRIVILEGES ON DATABASE cyclos TO cyclos;
ikubectl exec psql-2579651567-bx6sb -i --tty -- psql --host stolon-proxy-service postgres --port 5432 -U stolon -W -c "CREATE DATABASE cyclos"
kubectl exec psql-2579651567-bx6sb -i --tty -- psql --host stolon-proxy-service postgres --port 5432 -U stolon -W -c "CREATE ROLE cyclos WITH SUPERUSER PASSWORD 'cyclos'"
kubectl exec psql-2579651567-bx6sb -i --tty -- psql --host stolon-proxy-service postgres --port 5432 -U stolon -W -c "ALTER ROLE cyclos WITH LOGIN"
