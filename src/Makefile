include ../mk/debug.mk

NODE_ENV ?= development

ifeq ($(NODE_ENV), development)
out := ../app.devel
else
out := ../app
endif

html := $(patsubst %.html,$(out)/%.html,$(wildcard *.html))
json := $(patsubst %.json,$(out)/%.json,$(wildcard *.json))
css := $(patsubst %.css,$(out)/%.css,$(wildcard *.css))
txt := $(patsubst %.txt,$(out)/%.txt,$(wildcard *.txt))

.PHONY: copy
copy: $(html) $(json) $(css) $(txt)

$(out)/%.html: %.html
	cp $< $@

$(out)/%.json: %.json
	cp $< $@

$(out)/%.css: %.css
	cp $< $@

$(out)/%.txt: %.txt
	cp $< $@

.PHONY: clean
clean:
	rm -f $(html) $(json) $(css) $(txt)
