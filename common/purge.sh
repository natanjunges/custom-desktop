#!/usr/bin/env sh

# This script is part of Custom Desktop.
# Copyright (C) 2022  Natan Junges <natanajunges@gmail.com>
#
# Custom Desktop is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# Custom Desktop is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Custom Desktop.  If not, see <https://www.gnu.org/licenses/>.

set -e
sudo apt purge -y $(grep "^#" | tr -d "#*" | sed ":a; $!N; s/\n/ /; ta")
sudo apt autoremove --purge -y
