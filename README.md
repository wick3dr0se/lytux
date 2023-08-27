<div align="center">
<h1>Lytux :penguin:</h1>
<p>A terminal-centric, stripped-down Arch-derived Linux distribution</p>

<a href="https://discord.gg/W4mQqNnfSq"><img src="https://discordapp.com/api/guilds/913584348937207839/widget.png?style=shield"/></a>
</div>

## ISO Modifications
Just some of the key changes made from a baseline ArchISO image:
- Removed Zsh in favor of BASH only
- Removed GRUB and rEFind bootloader; BIOS boot w/ syslinux & UEFI boot w/ systemd-boot
- Disabled mouse and audio support
- Removed tons of unecessary bloat (no edge cases)
- Removed archinstall and all Arch custom scripts
- Included custom configurations for TTY prompt, vim and more
- Created Lytux TUI auto installer

## Installer Features
On top of the standard Arch Linux installation process:
- Setup networking via `nc` (wraps `iwctl` or `nmcli`)
- Partitioning, filesystems and mounting via `ap` (wraps `parted`)
- Handles systemd-boot for UEFI boot & GRUB for BIOS boot
- Installs the correct CPU microcode updates
- Configures timezone/locales
- Creates specified user with superuser elevation
- Sets then locks root user password
- Enables bluetooth & audio

## ToDo
ISO:
- Create custom bootloader splash screen
- Create logo & artwork
Installer:
- Handle various environments & setups

## Aquiring the ISO
Download the Lytux ISO from the [releases](https://github.com/opensource-force/lytux/releases) page

---

Otherwise build the latest Lytux ISO from source
```bash
# clone from github & change dir
git clone https://github.com/opensource-force/lytux&& cd lytux

# build the iso
sudo mkarchiso -v -o ./ iso
```

## Contributing
Open an [issue](https://github.com/opensource-force/lytux/issues) or fork this repo and submit a PR, linking any relevant open issues. Any contributions are much appreciated!

## Acknowledgments
Lytux is built upon the strong foundation of Arch Linux and the ArchISO project. Special thanks to the open-source community!

## License
Lytux is released under the [GPL-3](LICENSE)
