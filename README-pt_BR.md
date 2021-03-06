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

Substitui os metapacotes desktop originais do Ubuntu 22.04 ([`ubuntu-desktop-minimal`](https://packages.ubuntu.com/jammy/ubuntu-desktop-minimal) e [`ubuntu-desktop`](https://packages.ubuntu.com/jammy/ubuntu-desktop)). **Tenha em mente que eles também são usados para ajudar a garantir atualizações corretamente, então é recomendado que eles não sejam removidos**. **Apenas faça isto se você sabe o que está fazendo, e continue a seu próprio risco**. Para evitar quaisquer problemas, é recomendado instalá-los em uma nova instalação do Ubuntu 22.04.

## Como usar
### Instalar
Baixe o código-fonte deste projeto da [página de lançamentos](https://github.com/natanjunges/custom-desktop/releases). Extraia-o e abra o terminal na pasta `installer/`. Baixe os arquivos `.deb` da página de lançamentos e salve-os em `installer/build/`. Execute o script principal com:
```shell
./main
```

Qual edição deve ser instalada depende de qual versão do Ubuntu foi instalada. Se a instalação mínima do Ubuntu foi feita, então a edição mínima deve ser instalada. Se, em vez disso, a instalação normal do Ubuntu foi feita, então a edição completa deve ser instalada. Para cada execução do script, selecione a mesma opção.

No menu, selecione "Add repositories and install" (Adicionar repositórios e instalar). Quando a execução terminar, encerre a sessão e entre novamente, mas na sessão GNOME (Wayland) em vez de a sessão Ubuntu.

Reabra o terminal na pasta `installer/` e reexecute o script principal. No menu, selecione "Change icon and cursor theme and favorite apps" (Mudar tema de ícones e cursor e os apps favoritos). Então, para cada usuário no sistema, reabra o terminal na pasta `installer/` e reexecute o script principal. No menu, selecione "Apply changes (per user)" (Aplicar mudanças, por usuário). Se o layout de apps favoritos deve ou não ser preservado depende da preferência do usuário. Em uma nova instalação, ele não deve ser preservado. Quando a execução terminar para cada usuário, encerre a sessão e entre novamente na sessão GNOME (Wayland) para aplicar as mudanças.

Se você não está fazendo isto em uma nova instalação, você pode querer substituir os snaps instalados com os seus flatpaks equivalentes: [popey/unsnap](https://github.com/popey/unsnap). **Tenha em mente que esta ferramenta ainda está em estágio "pré-alfa", e pode não funcionar como desejado**. **Você pode [contribuir](https://github.com/popey/unsnap#contributions) testando-a e relatando bugs ou flatpaks faltando**. Apenas os scripts gerados `00-backup` e `03-install-flatpaks` são exigidos que sejam executados, já que o resto já é feito aqui. [`snap:firefox`](https://snapcraft.io/firefox) já é substituído pelo pacote deb nativo, então você deve removê-lo do script `03-install-flatpaks` gerado.

Reabra o terminal na pasta `installer/` e reexecute o script principal. No menu, selecione "Purge unused packages" (Purgar pacotes não usados). Depois de alguma execução, uma lista é exibida com os pacotes sugeridos para ser purgados. Para decidir quais pacotes manter e quais purgar, consulte a seção [Detalhes](#Detalhes) abaixo. Os pacotes para serem mantidos devem ser descomentados (removendo o prefixo `#`). Salve o arquivo com `Ctrl`+`S` e saia do editor com `Ctrl`+`X` e os pacotes comentados serão purgados. Quando a execução terminar, reinicie o sistema para descarregar completamente os softwares removidos.

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
sudo rm -r /etc/dconf/db/local.d/
sudo rm /etc/dconf/profile/user
sudo dconf update
```

Encerre a sessão e entre novamente, mas na sessão Ubuntu (a sessão padrão é Wayland, mas você também pode usar a sessão X) em vez de a sessão GNOME.

Para cada usuário no sistema, execute:
```shell
gsettings reset org.gnome.desktop.interface icon-theme
gsettings reset org.gnome.desktop.interface cursor-theme
```

Reinstale [`snap:snap-store`](https://snapcraft.io/snap-store) e `snap:firefox`:
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
sudo apt purge firefox flatpak gnome-session gnome-software linuxmint-keyring qbittorrent ubuntu-restricted-extras
sudo apt-mark manual <pacotes para manter> # Pode ser omitido se você não quiser manter nenhum pacote
sudo apt autoremove --purge
```

Remova os repositórios do Linux Mint:
```shell
sudo rm /etc/apt/preferences.d/pin-chromium-firefox
sudo rm /etc/apt/sources.list.d/mint-una.list
sudo apt update
```

## Extensões GNOME Shell sugeridas
- [Awesome Tiles](https://extensions.gnome.org/extension/4702/awesome-tiles/): Encaixe janelas usando atalhos do teclado;
- [Caffeine](https://extensions.gnome.org/extension/517/caffeine/): Desabilita a proteção de tela e suspensão automática;
- [~~Dash to Dock~~](https://extensions.gnome.org/extension/307/dash-to-dock/): Esta extensão move o dash para fora da visão geral transformando-o em uma dock para um lançamento mais fácil de aplicações e uma troca mais rápida entre janelas e desktops (**atualmente não suportada no GNOME 42, enquanto isso [Dash to Dock for COSMIC](https://extensions.gnome.org/extension/5004/dash-to-dock-for-cosmic/) pode ser usada**);
- [GSConnect](https://extensions.gnome.org/extension/1319/gsconnect/): GSConnect é uma implementação completa do KDE Connect especialmente para o GNOME Shell com integração para Nautilus, Chrome e Firefox;
    - Para integrar com o Nautilus, você precisa instalar [`python3-nautilus`](https://packages.ubuntu.com/jammy/python3-nautilus) e [`gir1.2-nautilus-3.0`](https://packages.ubuntu.com/jammy/gir1.2-nautilus-3.0):
```shell
sudo apt install python3-nautilus gir1.2-nautilus-3.0
```
- [Night Theme Switcher](https://extensions.gnome.org/extension/2236/night-theme-switcher/): Deixe seu desktop suave para os olhos, dia e noite;
- [Tiling Assistant](https://extensions.gnome.org/extension/3733/tiling-assistant/): Expanda o encaixe de 2 colunas do GNOME e adicione um popup inspirado na assistência de encaixe de janelas do Windows.

Para instalar as extensões você pode precisar da extensão GNOME Shell integration do Firefox.

Awesome Tiles e Tiling Assistant fazem coisas similares, e podem não funcionar bem juntas. Qual delas você escolher é apenas questão de gosto.

## Extensões Firefox sugeridas
- [Bitwarden - Free Password Manager](https://addons.mozilla.org/firefox/addon/bitwarden-password-manager/): Um gerenciador de senhas seguro e gratuito para todos os seus dispositivos;
- [GNOME Shell integration](https://addons.mozilla.org/firefox/addon/gnome-shell-integration/): Esta extensão provê integração com o GNOME Shell e o repositório de extensões correspondente;
    - Primeiro você precisa instalar [`chrome-gnome-shell`](https://packages.ubuntu.com/jammy/chrome-gnome-shell):
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
| [~~dmz-cursor-theme~~](https://packages.ubuntu.com/jammy/dmz-cursor-theme) | | Tema de cursor escalável e de estilo neutro. **Isto nã deveria estar no metapacote mínimo, muito menos como uma dependência, já que não é usado pela maioria das pessoas**. **O tema Yaru é usado em vez disso**. |
| [~~gnome-accessibility-themes~~](https://packages.ubuntu.com/jammy/gnome-accessibility-themes) | | Tema GTK+ 2 e ícones de alto contraste. **GTK+ 2 não é suportado**. |
| [~~gnome-disk-utility~~](https://packages.ubuntu.com/jammy/gnome-disk-utility) | | Gerencia e configura mídia e drives de disco. **Movido para `custom-desktop`, já que não é considerado mínimo**. |
| [~~gnome-session-canberra~~](https://packages.ubuntu.com/jammy/gnome-session-canberra) | | Eventos de som de login e logout da sessão GNOME. **Isto não deveria estar no metapacote mínimo, muito menos como uma dependência, já que a maioria das pessoas não liga para sons**. |
| [~~gnome-shell-extension-desktop-icons-ng~~](https://packages.ubuntu.com/jammy/gnome-shell-extension-desktop-icons-ng) | | Suporte a ícones no desktop para o GNOME Shell. **Desktop ativo não é suportado**. |
| [~~gnome-shell-extension-ubuntu-dock~~](https://packages.ubuntu.com/jammy/gnome-shell-extension-ubuntu-dock) | | Dock Ubuntu para o GNOME Shell. **A dock padrão ou o dash-to-dock completo é preferido**. |
| [~~gstreamer1.0-pulseaudio~~](https://packages.ubuntu.com/jammy/gstreamer1.0-pulseaudio) | | Plugin GStreamer para PulseAudio (pacote transicional). **Pacotes transicionais não são necessários**. |
| [~~ibus-gtk~~](https://packages.ubuntu.com/jammy/ibus-gtk) | | Intelligent Input Bus - suporte GTK2. **GTK+ 2 não é suportado**. |
| [~~libu2f-udev~~](https://packages.ubuntu.com/jammy/libu2f-udev) | | Universal 2nd Factor (U2F) - pacote transicional. **Pacotes transicionais não são necessários**. |
| [~~snap:firefox~~](https://snapcraft.io/firefox) | [firefox](https://packages.ubuntu.com/jammy/firefox) | Navegador web seguro e fácil da Mozilla. **Snap não é suportado**. |
| [~~snap:snap-store~~](https://snapcraft.io/snap-store) | [gnome-software](https://packages.ubuntu.com/jammy/gnome-software) | Central de Software do GNOME. **Snap não é suportado e a GNOME Software suporta pacotes deb nativos, snap e flatpak, enquanto a Snap Store apenas suporta snap**. |
| [~~snapd~~](https://packages.ubuntu.com/jammy/snapd) | [flatpak](https://packages.ubuntu.com/jammy/flatpak) | Infraestrutura de distribuição de aplicações para apps de desktop. **Snap não é suportado**. **Flatpak é usado em vez disso**. |
| [~~ubuntu-session~~](https://packages.ubuntu.com/jammy/ubuntu-session) | [gnome-session](https://packages.ubuntu.com/jammy/gnome-session) | Gerenciador de Sessão GNOME - sessão GNOME 3. **A sessão customizada Ubuntu não é suportada**. **A sessão padrão GNOME é usada em vez disso**. |
| [~~xcursor-themes~~](https://packages.ubuntu.com/jammy/xcursor-themes) | | Temas de cursor X base. **X não é suportado e isto não deveria estar no metapacote mínimo, já que não é usado pela maioria das pessoas**. **O tema Yaru é usado em vez disso**. |
| [~~xorg~~](https://packages.ubuntu.com/jammy/xorg) | | Sistema de janelas X X.Org. **X não é suportado**. **Wayland é usado em vez disso**. |
| [~~yaru-theme-gnome-shell~~](https://packages.ubuntu.com/jammy/yaru-theme-gnome-shell) | | Tema desktop Yaru do GNOME Shell da Comunidade Ubuntu. **O tema padrão Adwaita é preferido**. |
| [~~yaru-theme-gtk~~](https://packages.ubuntu.com/jammy/yaru-theme-gtk) | | Tema GTK Yaru da Comunidade Ubuntu. **O tema padrão Adwaita é preferido**. |
| [~~yaru-theme-sound~~](https://packages.ubuntu.com/jammy/yaru-theme-sound) | | Tema de som Yaru da Comunidade Ubuntu. **Isto não deveria estar no metapacote mínimo, já que a maioria das pessoas não liga para sons**. |

Há grupos de pacotes que originalmente pertenciam ao metapacote `ubuntu-desktop-minimal`, mas que são apenas sugeridos pelo `custom-desktop-minimal`. A sua remoção é opcional, dependendo de eles serem ou não necessários.

#### Accessibilidade

| Função | ubuntu-desktop-minimal | Descrição |
|--------|------------------------|-----------|
| | [at-spi2-core](https://packages.ubuntu.com/jammy/at-spi2-core) | Interface de Provedor de Serviços de Tecnologia Assistiva (dbus principal). |
| | [libatk-adaptor](https://packages.ubuntu.com/jammy/libatk-adaptor) | Ponte do toolkit AT-SPI 2. |
| Braille | [brltty](https://packages.ubuntu.com/jammy/brltty) | Software de acessibilidade para pessoa cega usando uma linha Braille. |
| Mouse | [mousetweaks](https://packages.ubuntu.com/jammy/mousetweaks) | Melhorias de acessibilidade de mouse para a área de trabalho GNOME. |
| Leitor de Tela | [orca](https://packages.ubuntu.com/jammy/orca) | Leitor de telas scriptável. |
| Leitor de Tela | [speech-dispatcher](https://packages.ubuntu.com/jammy/speech-dispatcher) | Interface comum para sintetizadores de fala. |

#### Avahi/NSS

| ubuntu-desktop-minimal | Descrição |
|------------------------|-----------|
| [avahi-autoipd](https://packages.ubuntu.com/jammy/avahi-autoipd) | Daemon de configuração de endereço de rede Avahi IPv4LL. |
| [avahi-daemon](https://packages.ubuntu.com/jammy/avahi-daemon) | Daemon Avahi mDNS/DNS-SD. |
| [libnss-mdns](https://packages.ubuntu.com/jammy/libnss-mdns) | Módulo NSS para resolução de nomes DNS Multicast. |

#### Bluetooth

| Função | ubuntu-desktop-minimal | Descrição |
|--------|------------------------|-----------|
| | [bluez](https://packages.ubuntu.com/jammy/bluez) | Ferramentas e daemons Bluetooth. |
| | [gnome-bluetooth](https://packages.ubuntu.com/jammy/gnome-bluetooth) | Ferramentas bluetooth do GNOME. |
| | [pulseaudio-module-bluetooth](https://packages.ubuntu.com/jammy/pulseaudio-module-bluetooth) | Módulo Bluetooth para o servidor de som PulseAudio. |
| | [rfkill](https://packages.ubuntu.com/jammy/rfkill) | Ferramenta para habilitar e desabilitar dispositivos sem fio. **Este pacote também é usado por dispositivos Wi-Fi**. **Ele deveria ser removido apenas se tanto Bluetooth quanto Wi-Fi não forem usados**. |
| Impressão | [bluez-cups](https://packages.ubuntu.com/jammy/bluez-cups) | Driver de impressora bluetooth para CUPS. |

`bluez-cups` é repetido em [Impressão](#Impressão) para facilitar a visualização.

`rfkill` é repetido em [Wi-Fi](#Wi-Fi) para facilitar a visualização.

#### Impressão digital

| ubuntu-desktop-minimal | Descrição |
|------------------------|-----------|
| [libpam-fprintd](https://packages.ubuntu.com/jammy/libpam-fprintd) | Módulo PAM para autenticação de impressão digital através do fprintd. |

#### Jogar

| ubuntu-desktop-minimal | Descrição |
|------------------------|-----------|
| [gamemode](https://packages.ubuntu.com/jammy/gamemode) | Otimize a performance de um sistema Linux sob demanda. |

#### Extras GNOME

| ubuntu-desktop-minimal | Descrição |
|------------------------|-----------|
| [gnome-characters](https://packages.ubuntu.com/jammy/gnome-characters) | Aplicação de mapa de caracteres. |
| [gnome-font-viewer](https://packages.ubuntu.com/jammy/gnome-font-viewer) | Visualizador de fontes para Gnome. |
| [gnome-logs](https://packages.ubuntu.com/jammy/gnome-logs) | Visualizador para o journal do systemd. |

####  Fontes de linguagens

| Função | ubuntu-desktop-minimal | Descrição |
|--------|------------------------|-----------|
| Árabe | [fonts-kacst-one](https://packages.ubuntu.com/jammy/fonts-kacst-one) | Fonte TrueType desenhada para a língua árabe. |
| Birmanês | [fonts-sil-padauk](https://packages.ubuntu.com/jammy/fonts-sil-padauk) | Fonte TrueType Unicode birmanesa com suporte a OpenType e Graphite. |
| CJK | [fonts-noto-cjk](https://packages.ubuntu.com/jammy/fonts-noto-cjk) | Famílias de fontes "No Tofu" com grande cobertura Unicode (CJK regular e negrito). |
| Etíope | [fonts-sil-abyssinica](https://packages.ubuntu.com/jammy/fonts-sil-abyssinica) | Fonte Unicode para a escrita etíope. |
| Indiano | [fonts-indic](https://packages.ubuntu.com/jammy/fonts-indic) | Meta pacote para instalar todas as fontes da língua indiana. |
| Khmer | [fonts-khmeros-core](https://packages.ubuntu.com/jammy/fonts-khmeros-core) | Fontes Unicode KhmerOS para a língua khmer do Camboja. |
| Lao | [fonts-lao](https://packages.ubuntu.com/jammy/fonts-lao) | Fonte TrueType para a língua lao. |
| Cingalês | [fonts-lklug-sinhala](https://packages.ubuntu.com/jammy/fonts-lklug-sinhala) | Fonte Unicode cingalês pelo Lanka Linux User Group. |
| Tailandês | [fonts-thai-tlwg](https://packages.ubuntu.com/jammy/fonts-thai-tlwg) | Fontes tailandesas mantidas pelo TLWG (metapacote). |
| Tibetano | [fonts-tibetan-machine](https://packages.ubuntu.com/jammy/fonts-tibetan-machine) | Fonte para tibetano, dzongkha e ladakhi (OpenType Unicode). |

#### Hardware legado

| ubuntu-desktop-minimal | Descrição |
|------------------------|-----------|
| [pcmciautils](https://packages.ubuntu.com/jammy/pcmciautils) | Utilitários PCMCIA para o Linux 2.6. |
| [inputattach](https://packages.ubuntu.com/jammy/inputattach) | Utilitário para conectar periféricos seriais ao subsistema de entrada. |

#### Suporte LibreOffice

| ubuntu-desktop-minimal | Descrição |
|------------------------|-----------|
| [fonts-opensymbol](https://packages.ubuntu.com/jammy/fonts-opensymbol) | Fonte OpenSymbol TrueType. |
| [libwmf0.2-7-gtk](https://packages.ubuntu.com/jammy/libwmf0.2-7-gtk) | Biblioteca de conversão de Windows metafile. |

`fonts-opensymbol` e `libwmf0.2-7-gtk` são movidos para `custom-desktop`, já que eles são usados por LibreOffice.

#### Miscelânea

| ubuntu-desktop-minimal | Descrição |
|------------------------|-----------|
| [bc](https://packages.ubuntu.com/jammy/bc) | Linguagem de calculadora de precisão arbitrária bc do GNU. |
| [ghostscript-x](https://packages.ubuntu.com/jammy/ghostscript-x) | Interpretador para a linguagem PostScript e para PDF - suporte X11. |
| [gvfs-fuse](https://packages.ubuntu.com/jammy/gvfs-fuse) | Sistema de arquivos virtual em espaço de usuário - servidor fuse. |
| [ibus-table](https://packages.ubuntu.com/jammy/ibus-table) | Motor de tabelas para IBus. |
| [memtest86+](https://packages.ubuntu.com/jammy/memtest86+) | Testador de memória completa em modo real. |
| [nautilus-sendto](https://packages.ubuntu.com/jammy/nautilus-sendto) | Mandar arquivos via e-mail facilmente de dentro do Nautilus. |
| [nautilus-share](https://packages.ubuntu.com/jammy/nautilus-share) | Extensão do Nautilus para compartilhar diretórios usando o Samba. |

#### Impressão

| Função | ubuntu-desktop-minimal | Descrição |
|--------|------------------------|-----------|
| | [cups](https://packages.ubuntu.com/jammy/cups) | Common UNIX Printing System(R) - suporte a PPD/driver, interface web. |
| | [cups-bsd](https://packages.ubuntu.com/jammy/cups-bsd) | Common UNIX Printing System UNIX (tm) - comandos BSD. |
| | [cups-client](https://packages.ubuntu.com/jammy/cups-client) | Common UNIX Printing System(tm) - programas clientes (SysV). |
| | [cups-filters](https://packages.ubuntu.com/jammy/cups-filters) | Filtros CUPS OpenPrinting - Pacote principal. |
| Bluetooth | bluez-cups | Driver de impressora bluetooth para CUPS. |
| Brother/Lenovo | [printer-driver-brlaser](https://packages.ubuntu.com/jammy/printer-driver-brlaser) | Driver de impressora para (algumas) impressoras laser Brother. |
| Brother | [printer-driver-ptouch](https://packages.ubuntu.com/jammy/printer-driver-ptouch) | Driver de impressão para impressoras de etiqueta Brother P-touch. |
| Foomatic | [foomatic-db-compressed-ppds](https://packages.ubuntu.com/jammy/foomatic-db-compressed-ppds) | Suporte a impressoras OpenPrinting - PPDs comprimidos derivados da base de dados. |
| HP | [hplip](https://packages.ubuntu.com/jammy/hplip) | Sistema de Imagem e Impressão HP Linux (HPLIP). |
| HP | [printer-driver-pnm2ppa](https://packages.ubuntu.com/jammy/printer-driver-pnm2ppa) | Driver de impressão para impressoras HP-GDI. |
| HP | [printer-driver-pxljr](https://packages.ubuntu.com/jammy/printer-driver-pxljr) | Driver de impressão para HP Color LaserJet 35xx/36xx. |
| Kodak | [printer-driver-c2esp](https://packages.ubuntu.com/jammy/printer-driver-c2esp) | Driver de impressora para a série jato de tinta Kodak ESP AiO color. |
| Konica Minolta | [printer-driver-m2300w](https://packages.ubuntu.com/jammy/printer-driver-m2300w) | Driver de impressão para impressoras laser coloridas Minolta magicolor 2300W/2400W. |
| Konica Minolta | [printer-driver-min12xxw](https://packages.ubuntu.com/jammy/printer-driver-min12xxw) | Driver de impressão para a KonicaMinolta PagePro 1[234]xxW. |
| PostScript | [openprinting-ppds](https://packages.ubuntu.com/jammy/openprinting-ppds) | Suporte para impressora OpenPrinting - arquivos PPD para PostScript. |
| Ricoh Aficio | [printer-driver-sag-gdi](https://packages.ubuntu.com/jammy/printer-driver-sag-gdi) | Driver de impressão para Ricoh Aficio SP 1000s e SP 1100s. |
| Samsung/Xerox | [printer-driver-splix](https://packages.ubuntu.com/jammy/printer-driver-splix) | Driver para as impressoras laser Samsung e Xerox SPL2 e SPLc. |
| Zenographics ZjStream | [printer-driver-foo2zjs](https://packages.ubuntu.com/jammy/printer-driver-foo2zjs) | Driver de impressora para impressoras baseadas em ZjStream. |

`bluez-cups` é repetido em [Bluetooth](#Bluetooth) para facilitar a visualização.

#### Desktop remoto

| ubuntu-desktop | Description |
|----------------|-------------|
| [gnome-remote-desktop](https://packages.ubuntu.com/jammy/gnome-remote-desktop) | Daemon de desktop remoto para GNOME usando PipeWire. |

#### VM

| ubuntu-desktop-minimal | Descrição |
|------------------------|-----------|
| [spice-vdagent](https://packages.ubuntu.com/jammy/spice-vdagent) | Agente Spice para Linux. |

#### Wi-Fi

| ubuntu-desktop-minimal | Descrição |
|------------------------|-----------|
| rfkill | Ferramenta para habilitar e desabilitar dispositivos sem fio. **Este pacote também é usado por dispositivos Bluetooth**. **Ele deveria ser removido apenas se tanto Bluetooth quanto Wi-Fi não forem usados**. |
| [wireless-tools](https://packages.ubuntu.com/jammy/wireless-tools) | Ferramentas p/ manipular as Extensões Sem-fio do Linux (Linux Wireless Extensions). |
| [wpasupplicant](https://packages.ubuntu.com/jammy/wpasupplicant) | Suporte ao cliente para WPA e WPA2 (IEEE 802.11i). |

`rfkill` é repetido em [Bluetooth](#Bluetooth) para facilitar a visualização.

### custom-desktop
Estes são os pacotes que são adicionados ao, removidos do ou substituídos no metapacote `custom-desktop`:

| ubuntu-desktop | custom-desktop | Descrição |
|----------------|----------------|-----------|
| fonts-opensymbol | fonts-opensymbol | Fonte OpenSymbol TrueType. **Movido do `custom-desktop-minimal`, já que é usado pelo LibreOffice**. |
| gnome-disk-utility | gnome-disk-utility | Gerencia e configura mídia e drives de disco. **Movido do `custom-desktop-minimal`, já que não é considerado mínimo**. |
| [~~libreoffice-ogltrans~~](https://packages.ubuntu.com/jammy/libreoffice-ogltrans) | | Pacote transicional para libreoffice-ogltrans. **Pacotes transicionais não são necessários**. |
| [~~libreoffice-pdfimport~~](https://packages.ubuntu.com/jammy/libreoffice-pdfimport) | | Pacote transicional para o componente de Importar PDF para LibreOffice. **Pacotes transicionais não são necessários**. |
| [~~libreoffice-style-breeze~~](https://packages.ubuntu.com/jammy/libreoffice-style-breeze) | | Suíte de produtividade Office -- Estilo de símbolos Breeze. **KDE não é suportado, então não é usado pela maioria das pessoas**. |
| libwmf0.2-7-gtk | libwmf0.2-7-gtk | Biblioteca  de conversão de Windows metafile. **Movido do `custom-desktop-minimal`, já que é usado pelo LibreOffice**. |
| [~~transmission-gtk~~](https://packages.ubuntu.com/jammy/transmission-gtk) | [qbittorrent](https://packages.ubuntu.com/jammy/qbittorrent) | Cliente bittorrent baseado na libtorrent-rasterbar com uma GUI Qt5. **Transmission não é suportado, já que é bugado e falta várias funcionalidades**. **qBittorrent é usado em vez disso, já que é um dos melhores clientes torrent já feitos**. |
| | [ubuntu-restricted-extras](https://packages.ubuntu.com/jammy/ubuntu-restricted-extras) | Codecs de mídia e fontes comumente usados para o Ubuntu. **Adiciona codecs proprietários para que o Totem e o Rhythmbox possam reproduzir a maioria dos formatos**. **As fontes extras e o unrar não são instalados**. |

Há grupos de pacotes que originalmente pertenciam ao metapacote `ubuntu-desktop`, mas que são apenas sugeridos pelo `custom-desktop`. A sua remoção é opcional, dependendo de eles serem ou não necessários.

#### Jogar

| ubuntu-desktop | Descrição |
|----------------|-----------|
| [aisleriot](https://packages.ubuntu.com/jammy/aisleriot) | Coleção de jogos tipo Paciência para o GNOME. |
| [gnome-mahjongg](https://packages.ubuntu.com/jammy/gnome-mahjongg) | Jogo de peças oriental clássico para GNOME. |
| [gnome-mines](https://packages.ubuntu.com/jammy/gnome-mines) | Jogo de quebra-cabeças popular campo minado para o GNOME. |
| [gnome-sudoku](https://packages.ubuntu.com/jammy/gnome-sudoku) | Jogo de raciocínio Sudoku para GNOME. |

#### Extras GNOME

| ubuntu-desktop | Descrição |
|----------------|-----------|
| [cheese](https://packages.ubuntu.com/jammy/cheese) | Ferramenta para capturar fotos e vídeos a partir da webcam. |
| [eog](https://packages.ubuntu.com/jammy/eog) | Programa visualizador de gráficos "Eye of GNOME". **Removido já que o Shotwell faz o que ele faz e mais**. |
| [simple-scan](https://packages.ubuntu.com/jammy/simple-scan) | Utilitário Simples de Escaneamento (Scanning). |

#### Email

| ubuntu-desktop | Descrição |
|----------------|-----------|
| [thunderbird](https://packages.ubuntu.com/jammy/thunderbird) | Cliente de email, RSS e grupo de notícias com filtro de spam integrado. |
| [thunderbird-gnome-support](https://packages.ubuntu.com/jammy/thunderbird-gnome-support) | Cliente de email, RSS e grupo de notícias - suporte GNOME. |

#### Miscelânea

| ubuntu-desktop | Descrição |
|----------------|-----------|
| [branding-ubuntu](https://packages.ubuntu.com/jammy/branding-ubuntu) | Substituição arte com Ubuntu branding. |
| [usb-creator-gtk](https://packages.ubuntu.com/jammy/usb-creator-gtk) | Crie um disco de inicialização usando um CD ou imagem de disco (para GNOME). |

#### Desktop remoto

| ubuntu-desktop | Descrição |
|----------------|-----------|
| [remmina](https://packages.ubuntu.com/jammy/remmina) | Cliente de área de trabalho remota em GTK+. |

## Construindo
Para construir os metapacotes a partir de seus arquivos de controle, você precisa instalar [`equivs`](https://packages.ubuntu.com/jammy/equivs):
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
make ubuntu-system-adjustments
```


# Desenvolvendo
Para customizar os metapacotes, leia o [README](builder/README-pt_BR.md) na pasta `builder/`.
