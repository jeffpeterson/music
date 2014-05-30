.RECIPEPREFIX   = >
bin             = ./node_modules/.bin
rootdir         = $(realpath .)

source_modules != $(bin)/browserify --list --transform es6ify source/scout.js
modules         = ${source_modules:$(rootdir)/source/%=%}
dev_modules     = ${modules:%=build/dev/%}
prod_modules    = ${modules:%=build/prod/%}

module_css      = $(patsubst %.js,%.css,$(filter components/%,$(modules)))
prod_module_css = $(module_css:%=build/prod/%)
dev_module_css  = $(module_css:%=build/dev/%)

# targets

all: $(prod_modules) $(prod_module_css)

component:
> @echo Component name? \\c; \
> read cname; \
> mkdir source/components/$$cname; \
> cat templates/Component/index.js   | sed -e "s/{name}/$$cname/g" > source/components/$$cname/index.js; \
> cat templates/Component/index.styl | sed -e "s/{name}/$$cname/g" > source/components/$$cname/index.styl

install:
> npm install

clean:
> rm -rf build/**


# file rules

# build/dev/scout.js: source/scout.js
# > @mkdir -p $(dir $@)
# > @cat $< | $(bin)/compile-modules --module-name $(mod_name) --stdio | sed -e "s/{files}/$$cname/g" > $@

# implicit rules

build/dev/%.js: mod_name = $(<:source/%=%)
build/dev/%.js: source/%.js
> @mkdir -p $(dir $@)
> @cat $< | $(bin)/compile-modules --module-name $(mod_name) --stdio > $@

build/dev/%.css: source/%.styl
> $(bin)/stylus < $< > $@

build/prod/%: build/dev/%
> @mkdir -p $(@D)
> @cp $? $@
> @echo making $(mod_name)

%/:
> @mkdir -p $^

# special rules

.PHONY: all component install clean
.SECONDARY: $(dev_modules) $(dev_module_css)
