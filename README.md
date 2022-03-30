# Custom Desktop
The Ubuntu custom desktop system.

It replaces the Ubuntu original desktop metapackages (`ubuntu-desktop-minimal` and `ubuntu-desktop`). **Keep in mind that they are also used to help ensure proper upgrades, so it is recommended that they not be removed. Only do this if you know what you are doing, and proceed at your own risk.**

## custom-desktop-minimal
These are the packages that are added to, removed from or replaced in the `custom-desktop-minimal` metapackage:

| ubuntu-desktop-minimal                     | custom-desktop-minimal        |
|--------------------------------------------|-------------------------------|
| ~~dmz-cursor-theme~~                       |                               |
| ~~gnome-accessibility-themes~~             |                               |
| ~~gnome-disk-utility~~                     |                               |
| ~~gnome-session-canberra~~                 |                               |
| ~~gnome-shell-extension-desktop-icons-ng~~ |                               |
| ~~gnome-shell-extension-ubuntu-dock~~      |                               |
| ~~gstreamer1.0-pulseaudio~~                |                               |
| ~~ibus-gtk~~                               |                               |
| ~~libu2f-udev~~                            |                               |
| ~~snap:firefox~~                           | firefox                       |
| ~~snap:snap-store~~                        | gnome-software                |
|                                            | gnome-software-plugin-flatpak |
| ~~snapd~~                                  | flatpak                       |
| ~~ubuntu-session~~                         | gnome-session                 |
| ~~xcursor-themes~~                         |                               |
| ~~xorg~~                                   |                               |
| ~~yaru-theme-gnome-shell~~                 |                               |
| ~~yaru-theme-gtk~~                         |                               |
| ~~yaru-theme-sound~~                       |                               |

`gnome-disk-utility` is moved to `custom-desktop`, as it is not considered minimal.

There are groups of packages that originally belonged to the `ubuntu-desktop-minimal` metapackage but are just suggested by `custom-desktop-minimal`. Their removal is optional, depending on whether or not they are necessary.

### Accessibility

| Function      | ubuntu-desktop-minimal |
|---------------|------------------------|
|               | at-spi2-core           |
|               | libatk-adaptor         |
| Braille       | brltty                 |
| Mouse         | mousetweaks            |
| Screen Reader | orca                   |
| Screen Reader | speech-dispatcher      |

### Avahi/NSS

| ubuntu-desktop-minimal |
|------------------------|
| avahi-autoipd          |
| avahi-daemon           |
| libnss-mdns            |

### Bluetooth

| Function | ubuntu-desktop-minimal      |
|----------|-----------------------------|
|          | bluez                       |
|          | gnome-bluetooth             |
|          | pulseaudio-module-bluetooth |
|          | rfkill                      |
| Printing | bluez-cups                  |

### Fingerprint

| ubuntu-desktop-minimal |
|------------------------|
| libpam-fprintd         |

### Gaming

| ubuntu-desktop-minimal |
|------------------------|
| gamemode               |

### Gnome Extras

| ubuntu-desktop-minimal |
|------------------------|
| gnome-characters       |
| gnome-font-viewer      |
| gnome-logs             |

### Language

| Function | ubuntu-desktop-minimal |
|----------|------------------------|
| Arabic   | fonts-kacst-one        |
| Burmese  | fonts-sil-padauk       |
| CJK      | fonts-noto-cjk         |
| Ethiopic | fonts-sil-abyssinica   |
| Indian   | fonts-indic            |
| Khmer    | fonts-khmeros-core     |
| Lao      | fonts-lao              |
| Sinhala  | fonts-lklug-sinhala    |
| Thai     | fonts-thai-tlwg        |
| Tibetan  | fonts-tibetan-machine  |

### Legacy Hardware

| ubuntu-desktop-minimal |
|------------------------|
| pcmciautils            |
| inputattach            |

### LibreOffice

| ubuntu-desktop-minimal |
|------------------------|
| fonts-opensymbol       |
| libwmf0.2-7-gtk        |

`fonts-opensymbol` and `libwmf0.2-7-gtk` are moved to `custom-desktop`, as they are used by LibreOffice.

### Miscellaneous

| ubuntu-desktop-minimal   |
|--------------------------|
| app-install-data-partner |
| bc                       |
| ghostscript-x            |
| gvfs-fuse                |
| ibus-table               |
| memtest86+               |
| nautilus-sendto          |
| nautilus-share           |

### Printing

