#!/usr/bin/env sh

set -e
sudo apt purge -y $(grep "#" | tr -d "#" | sed ":a; $!N; s/\n/ /; ta")
sudo apt autoremove --purge -y
