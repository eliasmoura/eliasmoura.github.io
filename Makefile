
prefix ?= .
DESTDIR ?= /docs
BUILD_DIR=_html
STATIC_DIR=${BUILD_DIR}/$(BLOG)/static
BLOG=
WEBSITE=https://eliasmoura.github.io

JS=$(STATIC_DIR)/javascript/asciidoc.js
CSS=css/blog.css css/pygments.css
IMAGES=img/carro_projeto_robotica_2008.jpg \
			 img/elias_portrait_20171206_14_44_18.jpg
ASCIIDOC_CONFIG=-f asciidoc.conf -f html5.conf \
								-f filters/source/source-highlight-filter.conf -f lang-en.conf

ADOC_FILES = $(shell git ls-files src)
POSTS = $(shell ./tools/adoc_files.sh $(BUILD_DIR))

all: build_dir $(JS) $(IMAGES) all_img src/index.adoc src/archive.adoc $(POSTS) \
	$(BUILD_DIR)/$(BLOG)/archive.html $(BUILD_DIR)/$(BLOG)/index.html

build_dir:
	@mkdir -p $(STATIC_DIR)/javascript
	@mkdir -p $(STATIC_DIR)/img
	@mkdir -p $(STATIC_DIR)/img/galery/portugal_views

src/archive.adoc:
	./tools/build_archive.sh > src/blog/archive.adoc

src/index.adoc:
	./tools/build_index.sh > src/blog/index.adoc

$(BUILD_DIR)/%.html: $(ADOC_FILES)
	asciidoc -o - > $@ -e $(ASCIIDOC_CONFIG) -a website=$(WEBSITE) $<

$(STATIC_DIR)/javascript/%.js: javascript/%.ts
	tsc --outFile $@ $^

all_img:
	cp -R img/* $(STATIC_DIR)/img/

install: all
	#install -d $(prefix)/$(DESTDIR)/$(BLOG)
	#install -d $(prefix)/$(DESTDIR)/$(BLOG)/static
	#install -d $(prefix)/$(DESTDIR)/$(BLOG)/static/css
	#install -d $(prefix)/$(DESTDIR)/$(BLOG)/static/javascript
	#install -d $(prefix)/$(DESTDIR)/$(BLOG)/static/img
	#install -d $(prefix)/$(DESTDIR)/$(BLOG)/static/img/galery
	#install -v -d $(prefix)/$(DESTDIR)/$(BLOG)/static/img/galery/portugal_views
	#cp -r img/* "$(prefix)/$(DESTDIR)/$(BLOG)"/static/img
	#install -m 0644 $(BUILD_DIR)/$(BLOG)/**/** $(prefix)/$(DESTDIR)/$(BLOG)/
	#install -m 0644 $(BLOG)/$(STATIC_DIR)/javascript/*.js $(prefix)/$(DESTDIR)/$(BLOG)/static/javascript
	#install -m 0644 img/galery/portugal_views/* $(prefix)/$(DESTDIR)/$(BLOG)/static/img/galery/portugal_views
	#install -m 0644 $(BUILD_DIR)/$(BLOG) $(prefix)/$(DESTDIR)/
	#cp -r css/* "$(prefix)/$(DESTDIR)/$(BLOG)"/static/css
	cp -r _html/* $(prefix)/$(DESTDIR)/$(BLOG)/

clean:
	-rm -r $(BUILD_DIR)
	-rm src/archive.adoc src/index.adoc

.PHONY: all build_dir
