bin := node_modules/.bin

build:
	find components -name '*.css' | xargs cat > bundle.css

watch:
	$(bin)/watchify index.js -t 6to5ify -vo bundle.js & $(bin)/barkeep --silent

.PHONY: watch build
