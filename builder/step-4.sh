#!/usr/bin/env sh

set -e

for pkg in $(LC_ALL=POSIX apt-cache depends --no-recommends --installed ubuntu-desktop-minimal | grep Depends: | sed "s/  Depends: //"); do
    if [ $(apt-cache rdepends --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances --installed $pkg | wc -l) != 2 ]; then
        for p in $(LC_ALL=POSIX apt purge -s $pkg | grep Purg | sed "s/Purg //; s/ \[.*//"); do
            if [ $p != $pkg ] && (echo "firefox flatpak gnome-session gnome-software qbittorrent vlc" | grep -w -q $p || apt-cache rdepends $p | grep -q "^  ubuntu-desktop"); then
                continue 2
            fi
        done

        echo $pkg
    fi
done

echo

for pkg in $(LC_ALL=POSIX apt-cache depends --no-depends --installed ubuntu-desktop | grep Recommends: | sed "s/  Recommends: //"); do
    if [ $(apt-cache rdepends --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances --installed $pkg | wc -l) != 2 ]; then
        for p in $(LC_ALL=POSIX apt purge -s $pkg | grep Purg | sed "s/Purg //; s/ \[.*//"); do
            if [ $p != $pkg ] && (echo "firefox flatpak gnome-session gnome-software qbittorrent vlc" | grep -w -q $p || apt-cache rdepends $p | grep -q "^  ubuntu-desktop"); then
                continue 2
            fi
        done

        echo "*$pkg"
    fi
done
