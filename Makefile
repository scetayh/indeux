.PHONY: clean install uninstall reinstall

version = 0.1.0

indeux:
	cd lib/slibs && make install
	mkdir -p bin
	export PATH="${PATH}:/usr/local/lib/slibs" && cd src && ssc indeux-${version}.s.sh ../bin/indeux

clean:
	rm -rf bin/*

install:
	cp bin/indeux /usr/local/bin

uninstall:
	rm -rf /usr/local/bin/indeux

reinstall:
	make uninstall && make clean && make && make install