# Timecard

## Local

```
$ docker-compose up -d --build
$ docker-compose exec api python manage.py create_db
$ docker-compose exec api python manage.py seed_db
$ docker-compose exec db psql --username=postgres --dbname=timecard
```

## Kubernetes

```
$ kubectl create secret generic appkey --from-file [PATH_TO_DIRECTORY]
$ kubectl apply -k k8s
```