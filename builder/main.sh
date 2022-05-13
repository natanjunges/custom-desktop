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

op=$(dialog --stdout --title "Operation" --menu "Choose the desired operation:" 0 0 0 1 Initialize 2 "Execute round" 3 "Finish metapackage control file")
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
            ;;
            2) clear; ./init-2.sh || exit 7;;
        esac
    ;;
    2)
        round=$(dialog --stdout --title "Execute round - Current round" --inputbox "Round number:" 0 0 1)
        err=$?

        if [ $err != 0 ]; then
            clear
            exit 8
        fi

        while :; do
            step=$(dialog --stdout --title "Execute round - Round $round - Current step" --menu "Choose the desired step:" 0 0 0 1 "Step 1" 2 "Step 2" 3 "Step 3" 4 "Step 4" 5 "Step 5")
            err=$?

            if [ $err != 0 ]; then
                clear
                exit 9
            fi

            while :; do
                cmd=$(dialog --stdout --title "Execute round - Round $round - Step $step - Command" --menu "Choose the desired command:" 0 0 0 1 Run 2 diff 3 rm 4 Edit 5 Purge 6 Exit)
                err=$?

                if [ $err != 0 ]; then
                    clear
                    exit 10
                fi

                case $cmd in
                    1)
                        clear
                        echo "Running round $round step $step..."
                        "./step-$step.sh" > "./round-$round-step-$step" || exit 11
                    ;;
                    2)
                        last_round=$(dialog --stdout --title "Execute round - Round $round - Step $step - diff - Last round" --inputbox "Last round number:" 0 0 1)
                        err=$?
                        clear

                        if [ $err != 0 ]; then
                            exit 12
                        fi

                        diff "./round-$last_round-step-$step" "./round-$round-step-$step"
                        err=$?

                        if [ $err -gt 1 ]; then
                            exit 13
                        fi

                        read -p "Press Enter to continue..." e
                    ;;
                    3) rm "./round-$round-step-$step" || exit 14;;
                    4) nano "./round-$round-step-$step" || exit 15;;
                    5)
                        clear
                        echo "Purging packages from round $round step $step..."
                        ./purge.sh < "./round-$round-step-$step" || exit 16
                        read -p "Press Enter to continue..." e
                    ;;
                    6) break;;
                esac
            done
        done
    ;;
    3)
        dialog --title "Finish - Full Package" --yesno "Build full package?" 0 0
        err=$?
        clear

        if [ $err = 0 ]; then
            ./finish.sh --full || exit 17
        elif [ $err = 1 ]; then
            ./finish.sh || exit 18
        else
            exit 19
        fi
    ;;
esac
