all: build push clean

build:
	bundle exec middleman build
push:
	rsync -rv build/* jetfire.arsinh.com:~/www/
clean:
	rm -r build
