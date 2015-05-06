bin := node_modules/.bin

start: watch

build:
	NODE_ENV=production $(bin)/webpack --config webpack.prod-config.js

test:
	@ag -lG js "//(.*->)" components lib | xargs $(bin)/babel-node test.js

test/%:
	$(bin)/babel-node test.js $*

watch:
	$(bin)/webpack-dev-server --port 4321 --hot --no-info --colors

.PHONY: watch build start
