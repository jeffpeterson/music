bin := node_modules/.bin

build:
	find components -name '*.css' | xargs cat > bundle.css

watch:
	$(bin)/watchify index.js -vo bundle.js & $(bin)/barkeep --silent

.PHONY: watch build
