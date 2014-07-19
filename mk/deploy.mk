# Deps:
#
# rsync
#
# Customization:
#
# deploy.mk-src
# deploy.mk-sf_user
# deploy.mk-cloud_web_dest

deploy.mk-where_am_i = $(lastword $(MAKEFILE_LIST))
deploy.mk-MK_LOCATION := $(realpath $(call deploy.mk-where_am_i))
deploy.mk-MK_DIR := $(dir $(deploy.mk-MK_LOCATION))

deploy.mk-src ?= $(deploy.mk-MK_DIR)/../app

.PHONY: deploy.mk-rsync
deploy.mk-rsync:
	rsync -avPL --delete -e ssh $(deploy.mk-src)/ \
		$(deploy.mk-sf_user)@web.sourceforge.net:/home/user-web/$(deploy.mk-sf_user)/htdocs/$(deploy.mk-cloud_web_dest)
