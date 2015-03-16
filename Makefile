bin := node_modules/.bin

start: watch

build:
	$(bin)/webpack --optimize-minimize --optimize-dedupe --config webpack.prod-config.js

watch:
	$(bin)/webpack-dev-server --port 4321 --hot --no-info --colors

.PHONY: watch build start
