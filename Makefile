
prefix?=/srv/noobkotto/blog
BUILD_DIR=html
STATIC_DIR=${BUILD_DIR}/static

JS=${STATIC_DIR}/javascript/asciidoc.js
CSS=${STATIC_DIR}/css/blog.css

all: build_dir ${CSS} ${JS} src/index.adoc ${BUILD_DIR}/about.html ${BUILD_DIR}/index.html

build_dir:
	@mkdir -p ${STATIC_DIR}/css
	@mkdir -p ${STATIC_DIR}/javascript
	@mkdir -p ${STATIC_DIR}/img

src/index.adoc:
	./tools/build_index.sh > src/index.adoc

html/%.html: src/%.adoc
	asciidoc -o - > $@ -e -f asciidoc.conf -f html5.conf -f lang-en.conf -a website=http://www.noobkoto.com/ $^

${STATIC_DIR}/css/%.css: less/%.less
	lessc $^ $@

${STATIC_DIR}/javascript/%.js: javascript/%.ts
	@tsc --outFile $@ $^

install:
	mv html ${DESTDIR}/${prefix}/

clean:
	-rm -r ${BUILD_DIR}

.PHONY: all build_dir
