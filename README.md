# Custom Desktop
The custom Ubuntu desktop system.

[Ler em português do Brasil](README-pt_BR.md).

It replaces the Ubuntu 21.10 original desktop metapackages ([`ubuntu-desktop-minimal`](https://packages.ubuntu.com/impish/ubuntu-desktop-minimal) and [`ubuntu-desktop`](https://packages.ubuntu.com/impish/ubuntu-desktop)). **Keep in mind that they are also used to help ensure proper upgrades, so it is recommended that they not be removed**. **Only do this if you know what you are doing, and proceed at your own risk**. To avoid any problems, it is recommended to install them in a fresh Ubuntu 21.10 install.

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

Now it is time to remove the Ubuntu original metapackages:
```shell
sudo apt purge ubuntu-desktop ubuntu-desktop-minimal
```

Replace the favorites for `snap:firefox` and `snap:snap-store` with the ones for `firefox` and `gnome-software`, respectively:
```shell
gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/firefox_firefox/firefox/; s/snap-store_ubuntu-software/org.gnome.Software/")"
```

Add the Flathub repository to flatpak:
```shell
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

Log out and back in, but into the GNOME session (Wayland) instead of the Ubuntu one.

Change the icon and cursor themes to Yaru:
```shell
gsettings set org.gnome.desktop.interface icon-theme "Yaru"
gsettings set org.gnome.desktop.interface cursor-theme "Yaru"
```

Remove the packages that might have remained (you might also want to remove `fonts-opensymbol`, `gnome-disk-uility` and `libwmf0.2-7-gtk` if you only want the packages in the minimal set). If you want to remove any of the [suggested packages](#Details), add them to the first command:
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

If you wish to do so, reinstall `snap:snap-store` and `snap:firefox`:
```shell
sudo snap install snap-store firefox
```

Replace the favorites for `firefox` and `gnome-software` with the ones for `snap:firefox` and `snap:snap-store`, respectively:
```shell
gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/firefox/firefox_firefox/; s/org.gnome.Software/snap-store_ubuntu-software/")"
```

Log out and back in, but into the Ubuntu session (the default one is Wayland, but you can also use the X one) instead of the GNOME one.

Remove the packages that might have remained. If you want to keep any of those packages, remove them from the first command and add them to the second:
```shell
sudo apt purge firefox flatpak gnome-session gnome-software gnome-software-plugin-flatpak qbittorrent vlc
sudo apt-mark manual <packages to keep> # It can be ommited if you do not want to keep any package
sudo apt autoremove --purge
```

## Suggested GNOME Shell and GTK theme
[WhiteSur](https://github.com/vinceliuice/WhiteSur-gtk-theme): MacOS Big Sur-like theme for Gnome desktops.

Install it with the suggested options:
```shell
./install.sh -o solid -a alt -i ubuntu -m --right
```

## Suggested GNOME Shell extenstions
- [Awesome Tiles](https://extensions.gnome.org/extension/4702/awesome-tiles/): Tile windows using keyboard shortcuts;
- [Caffeine](https://extensions.gnome.org/extension/517/caffeine/): Disable the screensaver and auto suspend;
- [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/): This extension moves the dash out of the overview transforming it in a dock for an easier launching of applications and a faster switching between windows and desktops;
- [GSConnect](https://extensions.gnome.org/extension/1319/gsconnect/): GSConnect is a complete implementation of KDE Connect especially for GNOME Shell with Nautilus, Chrome and Firefox integration;
- [Night Theme Switcher](https://extensions.gnome.org/extension/2236/night-theme-switcher/): Make your desktop easy on the eye, day and night;
- [Tiling Assistant](https://extensions.gnome.org/extension/3733/tiling-assistant/): Expand GNOME's 2 column tiling and add a Windows-snap-assist-inspired popup;
- [User Themes](https://extensions.gnome.org/extension/19/user-themes/): Load shell themes from user directory.

## Suggested Firefox extensions
- [Bitwarden - Free Password Manager](https://addons.mozilla.org/firefox/addon/bitwarden-password-manager/): A secure and free password manager for all of your devices;
- [GNOME Shell integration](https://addons.mozilla.org/firefox/addon/gnome-shell-integration/): This extension provides integration with GNOME Shell and the corresponding extensions repository;
    - First you need to install `chrome-gnome-shell`:
```shell
sudo apt install chrome-gnome-shell
```
- [GSConnect](https://addons.mozilla.org/firefox/addon/gsconnect/): Share links with GSConnect, direct to the browser or by SMS;
    - First you need to install the GNOME Shell extension.
- [uBlock Origin](https://addons.mozilla.org/firefox/addon/ublock-origin/): Finally, an efficient wide-spectrum content blocker.

## Details
### custom-desktop-minimal
These are the packages that are added to, removed from or replaced in the `custom-desktop-minimal` metapackage:

| ubuntu-desktop-minimal | custom-desktop-minimal | Description |
|------------------------|------------------------|-------------|
| [~~dmz-cursor-theme~~](https://packages.ubuntu.com/impish/dmz-cursor-theme) | | Style neutral, scalable cursor theme. **This should not be in the minimal metapackage, much less as a depend, as it is not used by most people**. **The Yaru theme is used instead**. |
| [~~gnome-accessibility-themes~~](https://packages.ubuntu.com/impish/gnome-accessibility-themes) | | High Contrast GTK+ 2 theme and icons. **GTK+ 2 is not supported**. |
| [~~gnome-disk-utility~~](https://packages.ubuntu.com/impish/gnome-disk-utility) | | Manage and configure disk drives and media. **Moved to `custom-desktop`, as it is not considered minimal**. |
| [~~gnome-session-canberra~~](https://packages.ubuntu.com/impish/gnome-session-canberra) | | GNOME session log in and log out sound events. **This should not be in the minimal metapackage, much less as a depend, as most people do not care about sounds**. |
| [~~gnome-shell-extension-desktop-icons-ng~~](https://packages.ubuntu.com/impish/gnome-shell-extension-desktop-icons-ng) | | Desktop icon support for GNOME Shell. **Active desktop is not supported**. |
| [~~gnome-shell-extension-ubuntu-dock~~](https://packages.ubuntu.com/impish/gnome-shell-extension-ubuntu-dock) | | Ubuntu Dock for GNOME Shell. **The vanilla dock or the full blown dash-to-dock is preferred**. |
| [~~gstreamer1.0-pulseaudio~~](https://packages.ubuntu.com/impish/gstreamer1.0-pulseaudio) | | GStreamer plugin for PulseAudio (transitional package). **Transitional packages are not needed**. |
| [~~ibus-gtk~~](https://packages.ubuntu.com/impish/ibus-gtk) | | Intelligent Input Bus - GTK2 support. **GTK+ 2 is not supported**. |
| [~~libu2f-udev~~](https://packages.ubuntu.com/impish/libu2f-udev) | | Universal 2nd Factor (U2F) - transitional package. **Transitional packages are not needed**. |
| [~~snap:firefox~~](https://snapcraft.io/firefox) | [firefox](https://packages.ubuntu.com/impish/firefox) | Safe and easy web browser from Mozilla. **Snap is not supported**. |
| [~~snap:snap-store~~](https://snapcraft.io/snap-store) | [gnome-software](https://packages.ubuntu.com/impish/gnome-software) | Software Center for GNOME. **Snap is not supported and GNOME Software supports native deb packages, snap and flatpak, while Snap Store only supports snap**. |
| | [gnome-software-plugin-flatpak](https://packages.ubuntu.com/impish/gnome-software-plugin-flatpak) | Flatpak support for GNOME Software. **Required for GNOME Software to support flatpak**. |
| [~~snapd~~](https://packages.ubuntu.com/impish/snapd) | [flatpak](https://packages.ubuntu.com/impish/flatpak) | Application deployment framework for desktop apps. **Snap is not supported**. **Flatpak is used instead**. |
| [~~ubuntu-session~~](https://packages.ubuntu.com/impish/ubuntu-session) | [gnome-session](https://packages.ubuntu.com/impish/gnome-session) | GNOME Session Manager - GNOME 3 session. **The custom Ubuntu session is not supported**. **The vanilla GNOME session is used instead**. |
| [~~xcursor-themes~~](https://packages.ubuntu.com/impish/xcursor-themes) | | Base X cursor themes. **X is not supported and this should not be in the minimal metapackage, as it is not used by most people**. **The Yaru theme is used instead**. |
| [~~xorg~~](https://packages.ubuntu.com/impish/xorg) | | X.Org X Window System. **X is not supported**. **Wayland is used instead**. |
| [~~yaru-theme-gnome-shell~~](https://packages.ubuntu.com/impish/yaru-theme-gnome-shell) | | Yaru GNOME Shell desktop theme from the Ubuntu Community. **The vanilla Adwaita theme is preferred**. |
| [~~yaru-theme-gtk~~](https://packages.ubuntu.com/impish/yaru-theme-gtk) | | Yaru GTK theme from the Ubuntu Community. **The vanilla Adwaita theme is preferred**. |
| [~~yaru-theme-sound~~](https://packages.ubuntu.com/impish/yaru-theme-sound) | | Yaru sound theme from the Ubuntu Community. **This should not be in the minimal metapackage, as most people do not care about sounds**. |

There are groups of packages that originally belonged to the `ubuntu-desktop-minimal` metapackage but are just suggested by `custom-desktop-minimal`. Their removal is optional, depending on whether or not they are necessary.

#### Accessibility

| Function | ubuntu-desktop-minimal | Description |
|----------|------------------------|-------------|
| | [at-spi2-core](https://packages.ubuntu.com/impish/at-spi2-core) | Assistive Technology Service Provider Interface (dbus core). |
| | [libatk-adaptor](https://packages.ubuntu.com/impish/libatk-adaptor) | AT-SPI 2 toolkit bridge. |
| Braille | [brltty](https://packages.ubuntu.com/impish/brltty) | Access software for a blind person using a braille display. |
| Mouse | [mousetweaks](https://packages.ubuntu.com/impish/mousetweaks) | Mouse accessibility enhancements for the GNOME desktop. |
| Screen Reader | [orca](https://packages.ubuntu.com/impish/orca) | Scriptable screen reader. |
| Screen Reader | [speech-dispatcher](https://packages.ubuntu.com/impish/speech-dispatcher) | Common interface to speech synthesizers. |

#### Avahi/NSS

| ubuntu-desktop-minimal | Description |
|------------------------|-------------|
| [avahi-autoipd](https://packages.ubuntu.com/impish/avahi-autoipd) | Avahi IPv4LL network address configuration daemon. |
| [avahi-daemon](https://packages.ubuntu.com/impish/avahi-daemon) | Avahi mDNS/DNS-SD daemon. |
| [libnss-mdns](https://packages.ubuntu.com/impish/libnss-mdns) | NSS module for Multicast DNS name resolution. |

#### Bluetooth

| Function | ubuntu-desktop-minimal | Description |
|----------|------------------------|-------------|
| | [bluez](https://packages.ubuntu.com/impish/bluez) | Bluetooth tools and daemons. |
| | [gnome-bluetooth](https://packages.ubuntu.com/impish/gnome-bluetooth) | GNOME Bluetooth tools. |
| | [pulseaudio-module-bluetooth](https://packages.ubuntu.com/impish/pulseaudio-module-bluetooth) | Bluetooth module for PulseAudio sound server. |
| | [rfkill](https://packages.ubuntu.com/impish/rfkill) | Tool for enabling and disabling wireless devices. **This package is also used by Wi-Fi devices**. **It should only be removed if both Bluetooth and Wi-Fi are not used**. |
| Printing | [bluez-cups](https://packages.ubuntu.com/impish/bluez-cups) | Bluetooth printer driver for CUPS. |

`bluez-cups` is repeated in [Printing](#Printing) to make visualization easier.

`rfkill` is repeated in [Wi-Fi](#Wi-Fi) to make visualization easier.

#### Fingerprint

| ubuntu-desktop-minimal | Description |
|------------------------|-------------|
| [libpam-fprintd](https://packages.ubuntu.com/impish/libpam-fprintd) | PAM module for fingerprint authentication through fprintd. |

#### Gaming

| ubuntu-desktop-minimal | Description |
|------------------------|-------------|
| [gamemode](https://packages.ubuntu.com/impish/gamemode) | Optimise Linux system performance on demand. |

#### GNOME extras

| ubuntu-desktop-minimal | Description |
|------------------------|-------------|
| [gnome-characters](https://packages.ubuntu.com/impish/gnome-characters) | Character map application. |
| [gnome-font-viewer](https://packages.ubuntu.com/impish/gnome-font-viewer) | Font viewer for GNOME. |
| [gnome-logs](https://packages.ubuntu.com/impish/gnome-logs) | Viewer for the systemd journal. |

#### Language fonts

| Function | ubuntu-desktop-minimal | Description |
|----------|------------------------|-------------|
| Arabic | [fonts-kacst-one](https://packages.ubuntu.com/impish/fonts-kacst-one) | TrueType font designed for Arabic language. |
| Burmese | [fonts-sil-padauk](https://packages.ubuntu.com/impish/fonts-sil-padauk) | Burmese Unicode TrueType font with OpenType and Graphite support. |
| CJK | [fonts-noto-cjk](https://packages.ubuntu.com/impish/fonts-noto-cjk) | "No Tofu" font families with large Unicode coverage (CJK regular and bold). |
| Ethiopic | [fonts-sil-abyssinica](https://packages.ubuntu.com/impish/fonts-sil-abyssinica) | Unicode font for the Ethiopic script. |
| Indian | [fonts-indic](https://packages.ubuntu.com/impish/fonts-indic) | Meta package to install all Indian language fonts. |
| Khmer | [fonts-khmeros-core](https://packages.ubuntu.com/impish/fonts-khmeros-core) | KhmerOS Unicode fonts for the Khmer language of Cambodia. |
| Lao | [fonts-lao](https://packages.ubuntu.com/impish/fonts-lao) | TrueType font for Lao language. |
| Sinhala | [fonts-lklug-sinhala](https://packages.ubuntu.com/impish/fonts-lklug-sinhala) | Unicode Sinhala font by Lanka Linux User Group. |
| Thai | [fonts-thai-tlwg](https://packages.ubuntu.com/impish/fonts-thai-tlwg) | Thai fonts maintained by TLWG (metapackage). |
| Tibetan | [fonts-tibetan-machine](https://packages.ubuntu.com/impish/fonts-tibetan-machine) | Font for Tibetan, Dzongkha and Ladakhi (OpenType Unicode). |

#### Legacy hardware

| ubuntu-desktop-minimal | Description |
|------------------------|-------------|
| [pcmciautils](https://packages.ubuntu.com/impish/pcmciautils) | PCMCIA utilities for Linux 2.6. |
| [inputattach](https://packages.ubuntu.com/impish/inputattach) | Utility to connect serial-attached peripherals to the input subsystem. |

#### LibreOffice support

| ubuntu-desktop-minimal | Description |
|------------------------|-------------|
| [fonts-opensymbol](https://packages.ubuntu.com/impish/fonts-opensymbol) | OpenSymbol TrueType font. |
| [libwmf0.2-7-gtk](https://packages.ubuntu.com/impish/libwmf0.2-7-gtk) | Windows metafile conversion library. |

`fonts-opensymbol` and `libwmf0.2-7-gtk` are moved to `custom-desktop`, as they are used by LibreOffice.

#### Miscellaneous

| ubuntu-desktop-minimal | Description |
|------------------------|-------------|
| [app-install-data-partner](https://packages.ubuntu.com/impish/app-install-data-partner) | Application Installer (data files for partner applications/repositories). |
| [bc](https://packages.ubuntu.com/impish/bc) | GNU bc arbitrary precision calculator language. |
| [ghostscript-x](https://packages.ubuntu.com/impish/ghostscript-x) | Interpreter for the PostScript language and for PDF - X11 support. |
| [gvfs-fuse](https://packages.ubuntu.com/impish/gvfs-fuse) | Userspace virtual filesystem - fuse server. |
| [ibus-table](https://packages.ubuntu.com/impish/ibus-table) | Table engine for IBus. |
| [memtest86+](https://packages.ubuntu.com/impish/memtest86+) | Thorough real-mode memory tester. |
| [nautilus-sendto](https://packages.ubuntu.com/impish/nautilus-sendto) | Easily send files via email from within Nautilus. |
| [nautilus-share](https://packages.ubuntu.com/impish/nautilus-share) | Nautilus extension to share folder using Samba. |

#### Printing

| Function | ubuntu-desktop-minimal | Description |
|----------|------------------------|-------------|
| | [cups](https://packages.ubuntu.com/impish/cups) | Common UNIX Printing System(tm) - PPD/driver support, web interface. |
| | [cups-bsd](https://packages.ubuntu.com/impish/cups-bsd) | Common UNIX Printing System(tm) - BSD commands. |
| | [cups-client](https://packages.ubuntu.com/impish/cups-client) | Common UNIX Printing System(tm) - client programs (SysV). |
| | [cups-filters](https://packages.ubuntu.com/impish/cups-filters) | OpenPrinting CUPS Filters - Main Package. |
| Bluetooth | [bluez-cups](https://packages.ubuntu.com/impish/bluez-cups) | Bluetooth printer driver for CUPS. |
| Brother/Lenovo | [printer-driver-brlaser](https://packages.ubuntu.com/impish/printer-driver-brlaser) | Printer driver for (some) Brother laser printers. |
| Brother | [printer-driver-ptouch](https://packages.ubuntu.com/impish/printer-driver-ptouch) | Printer driver Brother P-touch label printers. |
| Foomatic | [foomatic-db-compressed-ppds](https://packages.ubuntu.com/impish/foomatic-db-compressed-ppds) | OpenPrinting printer support - Compressed PPDs derived from the database. |
| HP | [hplip](https://packages.ubuntu.com/impish/hplip) | HP Linux Printing and Imaging System (HPLIP). |
| HP | [printer-driver-pnm2ppa](https://packages.ubuntu.com/impish/printer-driver-pnm2ppa) | Printer driver for HP-GDI printers. |
| HP | [printer-driver-pxljr](https://packages.ubuntu.com/impish/printer-driver-pxljr) | Printer driver for HP Color LaserJet 35xx/36xx. |
| Kodak | [printer-driver-c2esp](https://packages.ubuntu.com/impish/printer-driver-c2esp) | Printer driver for Kodak ESP AiO color inkjet Series. |
| Konica Minolta | [printer-driver-m2300w](https://packages.ubuntu.com/impish/printer-driver-m2300w) | Printer driver for Minolta magicolor 2300W/2400W color laser printers. |
| Konica Minolta | [printer-driver-min12xxw](https://packages.ubuntu.com/impish/printer-driver-min12xxw) | Printer driver for KonicaMinolta PagePro 1[234]xxW. |
| PostScript | [openprinting-ppds](https://packages.ubuntu.com/impish/openprinting-ppds) | OpenPrinting printer support - PostScript PPD files. |
| Ricoh Aficio | [printer-driver-sag-gdi](https://packages.ubuntu.com/impish/printer-driver-sag-gdi) | Printer driver for Ricoh Aficio SP 1000s/SP 1100s. |
| Samsung/Xerox | [printer-driver-splix](https://packages.ubuntu.com/impish/printer-driver-splix) | Driver for Samsung and Xerox SPL2 and SPLc laser printers. |
| Zenographics ZjStream | [printer-driver-foo2zjs](https://packages.ubuntu.com/impish/printer-driver-foo2zjs) | Printer driver for ZjStream-based printers. |

`bluez-cups` is repeated in [Bluetooth](#Bluetooth) to make visualization easier.

#### VM

| ubuntu-desktop-minimal | Description |
|------------------------|-------------|
| [spice-vdagent](https://packages.ubuntu.com/impish/spice-vdagent) | Spice agent for Linux. |

#### Wi-Fi

| ubuntu-desktop-minimal | Description |
|------------------------|-------------|
| [rfkill](https://packages.ubuntu.com/impish/rfkill) | Tool for enabling and disabling wireless devices. **This package is also used by Bluetooth devices**. **It should only be removed if both Bluetooth and Wi-Fi are not used**. |
| [wireless-tools](https://packages.ubuntu.com/impish/wireless-tools) | Tools for manipulating Linux Wireless Extensions. |

`rfkill` is repeated in [Bluetooth](#Bluetooth) to make visualization easier.

### custom-desktop
These are the packages that are added to, removed from or replaced in the `custom-desktop` metapackage:

| ubuntu-desktop | custom-desktop | Description |
|----------------|----------------|-------------|
| [fonts-opensymbol](https://packages.ubuntu.com/impish/fonts-opensymbol) | fonts-opensymbol | OpenSymbol TrueType font. **Moved from `custom-desktop-minimal`, as it is used by LibreOffice**. |
| [gnome-disk-utility](https://packages.ubuntu.com/impish/gnome-disk-utility) | gnome-disk-utility | Manage and configure disk drives and media. **Moved from `custom-desktop-minimal`, as it is not considered minimal**. |
| [~~libreoffice-ogltrans~~](https://packages.ubuntu.com/impish/libreoffice-ogltrans) | | Transitional package for libreoffice-ogltrans. **Transitional packages are not needed**. |
| [~~libreoffice-pdfimport~~](https://packages.ubuntu.com/impish/libreoffice-pdfimport) | | Transitional package for PDF Import component for LibreOffice. **Transitional packages are not needed**. |
| [~~libreoffice-style-breeze~~](https://packages.ubuntu.com/impish/libreoffice-style-breeze) | | Office productivity suite -- Breeze symbol style. **KDE is not supported, so it is not used by most people**. |
| [libwmf0.2-7-gtk](https://packages.ubuntu.com/impish/libwmf0.2-7-gtk) | libwmf0.2-7-gtk | Windows metafile conversion library. **Moved from `custom-desktop-minimal`, as it is used by LibreOffice**. |
| [~~transmission-gtk~~](https://packages.ubuntu.com/impish/transmission-gtk) | [qbittorrent](https://packages.ubuntu.com/impish/qbittorrent) | Bittorrent client based on libtorrent-rasterbar with a Qt5 GUI. **Transmission is not supported, as it is buggy and lacks several features**. **qBittorrent is used instead, as it is one of the best torrent clients ever**. |
| | [vlc](https://packages.ubuntu.com/impish/vlc) | Multimedia player and streamer. **It is more feature-rich than Totem, but cannot replace it since Totem supports more codec formats**. **In the future only one of them should be used**. |

There are groups of packages that originally belonged to the `ubuntu-desktop` metapackage but are just suggested by `custom-desktop`. Their removal is optional, depending on whether or not they are necessary.

#### Gaming

| ubuntu-desktop | Description |
|----------------|-------------|
| [aisleriot](https://packages.ubuntu.com/impish/aisleriot) | GNOME solitaire card game collection. |
| [gnome-mahjongg](https://packages.ubuntu.com/impish/gnome-mahjongg) | Classic Eastern tile game for GNOME. |
| [gnome-mines](https://packages.ubuntu.com/impish/gnome-mines) | Popular minesweeper puzzle game for GNOME. |
| [gnome-sudoku](https://packages.ubuntu.com/impish/gnome-sudoku) | Sudoku puzzle game for GNOME. |

#### GNOME extras

| ubuntu-desktop | Description |
|----------------|-------------|
| [cheese](https://packages.ubuntu.com/impish/cheese) | Tool to take pictures and videos from your webcam. |
| [simple-scan](https://packages.ubuntu.com/impish/simple-scan) | Simple Scanning Utility. |

#### Email

| ubuntu-desktop | Description |
|----------------|-------------|
| [thunderbird](https://packages.ubuntu.com/impish/thunderbird) | Email, RSS and newsgroup client with integrated spam filter. |
| [thunderbird-gnome-support](https://packages.ubuntu.com/impish/thunderbird-gnome-support) | Email, RSS and newsgroup client - GNOME support. |

#### Miscellaneous

| ubuntu-desktop | Description |
|----------------|-------------|
| [branding-ubuntu](https://packages.ubuntu.com/impish/branding-ubuntu) | Replacement artwork with Ubuntu branding. |
| [usb-creator-gtk](https://packages.ubuntu.com/impish/usb-creator-gtk) | Create a startup disk using a CD or disc image (for GNOME). |

#### Remote desktop

| ubuntu-desktop | Description |
|----------------|-------------|
| [gnome-remote-desktop](https://packages.ubuntu.com/impish/gnome-remote-desktop) | Remote desktop daemon for GNOME using PipeWire. |
| [remmina](https://packages.ubuntu.com/impish/remmina) | GTK+ Remote Desktop Client. |

## Building
To build the metapackages you need to install [`equivs`](https://packages.ubuntu.com/impish/equivs):
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
