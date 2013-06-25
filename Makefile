all: build push clean

build:
	bundle exec middleman build --verbose
push:
	rsync -rv build/* jetfire.arsinh.com:~/www/
clean:
	rm -r build
