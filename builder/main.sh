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

if ! which dialog > /dev/null; then
    echo "dialog required."
    exit 1
fi

op=$(dialog --stdout --title Operation --menu "Choose the desired operation:" 0 0 0 1 Initialize 2 "Execute rounds" 3 "Generate metapackage control file")
err=$?

if [ $err != 0 ]; then
    clear
    exit 2
fi

case $op in
    1)
        part=$(dialog --stdout --title "Initialize - Part" --menu "Choose the desired part:" 0 0 0 1 "Part 1" 2 "Part 2")
        err=$?

        if [ $err != 0 ]; then
            clear
            exit 3
        fi

        case $part in
            1)
                dialog --title "Initialize - Part 1 - Full Packages" --yesno "Install full packages?" 0 0
                err=$?
                clear

                if [ $err = 0 ]; then
                    ./init-1.sh --full || exit 4
                elif [ $err = 1 ]; then
                    ./init-1.sh || exit 5
                else
                    exit 6
                fi

                echo "Logout and login into the GNOME session"
            ;;
            2) clear; ./init-2.sh && echo "Restart your machine" || exit 7;;
        esac
    ;;
    2)
        while :; do
            round=$(($(ls -1 -t ./round-*-step-* 2> /dev/null | head -n 1 | sed "s|./round-||; s/-step-[1-5]//" || echo 0) + 1))
            step=0

            while :; do
                step=$((step + 1))

                if [ $step = 2 -a -f ./round-*-step-2 ]; then
                    step=3
                fi

                clear
                echo "Running round $round step $step..."
                read -p "Press Enter to continue or Ctrl+C to abort..." e
                "./step-$step.sh" > "./round-$round-step-$step" || exit 8

                if [ $step = 4 ]; then
                    echo "Running round $round step 5..."
                    read -p "Press Enter to continue or Ctrl+C to abort..." e
                    "./step-5.sh" > "./round-$round-step-5" || exit 9
                fi

                read -p "Press Enter to continue or Ctrl+C to abort..." e
                clear
                last_round=$(ls -1 -t "./round-"*"-step-$step" | head -n 2 | tail -n 1 | sed "s|./round-||; s/-step-$step//")

                if [ $last_round = $round ] || diff "./round-$last_round-step-$step" "./round-$round-step-$step" | grep -q "> "; then
                    nano "./round-$round-step-$step" || exit 10
                    echo "Purging packages from round $round step $step..."
                    read -p "Press Enter to continue or Ctrl+C to abort..." e
                    ./purge.sh < "./round-$round-step-$step" || exit 11
                    read -p "Press Enter to continue or Ctrl+C to abort..." e
                    break
                else
                    echo "Removing ./round-$round-step-$step..."
                    read -p "Press Enter to continue or Ctrl+C to abort..." e
                    rm "./round-$round-step-$step" || exit 12

                    if [ $step = 4 ]; then
                        echo "Removing ./round-$round-step-5..."
                        read -p "Press Enter to continue or Ctrl+C to abort..." e
                        rm "./round-$round-step-5" || exit 13
                        read -p "Press Enter to continue or Ctrl+C to abort..." e
                        break 2
                    fi

                    read -p "Press Enter to continue or Ctrl+C to abort..." e
                fi
            done
        done
    ;;
    3)
        dialog --title "Generate - Full Package" --yesno "Build full package?" 0 0
        err=$?
        clear

        if [ $err = 0 ]; then
            ./finish.sh --full || exit 14
        elif [ $err = 1 ]; then
            ./finish.sh || exit 15
        else
            exit 16
        fi
    ;;
esac
