bin := node_modules/.bin

build:
	$(bin)/webpack --optimize-minimize --optimize-dedupe

start: watch

watch:
	$(bin)/webpack-dev-server --port 4321 --hot

.PHONY: watch build start
