DEV_COMPOSE  = compose.dev.yml
PROD_COMPOSE = compose.prod.yml

FRONTEND_IMAGE = frontend-final:latest

## ---------- Development ----------
dev: build-dev up-dev

build-dev:
	@docker compose -f $(DEV_COMPOSE) build

up-dev:
	@docker compose -f $(DEV_COMPOSE) up -d

down-dev:
	@docker compose -f $(DEV_COMPOSE) down

logs-dev:
	@docker compose -f $(DEV_COMPOSE) logs -f

node-dev:
	@docker compose -f $(DEV_COMPOSE) exec node sh

## ---------- Production ----------
prod: build-prod up-prod

build-prod:
	@echo "Building theme image: $(FRONTEND_IMAGE)"
	@docker build -f docker/node/Dockerfile -t $(FRONTEND_IMAGE) .

	@echo "Building wordpres image"
	@docker build -f docker/php-fpm/Dockerfile -t php-production:latest \
		--target production .

	@docker compose -f $(PROD_COMPOSE) build

up-prod:
	@docker compose -f $(PROD_COMPOSE) up -d --remove-orphans

down-prod:
	@docker compose -f $(PROD_COMPOSE) down

logs-prod:
	@docker compose -f $(PROD_COMPOSE) logs -f

## ---------- Utilities ----------
down: down-dev down-prod

.PHONY: dev build-dev up-dev node-dev logs-dev build-prod up-prod down-prod logs-prod
