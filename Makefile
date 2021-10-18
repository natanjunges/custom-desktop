.PHONY: all custom-desktop-minimal custom-desktop clean

all: custom-desktop-minimal custom-desktop

custom-desktop-minimal:
	mkdir -p build/
	cd build/ && equivs-build ../custom-desktop-minimal

custom-desktop:
	mkdir -p build/
	cd build/ && equivs-build ../custom-desktop

clean:
	rm -fr build/
