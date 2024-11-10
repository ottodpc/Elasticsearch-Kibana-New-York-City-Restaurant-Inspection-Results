DOCKER_COMPOSE_FILE=./docker-compose.yml

##
## Docker
## -----
up: ## Monter les containers
up:
	docker-compose -f $(DOCKER_COMPOSE_FILE) up -d --build
 