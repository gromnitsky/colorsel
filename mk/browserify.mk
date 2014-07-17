# Deps:
#
# browserify
# coffee-inline-map
# uglify-js
# make-commonjs-depend (global)
#
# Customization:
#
# browserify.mk-out
# browserify.mk-wildcard
# BROWSERIFY_OPTS

browserify.mk-where_am_i = $(lastword $(MAKEFILE_LIST))
browserify.mk-MK_LOCATION := $(realpath $(call browserify.mk-where_am_i))
browserify.mk-MK_DIR := $(dir $(browserify.mk-MK_LOCATION))

NODE_ENV ?= development

BROWSERIFY := $(browserify.mk-MK_DIR)/../node_modules/.bin/browserify
UGLIFYJS := $(browserify.mk-MK_DIR)/../node_modules/.bin/uglifyjs
UGLIFYJS_OPTS := -c hoist_funs=false,join_vars=false,loops=false,unused=false

ifeq ($(NODE_ENV), development)
COFFEE := $(browserify.mk-MK_DIR)/../node_modules/.bin/coffee-inline-map
BROWSERIFY_OPTS ?= -d
# all bundles go here
browserify.mk-out ?= $(browserify.mk-MK_DIR)/../app.devel/js
else
COFFEE := $(browserify.mk-MK_DIR)/../node_modules/.bin/coffee
browserify.mk-out ?= $(browserify.mk-MK_DIR)/../app/js
BROWSERIFY_OPTS ?=
endif

browserify.mk-wildcard ?= *.coffee
browserify.mk-js := $(patsubst %.coffee,%.js,$(wildcard $(browserify.mk-wildcard)))

browserify.mk-bundles := $(addsuffix .browserify.js,$(basename $(browserify.mk-js)))
browserify.mk-bundles := $(addprefix $(browserify.mk-out)/,$(browserify.mk-bundles))

# gather again in case of browserify.mk-wildcard was set by user to a
# limited scope like 'test_*.coffee'
browserify.mk-js := $(patsubst %.coffee,%.js,$(wildcard *.coffee))

$(browserify.mk-out):
	mkdir -p $(browserify.mk-out)

.PHONY: browserify.mk-js
browserify.mk-js: $(browserify.mk-js)

.PHONY: browserify.mk-depend
browserify.mk-depend: $(browserify.mk-js)
	make-commonjs-depend $(browserify.mk-js) -o js.mk

-include js.mk

.PHONY: browserify.mk-compile
browserify.mk-compile: $(browserify.mk-out) $(browserify.mk-bundles)

%.js: %.coffee
ifeq ($(NODE_ENV), development)
	$(COFFEE) $< -o $@
else
	$(COFFEE) -c $<
endif

# bundles
$(browserify.mk-out)/%.browserify.js: %.js
ifeq ($(NODE_ENV), development)
	$(BROWSERIFY) $(BROWSERIFY_OPTS) $< -o $@
else
	$(BROWSERIFY) $(BROWSERIFY_OPTS) $< | $(UGLIFYJS) - $(UGLIFYJS_OPTS) -o $@
endif

.PHONY: browserify.mk-clean
browserify.mk-clean:
	rm -f $(browserify.mk-js) $(browserify.mk-bundles) js.mk
