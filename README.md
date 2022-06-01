# Custom Desktop
[Ler em português do Brasil](README-pt_BR.md).

The custom Ubuntu desktop system.  
Copyright (C) 2021, 2022  Natan Junges &lt;natanajunges@gmail.com&gt;

Custom Desktop is free software: you can redistribute it and/or modify  
it under the terms of the GNU General Public License as published by  
the Free Software Foundation, either version 3 of the License, or  
any later version.

Custom Desktop is distributed in the hope that it will be useful,  
but WITHOUT ANY WARRANTY; without even the implied warranty of  
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the  
GNU General Public License for more details.

You should have received a copy of the GNU General Public License  
along with Custom Desktop.  If not, see &lt;https://www.gnu.org/licenses/&gt;.

It replaces the Ubuntu 22.04 original desktop metapackages ([`ubuntu-desktop-minimal`](https://packages.ubuntu.com/jammy/ubuntu-desktop-minimal) and [`ubuntu-desktop`](https://packages.ubuntu.com/jammy/ubuntu-desktop)). **Keep in mind that they are also used to help ensure proper upgrades, so it is recommended that they not be removed**. **Only do this if you know what you are doing, and proceed at your own risk**. To avoid any problems, it is recommended to install them in a fresh Ubuntu 22.04 install.

## How to use
### Install
Download the `.deb` files from the [releases page](https://github.com/natanjunges/custom-desktop/releases) or [build them](#Building) yourself. Then open the terminal in the path where the `.deb` files are.

Download the `linuxmint-keyring` package and add the required keys:
```shell
wget http://packages.linuxmint.com/pool/main/l/linuxmint-keyring/linuxmint-keyring_2016.05.26_all.deb
sudo apt install ./linuxmint-keyring_*_all.deb
sudo apt-key del 451BBBF2
sudo mv /usr/share/keyrings/linuxmint-keyring.gpg /usr/share/keyrings/linuxmint-keyring
sudo gpg --dearmor /usr/share/keyrings/linuxmint-keyring
sudo rm /usr/share/keyrings/linuxmint-keyring
```

Add the main and upstream repositories from Linux Mint Una (they will be used to install `firefox`):
```shell
sudo tee /etc/apt/sources.list.d/mint-una.list << EOF
deb [signed-by=/usr/share/keyrings/linuxmint-keyring.gpg] http://packages.linuxmint.com una main
deb [signed-by=/usr/share/keyrings/linuxmint-keyring.gpg] http://packages.linuxmint.com una upstream
EOF
```

Pin the Linux Mint repositories so they are only used for `chromium` and `firefox` (those Ubuntu packages are transitionals to snaps):
```shell
sudo tee /etc/apt/preferences.d/pin-chromium-firefox << EOF
Package: *
Pin: release o=linuxmint
Pin-Priority: -1

Package: chromium
Pin: release o=linuxmint
Pin-Priority: 1000

Package: firefox
Pin: release o=linuxmint
Pin-Priority: 1000

Package: linuxmint-keyring
Pin: release o=linuxmint
Pin-Priority: 1000
EOF
```

Update the repositories for changes to take effect:
```shell
sudo apt update
```

Install the `ubuntu-system-adjustments` dummy package and mark it as automatic (it is a dependency of `firefox`):
```shell
sudo apt install ./ubuntu-system-adjustments_*-dummy_all.deb
sudo apt-mark auto ubuntu-system-adjustments
```

Install `custom-desktop-minimal`:
```shell
sudo apt install ./custom-desktop-minimal_*_all.deb gnome-software-plugin-flatpak gnome-software-plugin-snap-
sudo apt-mark auto gnome-software-plugin-flatpak
```

If you only want the packages in the minimal set, install `custom-desktop` without the recommends:
```shell
sudo apt install --no-install-recommends ./custom-desktop_*_all.deb
```

If you want all the packages instead, install `custom-desktop` with the recommends:
```shell
sudo apt install ./custom-desktop_*_all.deb
```

Now it is time to remove the Ubuntu original metapackages:
```shell
sudo apt purge ubuntu-desktop ubuntu-desktop-minimal
```

Add the Flathub repository to flatpak:
```shell
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

Log out and back in, but into the GNOME session (Wayland) instead of the Ubuntu one.

Add a custom user profile to dconf/gsettings:
```shell
sudo tee /etc/dconf/profile/user << EOF
user-db:user
system-db:local
EOF
sudo mkdir /etc/dconf/db/local.d
```

Change the icon and cursor themes to Yaru:
```shell
sudo tee -a /etc/dconf/db/local.d/01-custom-desktop << EOF
[org/gnome/desktop/interface]
icon-theme='Yaru'
cursor-theme='Yaru'
EOF
sudo dconf update
```

For each user in the system, run:
```shell
gsettings reset org.gnome.desktop.interface icon-theme
gsettings reset org.gnome.desktop.interface cursor-theme
```

Replace the favorites for `snap:firefox` and `snap:snap-store` with the ones for `firefox` and `gnome-software`, respectively:
```shell
sudo tee -a /etc/dconf/db/local.d/01-custom-desktop << EOF
[org/gnome/shell]
favorite-apps=$(sudo gsettings get org.gnome.shell favorite-apps | sed "s/firefox_firefox/firefox/; s/snap-store_ubuntu-software/org.gnome.Software/")
EOF
sudo dconf update
```

For each user in the system, do the following:
- If you want to preserve the customizations made to the favorites, run:
```shell
gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/firefox_firefox/firefox/; s/snap-store_ubuntu-software/org.gnome.Software/")"
```
- If instead you want to reset them to the default values (eg. in a fresh install), run:
```shell
gsettings reset org.gnome.shell favorite-apps
```

Log out and back into the GNOME session (Wayland) to apply changes.

If you are not doing this in a fresh install, you might want to replace the installed snaps with their equivalent flatpaks: [popey/unsnap](https://github.com/popey/unsnap). **Keep in mind that this tool is still in "pre-alpha" stage, and might not work as intended**. **You can [contribute](https://github.com/popey/unsnap#contributions) testing it and reporting bugs or missing flatpaks**. Only the generated scripts `00-backup` and `03-install-flatpaks` are required to be run, as the rest is already done here. `snap:firefox` is already replaced with the native deb package, so you should remove it from the generated `03-install-flatpaks` script.

Remove the packages that remained (you might also want to remove `fonts-opensymbol`, `gnome-disk-utility` and `libwmf0.2-7-gtk` if you only want the packages in the minimal set). If you want to remove any of the [suggested packages](#Details), add them to the first command:
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

Now it is time to remove the custom metapackages:
```shell
sudo apt purge custom-desktop custom-desktop-minimal
```

Remove the custom profile from dconf/gsettings:
```shell
sudo rm /etc/dconf/db/local.d/01-custom-desktop
sudo rm -r /etc/dconf/db/local.d
sudo rm /etc/dconf/profile/user
sudo dconf update
```

Log out and back in, but into the Ubuntu session (the default one is Wayland, but you can also use the X one) instead of the GNOME one.

For each user in the system, run:
```shell
gsettings reset org.gnome.desktop.interface icon-theme
gsettings reset org.gnome.desktop.interface cursor-theme
```

Reinstall `snap:snap-store` and `snap:firefox`:
```shell
sudo snap install snap-store firefox
```

For each user in the system, do the following:
- If you want to preserve the customizations made to the favorites, run:
```shell
gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/firefox/firefox_firefox/; s/org.gnome.Software/snap-store_ubuntu-software/")"
```
- If instead you want to reset them to the default values, run:
```shell
gsettings reset org.gnome.shell favorite-apps
```

Log out and back into the Ubuntu session to apply changes.

Remove the flatpaks that might have been installed:
```shell
sudo flatpak remove --all
```

Remove the packages that remained. If you want to keep any of those packages, remove them from the first command and add them to the second:
```shell
sudo apt purge firefox flatpak gnome-session gnome-software linuxmint-keyring qbittorrent vlc
sudo apt-mark manual <packages to keep> # It can be ommited if you do not want to keep any package
sudo apt autoremove --purge
```

Remove the Linux Mint repositories:
```shell
sudo rm /etc/apt/preferences.d/pin-chromium-firefox
sudo rm /etc/apt/sources.list.d/mint-una.list
sudo apt update
```

## Suggested GNOME Shell extenstions
- [Awesome Tiles](https://extensions.gnome.org/extension/4702/awesome-tiles/): Tile windows using keyboard shortcuts;
- [Caffeine](https://extensions.gnome.org/extension/517/caffeine/): Disable the screensaver and auto suspend;
- [~~Dash to Dock~~](https://extensions.gnome.org/extension/307/dash-to-dock/): This extension moves the dash out of the overview transforming it in a dock for an easier launching of applications and a faster switching between windows and desktops (**currently not supported in GNOME 42**);
- [GSConnect](https://extensions.gnome.org/extension/1319/gsconnect/): GSConnect is a complete implementation of KDE Connect especially for GNOME Shell with Nautilus, Chrome and Firefox integration;
- [Night Theme Switcher](https://extensions.gnome.org/extension/2236/night-theme-switcher/): Make your desktop easy on the eye, day and night;
- [Tiling Assistant](https://extensions.gnome.org/extension/3733/tiling-assistant/): Expand GNOME's 2 column tiling and add a Windows-snap-assist-inspired popup.

To install the extensions you might need the GNOME Shell integration Firefox extension.

Awesome Tiles and Tiling Assistant do similar things, and might not work well together. Which one do you choose is just a matter of taste.

## Suggested Firefox extensions
- [Bitwarden - Free Password Manager](https://addons.mozilla.org/firefox/addon/bitwarden-password-manager/): A secure and free password manager for all of your devices;
- [GNOME Shell integration](https://addons.mozilla.org/firefox/addon/gnome-shell-integration/): This extension provides integration with GNOME Shell and the corresponding extensions repository;
    - First you need to install `chrome-gnome-shell`:
```shell
sudo apt install chrome-gnome-shell
```
- [GSConnect](https://addons.mozilla.org/firefox/addon/gsconnect/): Share links with GSConnect, direct to the browser or by SMS;
    - First you need to install the GSConnect GNOME Shell extension.
- [uBlock Origin](https://addons.mozilla.org/firefox/addon/ublock-origin/): Finally, an efficient wide-spectrum content blocker.

## Details
### custom-desktop-minimal
These are the packages that are added to, removed from or replaced in the `custom-desktop-minimal` metapackage:

| ubuntu-desktop-minimal | custom-desktop-minimal | Description |
|------------------------|------------------------|-------------|
| [~~dmz-cursor-theme~~](https://packages.ubuntu.com/jammy/dmz-cursor-theme) | | Style neutral, scalable cursor theme. **This should not be in the minimal metapackage, much less as a depend, as it is not used by most people**. **The Yaru theme is used instead**. |
| [~~gnome-accessibility-themes~~](https://packages.ubuntu.com/jammy/gnome-accessibility-themes) | | High Contrast GTK+ 2 theme and icons. **GTK+ 2 is not supported**. |
| [~~gnome-disk-utility~~](https://packages.ubuntu.com/jammy/gnome-disk-utility) | | Manage and configure disk drives and media. **Moved to `custom-desktop`, as it is not considered minimal**. |
| [~~gnome-session-canberra~~](https://packages.ubuntu.com/jammy/gnome-session-canberra) | | GNOME session log in and log out sound events. **This should not be in the minimal metapackage, much less as a depend, as most people do not care about sounds**. |
| [~~gnome-shell-extension-desktop-icons-ng~~](https://packages.ubuntu.com/jammy/gnome-shell-extension-desktop-icons-ng) | | Desktop icon support for GNOME Shell. **Active desktop is not supported**. |
| [~~gnome-shell-extension-ubuntu-dock~~](https://packages.ubuntu.com/jammy/gnome-shell-extension-ubuntu-dock) | | Ubuntu Dock for GNOME Shell. **The vanilla dock or the full blown dash-to-dock is preferred**. |
| [~~gstreamer1.0-pulseaudio~~](https://packages.ubuntu.com/jammy/gstreamer1.0-pulseaudio) | | GStreamer plugin for PulseAudio (transitional package). **Transitional packages are not needed**. |
| [~~ibus-gtk~~](https://packages.ubuntu.com/jammy/ibus-gtk) | | Intelligent Input Bus - GTK2 support. **GTK+ 2 is not supported**. |
| [~~libu2f-udev~~](https://packages.ubuntu.com/jammy/libu2f-udev) | | Universal 2nd Factor (U2F) - transitional package. **Transitional packages are not needed**. |
| [~~snap:firefox~~](https://snapcraft.io/firefox) | [firefox](https://packages.ubuntu.com/jammy/firefox) | Safe and easy web browser from Mozilla. **Snap is not supported**. |
| [~~snap:snap-store~~](https://snapcraft.io/snap-store) | [gnome-software](https://packages.ubuntu.com/jammy/gnome-software) | Software Center for GNOME. **Snap is not supported and GNOME Software supports native deb packages, snap and flatpak, while Snap Store only supports snap**. |
| [~~snapd~~](https://packages.ubuntu.com/jammy/snapd) | [flatpak](https://packages.ubuntu.com/jammy/flatpak) | Application deployment framework for desktop apps. **Snap is not supported**. **Flatpak is used instead**. |
| [~~ubuntu-session~~](https://packages.ubuntu.com/jammy/ubuntu-session) | [gnome-session](https://packages.ubuntu.com/jammy/gnome-session) | GNOME Session Manager - GNOME 3 session. **The custom Ubuntu session is not supported**. **The vanilla GNOME session is used instead**. |
| [~~xcursor-themes~~](https://packages.ubuntu.com/jammy/xcursor-themes) | | Base X cursor themes. **X is not supported and this should not be in the minimal metapackage, as it is not used by most people**. **The Yaru theme is used instead**. |
| [~~xorg~~](https://packages.ubuntu.com/jammy/xorg) | | X.Org X Window System. **X is not supported**. **Wayland is used instead**. |
| [~~yaru-theme-gnome-shell~~](https://packages.ubuntu.com/jammy/yaru-theme-gnome-shell) | | Yaru GNOME Shell desktop theme from the Ubuntu Community. **The vanilla Adwaita theme is preferred**. |
| [~~yaru-theme-gtk~~](https://packages.ubuntu.com/jammy/yaru-theme-gtk) | | Yaru GTK theme from the Ubuntu Community. **The vanilla Adwaita theme is preferred**. |
| [~~yaru-theme-sound~~](https://packages.ubuntu.com/jammy/yaru-theme-sound) | | Yaru sound theme from the Ubuntu Community. **This should not be in the minimal metapackage, as most people do not care about sounds**. |

There are groups of packages that originally belonged to the `ubuntu-desktop-minimal` metapackage but are just suggested by `custom-desktop-minimal`. Their removal is optional, depending on whether or not they are necessary.

#### Accessibility

| Function | ubuntu-desktop-minimal | Description |
|----------|------------------------|-------------|
| | [at-spi2-core](https://packages.ubuntu.com/jammy/at-spi2-core) | Assistive Technology Service Provider Interface (dbus core). |
| | [libatk-adaptor](https://packages.ubuntu.com/jammy/libatk-adaptor) | AT-SPI 2 toolkit bridge. |
| Braille | [brltty](https://packages.ubuntu.com/jammy/brltty) | Access software for a blind person using a braille display. |
| Mouse | [mousetweaks](https://packages.ubuntu.com/jammy/mousetweaks) | Mouse accessibility enhancements for the GNOME desktop. |
| Screen Reader | [orca](https://packages.ubuntu.com/jammy/orca) | Scriptable screen reader. |
| Screen Reader | [speech-dispatcher](https://packages.ubuntu.com/jammy/speech-dispatcher) | Common interface to speech synthesizers. |

#### Avahi/NSS

| ubuntu-desktop-minimal | Description |
|------------------------|-------------|
| [avahi-autoipd](https://packages.ubuntu.com/jammy/avahi-autoipd) | Avahi IPv4LL network address configuration daemon. |
| [avahi-daemon](https://packages.ubuntu.com/jammy/avahi-daemon) | Avahi mDNS/DNS-SD daemon. |
| [libnss-mdns](https://packages.ubuntu.com/jammy/libnss-mdns) | NSS module for Multicast DNS name resolution. |

#### Bluetooth

| Function | ubuntu-desktop-minimal | Description |
|----------|------------------------|-------------|
| | [bluez](https://packages.ubuntu.com/jammy/bluez) | Bluetooth tools and daemons. |
| | [gnome-bluetooth](https://packages.ubuntu.com/jammy/gnome-bluetooth) | GNOME Bluetooth tools. |
| | [pulseaudio-module-bluetooth](https://packages.ubuntu.com/jammy/pulseaudio-module-bluetooth) | Bluetooth module for PulseAudio sound server. |
| | [rfkill](https://packages.ubuntu.com/jammy/rfkill) | Tool for enabling and disabling wireless devices. **This package is also used by Wi-Fi devices**. **It should only be removed if both Bluetooth and Wi-Fi are not used**. |
| Printing | [bluez-cups](https://packages.ubuntu.com/jammy/bluez-cups) | Bluetooth printer driver for CUPS. |

`bluez-cups` is repeated in [Printing](#Printing) to make visualization easier.

`rfkill` is repeated in [Wi-Fi](#Wi-Fi) to make visualization easier.

#### Fingerprint

| ubuntu-desktop-minimal | Description |
|------------------------|-------------|
| [libpam-fprintd](https://packages.ubuntu.com/jammy/libpam-fprintd) | PAM module for fingerprint authentication through fprintd. |

#### Gaming

| ubuntu-desktop-minimal | Description |
|------------------------|-------------|
| [gamemode](https://packages.ubuntu.com/jammy/gamemode) | Optimise Linux system performance on demand. |

#### GNOME extras

| ubuntu-desktop-minimal | Description |
|------------------------|-------------|
| [gnome-characters](https://packages.ubuntu.com/jammy/gnome-characters) | Character map application. |
| [gnome-font-viewer](https://packages.ubuntu.com/jammy/gnome-font-viewer) | Font viewer for GNOME. |
| [gnome-logs](https://packages.ubuntu.com/jammy/gnome-logs) | Viewer for the systemd journal. |

#### Language fonts

| Function | ubuntu-desktop-minimal | Description |
|----------|------------------------|-------------|
| Arabic | [fonts-kacst-one](https://packages.ubuntu.com/jammy/fonts-kacst-one) | TrueType font designed for Arabic language. |
| Burmese | [fonts-sil-padauk](https://packages.ubuntu.com/jammy/fonts-sil-padauk) | Burmese Unicode TrueType font with OpenType and Graphite support. |
| CJK | [fonts-noto-cjk](https://packages.ubuntu.com/jammy/fonts-noto-cjk) | "No Tofu" font families with large Unicode coverage (CJK regular and bold). |
| Ethiopic | [fonts-sil-abyssinica](https://packages.ubuntu.com/jammy/fonts-sil-abyssinica) | Unicode font for the Ethiopic script. |
| Indian | [fonts-indic](https://packages.ubuntu.com/jammy/fonts-indic) | Meta package to install all Indian language fonts. |
| Khmer | [fonts-khmeros-core](https://packages.ubuntu.com/jammy/fonts-khmeros-core) | KhmerOS Unicode fonts for the Khmer language of Cambodia. |
| Lao | [fonts-lao](https://packages.ubuntu.com/jammy/fonts-lao) | TrueType font for Lao language. |
| Sinhala | [fonts-lklug-sinhala](https://packages.ubuntu.com/jammy/fonts-lklug-sinhala) | Unicode Sinhala font by Lanka Linux User Group. |
| Thai | [fonts-thai-tlwg](https://packages.ubuntu.com/jammy/fonts-thai-tlwg) | Thai fonts maintained by TLWG (metapackage). |
| Tibetan | [fonts-tibetan-machine](https://packages.ubuntu.com/jammy/fonts-tibetan-machine) | Font for Tibetan, Dzongkha and Ladakhi (OpenType Unicode). |

#### Legacy hardware

| ubuntu-desktop-minimal | Description |
|------------------------|-------------|
| [pcmciautils](https://packages.ubuntu.com/jammy/pcmciautils) | PCMCIA utilities for Linux 2.6. |
| [inputattach](https://packages.ubuntu.com/jammy/inputattach) | Utility to connect serial-attached peripherals to the input subsystem. |

#### LibreOffice support

| ubuntu-desktop-minimal | Description |
|------------------------|-------------|
| [fonts-opensymbol](https://packages.ubuntu.com/jammy/fonts-opensymbol) | OpenSymbol TrueType font. |
| [libwmf0.2-7-gtk](https://packages.ubuntu.com/jammy/libwmf0.2-7-gtk) | Windows metafile conversion library. |

`fonts-opensymbol` and `libwmf0.2-7-gtk` are moved to `custom-desktop`, as they are used by LibreOffice.

#### Miscellaneous

| ubuntu-desktop-minimal | Description |
|------------------------|-------------|
| [bc](https://packages.ubuntu.com/jammy/bc) | GNU bc arbitrary precision calculator language. |
| [ghostscript-x](https://packages.ubuntu.com/jammy/ghostscript-x) | Interpreter for the PostScript language and for PDF - X11 support. |
| [gvfs-fuse](https://packages.ubuntu.com/jammy/gvfs-fuse) | Userspace virtual filesystem - fuse server. |
| [ibus-table](https://packages.ubuntu.com/jammy/ibus-table) | Table engine for IBus. |
| [memtest86+](https://packages.ubuntu.com/jammy/memtest86+) | Thorough real-mode memory tester. |
| [nautilus-sendto](https://packages.ubuntu.com/jammy/nautilus-sendto) | Easily send files via email from within Nautilus. |
| [nautilus-share](https://packages.ubuntu.com/jammy/nautilus-share) | Nautilus extension to share folder using Samba. |

#### Printing

| Function | ubuntu-desktop-minimal | Description |
|----------|------------------------|-------------|
| | [cups](https://packages.ubuntu.com/jammy/cups) | Common UNIX Printing System(tm) - PPD/driver support, web interface. |
| | [cups-bsd](https://packages.ubuntu.com/jammy/cups-bsd) | Common UNIX Printing System(tm) - BSD commands. |
| | [cups-client](https://packages.ubuntu.com/jammy/cups-client) | Common UNIX Printing System(tm) - client programs (SysV). |
| | [cups-filters](https://packages.ubuntu.com/jammy/cups-filters) | OpenPrinting CUPS Filters - Main Package. |
| Bluetooth | [bluez-cups](https://packages.ubuntu.com/jammy/bluez-cups) | Bluetooth printer driver for CUPS. |
| Brother/Lenovo | [printer-driver-brlaser](https://packages.ubuntu.com/jammy/printer-driver-brlaser) | Printer driver for (some) Brother laser printers. |
| Brother | [printer-driver-ptouch](https://packages.ubuntu.com/jammy/printer-driver-ptouch) | Printer driver Brother P-touch label printers. |
| Foomatic | [foomatic-db-compressed-ppds](https://packages.ubuntu.com/jammy/foomatic-db-compressed-ppds) | OpenPrinting printer support - Compressed PPDs derived from the database. |
| HP | [hplip](https://packages.ubuntu.com/jammy/hplip) | HP Linux Printing and Imaging System (HPLIP). |
| HP | [printer-driver-pnm2ppa](https://packages.ubuntu.com/jammy/printer-driver-pnm2ppa) | Printer driver for HP-GDI printers. |
| HP | [printer-driver-pxljr](https://packages.ubuntu.com/jammy/printer-driver-pxljr) | Printer driver for HP Color LaserJet 35xx/36xx. |
| Kodak | [printer-driver-c2esp](https://packages.ubuntu.com/jammy/printer-driver-c2esp) | Printer driver for Kodak ESP AiO color inkjet Series. |
| Konica Minolta | [printer-driver-m2300w](https://packages.ubuntu.com/jammy/printer-driver-m2300w) | Printer driver for Minolta magicolor 2300W/2400W color laser printers. |
| Konica Minolta | [printer-driver-min12xxw](https://packages.ubuntu.com/jammy/printer-driver-min12xxw) | Printer driver for KonicaMinolta PagePro 1[234]xxW. |
| PostScript | [openprinting-ppds](https://packages.ubuntu.com/jammy/openprinting-ppds) | OpenPrinting printer support - PostScript PPD files. |
| Ricoh Aficio | [printer-driver-sag-gdi](https://packages.ubuntu.com/jammy/printer-driver-sag-gdi) | Printer driver for Ricoh Aficio SP 1000s/SP 1100s. |
| Samsung/Xerox | [printer-driver-splix](https://packages.ubuntu.com/jammy/printer-driver-splix) | Driver for Samsung and Xerox SPL2 and SPLc laser printers. |
| Zenographics ZjStream | [printer-driver-foo2zjs](https://packages.ubuntu.com/jammy/printer-driver-foo2zjs) | Printer driver for ZjStream-based printers. |

`bluez-cups` is repeated in [Bluetooth](#Bluetooth) to make visualization easier.

#### Remote desktop

| ubuntu-desktop | Description |
|----------------|-------------|
| [gnome-remote-desktop](https://packages.ubuntu.com/jammy/gnome-remote-desktop) | Remote desktop daemon for GNOME using PipeWire. |

#### VM

| ubuntu-desktop-minimal | Description |
|------------------------|-------------|
| [spice-vdagent](https://packages.ubuntu.com/jammy/spice-vdagent) | Spice agent for Linux. |

#### Wi-Fi

| ubuntu-desktop-minimal | Description |
|------------------------|-------------|
| [rfkill](https://packages.ubuntu.com/jammy/rfkill) | Tool for enabling and disabling wireless devices. **This package is also used by Bluetooth devices**. **It should only be removed if both Bluetooth and Wi-Fi are not used**. |
| [wireless-tools](https://packages.ubuntu.com/jammy/wireless-tools) | Tools for manipulating Linux Wireless Extensions. |
| [wpasupplicant](https://packages.ubuntu.com/jammy/wpasupplicant) | Client support for WPA and WPA2 (IEEE 802.11i). |

`rfkill` is repeated in [Bluetooth](#Bluetooth) to make visualization easier.

### custom-desktop
These are the packages that are added to, removed from or replaced in the `custom-desktop` metapackage:

| ubuntu-desktop | custom-desktop | Description |
|----------------|----------------|-------------|
| [fonts-opensymbol](https://packages.ubuntu.com/jammy/fonts-opensymbol) | fonts-opensymbol | OpenSymbol TrueType font. **Moved from `custom-desktop-minimal`, as it is used by LibreOffice**. |
| [gnome-disk-utility](https://packages.ubuntu.com/jammy/gnome-disk-utility) | gnome-disk-utility | Manage and configure disk drives and media. **Moved from `custom-desktop-minimal`, as it is not considered minimal**. |
| [~~libreoffice-ogltrans~~](https://packages.ubuntu.com/jammy/libreoffice-ogltrans) | | Transitional package for libreoffice-ogltrans. **Transitional packages are not needed**. |
| [~~libreoffice-pdfimport~~](https://packages.ubuntu.com/jammy/libreoffice-pdfimport) | | Transitional package for PDF Import component for LibreOffice. **Transitional packages are not needed**. |
| [~~libreoffice-style-breeze~~](https://packages.ubuntu.com/jammy/libreoffice-style-breeze) | | Office productivity suite -- Breeze symbol style. **KDE is not supported, so it is not used by most people**. |
| [libwmf0.2-7-gtk](https://packages.ubuntu.com/jammy/libwmf0.2-7-gtk) | libwmf0.2-7-gtk | Windows metafile conversion library. **Moved from `custom-desktop-minimal`, as it is used by LibreOffice**. |
| [~~transmission-gtk~~](https://packages.ubuntu.com/jammy/transmission-gtk) | [qbittorrent](https://packages.ubuntu.com/jammy/qbittorrent) | Bittorrent client based on libtorrent-rasterbar with a Qt5 GUI. **Transmission is not supported, as it is buggy and lacks several features**. **qBittorrent is used instead, as it is one of the best torrent clients ever**. |
| | [vlc](https://packages.ubuntu.com/jammy/vlc) | Multimedia player and streamer. **It is more feature-rich than Totem, but cannot replace it since Totem supports more codec formats**. **In the future only one of them should be used**. |

There are groups of packages that originally belonged to the `ubuntu-desktop` metapackage but are just suggested by `custom-desktop`. Their removal is optional, depending on whether or not they are necessary.

#### Gaming

| ubuntu-desktop | Description |
|----------------|-------------|
| [aisleriot](https://packages.ubuntu.com/jammy/aisleriot) | GNOME solitaire card game collection. |
| [gnome-mahjongg](https://packages.ubuntu.com/jammy/gnome-mahjongg) | Classic Eastern tile game for GNOME. |
| [gnome-mines](https://packages.ubuntu.com/jammy/gnome-mines) | Popular minesweeper puzzle game for GNOME. |
| [gnome-sudoku](https://packages.ubuntu.com/jammy/gnome-sudoku) | Sudoku puzzle game for GNOME. |

#### GNOME extras

| ubuntu-desktop | Description |
|----------------|-------------|
| [cheese](https://packages.ubuntu.com/jammy/cheese) | Tool to take pictures and videos from your webcam. |
| [simple-scan](https://packages.ubuntu.com/jammy/simple-scan) | Simple Scanning Utility. |

#### Email

| ubuntu-desktop | Description |
|----------------|-------------|
| [thunderbird](https://packages.ubuntu.com/jammy/thunderbird) | Email, RSS and newsgroup client with integrated spam filter. |
| [thunderbird-gnome-support](https://packages.ubuntu.com/jammy/thunderbird-gnome-support) | Email, RSS and newsgroup client - GNOME support. |

#### Miscellaneous

| ubuntu-desktop | Description |
|----------------|-------------|
| [branding-ubuntu](https://packages.ubuntu.com/jammy/branding-ubuntu) | Replacement artwork with Ubuntu branding. |
| [usb-creator-gtk](https://packages.ubuntu.com/jammy/usb-creator-gtk) | Create a startup disk using a CD or disc image (for GNOME). |

#### Remote desktop

| ubuntu-desktop | Description |
|----------------|-------------|
| [remmina](https://packages.ubuntu.com/jammy/remmina) | GTK+ Remote Desktop Client. |

## Building
To build the metapackages from their control files, you need to install [`equivs`](https://packages.ubuntu.com/jammy/equivs):
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
make ubuntu-system-adjustments
```

# Developing
To customize the metapackages, you can use the `main.sh` script from the `builder/` folder.
