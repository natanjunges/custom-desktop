# Custom Desktop Builder

Scripts para construir os metapacotes para Custom Desktop.  
Copyright (C) 2022  Natan Junges &lt;natanajunges@gmail.com&gt;

Custom Desktop Builder é um software livre: você pode redistribuí-lo e/ou  
modificá-lo sob os termos da Licença Pública Geral GNU, conforme  
publicado pela Free Software Foundation, seja a versão 3 da Licença  
ou qualquer versão posterior.

Custom Desktop Builder é distribuído na esperança de que seja útil,  
mas SEM QUALQUER GARANTIA; sem a garantia implícita de  
COMERCIALIZAÇÃO OU ADEQUAÇÃO A UM DETERMINADO PROPÓSITO. Veja a  
Licença Pública Geral GNU para obter mais detalhes.

Você deve ter recebido uma cópia da Licença Pública Geral GNU  
junto com Custom Desktop Builder. Se não, veja &lt;https://www.gnu.org/licenses/&gt;.

## Requisitos
- A ISO desktop do Ubuntu da versão a ser customizada;
- Um emulador de máquina virtual (recomendado [`virt-manager`](https://packages.ubuntu.com/jammy/virt-manager)).

## Instruções
Use a imagem ISO para instalar o Ubuntu em uma máquina virtual. Na seleção de linguagem, selecione English (inglês), já que não terá nenhum pacote adicional de linguagem que possa interferir com este processo, e também garante que não haja inconsistências nas saídas dos comandos usados por estes scripts. Quando escolhendo entre a instalação normal/mínima, não é recomendado selecionar a opção de instalar drivers e codecs de terceiros, já que eles também podem interferir com este processo. Todas as outras opções são questão de gosto.

Uma vez que o sistema esteja instalado com sucesso e propriamente configurado após o primeiro boot, atualize-o executando a seguinte sequência no terminal:
```shell
sudo apt update
sudo apt upgrade
sudo apt autoremove --purge
```

Note que snaps não são atualizados, já que eles serão em breve removidos. Reinicie a máquina virtual para carregar os softwares mais atualizados (principalmente o kernel).

Baixe o código-fonte deste projeto da [página de lançamentos](https://github.com/natanjunges/custom-desktop/releases). Extraia-o e abra o terminal na pasta `builder`. Baixe `ubuntu-system-adjustments` da página de lançamentos e salve-o em `builder/build`. Execute o script principal com:
```shell
./main
```

Nos menus, selecione "Initialize" (Inicializar), e então "Part 1" (Parte 1). Se os pacotes extras devem ou não ser instalados depende de qual versão do Ubuntu foi instalada. Se a instalação mínima foi feita, então nenhum pacote extra deve ser instalado. Se, em vez disso, a instalação normal foi feita, então os pacotes extras devem ser instalados. Quando a execução terminar, encerre a sessão e entre novamente, mas na sessão GNOME (Wayland) em vez de a sessão Ubuntu.

Reabra o terminal na pasta `builder` e reexecute o script principal. Nos menus, selecione "Initialize" (Inicializar), e então "Part 2" (Parte 2). Quando a execução terminar, reinicie o sistema para descarregar completamente os softwares removidos.

Reabra o terminal na pasta `builder` e reexecute o script principal. No menu, selecione "Execute rounds" (Executar rodadas). Quando perguntado, pressionar `Enter` irá executar a ação descrita. Elas podem ser abortadas pressionando `Ctrl`+`C`. Isto irá executar iterativamente rodadas que irão detectar os pacotes instalados dos metapacotes desktop do Ubuntu e escolher quais remover.

Primeiro, ele detecta os pacotes instalados. Então, ele os compara com os da rodada anterior. Se novos pacotes são detectados, ele os exibe para serem escolhidos para remoção. Os pacotes são listados um por linha, com os recommends começando com um `*`. Os pacotes a serem removidos devem ser comentados (prefixando-os com `#`, não remova o `*`). Salve o arquivo com `Ctrl`+`S` e saia do editor com `Ctrl`+`X` e os pacotes comentados serão purgados, iniciando uma nova rodada.

Cada uma dessas rodadas consiste de até cinco passos:
- No primeiro passo, apenas os pacotes sem dependências reversas (sem pacotes, além dos metapacotes, que dependam deles, seja pre-depends, depends, recommends ou suggests) serão listados;
- No segundo passo, que irá executar apenas uma vez em toda a execução, apenas os pacotes com apenas dependências circulares (eles são candidatos à remoção automática se não marcados como instalados manualmente) serão listados;
- No terceiro passo, apenas os pacotes com dependências reversas recommends ou suggests (sem pre-depends ou depends) serão listados;
- No quarto passo, apenas os pacotes com dependências reversas pre-depends ou depends que não sejam dos metapacotes serão listados;
- No quinto passo, apenas os pacotes com dependências reversas pre-depends ou depends que sejam dos metapacotes serão listados, e eles não podem ser removidos;

Uma vez que as rodadas terminem, reexecute o script principal. No menu, selecione "Generate metapackage control file" (Gerar arquivo de controle do metapacote). Se o pacote completo deve ou não ser construído depende dos mesmos critérios de "Initialize - Part 1". Os pacotes removidos são exibidos para serem adicionados aos suggests, com os pacotes a não ser adicionados aos suggests sendo comentados. Um arquivo de controle nomeado `build/control` será gerado, que pode ser usado para substituir `custom-desktop` ou `custom-desktop-minimal` na pasta mãe. Editar o arquivo de controle é altamente encorajado, principalmente as seções `Homepage`, `Bugs`, `Package`, `Version`, `Maintainer` e `Description`.
