IMAGE=docker-hakyll:v0.1

.PHONY: deploy interact rebuild clean

rebuild:
	cabal run site rebuild

interact:
	docker run \
	  --interactive --tty --rm \
	  --volume "$(shell pwd):/home/docker/src/" \
	  --workdir "/home/docker/src/" \
	  $(IMAGE)

deploy: _site
	rsync -avh _site/ deploy@learn-emerald.org:/var/www/html/ --delete

clean:
	rm -rf _site _cache
