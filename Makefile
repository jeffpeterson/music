bin := node_modules/.bin

start: watch

build:
	$(bin)/webpack --optimize-minimize --optimize-dedupe

watch:
	$(bin)/webpack-dev-server --port 4321 --hot

.PHONY: watch build start
