# Timecard

## Stack

- Kubernetes
- Kustomize
- AWS
- GCP
- Nginx
- Python
- Go
- React
- PostgreSQL
- Redis
- MongoDB
- RabbitMQ
- Elasticsearch
- Logstash
- Filebeat
- Docker
- Docker Compose
- Ansible
- Terraform

## Development

```
$ make run
$ make init_db
$ make exec_db
```

### Check data in Redis

```
$ docker exec -it timecard-redis-1 /bin/bash
# redis-cli -h 127.0.0.1 -p 6379 -a 12345
127.0.0.1:6379> KEYS *
127.0.0.1:6379> GET date
```

### Check data in MongoDB

```
$ docker exec -it timecard-mongodb-1 mongosh -u mongo -p 12345
test> show dbs
test> use timecard
switched to db timecard
timecard> show collections
timecard
timecard> db.timecard.find().pretty()
```

### Check data in Elasticsearch

```
$ docker exec -it timecard-elasticsearch-1 /bin/bash
$ curl -u elastic:12345 localhost:9200/timecard/_search
```

### Check data in RabbitMQ

```
$ docker exec -it timecard-rabbitmq-1 /bin/bash
# rabbitmqadmin list queues -u rabbitmquser -p 12345
# rabbitmqadmin get queue=timecard -u rabbitmquser -p 12345
```

## Kubernetes

```
$ kubectl create secret generic appkey --from-file [PATH_TO_DIRECTORY]
$ kubectl apply -k k8s/kustomize
```

## Logging

```
# Staging
$ kustomize build ./k8s/kustomize/logging/staging | kubectl apply -f -
# Production
$ kustomize build ./k8s/kustomize/logging/production | kubectl apply -f -
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
$ cd terraform/{aws|gcp}
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

## License

MIT
