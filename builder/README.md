# Custom Desktop Builder
[Ler em português do Brasil](README-pt_BR.md).

Scripts to build the metapackages for Custom Desktop.  
Copyright (C) 2022  Natan Junges &lt;natanajunges@gmail.com&gt;

Custom Desktop Builder is free software: you can redistribute it and/or modify  
it under the terms of the GNU General Public License as published by  
the Free Software Foundation, either version 3 of the License, or  
any later version.

Custom Desktop Builder is distributed in the hope that it will be useful,  
but WITHOUT ANY WARRANTY; without even the implied warranty of  
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the  
GNU General Public License for more details.

You should have received a copy of the GNU General Public License  
along with Custom Desktop Builder.  If not, see &lt;https://www.gnu.org/licenses/&gt;.

## Requirements
- The Ubuntu desktop ISO of the version to be customized;
- A virtual machine emulator (recommended [`virt-manager`](https://packages.ubuntu.com/jammy/virt-manager)).

## Instructions
Use the ISO image to install Ubuntu in a virtual machine. In the language selection, select English, as it will not have any additional language packages that might interfere with this process, and also ensures no inconsistencies in the outputs of commands used by these scripts. When choosing the normal/minimal install, it is not recommended to select the option to install third-party drivers and codecs, as they might interfere with this process as well. All the other options are customary.

Once the system is successfully installed and properly set up after the first boot, update it running the following sequence in the terminal:
```shell
sudo apt update
sudo apt upgrade
sudo apt autoremove --purge
```

Note that snaps are not updated, as they will soon be removed. Restart the virtual machine to load the most up to date software (most importantly the kernel).

Download this project's source from the [releases page](https://github.com/natanjunges/custom-desktop/releases). Extract it and open the terminal in the `builder` folder. Download `ubuntu-system-adjustments` from the releases page and save it in `builder/build`. Run the main script with:
```shell
./main
```

In the menus, select "Initialize", and then "Part 1". Whether or not the extra packages should be installed depends on which version of Ubuntu was installed. If the minimal install was done, then no extra packages should be installed. If the normal install was done instead, then the extra packages should be installed. When the execution is finished, log out and back in, but into the GNOME session (Wayland) instead of the Ubuntu one.

Reopen the terminal in the `builder` folder and rerun the main script. In the menus, select "Initialize", and then "Part 2". When the execution is finished, restart the virtual machine to completely unload the removed software.

Reopen the terminal in the `builder` folder and rerun the main script. In the menu, select "Execute rounds". When asked, pressing `Enter` will perform the described action. They can be aborted pressing `Ctrl`+`C`. This will iteratively run rounds that will detect the installed packages from the Ubuntu desktop metapackages and choose which ones to remove.

First, it detects the installed packages. Then, it compares them with the ones from the previous round. If new packages are detected, it shows them to be chosen for removal. The packages are listed one per line, with the recommends starting with a `*`. The packages to be removed must be commented out (prefixing them with `#`, do not remove the `*`). Save the file with `Ctrl`+`S` and quit the editor with `Ctrl`+`X` and the commented packages will be purged, starting a new round.

Each of those rounds consists of up to five steps:
- In the first step, only the packages with no reverse dependencies (no packages, besides the metapackages, that depend on them, be it pre-depends, depends, recommends or suggests) will be listed;
- In the second step, which will only execute once in the entire run, only the packages with only circular dependencies (they are candidates for automatic removal if not marked as manually installed) will be listed;
- In the third step, only the packages with recommends or suggests reverse dependencies (no pre-depends or depends) will be listed;
- In the fourth step, only the packages with pre-depends or depends reverse dependencies that are not from the metapackages will be listed;
- In the fifth step, only the packages with pre-depends or depends reverse dependencies that are from the metapackages will be listed, and they cannot be removed;

Once the rounds are finished, rerun the main script. In the menu, select "Generate metapackage control file". Whether or not the full package should be built depends on the same criteria of "Initialize - Part 1". The removed packages are shown to be added to the suggests, with the packages not to be added to the suggests being commented out. A control file named `build/control` will be generated, that can be used to replace `custom-desktop` or `custom-desktop-minimal` in the parent folder. Editing the control file is highly encouraged, mainly the `Homepage`, `Bugs`, `Package`, `Version`, `Maintainer` and `Description` sections.
