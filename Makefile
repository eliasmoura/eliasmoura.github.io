
prefix ?= /srv/noobkotto
DESTDIR ?= /#root dir
BUILD_DIR=html
STATIC_DIR=${BUILD_DIR}/static
BLOG=blog

JS=${STATIC_DIR}/javascript/asciidoc.js
CSS=${STATIC_DIR}/css/blog.css

all: build_dir ${CSS} ${JS} ${STATIC_DIR}/img/elias_portrait_20171206_14_44_18.jpg src/index.adoc ${BUILD_DIR}/about.html ${BUILD_DIR}/index.html

build_dir:
	@mkdir -p ${STATIC_DIR}/css
	@mkdir -p ${STATIC_DIR}/javascript
	@mkdir -p ${STATIC_DIR}/img

src/index.adoc:
	./tools/build_index.sh > src/index.adoc

${BUILD_DIR}/%.html: src/%.adoc
	asciidoc -o - > $@ -e -f asciidoc.conf -f html5.conf -f lang-en.conf -a website=http://www.noobkoto.com/ $^

${STATIC_DIR}/css/%.css: less/%.less
	lessc $^ $@

${STATIC_DIR}/javascript/%.js: javascript/%.ts
	tsc --outFile $@ $^

${STATIC_DIR}/img/%.jpg: img/%.jpg
	cp $^ $@

${STATIC_DIR}/img/%.png: img/%.png
	cp $^ $@

install:
	install -d $(DESTDIR)$(prefix)/${BLOG}
	install -d $(DESTDIR)$(prefix)/${BLOG}/static
	install -d $(DESTDIR)$(prefix)/${BLOG}/static/css
	install -d $(DESTDIR)$(prefix)/${BLOG}/static/javascript
	install -d $(DESTDIR)$(prefix)/${BLOG}/static/img
	install -m 0644 $(BUILD_DIR)/*.html $(DESTDIR)$(prefix)/$(BLOG)/
	install -m 0644 $(STATIC_DIR)/css/*.css $(DESTDIR)$(prefix)/$(BLOG)/static/css
	install -m 0644 $(STATIC_DIR)/javascript/*.js $(DESTDIR)$(prefix)/$(BLOG)/static/javascript
	install -m 0644 $(STATIC_DIR)/img/* $(DESTDIR)$(prefix)/$(BLOG)/static/img

clean:
	-rm -r ${BUILD_DIR}
	-rm src/index.adoc

.PHONY: all build_dir
