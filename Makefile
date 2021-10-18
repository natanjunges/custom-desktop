.PHONY: all clean

all: custom-desktop-minimal custom-desktop
	mkdir -p build/
	cd build/ && equivs-build ../custom-desktop-minimal
	cd build/ && equivs-build ../custom-desktop

clean:
	rm -fr build/
