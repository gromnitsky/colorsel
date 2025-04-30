remote := alex@sigwait.org:/home/alex/public_html/demo/colorsel/
out := _out
src := $(wildcard *.js *.html *.txt) node_modules/chroma-js/dist/chroma.min.cjs
dest := $(addprefix $(out)/, $(src))

all: $(dest)
	rsync -Pa --delete $(out)/ $(remote) $(o)

$(dest): $(out)/%: %
	@mkdir -p $(dir $@)
	cp $< $@
