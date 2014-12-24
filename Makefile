bin := node_modules/.bin

build:
	find components -name '*.css' | xargs -I{} cat {} | $(bin)/autoprefixer > bundle.css

watch:
	$(bin)/watchify index.js -t 6to5ify -vo bundle.js & $(bin)/barkeep -p 4321 --silent

.PHONY: watch build
