SHELL  := /bin/bash
PATH   := ./node_modules/.bin:$(PATH)

.PHONY: clean test test-coverage build package.json javascript release example documentation

build:
	make clean
	make javascript
	make package.json
	make documentation

javascript: $(shell find src -name '*.js*' ! -name '*.test.js*')
	mkdir -p dist
	babel -d dist $^

package.json:
	node -p 'p=require("./package");p.private=undefined;p.scripts=p.devDependencies=undefined;JSON.stringify(p,null,2)' > dist/package.json

documentation: README.md LICENSE.md
	mkdir -p dist
	cp -r $^ dist

release:
	make build
	npm publish dist

release-support:
	make build
	npm publish dist --tag support

example:
	open example/index.html
	webpack -wd

clean:
	rm -rf dist

test:
	NODE_ENV=test karma start --single-run

test-watch:
	NODE_ENV=test karma start

test-coverage:
	make test
	coveralls < coverage/report-lcov/lcov.info
