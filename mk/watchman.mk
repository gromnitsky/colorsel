# Non-universal & project dependent.
#
# Deps:
#
# watchman (global)

watchman.mk-where_am_i = $(lastword $(MAKEFILE_LIST))
watchman.mk-MK_LOCATION := $(realpath $(call watchman.mk-where_am_i))
watchman.mk-MK_DIR := $(dir $(watchman.mk-MK_LOCATION))

WATCHMAN_TRIGGER_CMD := $(watchman.mk-MK_DIR)/watchman-build.sh

watchman.mk-dirs ?= $(shell pwd)
watchman.mk-pattern ?= '*.coffee' '*.less'

.PHONY: watchman.mk-watch
watchman.mk-watch:
	-pkill watchman
	idx=0; \
	for dir in $(watchman.mk-dirs); do \
		watchman -n watch `realpath $$dir`; \
		watchman -n -- trigger `realpath $$dir` \
			asset-$$idx $(watchman.mk-pattern) \
			-X '*.#*' -- \
			$(WATCHMAN_TRIGGER_CMD) \
			-d $(watchman.mk-MK_DIR)/.. \
			-t `tty`; \
		idx=$$((idx + 1)); \
	done
