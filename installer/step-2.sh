#!/usr/bin/env sh

# This script is part of Custom Desktop Installer.
# Copyright (C) 2022  Natan Junges <natanajunges@gmail.com>
#
# Custom Desktop Installer is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# Custom Desktop Installer is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Custom Desktop Installer.  If not, see <https://www.gnu.org/licenses/>.

set -e

sudo tee /etc/dconf/profile/user << EOF
user-db:user
system-db:local
EOF

sudo mkdir /etc/dconf/db/local.d

sudo tee /etc/dconf/db/local.d/01-custom-desktop << EOF
[org/gnome/desktop/interface]
icon-theme='Yaru-blue'
cursor-theme='Yaru'
[org/gnome/shell]
favorite-apps=$(sudo gsettings get org.gnome.shell favorite-apps | sed "s/firefox_firefox/firefox/; s/snap-store_ubuntu-software/org.gnome.Software/")
EOF

sudo dconf update
