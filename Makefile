.DEFAULT_GOAL := all
DESTDIR ?= assets
INSTALL ?= /usr/bin/install
RM ?= /usr/bin/rm
LOCAL_UID = $(shell id -u)

# the base node:13.2 image is based off Debian stretch which does not take
# passing down parallel build arguments.
DOCKER_NODE_IMAGE := node:13.2-buster

ASSETS = assets/lunr.min.js

all: $(ASSETS)

# The image is NOT in this variable, to allow extra options to be passed.
# Mount the cache & config into the container for persistance
# Be sure to run as non-root so the output files have the correct owner
DOCKER_NODE_CMD = \
	docker run \
		--volume "${PWD}/npm_cache:/.npm" \
		--volume "${PWD}/npm_config:/.config" \
		--workdir '/mnt' \
		--user $(LOCAL_UID)

LUNR_SRC = lunr/Makefile lunr/VERSION $(wildcard lunr/src/*.js) lunr/package.json

# Deps first:
lunr/node_modules: lunr/package.json
lunr/lunr.min.js: lunr/node_modules
# Just because the directory exists does not mean it's done yet
.NO_PARALLEL: lunr/node_modules
# Then the command:
lunr/lunr.min.js lunr/node_modules: $(LUNR_SRC)
		$(DOCKER_NODE_CMD) \
		--volume "${PWD}/lunr:/mnt" \
		$(DOCKER_NODE_IMAGE) \
	    $(MAKE) $(MAKEFLAGS) $(notdir $@) \
		&& touch $@
# Output prep
assets/lunr.min.js: lunr/lunr.min.js
	$(INSTALL) --mode=0644 -D -p $^ $@

clean-lunr:
	# The clean target in lunr/Makefile also removes package.json
	# which is needed!
	$(RM) -r lunr/node_modules
	$(RM) lunr/docs
	$(RM) lunr/lunr.min.js
clean-output:
	$(RM) -r $(DESTDIR)

clean: clean-lunr clean-output

.PHONY: all clean clean-lunr clean-output
