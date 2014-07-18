all: compile

include mk/debug.mk

watchman.mk-dirs := src test/browser
watchman.mk-pattern := '*.coffee' '*.html' '*.json' '*.txt' '*.css'
include mk/watchman.mk

OPTS :=

.PHONY: test
test: node_modules bower_components compile
	$(MAKE) -C test test $(OPTS)

.PHONY: compile
compile:
	$(MAKE) -C src/lib compile
	$(MAKE) -C src/app compile
	$(MAKE) -C src copy
#	$(MAKE) -C test compile

.PHONY: depend
depend:
	$(MAKE) -C src/lib depend
	$(MAKE) -C src/app depend
#	$(MAKE) -C test depend

node_modules: package.json
	npm install
	touch $@

bower_components: bower.json
	bower install
	touch $@


.PHONY: clean
clean:
	$(MAKE) -C src/lib clean
	$(MAKE) -C src/app clean
	$(MAKE) -C src clean
#	$(MAKE) -C test clean


.PHONY: clobber
clobber: clean
	rm -rf node_modules bower_components

.PHONY: http
http:
	-node_modules/.bin/http-server -a 127.0.0.1 -p 8080

.PHONY: watch
watch: watchman.mk-watch
