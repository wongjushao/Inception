# Inception Makefile

include srcs/.env

COMPOSE_FILE = srcs/docker-compose.yml

all: up

build:
	@docker-compose -f $(COMPOSE_FILE) build

up:
	@mkdir -p $(DATA_PATH)/mysql $(DATA_PATH)/wordpress
	@docker-compose -f $(COMPOSE_FILE) up -d
	@echo "Access your site at: https://$(DOMAIN_NAME)"

start: build up

down:
	@docker-compose -f $(COMPOSE_FILE) down

clean:
	@docker-compose -f $(COMPOSE_FILE) down -v

fclean: clean
	@docker-compose -f $(COMPOSE_FILE) down -v --rmi all
	@rm -rf $(DATA_PATH)/mysql $(DATA_PATH)/wordpress

re: fclean all

status:
	@docker-compose -f $(COMPOSE_FILE) ps

logs:
	@docker-compose -f $(COMPOSE_FILE) logs -f

restart: down up

.PHONY: all build up start down clean fclean re status logs restart