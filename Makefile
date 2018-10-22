IMAGE=docker-hakyll:v0.1

.PHONY: interact rebuild clean

rebuild:
	cabal run site rebuild

interact:
	docker run \
	  --interactive --tty --rm \
	  --volume "$(shell pwd):/home/docker/src/" \
	  --workdir "/home/docker/src/" \
	  $(IMAGE)

clean:
	rm -rf _site _cache
