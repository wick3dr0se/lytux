<div align="center">
<h1>Lytux :penguin:</h1>
<p>A terminal-centric, stripped-down Arch-derived Linux distribution</p>

<a href="https://discord.gg/W4mQqNnfSq"><img src="https://discordapp.com/api/guilds/913584348937207839/widget.png?style=shield"/></a>
</div>

## Features and Modifications
Just some of the key changes made from a base releng ArchISO:
- Created 'live' user with the password 'live'
- Enabled `pacman` testing repositories by default
- Removed `zsh` in favor of bash only
- Moved from iw/iwd to networkmanager, including a systemd service file (enable)
- Removed `archinstall`; Included an auto installer script
- Included custom configurations for vim, .bashrc (prmopt) and more

## Objectives
A list of some goals for Lytux in no particular order:
- Include manual install instructions in live user home directory
- Remove more unecessary packages
- Remove systemd-boot and syslinux for GRUB to boot UEFI/BIOS & ISO-9660 volumes
- Create/change logo and bootloader artwork
- Switch to hardened kernel
- Add firewall/iptables
- Enable ssh by default

## Aquiring the ISO
Download the Lytux ISO from the [releases](https://github.com/opensource-force/lytux/releases) page

Otherwise build the latest Lytux ISO from source
```
# clone from github & change dir
git clone https://github.com/opensource-force/lytux&& cd lytux

# build the iso
mkarchiso -v -w lytux-iso -o lytux-iso iso
```

## Contributing
Open an [issue](https://github.com/opensource-force/lytux/issues) or fork this repo and submit a PR, linking any relevant open issues. Any contributions are much appreciated!

## Acknowledgments
Lytux is built upon the strong foundation of Arch Linux and the ArchISO project. Special thanks to the open-source community!

## License
Lytux is released under the [GPL-3](LICENSE)
