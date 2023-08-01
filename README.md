# Timecard

## Development

```
$ docker compose up -d --build
$ docker compose exec api python manage.py create_db
$ docker compose exec api python manage.py seed_db
$ docker compose exec db psql --username=postgres --dbname=timecard
```

## Kubernetes

```
$ kubectl create secret generic appkey --from-file [PATH_TO_DIRECTORY]
$ kubectl apply -k k8s
```

## Ansible

```
$ cd ansible
# Staging
$ ansible-playbook -i inventories/staging/hosts --extra-vars "foo=bar" --ask-vault-pass site.yml
# Production
$ ansible-playbook -i inventories/production/hosts --extra-vars "foo=bar" --ask-vault-pass site.yml
```

## Terraform

```
$ cd terraform
# Staging
$ cd staging
$ terraform init
$ terraform plan
$ terraform apply
# Production
$ cd production
$ terraform init
$ terraform plan
$ terraform apply
```

## Logging

```
# Staging
$ kustomize build ./k8s/logging/staging | kubectl apply -f -
# Production
$ kustomize build ./k8s/logging/production | kubectl apply -f -
```
