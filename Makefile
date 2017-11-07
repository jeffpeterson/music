bin := node_modules/.bin

all: open watch

start: watch

open:
	open http://localhost:4321

build:
	NODE_ENV=production $(bin)/webpack --optimize-minimize --optimize-dedupe --config webpack.prod-config.js

watch:
	$(bin)/webpack-dev-server --port 4321 --colors --hot

.PHONY: watch build start
