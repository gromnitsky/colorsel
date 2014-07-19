# Deps:
#
# coffee-inline-map
# make-commonjs-depend (global)

coffee.mk-where_am_i = $(lastword $(MAKEFILE_LIST))
coffee.mk-MK_LOCATION := $(realpath $(call coffee.mk-where_am_i))
coffee.mk-MK_DIR := $(dir $(coffee.mk-MK_LOCATION))

NODE_ENV ?= development

ifeq ($(NODE_ENV), development)
COFFEE := $(coffee.mk-MK_DIR)/../node_modules/.bin/coffee-inline-map
else
COFFEE := $(coffee.mk-MK_DIR)/../node_modules/.bin/coffee
endif

coffee.mk-js := $(patsubst %.coffee,%.js,$(wildcard *.coffee))

.PHONY: coffee.mk-compile
coffee.mk-compile: $(coffee.mk-js)

.PHONY: coffee.mk-depend
coffee.mk-depend: $(coffee.mk-js)
	make-commonjs-depend $(coffee.mk-js) -o js.mk

-include js.mk

%.js: %.coffee
ifeq ($(NODE_ENV), development)
	$(COFFEE) $< -o $@
else
	$(COFFEE) -c $<
endif

.PHONY: coffee.mk-clean
coffee.mk-clean:
	rm -f $(coffee.mk-js)
