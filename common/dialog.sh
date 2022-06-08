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

wait_confirm() {
    read -p "Press Enter to continue or Ctrl+C to abort..." e
}

dialog_title() {
    echo "$1" >&2
    echo -------- >&2
}

dialog_menu() {
    local opts=""
    echo "$1" >&2
    shift
    echo >&2

    while [ "$1" -a "$2" ]; do
        if [ "$opts" ]; then
            opts="$opts $1"
        else
            opts="$1"
        fi

        echo "[$1] $2" >&2
        shift 2
    done

    echo >&2
    read -p "? " opt

    if echo $opts | grep -q -w "$opt"; then
        echo $opt
        return 0
    else
        echo "Invalid option: $opt" >&2
        return 1
    fi
}

dialog_yesno() {
    read -p "$1 [y/N] " yn

    if [ "$yn" = y -o "$yn" = Y ]; then
        return 0
    else
        return 1
    fi
}
