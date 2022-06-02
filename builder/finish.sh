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
rm -f ./build/round-*-step-*-full
cat ./build/round-*-step-*-diff | tr -d "#" | sort > ./build/finish-checked

if [ "$1" = --full ]; then
    LC_ALL=POSIX apt-cache depends ubuntu-desktop | grep "\(Depends\|Recommends\):" | sed "s/^  Depends: //; s/^  Recommends: /*/" | sort > ./build/finish-total
else
    LC_ALL=POSIX apt-cache depends ubuntu-desktop-minimal | grep "\(Depends\|Recommends\):" | sed "s/^  Depends: //; s/^  Recommends: /*/" | sort > ./build/finish-total
fi

diff ./build/finish-checked ./build/finish-total | grep "^> " | sed "s/^> /#/" > ./build/finish-diff
rm ./build/finish-checked ./build/finish-total

tee ./build/finish-add << EOF
*firefox
*flatpak
gnome-session
*gnome-software
EOF

if [ "$1" = --full ]; then
    tee -a ./build/finish-add << EOF
custom-desktop-minimal
*qbittorrent
*ubuntu-restricted-extras
EOF
fi

cat ./build/round-*-step-*-diff ./build/finish-diff | grep "^#" | tr -d "#" | sort > ./build/finish-remove
cat ./build/round-*-step-*-diff ./build/finish-add | grep "^[^#]" | sort > ./build/finish-keep
rm ./build/finish-diff ./build/finish-add
sed -i "s/^\(*snapd\|*transmission-gtk\|ubuntu-desktop-minimal\|ubuntu-session\)/#\1/" ./build/finish-remove
nano ./build/finish-remove

tee ./build/control << EOF
Section: metapackages
Priority: optional
Homepage: https://github.com/natanjunges/custom-desktop
Bugs: https://github.com/natanjunges/custom-desktop/issues
Standards-Version: 3.9.2
EOF

if [ "$1" = --full ]; then
    echo Package: custom-desktop >> ./build/control
else
    echo Package: custom-desktop-minimal >> ./build/control
fi

tee -a ./build/control << EOF
Version: 22.04.1.1
Maintainer: Natan Junges <natanajunges@gmail.com>
EOF

echo Depends: $(grep "^[^*]" ./build/finish-keep | sed ":a; $!N; s/\n/, /; ta") >> ./build/control
echo Recommends: $(grep "^*" ./build/finish-keep | tr -d "*" | sed ":a; $!N; s/\n/, /; ta") >> ./build/control
echo Suggests: $(grep "^[^#]" ./build/finish-remove | tr -d "*" | sed ":a; $!N; s/\n/, /; ta") >> ./build/control
echo Provides: packagekit-installer >> ./build/control

if [ "$1" = --full ]; then
    tee -a ./build/control << EOF
Task: ubuntu-desktop
Replaces: ubuntu-desktop
EOF
else
    tee -a ./build/control << EOF
Task: ubuntu-desktop-minimal, ubuntu-desktop
Replaces: ubuntu-desktop-minimal
EOF
fi

tee -a ./build/control << EOF
Copyright: ../LICENSE
Readme: ../README.md
EOF

if [ "$1" = --full ]; then
    tee -a ./build/control << EOF
Description: The custom Ubuntu desktop system
 This package depends on all of the packages in the custom Ubuntu desktop system.
EOF
else
    tee -a ./build/control << EOF
Description: The custom Ubuntu desktop minimal system
 This package depends on all of the packages in the custom Ubuntu desktop minimal system.
EOF
fi
