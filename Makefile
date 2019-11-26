DESTDIR ?= assets
INSTALL ?= /usr/bin/install
RM ?= /usr/bin/rm

ASSETS = lunr/lunr.min.js


all: assets

assets: $(ASSETS)
	$(INSTALL) -t $(DESTDIR) -D -p $^
clean:
	$(RM) -f lunr/lunr.min.js
	$(RM) -rf $(DESTDIR)

.PHONY: all assets clean


lunr/lunr.min.js: lunr/Makefile
	$(MAKE) -C $(dir $<) node_modules
	$(MAKE) -C $(dir $<) $(notdir $@)
