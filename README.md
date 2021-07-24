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

## Terraform

```
$ cd terraform # staging or production
$ terraform init
$ terraform plan
$ terraform apply
```

## Logging

```
# docker build and push ...
# Staging
$ kustomize build ./k8s/logging/staging | kubectl apply -f -
# Production
$ kustomize build ./k8s/logging/production | kubectl apply -f -
```
