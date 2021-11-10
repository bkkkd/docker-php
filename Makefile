build:
	docker build -t docker-php .

run: build
	docker run --rm -p 18080:80 docker-php

shell: build
	docker run --rm -ti -p 18080:80 docker-php bash
