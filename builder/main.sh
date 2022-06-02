#!/usr/bin/env sh

# Custom Desktop Builder, scripts to build the metapackages for Custom Desktop.
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

wait_prompt() {
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

clear
op=$(dialog_title Operation; dialog_menu "Choose the desired operation:" 1 Initialize 2 "Execute rounds" 3 "Generate metapackage control file")
err=$?
clear

if [ $err != 0 ]; then
    exit 1
fi

case $op in
    1)
        part=$(dialog_title "Initialize - Part"; dialog_menu "Choose the desired part:" 1 "Part 1" 2 "Part 2")
        err=$?
        clear

        if [ $err != 0 ]; then
            exit 2
        fi

        case $part in
            1)
                dialog_title "Initialize - Part 1 - Extra Packages"; dialog_yesno "Install extra packages?"
                err=$?
                clear
                dialog_title "Running initialization part 1..."

                if [ $err = 0 ]; then
                    ./init-1.sh --full || exit 3
                else
                    ./init-1.sh || exit 4
                fi

                echo Logout and login into the GNOME session
            ;;
            2) dialog_title "Running initialization part 2..."; ./init-2.sh && echo Restart your machine || exit 5;;
        esac
    ;;
    2)
        mkdir -p ./build/

        while :; do
            round=$(($(ls -1 -t ./build/round-*-step-*-full 2> /dev/null | head -n 1 | sed "s|^./build/round-||; s/-step-[1-4]-full\$//" || echo 0) + 1))
            step=0

            if [ -f ./build/round-*-step-2-full ]; then
                step=2
            fi

            while :; do
                step=$((step + 1))
                clear
                dialog_title "Running round $round step $step..."
                wait_prompt

                if [ $step -gt 2 ]; then
                    grep "^[^#]" ./build/round-*-step-2-diff | tr -d "*" | sed ":a; $!N; s/\n/ /; ta" | ./step-$step.sh > ./build/round-$round-step-$step-full || exit 6
                else
                    ./step-$step.sh > ./build/round-$round-step-$step-full || exit 7
                fi

                clear
                last_round=$(ls -1 -t ./build/round-*-step-$step-full | head -n 2 | tail -n 1 | sed "s|^./build/round-||; s/-step-$step-full\$//")

                if [ $last_round = $round ] || diff ./build/round-$last_round-step-$step-full ./build/round-$round-step-$step-full | grep -q "^> "; then
                    if [ $step = 4 ]; then
                        dialog_title "Running round $round step 5..."
                        wait_prompt
                        grep "^[^#]" ./build/round-*-step-2-diff | tr -d "*" | sed ":a; $!N; s/\n/ /; ta" | ./step-5.sh > ./build/round-$round-step-5-diff || exit 8
                        clear
                    fi

                    if [ $last_round = $round ]; then
                        cp ./build/round-$round-step-$step-full ./build/round-$round-step-$step-diff
                    else
                        diff ./build/round-$last_round-step-$step-full ./build/round-$round-step-$step-full | grep "^> " | sed "s/^> //" > ./build/round-$round-step-$step-diff
                    fi

                    nano ./build/round-$round-step-$step-diff || exit 9
                    dialog_title "Purging packages from round $round step $step..."
                    wait_prompt
                    ./purge.sh < ./build/round-$round-step-$step-diff || exit 10
                    break
                else
                    dialog_title "Removing ./build/round-$round-step-$step-full..."
                    wait_prompt
                    rm ./build/round-$round-step-$step-full || exit 11

                    if [ $step = 4 ]; then
                        break 2
                    fi
                fi
            done
        done
    ;;
    3)
        dialog_title "Generate - Full Package"; dialog_yesno "Build full package?"
        err=$?
        clear
        dialog_title "Generating control file..."

        if [ $err = 0 ]; then
            ./finish.sh --full || exit 12
        else
            ./finish.sh || exit 13
        fi
    ;;
esac
