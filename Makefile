DEV_COMPOSE  = compose.dev.yml
PROD_COMPOSE = compose.prod.yml

THEME_IMAGE = skin-theme-final:latest

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

workspace-dev:
	@docker compose -f $(DEV_COMPOSE) exec workspace bash

## ---------- Production ----------
prod: build-prod up-prod

build-prod:
	@echo "Building theme image: $(THEME_IMAGE)"
	@docker build -f docker/node/Dockerfile -t $(THEME_IMAGE) .
	@docker compose -f $(PROD_COMPOSE) build

up-prod:
	@docker compose -f $(PROD_COMPOSE) up -d --remove-orphans

down-prod:
	@docker compose -f $(PROD_COMPOSE) down

logs-prod:
	@docker compose -f $(PROD_COMPOSE) logs -f

## ---------- Utilities ----------
down: down-dev down-prod

.PHONY: dev build-dev up-dev workspace-dev logs-dev build-prod up-prod down-prod logs-prod
