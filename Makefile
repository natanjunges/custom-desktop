.PHONY: all custom-desktop-minimal custom-desktop ubuntu-system-adjustments clean

all: custom-desktop-minimal custom-desktop ubuntu-system-adjustments

custom-desktop-minimal:
	mkdir -p build/
	cd build/ && equivs-build ../custom-desktop-minimal

custom-desktop:
	mkdir -p build/
	cd build/ && equivs-build ../custom-desktop

ubuntu-system-adjustments:
	mkdir -p build/
	cd build/ && equivs-build ../ubuntu-system-adjustments

clean:
	rm -fr build/
