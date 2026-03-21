.PHONY: help build up down restart logs clean deploy

help:		## Show this help message
	@echo "Usage: make [target]"
	@echo ""
	@echo "Available targets:"
	@sed -n 's/^##//p' $(MAKEFILE_LIST) | sed 's/:// /' | column -t -s ':'

## Build
build:		## Build Docker image
	docker build -t flowboard:latest .

build-nc:	## Build Docker image without cache
	docker build --no-cache -t flowboard:latest .

## Run
up:		## Start services with Docker Compose
	docker-compose up -d

up-logs:	## Start services and show logs
	docker-compose up

down:		## Stop and remove services
	docker-compose down

## Manage
restart:	## Restart services
	docker-compose restart

logs:		## Show logs
	docker-compose logs -f

logs-tail:	## Show last 50 log lines
	docker-compose logs --tail=50

## Maintenance
clean:		## Remove containers and volumes
	docker-compose down -v
	docker system prune -f

rebuild:	## Rebuild and restart services
	docker-compose down
	docker build -t flowboard:latest .
	docker-compose up -d

## Shell
shell:		## Open shell in container
	docker exec -it flowboard sh

## Utilities
ps:		## Show running containers
	docker ps | grep flowboard

status:		## Show container status
	docker inspect flowboard | jq -r '.[0].State.Status'

## Deployment
tag:		## Tag image for release
	docker tag flowboard:latest flowboard:v$(shell cat dashboard/package.json | jq -r .version)

push:		## Push image to registry
	@echo "Pushing to Docker Hub..."
	docker push yourusername/flowboard:latest

push-gh:		## Push image to GitHub Container Registry
	@echo "Pushing to GitHub Container Registry..."
	docker tag flowboard:latest ghcr.io/yourusername/flowboard:latest
	docker push ghcr.io/yourusername/flowboard:latest
