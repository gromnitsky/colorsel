MOCHA := ../node_modules/.bin/mocha
OPTS :=

# it doesn't depend on compilation in browser/ dir
.PHONY: test
test:
	$(MOCHA) --compilers coffee:coffee-script/register \
		-u tdd test_*.coffee $(OPTS)

.PHONY: compile
compile:
	$(MAKE) -C browser compile

.PHONY: depend
depend:
	$(MAKE) -C browser depend

.PHONY: clean
clean:
	$(MAKE) -C browser clean
