.PHONY: run init_db exec_db stop

## run: run docker compose
run: 
	docker compose up -d --build

## init_db: initialize database
init_db:
	docker compose exec api python manage.py create_db
	docker compose exec api python manage.py seed_db

## exec_db: execute database
exec_db:
	docker compose exec db psql --username=postgres --dbname=timecard

## stop: stop docker compose
stop: 
	docker compose down

## help: displays help
help: Makefile
	@echo " Choose a command:"
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'