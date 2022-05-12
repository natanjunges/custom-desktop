#!/usr/bin/env sh

set -e
for pkg in $(LC_ALL=POSIX apt-cache depends --no-recommends --installed ubuntu-desktop-minimal | grep Depends: | sed "s/  Depends: //"); do
    if [ $(apt-cache rdepends --no-pre-depends --no-depends --no-conflicts --no-breaks --no-replaces --no-enhances --installed $pkg | wc -l) != 2 ] && [ $(apt-cache rdepends --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances --installed $pkg | wc -l) = 2 ]; then
        echo $pkg
    fi
done

echo

for pkg in $(LC_ALL=POSIX apt-cache depends --no-depends --installed ubuntu-desktop | grep Recommends: | sed "s/  Recommends: //"); do
    if [ $(apt-cache rdepends --no-pre-depends --no-depends --no-conflicts --no-breaks --no-replaces --no-enhances --installed $pkg | wc -l) != 2 ] && [ $(apt-cache rdepends --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances --installed $pkg | wc -l) = 2 ]; then
        echo $pkg
    fi
done