| Function       | ubuntu-desktop-minimal      |
|----------------|-----------------------------|
|                | cups                        |
|                | cups-bsd                    |
|                | cups-client                 |
|                | cups-filters                |
| Bluetooth      | bluez-cups                  |
| Brother/Lenovo | printer-driver-brlaser      |
| Brother/Lenovo | printer-driver-ptouch       |
| Foomatic       | foomatic-db-compressed-ppds |
| HP             | hplip                       |
| HP             | printer-driver-pnm2ppa      |
| HP             | printer-driver-pxljr        |
| Kodak          | printer-driver-c2esp        |
| Konica Minolta | printer-driver-m2300w       |
| Konica Minolta | printer-driver-min12xxw     |
| PostScript     | openprinting-ppds           |
| Ricoh Aficio   | printer-driver-sag-gdi      |
| Samsung/Xerox  | printer-driver-splix        |
| ZjStream       | printer-driver-foo2zjs      |

### VM

| ubuntu-desktop-minimal |
|------------------------|
| spice-vdagent          |

### Wireless

| ubuntu-desktop-minimal |
|------------------------|
| rfkill                 |
| wireless-tools         |

## custom-desktop
These are the packages that are added to, removed from or replaced in the `custom-desktop` metapackage:

| ubuntu-desktop               | custom-desktop     |
|------------------------------|--------------------|
| fonts-opensymbol             | fonts-opensymbol   |
| gnome-disk-utility           | gnome-disk-utility |
| ~~libreoffice-ogltrans~~     |                    |
| ~~libreoffice-pdfimport~~    |                    |
| ~~libreoffice-style-breeze~~ |                    |
| libwmf0.2-7-gtk              | libwmf0.2-7-gtk    |
| ~~transmission-gtk~~         | qbittorrent        |
|                              | vlc                |

There are groups of packages that originally belonged to the `ubuntu-desktop` metapackage but are just suggested by `custom-desktop`. Their removal is optional, depending on whether or not they are necessary.

### Gaming

| ubuntu-desktop |
|----------------|
| aisleriot      |
| gnome-mahjongg |
| gnome-mines    |
| gnome-sudoku   |

### Gnome Extras

| ubuntu-desktop |
|----------------|
| cheese         |
| simple-scan    |

### Mail

| ubuntu-desktop            |
|---------------------------|
| thunderbird               |
| thunderbird-gnome-support |

### Miscellaneous

| ubuntu-desktop  |
|-----------------|
| branding-ubuntu |
| usb-creator-gtk |

### Remote Desktop

| ubuntu-desktop       |
|----------------------|
| gnome-remote-desktop |
| remmina              |

## How to use
### Install
Download the `.deb` files from the [releases page](https://github.com/natanjunges/custom-desktop/releases) or [build them](#Building) yourself. Then open the terminal in the path where the `.deb` files are.

Install `custom-desktop-minimal`:
```shell
sudo apt install ./custom-desktop-minimal_*_all.deb
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

Replace the favorites for `snap:firefox` and `snap:snap-store` with the ones for `firefox` and `gnome-software`, respectively:
```shell
gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/firefox_firefox/firefox/; s/snap-store_ubuntu-software/org.gnome.Software/")"
```

Log out and back in, but into the GNOME session instead of the Ubuntu one.

Change the icon and cursor themes to Yaru:
```shell
gsettings set org.gnome.desktop.interface icon-theme "Yaru"
gsettings set org.gnome.desktop.interface cursor-theme "Yaru"
```

Remove the packages that might have remained (you might also want to remove `fonts-opensymbol`, `gnome-disk-uility` and `libwmf0.2-7-gtk` if you only want the packages in the minimal set). If you want to remove any of the suggested packages, add them to the first command:
```shell
sudo apt purge dmz-cursor-theme gnome-accessibility-themes gnome-session-canberra gnome-shell-extension-desktop-icons-ng gnome-shell-extension-ubuntu-dock gstreamer1.0-pulseaudio ibus-gtk libreoffice-ogltrans libreoffice-pdfimport libreoffice-style-breeze libu2f-udev snapd transmission-gtk ubuntu-session xcursor-themes xorg yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-sound
sudo apt autoremove --purge
```

### Remove
Reinstall `ubuntu-desktop-minimal`:
```shell
sudo apt install ubuntu-desktop-minimal
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

If you wish to do so, reinstall `snap:snap-store` and `snap:firefox`:
```shell
sudo snap install snap-store firefox
```

Replace the favorites for `firefox` and `gnome-software` with the ones for `snap:firefox` and `snap:snap-store`, respectively:
```shell
gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/firefox/firefox_firefox/; s/org.gnome.Software/snap-store_ubuntu-software/")"
```

Log out and back in, but into the Ubuntu session instead of the GNOME one.

Remove the packages that might have remained. If you want to keep any of those packages, remove them from the first command and add them to the second:
```shell
sudo apt purge firefox flatpak gnome-session gnome-software gnome-software-plugin-flatpak qbittorrent vlc
sudo apt-mark manual <packages to keep> # It can be ommited if you do not want to keep any package
sudo apt autoremove --purge
```

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
