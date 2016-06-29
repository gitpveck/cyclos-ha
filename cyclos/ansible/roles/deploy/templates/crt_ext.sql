CREATE EXTENSION unaccent;
CREATE EXTENSION postgis;
CREATE EXTENSION cube;
CREATE EXTENSION earthdistance;
kubectl exec psql-2579651567-bx6sb -i --tty -- psql --host stolon-proxy-service cyclos --port 5432 -U stolon -W -c "CREATE EXTENSION unaccent"
kubectl exec psql-2579651567-bx6sb -i --tty -- psql --host stolon-proxy-service cyclos --port 5432 -U stolon -W -c "CREATE EXTENSION postgis"
kubectl exec psql-2579651567-bx6sb -i --tty -- psql --host stolon-proxy-service cyclos --port 5432 -U stolon -W -c "CREATE EXTENSION cube"
kubectl exec psql-2579651567-bx6sb -i --tty -- psql --host stolon-proxy-service cyclos --port 5432 -U stolon -W -c "CREATE EXTENSION earthdistance"
