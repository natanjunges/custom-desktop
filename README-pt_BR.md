# Custom Desktop
O sistema desktop Ubuntu customizado.  
Copyright (C) 2021, 2022  Natan Junges &lt;natanajunges@gmail.com&gt;

Custom Desktop é um software livre: você pode redistribuí-lo e/ou  
modificá-lo sob os termos da Licença Pública Geral GNU, conforme  
publicado pela Free Software Foundation, seja a versão 3 da Licença  
ou qualquer versão posterior.

Custom Desktop é distribuído na esperança de que seja útil,  
mas SEM QUALQUER GARANTIA; sem a garantia implícita de  
COMERCIALIZAÇÃO OU ADEQUAÇÃO A UM DETERMINADO PROPÓSITO. Veja a  
Licença Pública Geral GNU para obter mais detalhes.

Você deve ter recebido uma cópia da Licença Pública Geral GNU  
junto com Custom Desktop. Se não, veja &lt;https://www.gnu.org/licenses/&gt;.

Substitui os metapacotes desktop originais do Ubuntu 21.10 ([`ubuntu-desktop-minimal`](https://packages.ubuntu.com/impish/ubuntu-desktop-minimal) e [`ubuntu-desktop`](https://packages.ubuntu.com/impish/ubuntu-desktop)). **Tenha em mente que eles também são usados para ajudar a garantir atualizações corretamente, então é recomendado que eles não sejam removidos**. **Apenas faça isto se você sabe o que está fazendo, e continue a seu próprio risco**. Para evitar quaisquer problemas, é recomendado instalá-los em uma nova instalação do Ubuntu 21.10.

## Como usar
### Instalar
Baixe os arquivos `.deb` da [página de lançamentos](https://github.com/natanjunges/custom-desktop/releases) ou [construa-os](#Construindo) você mesmo. Então abra o terminal no caminho onde os arquivos `.deb` estão.

Instale `custom-desktop-minimal`:
```shell
sudo apt install ./custom-desktop-minimal_*_all.deb
```

Se você quiser apenas os pacotes no conjunto mínimo, instale `custom-desktop` sem as recomendações:
```shell
sudo apt install --no-install-recommends ./custom-desktop_*_all.deb
```

Se, em vez disso, você quiser todos os pacotes, instale `custom-desktop` com as recomendações:
```shell
sudo apt install ./custom-desktop_*_all.deb
```

Agora é a hora de remover os metapacotes originais do Ubuntu:
```shell
sudo apt purge ubuntu-desktop ubuntu-desktop-minimal
```

Adicione o repositório Flathub ao flatpak:
```shell
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

Encerre a sessão e entre novamente, mas na sessão GNOME (Wayland) em vez de a sessão Ubuntu.

Adicione um perfil customizado user para dconf/gsettings:
```shell
sudo bash -c "echo user-db:user > /etc/dconf/profile/user"
sudo bash -c "echo system-db:local >> /etc/dconf/profile/user"
sudo mkdir /etc/dconf/db/local.d
```

Mude os temas de ícones e cursor para Yaru:
```shell
sudo bash -c "echo [org/gnome/desktop/interface] > /etc/dconf/db/local.d/01-custom-desktop"
sudo bash -c "echo icon-theme=\'Yaru\' >> /etc/dconf/db/local.d/01-custom-desktop"
sudo bash -c "echo cursor-theme=\'Yaru\' >> /etc/dconf/db/local.d/01-custom-desktop"
sudo dconf update
```

Para cada usuário no sistema, execute:
```shell
gsettings reset org.gnome.desktop.interface icon-theme
gsettings reset org.gnome.desktop.interface cursor-theme
```

Substitua os favoritos para `snap:firefox` e `snap:snap-store` com os para `firefox` e `gnome-software`, respectivamente:
```shell
sudo bash -c "echo [org/gnome/shell] >> /etc/dconf/db/local.d/01-custom-desktop"
sudo bash -c "echo \"favorite-apps=\$(gsettings get org.gnome.shell favorite-apps | sed \"s/firefox_firefox/firefox/; s/snap-store_ubuntu-software/org.gnome.Software/\")\" >> /etc/dconf/db/local.d/01-custom-desktop"
sudo dconf update
```

Para cada usuário no sistema, faça o seguinte:
- Se você quiser preservar as customizações feitas aos favoritos, execute:
```shell
gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/firefox_firefox/firefox/; s/snap-store_ubuntu-software/org.gnome.Software/")"
```
- Se em vez disso você quiser redefini-los para os valores padrão (ex. em uma nova instalação), execute:
```shell
gsettings reset org.gnome.shell favorite-apps
```

Encerre a sessão e entre novamente na sessão GNOME (Wayland) para aplicar as mudanças.

Se você não está fazendo isto em uma nova instalação, você pode querer substituir os snaps instalados com os seus flatpaks equivalentes: [popey/unsnap](https://github.com/popey/unsnap). **Tenha em mente que esta ferramenta ainda está em estágio "pré-alfa", e pode não funcionar como desejado**. **Você pode [contribuir](https://github.com/popey/unsnap#contributions) testando-a e relatando bugs ou flatpaks faltando**. Apenas os scripts gerados `00-backup` e `03-install-flatpaks` são exigidos que sejam executados, já que o resto já é feito aqui. `snap:firefox` já é substituído pelo pacote deb nativo, então você deve removê-lo do script `03-install-flatpaks` gerado.

Remova os pacotes que permaneram (você também pode querer remover `fonts-opensymbol`, `gnome-disk-utility` e `libwmf0.2-7-gtk` se você apenas quiser os pacotes no conjunto mínimo). Se você quiser remover qualquer um dos [pacotes sugeridos](#Detalhes), adicione-os ao primeiro comando:
```shell
sudo apt purge dmz-cursor-theme gnome-accessibility-themes gnome-session-canberra gnome-shell-extension-desktop-icons-ng gnome-shell-extension-ubuntu-dock gstreamer1.0-pulseaudio ibus-gtk libreoffice-ogltrans libreoffice-pdfimport libreoffice-style-breeze libu2f-udev snapd transmission-gtk ubuntu-session xcursor-themes xorg yaru-theme-gnome-shell yaru-theme-gtk yaru-theme-sound
sudo apt autoremove --purge
```

### Remover
Reinstale `ubuntu-desktop-minimal`:
```shell
sudo apt install ubuntu-desktop-minimal
```

Se você quiser apenas os pacotes no conjunto mínimo, reinstale `ubuntu-desktop` sem as recomendações:
```shell
sudo apt install --no-install-recommends ubuntu-desktop
```

Se, em vez disso, você quiser todos os pacotes, reinstale `ubuntu-desktop` com as recomendações:
```shell
sudo apt install ubuntu-desktop
```

Agora é a hora de remover os metapacotes customizados:
```shell
sudo apt purge custom-desktop custom-desktop-minimal
```

Remova o perfil customizado de dconf/gsettings:
```shell
sudo rm /etc/dconf/db/local.d/01-custom-desktop
sudo rm -r /etc/dconf/db/local.d
sudo rm /etc/dconf/profile/user
sudo dconf update
```

Encerre a sessão e entre novamente, mas na sessão Ubuntu (a sessão padrão é Wayland, mas você também pode usar a sessão X) em vez de a sessão GNOME.

Para cada usuário no sistema, execute:
```shell
gsettings reset org.gnome.desktop.interface icon-theme
gsettings reset org.gnome.desktop.interface cursor-theme
```

Reinstale `snap:snap-store` e `snap:firefox`:
```shell
sudo snap install snap-store firefox
```

Para cada usuário no sistema, faça o seguinte:
- Se você quiser preservar as customizações feitas aos favoritos, execute:
```shell
gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed "s/firefox/firefox_firefox/; s/org.gnome.Software/snap-store_ubuntu-software/")"
```
- Se em vez disso você quiser redefini-los para os valores padrão, execute:
```shell
gsettings reset org.gnome.shell favorite-apps
```

Encerre a sessão e entre novamente na sessão Ubuntu para aplicar as mudanças.

Remova os flatpaks que possam ter sido instalados:
```shell
sudo flatpak remove --all
```

Remova os pacotes que permaneceram. Se você quiser manter qualquer um desses pacotes, remova-os do primeiro comando e adicione-os ao segundo:
```shell
sudo apt purge firefox flatpak gnome-session gnome-software gnome-software-plugin-flatpak qbittorrent vlc
sudo apt-mark manual <pacotes para manter> # Pode ser omitido se você não quiser manter nenhum pacote
sudo apt autoremove --purge
```

## Tema GNOME Shell e GTK sugerido
[WhiteSur](https://github.com/vinceliuice/WhiteSur-gtk-theme): Tema estilo MacOS Big Sur para desktops Gnome.

Instale-o com as opções sugeridas:
```shell
./install.sh -o solid -a alt -i ubuntu -m --right
```

Para aplicar os temas você pode precisar das extensões User Themes ou Night Theme Switcher do GNOME Shell.

## Extensões GNOME Shell sugeridas
- [Awesome Tiles](https://extensions.gnome.org/extension/4702/awesome-tiles/): Encaixe janelas usando atalhos do teclado;
- [Caffeine](https://extensions.gnome.org/extension/517/caffeine/): Desabilita a proteção de tela e suspensão automática;
- [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/): Esta extensão move o dash para fora da visão geral transformando-o em uma dock para um lançamento mais fácil de aplicações e uma troca mais rápida entre janelas e desktops;
- [GSConnect](https://extensions.gnome.org/extension/1319/gsconnect/): GSConnect é uma implementação completa do KDE Connect especialmente para o GNOME Shell com integração para Nautilus, Chrome e Firefox;
- [Night Theme Switcher](https://extensions.gnome.org/extension/2236/night-theme-switcher/): Deixe seu desktop suave para os olhos, dia e noite;
- [Tiling Assistant](https://extensions.gnome.org/extension/3733/tiling-assistant/): Expanda o encaixe de 2 colunas do GNOME e adicione um popup inspirado na assistência de encaixe de janelas do Windows;
- [User Themes](https://extensions.gnome.org/extension/19/user-themes/): Carrega temas do shell do diretório do usuário.

Para instalar as extensões você pode precisar da extensão GNOME Shell integration do Firefox.

Awesome Tiles e Tiling Assistant fazem coisas similares, e podem não funcionar bem juntas. Qual delas você escolher é apenas questão de gosto.

Tanto Night Theme Switcher quanto User Themes te permitem mudar o tema do GNOME Shell. Qual delas você escolher é apenas questão de quais funcionalidades extra você quiser.

## Extensões Firefox sugeridas
- [Bitwarden - Free Password Manager](https://addons.mozilla.org/firefox/addon/bitwarden-password-manager/): Um gerenciador de senhas seguro e gratuito para todos os seus dispositivos;
- [GNOME Shell integration](https://addons.mozilla.org/firefox/addon/gnome-shell-integration/): Esta extensão provê integração com o GNOME Shell e o repositório de extensões correspondente;
    - Primeiro você precisa instalar `chrome-gnome-shell`:
```shell
sudo apt install chrome-gnome-shell
```
- [GSConnect](https://addons.mozilla.org/firefox/addon/gsconnect/): Compartilhe links com o GSConnect, direcione para o navegador ou por SMS;
    - Primeiro você precisa instalar a extensão GSConnect do GNOME Shell.
- [uBlock Origin](https://addons.mozilla.org/firefox/addon/ublock-origin/): Finalmente, um bloqueador de conteúdo eficiente e de amplo-espectro.

## Detalhes
### custom-desktop-minimal
Estes são os pacotes que são adicionados ao, removidos do ou substituídos no metapacote `custom-desktop-minimal`:

| ubuntu-desktop-minimal | custom-desktop-minimal | Descrição |
|------------------------|------------------------|-----------|
| [~~dmz-cursor-theme~~](https://packages.ubuntu.com/impish/dmz-cursor-theme) | | Tema de cursor escalável e de estilo neutro. **Isto nã deveria estar no metapacote mínimo, muito menos como uma dependência, já que não é usado pela maioria das pessoas**. **O tema Yaru é usado em vez disso**. |
| [~~gnome-accessibility-themes~~](https://packages.ubuntu.com/impish/gnome-accessibility-themes) | | Tema GTK+ 2 e ícones de alto contraste. **GTK+ 2 não é suportado**. |
| [~~gnome-disk-utility~~](https://packages.ubuntu.com/impish/gnome-disk-utility) | | Gerencia e configura mídia e drives de disco. **Movido para `custom-desktop`, já que não é considerado mínimo**. |
| [~~gnome-session-canberra~~](https://packages.ubuntu.com/impish/gnome-session-canberra) | | Eventos de som de login e logout da sessão GNOME. **Isto não deveria estar no metapacote mínimo, muito menos como uma dependência, já que a maioria das pessoas não liga para sons**. |
| [~~gnome-shell-extension-desktop-icons-ng~~](https://packages.ubuntu.com/impish/gnome-shell-extension-desktop-icons-ng) | | Suporte a ícones no desktop para o GNOME Shell. **Desktop ativo não é suportado**. |
| [~~gnome-shell-extension-ubuntu-dock~~](https://packages.ubuntu.com/impish/gnome-shell-extension-ubuntu-dock) | | Dock Ubuntu para o GNOME Shell. **A dock padrão ou o dash-to-dock completo é preferido**. |
| [~~gstreamer1.0-pulseaudio~~](https://packages.ubuntu.com/impish/gstreamer1.0-pulseaudio) | | Plugin GStreamer para PulseAudio (pacote transicional). **Pacotes transicionais não são necessários**. |
| [~~ibus-gtk~~](https://packages.ubuntu.com/impish/ibus-gtk) | | Intelligent Input Bus - suporte GTK2. **GTK+ 2 não é suportado**. |
| [~~libu2f-udev~~](https://packages.ubuntu.com/impish/libu2f-udev) | | Universal 2nd Factor (U2F) - pacote transicional. **Pacotes transicionais não são necessários**. |
| [~~snap:firefox~~](https://snapcraft.io/firefox) | [firefox](https://packages.ubuntu.com/impish/firefox) | Navegador web seguro e fácil da Mozilla. **Snap não é suportado**. |
| [~~snap:snap-store~~](https://snapcraft.io/snap-store) | [gnome-software](https://packages.ubuntu.com/impish/gnome-software) | Central de Software do GNOME. **Snap não é suportado e a GNOME Software suporta pacotes deb nativos, snap e flatpak, enquanto a Snap Store apenas suporta snap**. |
| | [gnome-software-plugin-flatpak](https://packages.ubuntu.com/impish/gnome-software-plugin-flatpak) | Suporte a flatpak para a GNOME Software. **Exigido para que a GNOME Software suporte flatpak**. |
| [~~snapd~~](https://packages.ubuntu.com/impish/snapd) | [flatpak](https://packages.ubuntu.com/impish/flatpak) | Infraestrutura de distribuição de aplicações para apps de desktop. **Snap não é suportado**. **Flatpak é usado em vez disso**. |
| [~~ubuntu-session~~](https://packages.ubuntu.com/impish/ubuntu-session) | [gnome-session](https://packages.ubuntu.com/impish/gnome-session) | Gerenciador de Sessão GNOME - sessão GNOME 3. **A sessão customizada Ubuntu não é suportada**. **A sessão padrão GNOME é usada em vez disso**. |
| [~~xcursor-themes~~](https://packages.ubuntu.com/impish/xcursor-themes) | | Temas de cursor X base. **X não é suportado e isto não deveria estar no metapacote mínimo, já que não é usado pela maioria das pessoas**. **O tema Yaru é usado em vez disso**. |
| [~~xorg~~](https://packages.ubuntu.com/impish/xorg) | | Sistema de janelas X X.Org. **X não é suportado**. **Wayland é usado em vez disso**. |
| [~~yaru-theme-gnome-shell~~](https://packages.ubuntu.com/impish/yaru-theme-gnome-shell) | | Tema desktop Yaru do GNOME Shell da Comunidade Ubuntu. **O tema padrão Adwaita é preferido**. |
| [~~yaru-theme-gtk~~](https://packages.ubuntu.com/impish/yaru-theme-gtk) | | Tema GTK Yaru da Comunidade Ubuntu. **O tema padrão Adwaita é preferido**. |
| [~~yaru-theme-sound~~](https://packages.ubuntu.com/impish/yaru-theme-sound) | | Tema de som Yaru da Comunidade Ubuntu. **Isto não deveria estar no metapacote mínimo, já que a maioria das pessoas não liga para sons**. |

Há grupos de pacotes que originalmente pertenciam ao metapacote `ubuntu-desktop-minimal`, mas que são apenas sugeridos pelo `custom-desktop-minimal`. A sua remoção é opcional, dependendo de eles serem ou não necessários.

#### Accessibilidade

| Função | ubuntu-desktop-minimal | Descrição |
|--------|------------------------|-----------|
| | [at-spi2-core](https://packages.ubuntu.com/impish/at-spi2-core) | Interface de Provedor de Serviços de Tecnologia Assistiva (dbus principal). |
| | [libatk-adaptor](https://packages.ubuntu.com/impish/libatk-adaptor) | Ponte do toolkit AT-SPI 2. |
| Braille | [brltty](https://packages.ubuntu.com/impish/brltty) | Software de acessibilidade para pessoa cega usando uma linha Braille. |
| Mouse | [mousetweaks](https://packages.ubuntu.com/impish/mousetweaks) | Melhorias de acessibilidade de mouse para a área de trabalho GNOME. |
| Leitor de Tela | [orca](https://packages.ubuntu.com/impish/orca) | Leitor de telas scriptável. |
| Leitor de Tela | [speech-dispatcher](https://packages.ubuntu.com/impish/speech-dispatcher) | Interface comum para sintetizadores de fala. |

#### Avahi/NSS

| ubuntu-desktop-minimal | Descrição |
|------------------------|-----------|
| [avahi-autoipd](https://packages.ubuntu.com/impish/avahi-autoipd) | Daemon de configuração de endereço de rede Avahi IPv4LL. |
| [avahi-daemon](https://packages.ubuntu.com/impish/avahi-daemon) | Daemon Avahi mDNS/DNS-SD. |
| [libnss-mdns](https://packages.ubuntu.com/impish/libnss-mdns) | Módulo NSS para resolução de nomes DNS Multicast. |

#### Bluetooth

| Função | ubuntu-desktop-minimal | Descrição |
|--------|------------------------|-----------|
| | [bluez](https://packages.ubuntu.com/impish/bluez) | Ferramentas e daemons Bluetooth. |
| | [gnome-bluetooth](https://packages.ubuntu.com/impish/gnome-bluetooth) | Ferramentas bluetooth do GNOME. |
| | [pulseaudio-module-bluetooth](https://packages.ubuntu.com/impish/pulseaudio-module-bluetooth) | Módulo Bluetooth para o servidor de som PulseAudio. |
| | [rfkill](https://packages.ubuntu.com/impish/rfkill) | Ferramenta para habilitar e desabilitar dispositivos sem fio. **Este pacote também é usado por dispositivos Wi-Fi**. **Ele deveria ser removido apenas se tanto Bluetooth quanto Wi-Fi não forem usados**. |
| Impressão | [bluez-cups](https://packages.ubuntu.com/impish/bluez-cups) | Driver de impressora bluetooth para CUPS. |

`bluez-cups` é repetido em [Impressão](#Impressão) para facilitar a visualização.

`rfkill` é repetido em [Wi-Fi](#Wi-Fi) para facilitar a visualização.

#### Impressão digital

| ubuntu-desktop-minimal | Descrição |
|------------------------|-----------|
| [libpam-fprintd](https://packages.ubuntu.com/impish/libpam-fprintd) | Módulo PAM para autenticação de impressão digital através do fprintd. |

#### Jogar

| ubuntu-desktop-minimal | Descrição |
|------------------------|-----------|
| [gamemode](https://packages.ubuntu.com/impish/gamemode) | Otimize a performance de um sistema Linux sob demanda. |

#### Extras GNOME

| ubuntu-desktop-minimal | Descrição |
|------------------------|-----------|
| [gnome-characters](https://packages.ubuntu.com/impish/gnome-characters) | Aplicação de mapa de caracteres. |
| [gnome-font-viewer](https://packages.ubuntu.com/impish/gnome-font-viewer) | Visualizador de fontes para Gnome. |
| [gnome-logs](https://packages.ubuntu.com/impish/gnome-logs) | Visualizador para o journal do systemd. |

####  Fontes de linguagens

| Função | ubuntu-desktop-minimal | Descrição |
|--------|------------------------|-----------|
| Árabe | [fonts-kacst-one](https://packages.ubuntu.com/impish/fonts-kacst-one) | Fonte TrueType desenhada para a língua árabe. |
| Birmanês | [fonts-sil-padauk](https://packages.ubuntu.com/impish/fonts-sil-padauk) | Fonte TrueType Unicode birmanesa com suporte a OpenType e Graphite. |
| CJK | [fonts-noto-cjk](https://packages.ubuntu.com/impish/fonts-noto-cjk) | Famílias de fontes "No Tofu" com grande cobertura Unicode (CJK regular e negrito). |
| Etíope | [fonts-sil-abyssinica](https://packages.ubuntu.com/impish/fonts-sil-abyssinica) | Fonte Unicode para a escrita etíope. |
| Indiano | [fonts-indic](https://packages.ubuntu.com/impish/fonts-indic) | Meta pacote para instalar todas as fontes da língua indiana. |
| Khmer | [fonts-khmeros-core](https://packages.ubuntu.com/impish/fonts-khmeros-core) | Fontes Unicode KhmerOS para a língua khmer do Camboja. |
| Lao | [fonts-lao](https://packages.ubuntu.com/impish/fonts-lao) | Fonte TrueType para a língua lao. |
| Cingalês | [fonts-lklug-sinhala](https://packages.ubuntu.com/impish/fonts-lklug-sinhala) | Fonte Unicode cingalês pelo Lanka Linux User Group. |
| Tailandês | [fonts-thai-tlwg](https://packages.ubuntu.com/impish/fonts-thai-tlwg) | Fontes tailandesas mantidas pelo TLWG (metapacote). |
| Tibetano | [fonts-tibetan-machine](https://packages.ubuntu.com/impish/fonts-tibetan-machine) | Fonte para tibetano, dzongkha e ladakhi (OpenType Unicode). |

#### Hardware legado

| ubuntu-desktop-minimal | Descrição |
|------------------------|-----------|
| [pcmciautils](https://packages.ubuntu.com/impish/pcmciautils) | Utilitários PCMCIA para o Linux 2.6. |
| [inputattach](https://packages.ubuntu.com/impish/inputattach) | Utilitário para conectar periféricos seriais ao subsistema de entrada. |

#### Suporte LibreOffice

| ubuntu-desktop-minimal | Descrição |
|------------------------|-----------|
| [fonts-opensymbol](https://packages.ubuntu.com/impish/fonts-opensymbol) | Fonte OpenSymbol TrueType. |
| [libwmf0.2-7-gtk](https://packages.ubuntu.com/impish/libwmf0.2-7-gtk) | Biblioteca de conversão de Windows metafile. |

`fonts-opensymbol` e `libwmf0.2-7-gtk` são movidos para `custom-desktop`, já que eles são usados por LibreOffice.

#### Miscelânea

| ubuntu-desktop-minimal | Descrição |
|------------------------|-----------|
| [app-install-data-partner](https://packages.ubuntu.com/impish/app-install-data-partner) | Instalador de aplicativos (arquivos de dados para aplicações/repositorios parceiros). |
| [bc](https://packages.ubuntu.com/impish/bc) | Linguagem de calculadora de precisão arbitrária bc do GNU. |
| [ghostscript-x](https://packages.ubuntu.com/impish/ghostscript-x) | Interpretador para a linguagem PostScript e para PDF - suporte X11. |
| [gvfs-fuse](https://packages.ubuntu.com/impish/gvfs-fuse) | Sistema de arquivos virtual em espaço de usuário - servidor fuse. |
| [ibus-table](https://packages.ubuntu.com/impish/ibus-table) | Motor de tabelas para IBus. |
| [memtest86+](https://packages.ubuntu.com/impish/memtest86+) | Testador de memória completa em modo real. |
| [nautilus-sendto](https://packages.ubuntu.com/impish/nautilus-sendto) | Mandar arquivos via e-mail facilmente de dentro do Nautilus. |
| [nautilus-share](https://packages.ubuntu.com/impish/nautilus-share) | Extensão do Nautilus para compartilhar diretórios usando o Samba. |

#### Impressão

| Função | ubuntu-desktop-minimal | Descrição |
|--------|------------------------|-----------|
| | [cups](https://packages.ubuntu.com/impish/cups) | Common UNIX Printing System(R) - suporte a PPD/driver, interface web. |
| | [cups-bsd](https://packages.ubuntu.com/impish/cups-bsd) | Common UNIX Printing System UNIX (tm) - comandos BSD. |
| | [cups-client](https://packages.ubuntu.com/impish/cups-client) | Common UNIX Printing System(tm) - programas clientes (SysV). |
| | [cups-filters](https://packages.ubuntu.com/impish/cups-filters) | Filtros CUPS OpenPrinting - Pacote principal. |
| Bluetooth | [bluez-cups](https://packages.ubuntu.com/impish/bluez-cups) | Driver de impressora bluetooth para CUPS. |
| Brother/Lenovo | [printer-driver-brlaser](https://packages.ubuntu.com/impish/printer-driver-brlaser) | Driver de impressora para (algumas) impressoras laser Brother. |
| Brother | [printer-driver-ptouch](https://packages.ubuntu.com/impish/printer-driver-ptouch) | Driver de impressão para impressoras de etiqueta Brother P-touch. |
| Foomatic | [foomatic-db-compressed-ppds](https://packages.ubuntu.com/impish/foomatic-db-compressed-ppds) | Suporte a impressoras OpenPrinting - PPDs comprimidos derivados da base de dados. |
| HP | [hplip](https://packages.ubuntu.com/impish/hplip) | Sistema de Imagem e Impressão HP Linux (HPLIP). |
| HP | [printer-driver-pnm2ppa](https://packages.ubuntu.com/impish/printer-driver-pnm2ppa) | Driver de impressão para impressoras HP-GDI. |
| HP | [printer-driver-pxljr](https://packages.ubuntu.com/impish/printer-driver-pxljr) | Driver de impressão para HP Color LaserJet 35xx/36xx. |
| Kodak | [printer-driver-c2esp](https://packages.ubuntu.com/impish/printer-driver-c2esp) | Driver de impressora para a série jato de tinta Kodak ESP AiO color. |
| Konica Minolta | [printer-driver-m2300w](https://packages.ubuntu.com/impish/printer-driver-m2300w) | Driver de impressão para impressoras laser coloridas Minolta magicolor 2300W/2400W. |
| Konica Minolta | [printer-driver-min12xxw](https://packages.ubuntu.com/impish/printer-driver-min12xxw) | Driver de impressão para a KonicaMinolta PagePro 1[234]xxW. |
| PostScript | [openprinting-ppds](https://packages.ubuntu.com/impish/openprinting-ppds) | Suporte para impressora OpenPrinting - arquivos PPD para PostScript. |
| Ricoh Aficio | [printer-driver-sag-gdi](https://packages.ubuntu.com/impish/printer-driver-sag-gdi) | Driver de impressão para Ricoh Aficio SP 1000s e SP 1100s. |
| Samsung/Xerox | [printer-driver-splix](https://packages.ubuntu.com/impish/printer-driver-splix) | Driver para as impressoras laser Samsung e Xerox SPL2 e SPLc. |
| Zenographics ZjStream | [printer-driver-foo2zjs](https://packages.ubuntu.com/impish/printer-driver-foo2zjs) | Driver de impressora para impressoras baseadas em ZjStream. |

`bluez-cups` é repetido em [Bluetooth](#Bluetooth) para facilitar a visualização.

#### VM

| ubuntu-desktop-minimal | Descrição |
|------------------------|-----------|
| [spice-vdagent](https://packages.ubuntu.com/impish/spice-vdagent) | Agente Spice para Linux. |

#### Wi-Fi

| ubuntu-desktop-minimal | Descrição |
|------------------------|-----------|
| [rfkill](https://packages.ubuntu.com/impish/rfkill) | Ferramenta para habilitar e desabilitar dispositivos sem fio. **Este pacote também é usado por dispositivos Bluetooth**. **Ele deveria ser removido apenas se tanto Bluetooth quanto Wi-Fi não forem usados**. |
| [wireless-tools](https://packages.ubuntu.com/impish/wireless-tools) | Ferramentas p/ manipular as Extensões Sem-fio do Linux (Linux Wireless Extensions). |

`rfkill` é repetido em [Bluetooth](#Bluetooth) para facilitar a visualização.

### custom-desktop
Estes são os pacotes que são adicionados ao, removidos do ou substituídos no metapacote `custom-desktop`:

| ubuntu-desktop | custom-desktop | Descrição |
|----------------|----------------|-----------|
| [fonts-opensymbol](https://packages.ubuntu.com/impish/fonts-opensymbol) | fonts-opensymbol | Fonte OpenSymbol TrueType. **Movido do `custom-desktop-minimal`, já que é usado pelo LibreOffice**. |
| [gnome-disk-utility](https://packages.ubuntu.com/impish/gnome-disk-utility) | gnome-disk-utility | Gerencia e configura mídia e drives de disco. **Movido do `custom-desktop-minimal`, já que não é considerado mínimo**. |
| [~~libreoffice-ogltrans~~](https://packages.ubuntu.com/impish/libreoffice-ogltrans) | | Pacote transicional para libreoffice-ogltrans. **Pacotes transicionais não são necessários**. |
| [~~libreoffice-pdfimport~~](https://packages.ubuntu.com/impish/libreoffice-pdfimport) | | Pacote transicional para o componente de Importar PDF para LibreOffice. **Pacotes transicionais não são necessários**. |
| [~~libreoffice-style-breeze~~](https://packages.ubuntu.com/impish/libreoffice-style-breeze) | | Suíte de produtividade Office -- Estilo de símbolos Breeze. **KDE não é suportado, então não é usado pela maioria das pessoas**. |
| [libwmf0.2-7-gtk](https://packages.ubuntu.com/impish/libwmf0.2-7-gtk) | libwmf0.2-7-gtk | Biblioteca  de conversão de Windows metafile. **Movido do `custom-desktop-minimal`, já que é usado pelo LibreOffice**. |
| [~~transmission-gtk~~](https://packages.ubuntu.com/impish/transmission-gtk) | [qbittorrent](https://packages.ubuntu.com/impish/qbittorrent) | Cliente bittorrent baseado na libtorrent-rasterbar com uma GUI Qt5. **Transmission não é suportado, já que é bugado e falta várias funcionalidades**. **qBittorrent é usado em vez disso, já que é um dos melhores clientes torrent já feitos**. |
| | [vlc](https://packages.ubuntu.com/impish/vlc) | Reprodutor e gerador de fluxo multimídia. **É mais rico em funcionalidades que o Totem, mas não pode substituí-lo já que o Totem suporta mais formatos de codec**. **No futuro apenas um dos dois deveria ser usado**. |

Há grupos de pacotes que originalmente pertenciam ao metapacote `ubuntu-desktop`, mas que são apenas sugeridos pelo `custom-desktop`. A sua remoção é opcional, dependendo de eles serem ou não necessários.

#### Jogar

| ubuntu-desktop | Descrição |
|----------------|-----------|
| [aisleriot](https://packages.ubuntu.com/impish/aisleriot) | Coleção de jogos tipo Paciência para o GNOME. |
| [gnome-mahjongg](https://packages.ubuntu.com/impish/gnome-mahjongg) | Jogo de peças oriental clássico para GNOME. |
| [gnome-mines](https://packages.ubuntu.com/impish/gnome-mines) | Jogo de quebra-cabeças popular campo minado para o GNOME. |
| [gnome-sudoku](https://packages.ubuntu.com/impish/gnome-sudoku) | Jogo de raciocínio Sudoku para GNOME. |

#### Extras GNOME

| ubuntu-desktop | Descrição |
|----------------|-----------|
| [cheese](https://packages.ubuntu.com/impish/cheese) | Ferramenta para capturar fotos e vídeos a partir da webcam. |
| [simple-scan](https://packages.ubuntu.com/impish/simple-scan) | Utilitário Simples de Escaneamento (Scanning). |

#### Email

| ubuntu-desktop | Descrição |
|----------------|-----------|
| [thunderbird](https://packages.ubuntu.com/impish/thunderbird) | Cliente de email, RSS e grupo de notícias com filtro de spam integrado. |
| [thunderbird-gnome-support](https://packages.ubuntu.com/impish/thunderbird-gnome-support) | Cliente de email, RSS e grupo de notícias - suporte GNOME. |

#### Miscelânea

| ubuntu-desktop | Descrição |
|----------------|-----------|
| [branding-ubuntu](https://packages.ubuntu.com/impish/branding-ubuntu) | Substituição arte com Ubuntu branding. |
| [usb-creator-gtk](https://packages.ubuntu.com/impish/usb-creator-gtk) | Crie um disco de inicialização usando um CD ou imagem de disco (para GNOME). |

#### Desktop remoto

| ubuntu-desktop | Descrição |
|----------------|-----------|
| [gnome-remote-desktop](https://packages.ubuntu.com/impish/gnome-remote-desktop) | Daemon de desktop remoto para GNOME usando PipeWire. |
| [remmina](https://packages.ubuntu.com/impish/remmina) | Cliente de área de trabalho remota em GTK+. |

## Construindo
Para construir os metapacotes você precisa instalar [`equivs`](https://packages.ubuntu.com/impish/equivs):
```shell
sudo apt install equivs
```

Construa todos os pacotes com:
```shell
make all
```

Ou construa um pacote específico com um desses comandos:
```shell
make custom-desktop-minimal
make custom-desktop
```
