init:
	make build
	docker-compose run backend bundle exec rails db:create
	docker-compose run backend bundle exec rails db:migrate
	docker-compose run backend bundle exec rails db:seed
build:
	docker-compose build
	make install
install:
	docker-compose run backend bundle install
	docker-compose run frontend npm install
up:
	docker-compose up
down:
	docker-compose down
stop:
	docker-compose stop
restart:
	docker-compose up
	docker-compose stop
back-bash:
	docker-compose exec backend bash
front-bash:
	docker-compose exec frontend bash
lint:
	docker-compose exec frontend npm run lint
lint-fix:
	docker-compose exec frontend npm run lint-fix
jest:
	docker-compose exec frontend npm run test

# 不要なイメージと使われていないvolumeを削除
clean:
	docker image prune
	docker volume prune

# database
db-create:
	docker-compose exec backend bundle exec rails db:create
db-drop:
	docker-compose exec backend bundle exec rails db:drop
db-migrate:
	docker-compose exec backend bundle exec rails db:migrate
db-seed:
	docker-compose exec backend bundle exec rails db:seed
db-reset:
	docker-compose exec backend bundle exec rails db:drop db:create db:migrate db:seed
db-migrate-reset:
	docker-compose exec backend bundle exec rails db:migrate:reset

# rails command
rc:
	docker-compose exec backend bundle exec rails console
rr:
	docker-compose exec backend bundle exec rails routes
rt:
	docker-compose exec backend bundle exec rspec
guard:
	docker-compose exec backend bundle exec guard
rubocop:
	docker-compose exec backend bundle exec rubocop
brakeman:
	docker-compose exec backend bundle exec brakeman
