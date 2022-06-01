#!/usr/bin/env sh

# This script is part of Custom Desktop Builder.
# Copyright (C) 2022  Natan Junges <natanajunges@gmail.com>
#
# Custom Desktop Builder is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# Custom Desktop Builder is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Custom Desktop Builder.  If not, see <https://www.gnu.org/licenses/>.

set -e
rm ./round-*-step-*-full
cat ./round-*-step-*-diff | tr -d "#" | sort -u > ./finish-checked

if [ "$1" = "--full" ]; then
    LC_ALL=POSIX apt-cache depends ubuntu-desktop | grep "\(Depends\|Recommends\):" | sed "s/^  Depends: //; s/^  Recommends: /*/" | sort > ./finish-total
else
    LC_ALL=POSIX apt-cache depends ubuntu-desktop-minimal | grep "\(Depends\|Recommends\):" | sed "s/^  Depends: //; s/^  Recommends: /*/" | sort > ./finish-total
fi

diff ./finish-checked ./finish-total | grep "^> " | sed "s/^> /#/" > ./finish-diff
rm ./finish-checked ./finish-total

tee ./finish-add << EOF
*firefox
*flatpak
gnome-session
*gnome-software
EOF

if [ "$1" = "--full" ]; then
    tee -a ./finish-add << EOF
custom-desktop-minimal
*qbittorrent
*vlc
EOF
fi

cat ./round-*-step-*-diff ./finish-diff | grep "^#" | tr -d "#" | sort > ./finish-remove
cat ./round-*-step-*-diff ./finish-add | grep "^[^#]" | sort -u > ./finish-keep
rm ./finish-diff ./finish-add
nano ./finish-remove

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
Version: 22.04.0.1
Maintainer: Natan Junges <natanajunges@gmail.com>
EOF

echo "Depends: $(grep "^[^*]" ./finish-keep | sed ":a; $!N; s/\n/, /; ta")" >> ./control
echo "Recommends: $(grep "^*" ./finish-keep | tr -d "*" | sed ":a; $!N; s/\n/, /; ta")" >> ./control
echo "Suggests: $(grep "^[^#]" ./finish-remove | sed ":a; $!N; s/\n/, /; ta")" >> ./control
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
