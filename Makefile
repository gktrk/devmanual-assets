all: docker-assets

DESTDIR ?= assets
INSTALL ?= /usr/bin/install
RM ?= /usr/bin/rm
DOCKER_IMAGE := node:13.2


ASSETS = lunr/lunr.min.js

lunr/lunr.min.js: lunr/lunr.js
	$(MAKE) -C $(dir $<) node_modules
	$(MAKE) -C $(dir $<) $(notdir $@)
lunr/lunr.js: lunr/Makefile
	$(MAKE) -C $(dir $<) $(notdir $@)

docker-assets:
	docker run --volume "${PWD}:/mnt" \
	    $(DOCKER_IMAGE) \
	    make -C /mnt assets
assets: $(ASSETS)
	$(INSTALL) -t $(DESTDIR) -D -p $^
clean:
	$(RM) -f lunr/lunr.min.js
	$(RM) -rf $(DESTDIR)
.PHONY: all assets clean docker-assets
