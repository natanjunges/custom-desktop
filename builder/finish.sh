#!/usr/bin/env sh

set -e
cat ./round-*-step-* | tr -d "#" | sort -u > ./finish-checked

if [ "$1" = "--full" ]; then
    LC_ALL=POSIX apt-cache depends ubuntu-desktop | grep "  \(Depends\|Recommends\):" | sed "s/  Depends: //; s/  Recommends: /*/" | sort > ./finish-total
else
    LC_ALL=POSIX apt-cache depends ubuntu-desktop-minimal | grep "  \(Depends\|Recommends\):" | sed "s/  Depends: //; s/  Recommends: /*/" | sort > ./finish-total
fi

diff ./finish-checked ./finish-total | grep "> " | sed "s/> /#/" > ./finish-diff
rm ./finish-checked ./finish-total

tee ./finish-add << EOF
gnome-session
*firefox
*flatpak
*gnome-software
EOF

if [ "$1" = "--full" ]; then
    tee -a ./finish-add << EOF
custom-desktop-minimal
*qbittorrent
*vlc
EOF
fi

cat ./round-*-step-* ./finish-diff | grep "#" | tr -d "#" | sort > ./finish-remove
cat ./round-*-step-* ./finish-add | grep "^[^#]" | sort -u > ./finish-keep
rm ./finish-diff ./finish-add

tee ./control << EOF
Section: metapackages
Priority: optional
Homepage: https://github.com/natanjunges/custom-desktop
Bugs: https://github.com/natanjunges/custom-desktop/issues
Standards-Version: 3.9.2
EOF

if [ "$1" = "--full" ]; then
    echo "Package: custom-desktop" >> ./control
else
    echo "Package: custom-desktop-minimal" >> ./control
fi

tee -a ./control << EOF
Version: 22.04.0
Maintainer: Natan Junges <natanajunges@gmail.com>
EOF

echo "Depends: $(grep "^[^*]" ./finish-keep | sed ":a; $!N; s/\n/, /; ta")" >> ./control
echo "Recommends: $(grep "*" ./finish-keep | tr -d "*" | sed ":a; $!N; s/\n/, /; ta")" >> ./control
echo "Provides: packagekit-installer" >> ./control

if [ "$1" = "--full" ]; then
    tee -a ./control << EOF
Task: ubuntu-desktop
Replaces: ubuntu-desktop
EOF
else
    tee -a ./control << EOF
Task: ubuntu-desktop-minimal, ubuntu-desktop
Replaces: ubuntu-desktop-minimal
EOF
fi

tee -a ./control << EOF
Copyright: ../LICENSE
Readme: ../README.md
EOF

if [ "$1" = "--full" ]; then
    tee -a ./control << EOF
Description: The custom Ubuntu desktop system
 This package depends on all of the packages in the custom Ubuntu desktop system.
EOF
else
    tee -a ./control << EOF
Description: The custom Ubuntu desktop minimal system
 This package depends on all of the packages in the custom Ubuntu desktop minimal system.
EOF
fi
