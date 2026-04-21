.PHONY: help build up down restart logs bash composer app/artisan migrate fresh install

CLI_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(sort $(subst :,\:,$(CLI_ARGS))):;@:)

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

init: ## Application Initialization
	[ -f ./.env ] || cp ./.env.example ./.env
	[ -f ./app/.env ] || cp ./app/.env.example ./app/.env
	make build
	make wait-db
	make up
	make composer
	make artisan key:generate
	make migrate
	make seed
	make artisan optimize:clear

build: ## Build Docker containers
	docker compose build

up: ## Start Docker containers
	docker compose up -d

down: ## Stop Docker containers
	docker compose down

restart: down up ## Restart Docker containers

logs: ## Show Docker logs
	docker compose logs -f

bash: ## Access app container shell
	docker compose exec -w /var/www/app app bash

composer: ## Run composer install
	docker compose exec -w /var/www/app app composer install

artisan: ## Run app/artisan command (usage: make app/artisan migrate)
	docker compose exec -w /var/www/app app php artisan $(CLI_ARGS)

migrate: ## Run database migrations
	docker compose exec -w /var/www/app app php artisan migrate

fresh: ## Fresh database with seeds
	docker compose exec -w /var/www/app app php artisan migrate:fresh --seed

wait-db: ## Wait for Postgres to be ready
	docker compose run --rm app /wait-for-postgres.sh

seed: ## Seeds database
	docker compose exec -w /var/www/app app php artisan db:seed

test: ## Run tests
	docker compose exec -w /var/www/app app php artisan test

clear-cache: ## Clear all caches
	docker compose exec -w /var/www/app app artisan cache:clear
	docker compose exec -w /var/www/app app artisan config:clear
	docker compose exec -w /var/www/app app artisan route:clear
	docker compose exec -w /var/www/app app artisan view:clear

redis-cli: ## Access Redis CLI
	docker compose exec redis redis-cli

check-git-lf: ## Check git LF (тут можно rector, fixer, php stan)
	git ls-files --eol -- . ':!:app/public/img' ':!:app/public/fonts' | grep --color=always -i '^i/[^lf|none]' && exit 1 || echo 'LF Ok'

check-composer: ## Check composer
	docker compose exec -w /var/www/app app composer validate --strict
	docker compose exec -w /var/www/app app composer audit --format=plain
	docker compose exec -w /var/www/app app composer normalize --dry-run

check: ## Check
	make check-git-lf
	make check-composer

pint: ## Make pint
	docker compose exec -w /var/www/app app php vendor/bin/pint
