DESTDIR ?= assets
INSTALL ?= /usr/bin/install
RM ?= /usr/bin/rm


ASSETS = lunr/lunr.min.js

lunr/lunr.min.js: lunr/Makefile
	$(MAKE) -C $(dir $<) node_modules
	$(MAKE) -C $(dir $<) $(notdir $@)


all: docker-assets
docker-assets:
	docker run --volume "${PWD}:/mnt" node make -C /mnt assets
assets: $(ASSETS)
	$(INSTALL) -t $(DESTDIR) -D -p $^
clean:
	$(RM) -f lunr/lunr.min.js
	$(RM) -rf $(DESTDIR)
.PHONY: all assets clean docker-assets
.DEFAULT_GOAL := all
