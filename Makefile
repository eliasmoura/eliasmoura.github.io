
prefix?=/srv/noobkotto/blog
BUILD_DIR=html
STATIC_DIR=${BUILD_DIR}/static

all: build_dir ${STATIC_DIR}/css/blog.css ${BUILD_DIR}/about.html

build_dir:
	@mkdir -p ${STATIC_DIR}/css
	@mkdir -p ${STATIC_DIR}/javascript
	@mkdir -p ${STATIC_DIR}/img

html/%.html: src/%.adoc
	asciidoc -o - > $@ -e -f asciidoc.conf -f html5.conf -f lang-en.conf $^

${STATIC_DIR}/css/%.css: less/%.less
	lessc $^ $@

install:
	mv html ${DESTDIR}/${prefix}/

clean:
	-rm -r ${BUILD_DIR}

.PHONY: all build_dir
