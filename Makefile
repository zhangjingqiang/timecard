.PHONY: run init_db exec_db stop

run: 
	docker compose up -d --build

init_db:
	docker compose exec api python manage.py create_db
	docker compose exec api python manage.py seed_db

exec_db:
	docker compose exec db psql --username=postgres --dbname=timecard

stop: 
	docker compose down