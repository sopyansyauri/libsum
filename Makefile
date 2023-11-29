

.PHONY: all
all: make_package compile

.PHONY: make_package
make_package: package_build package_library



.PHONY: package_build
package_build:
	mkdir -p build/

.PHONY: package_library
package_library:
	mkdir -p build/include
	mkdir -p build/lib
	mkdir -p build/src

.PHONY: compile
compile:
	cc -Wall -Wextra -Werror -pedantic -std=c11 -fPIC -shared -Wl,-soname,libsum.so.1 -o libsum.so.1.0 src/sum.c
	cc -Wall -Wextra -Werror -pedantic -std=c11 -c -o libsum.o src/sum.c
	ar rcs libsum.a libsum.o
	chmod 644 libsum.a
	rm -f libsum.o
	ln -sf libsum.so.1.0 libsum.so
	install -m 644 src/sum.c build/src
	install -m 644 src/sum.h build/include
	mv libsum.so.1.0 libsum.so libsum.a build/lib

.PHONY: install
install:
	mkdir -p /usr/local/src /usr/local/lib /usr/local/include 
	cp -R build/include build/lib build/src /usr/local
	ldconfig /usr/local/lib

.PHONY: uninstall
uninstall:
	rm -f /usr/local/include/sum.h
	rm -rf /usr/local/src/sum.c
	rm -f /usr/local/lib/libsum.so /usr/local/lib/libsum.so.1 /usr/local/lib/libsum.so.1.0 /usr/local/lib/libsum.a

.PHONY: clean
clean: uninstall
	rm -rf build

.PHONY: version
version:
	@echo 1.0
