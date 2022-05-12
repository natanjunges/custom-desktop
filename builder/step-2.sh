#!/usr/bin/env sh

set -e
for pkg in $(LC_ALL=POSIX apt-cache depends --no-recommends --installed ubuntu-desktop-minimal | grep Depends: | sed "s/  Depends: //"); do
    if [ $(apt-cache rdepends --no-conflicts --no-breaks --no-replaces --no-enhances --installed $pkg | wc -l) != 2 ]; then
        sudo apt-mark auto $pkg > /dev/null
    fi
done

for pkg in $(LC_ALL=POSIX apt-cache depends --no-depends --installed ubuntu-desktop | grep Recommends: | sed "s/  Recommends: //"); do
    if [ $(apt-cache rdepends --no-conflicts --no-breaks --no-replaces --no-enhances --installed $pkg | wc -l) != 2 ]; then
        sudo apt-mark auto $pkg > /dev/null
    fi
done

for pkg in $(LC_ALL=POSIX apt autoremove -s | grep Remv | sed "s/Remv //; s/ \[.*//"); do
    if apt-cache rdepends $pkg | grep -q "^  ubuntu-desktop"; then
        sudo apt-mark manual $pkg > /dev/null
        echo $pkg
    fi
done
