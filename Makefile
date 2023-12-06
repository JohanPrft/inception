####		VARIABLES		####

LOGIN 	= 		jprofit
DOMAIN =		$(LOGIN).42.fr
COMPOSE =		docker compose
COMPOSE_PATH =	src/docker-compose.yaml
VOLUME_PATH =	/home/$(LOGIN)/data
SCRIPT_FOLDER =	script
ENV=			VOLUME_PATH=$(VOLUME_PATH) DOMAIN=${DOMAIN} LOGIN=$(LOGIN)

####		RULES		####

# Default rule
all: up

# Start the Docker Compose project
up: setup
	$(ENV) $(COMPOSE) -f $(COMPOSE_PATH) up -d

setup:
	sudo mkdir -p ${VOLUME_PATH}
	sudo mkdir -p ${VOLUME_PATH}/mariadb-data
	sudo mkdir -p ${VOLUME_PATH}/wordpress-data
	${ENV} $(SCRIPT_FOLDER)/configure_login.sh
	${ENV} $(SCRIPT_FOLDER)/configure_hosts.sh

# Builds, (re)creates, starts, and attaches to containers for a service
build:
	$(ENV) $(COMPOSE) -f $(COMPOSE_PATH) build

# Stops containers and removes containers, networks, volumes, and images created by up.
down:
	$(ENV) $(COMPOSE) -f $(COMPOSE_PATH) down

# Start the Docker Compose project (without detaching)
start:
	$(ENV) $(COMPOSE) -f $(COMPOSE_PATH) start

# Stop the Docker Compose project
stop:
	$(ENV) $(COMPOSE) -f $(COMPOSE_PATH) stop

# Also remove volumes
clean: down
	docker volume rm -f ${COMPOSE_PATH} src_mariadb-data src_wordpress-data
	docker network rm -f ${COMPOSE_PATH} src_network
	docker image rm -f ${COMPOSE_PATH} src-mariadb src-nginx src-wordpress
	sudo rm -rf ${VOLUME_PATH}

# Change login by anonymous
anonymize:
	${ENV} script/anonymize_login.sh

# Also remove images, volumes, networks
fclean: down
	docker system prune -a

logs:
	@echo "Logs nginx:"
	docker logs src-nginx-1
	@echo "Logs mariadb:"
	docker logs src-mariadb-1
	@echo "Logs wordpress:"
	docker logs src-wordpress-1

.PHONY: up setup down build start stop clean fclean logs
