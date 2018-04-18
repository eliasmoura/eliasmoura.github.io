
prefix ?= /srv/noobkotto
DESTDIR ?= /#root dir
BUILD_DIR=html
STATIC_DIR=${BUILD_DIR}/static
BLOG=blog

JS=$(STATIC_DIR)/javascript/asciidoc.js
CSS=$(STATIC_DIR)/css/blog.css $(STATIC_DIR)/css/pygments.css
IMAGES=$(STATIC_DIR)/img/carro_projeto_robotica_2008.jpg \
			 $(STATIC_DIR)/img/elias_portrait_20171206_14_44_18.jpg
ASCIIDOC_CONFIG=-f asciidoc.conf -f html5.conf \
								-f filters/source/source-highlight-filter.conf -f lang-en.conf

POSTS = $(shell ./tools/adoc_files.sh $(BUILD_DIR))

all: build_dir $(CSS) $(JS) $(IMAGES) all_img src/index.adoc src/archive.adoc $(POSTS) \
	$(BUILD_DIR)/archive.html $(BUILD_DIR)/index.html

build_dir:
	@mkdir -p $(STATIC_DIR)/css
	@mkdir -p $(STATIC_DIR)/javascript
	@mkdir -p $(STATIC_DIR)/img
	@mkdir -p $(STATIC_DIR)/img/galery/portugal_views

src/archive.adoc:
	./tools/build_archive.sh > src/archive.adoc

src/index.adoc:
	./tools/build_index.sh > src/index.adoc

$(BUILD_DIR)/%.html: src/%.adoc
	asciidoc -o - > $@ -e $(ASCIIDOC_CONFIG) -a website=http://www.noobkoto.com/ $^

${STATIC_DIR}/css/%.css: less/%.less
	lessc $^ $@

$(STATIC_DIR)/javascript/%.js: javascript/%.ts
	tsc --outFile $@ $^

$(STATIC_DIR)/img/%.jpg: img/%.jpg
	cp $^ $@

$(STATIC_DIR)/img/%.png: img/%.png
	cp $^ $@

all_img:
	cp -R img/* $(STATIC_DIR)/img/

install: all
	install -d $(DESTDIR)$(prefix)/$(BLOG)
	install -d $(DESTDIR)$(prefix)/$(BLOG)/static
	install -d $(DESTDIR)$(prefix)/$(BLOG)/static/css
	install -d $(DESTDIR)$(prefix)/$(BLOG)/static/javascript
	install -d $(DESTDIR)$(prefix)/$(BLOG)/static/img
	install -d $(DESTDIR)$(prefix)/$(BLOG)/static/img/galery
	install -v -d $(DESTDIR)$(prefix)/$(BLOG)/static/img/galery/portugal_views
	install -m 0644 $(BUILD_DIR)/*.html $(DESTDIR)$(prefix)/$(BLOG)/
	install -m 0644 $(STATIC_DIR)/css/*.css $(DESTDIR)$(prefix)/$(BLOG)/static/css
	install -m 0644 $(STATIC_DIR)/javascript/*.js $(DESTDIR)$(prefix)/$(BLOG)/static/javascript
	install -m 0644 $(STATIC_DIR)/img/galery/portugal_views/* $(DESTDIR)$(prefix)/$(BLOG)/static/img/galery/portugal_views
	install -m 0644 $(STATIC_DIR)/img/* $(DESTDIR)$(prefix)/$(BLOG)/static/img

clean:
	-rm -r $(BUILD_DIR)
	-rm src/archive.adoc src/index.adoc

.PHONY: all build_dir
