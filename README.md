# Custom Desktop
The Ubuntu custom desktop system.

It replaces the Ubuntu original metapackages (`ubuntu-desktop-minimal` and `ubuntu-desktop`). **Keep in mind that they are also used to help ensure proper upgrades, so it is recommended that they not be removed. Only do this if you know what you are doing, and proceed at your own risk.**

Those are the packages that are added, removed or replaced:
| ubuntu-desktop-minimal                     | custom-desktop-minimal        |
|--------------------------------------------|-------------------------------|
| ~~gnome-logs~~                             |                               |
| ~~gnome-power-manager~~                    |                               |
| ~~gnome-shell-extension-desktop-icons-ng~~ |                               |
| ~~gnome-shell-extension-ubuntu-dock~~      |                               |
| ~~snapd~~                                  | flatpak                       |
| ~~snap:snap-store~~                        | gnome-software                |
|                                            | gnome-software-plugin-flatpak |
| ~~snap:firefox~~                           | firefox                       |
| ~~ubuntu-session~~                         | gnome-session                 |
| ~~yaru-theme-gtk~~                         |                               |
| ~~yaru-theme-sound~~                       |                               |

| ubuntu-desktop                | custom-desktop |
|-------------------------------|----------------|
| ~~aisleriot~~                 |                |
| ~~cheese~~                    |                |
| ~~gnome-mahjongg~~            |                |
| ~~gnome-mines~~               |                |
| ~~gnome-sudoku~~              |                |
| ~~remmina~~                   |                |
| ~~simple-scan~~               |                |
| ~~thunderbird~~               |                |
| ~~thunderbird-gnome-support~~ |                |
| ~~transmission-gtk~~          | qbittorrent    |
| ~~usb-creator-gtk~~           |                |
|                               | vlc            |

All the removed packages that do not have a replacement are still suggested, but not installed by default. It suggests `balena-etcher-electron` instead of `usb-creator-gtk` (as a replacement), but as a PPA is required, it is not installed.

## How to use
### Install
Download the `.deb` files from the [releases page](https://github.com/natanjunges/custom-desktop/releases) or [build them](#Building) yourself. Then open the terminal in the path where the `.deb` files are.

Install `custom-desktop-minimal`:
```shell
sudo apt install ./custom-desktop-minimal_*_all.deb
```

Replace the favorites for `snap:firefox` and `snap:snap-store` with the ones for `firefox` and `gnome-software`, respectively:
```shell
gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/firefox_firefox/firefox/; s/snap-store_ubuntu-software/org.gnome.Software/")"
```

If you only want the packages in the minimal set, install `custom-desktop` without the recommends:
```shell
sudo apt install --no-install-recommends ./custom-desktop_*_all.deb
```

If you want all the packages instead, install `custom-desktop` with the recommends:
```shell
sudo apt install ./custom-desktop_*_all.deb
```

Now it's time to remove the Ubuntu original metapackages:
```shell
sudo apt purge ubuntu-desktop ubuntu-desktop-minimal
```

Remove the packages that might have remained. If you want to keep any of those packages, remove them from the first command and add them to the second:
```shell
sudo apt purge aisleriot cheese gnome-logs gnome-mahjongg gnome-mines gnome-power-manager gnome-shell-extension-desktop-icons-ng gnome-shell-extension-ubuntu-dock gnome-sudoku remmina simple-scan snapd thunderbird thunderbird-gnome-support transmission-gtk ubuntu-session usb-creator-gtk yaru-theme-gtk yaru-theme-sound
sudo apt-mark manual <packages to keep> # It can be ommited if you do not want to keep any package
sudo apt autoremove --purge
```

Log out and back in to load `gnome-session`.

Change the icon and cursor themes to Yaru:
```shell
gsettings set org.gnome.desktop.interface icon-theme "Yaru"
gsettings set org.gnome.desktop.interface cursor-theme "Yaru"
```

### Remove
Reinstall `ubuntu-desktop-minimal`:
```shell
sudo apt install ubuntu-desktop-minimal
```

If you wish to do so, reinstall `snap:snap-store` and `snap:firefox`:
```shell
sudo snap install snap-store firefox
```

Replace the favorites for `firefox` and `gnome-software` with the ones for `snap:firefox` and `snap:snap-store`, respectively:
```shell
gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/firefox/firefox_firefox/; s/org.gnome.Software/snap-store_ubuntu-software/")"
```

If you only want the packages in the minimal set, reinstall `ubuntu-desktop` without the recommends:
```shell
sudo apt install --no-install-recommends ubuntu-desktop
```

If you want all the packages instead, reinstall `ubuntu-desktop` with the recommends:
```shell
sudo apt install ubuntu-desktop
```

Now it's time to remove the custom metapackages:
```shell
sudo apt purge custom-desktop custom-desktop-minimal
```

Remove the packages that might have remained. If you want to keep any of those packages, remove them from the first command and add them to the second:
```shell
sudo apt purge firefox flatpak gnome-session gnome-software gnome-software-plugin-flatpak qbittorrent
sudo apt-mark manual <packages to keep> # It can be ommited if you do not want to keep any package
sudo apt autoremove --purge
```

Log out and back in to load `ubuntu-session`.

## Building
To build the metapackages you need to install `equivs`:
```shell
sudo apt install equivs
```

Build all the packages with:
```shell
make all
```

Or build a specific package with one of:
```shell
make custom-desktop-minimal
make custom-desktop
```
