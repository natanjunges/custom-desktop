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

for pkg in $(LC_ALL=POSIX apt-cache depends --no-recommends --installed ubuntu-desktop-minimal | grep Depends: | sed "s/^  Depends: //"); do
    if [ $(apt-cache rdepends --no-conflicts --no-breaks --no-replaces --no-enhances --installed $pkg | wc -l) = 2 ]; then
        echo $pkg
    fi
done

echo

for pkg in $(LC_ALL=POSIX apt-cache depends --no-depends --installed ubuntu-desktop | grep Recommends: | sed "s/^  Recommends: //"); do
    if [ $(apt-cache rdepends --no-conflicts --no-breaks --no-replaces --no-enhances --installed $pkg | wc -l) = 2 ]; then
        echo "*$pkg"
    fi
done
