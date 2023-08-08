<div align="center">
<h1>Lytux :penguin:</h1>
<p>A terminal-centric, stripped-down Arch-derived Linux distribution</p>

<a href="https://discord.gg/W4mQqNnfSq"><img src="https://discordapp.com/api/guilds/913584348937207839/widget.png?style=shield"/></a>
</div>

## Features and Modifications
Just some of the key changes made from base releng ArchISO:
- Created a 'live' user with the password 'live' for easy access to the live environment
- Enabled testing repositories by default for the latest (potentially breaking) releases
- Removed Zsh: Streamlined the shell selection to provide a consistent experience

## Custom Environment
Lytux comes with a customized environment that includes:
- Bash - default and only shell
- Kitty - terminal emulator
- Hyprland - window manager/compositor
- Hyprpaper - wallpaper setter

## Objectives
A list of some goals for Lytux in no particular order:
- Remove GRUB bootloader: Use syslinux for BIOS booting and systemd-boot for UEFI
- Create/change logo and bootloader artwork
- Switch to hardened kernel
- Add firewall/iptables
- Enable ssh by default
- Implement autologin

## Aquiring the ISO
Download the Lytux ISO from the [Releases](https://github.com/yourusername/lytux/releases) page

Otherwise build the latest Lytux ISO from source
```
# clone from github & change dir
git clone https://github.com/opensource-force/lytux&& cd lytux

# build the iso
mkarchiso -v -w lytux-iso -o lytux-iso iso
```

## Contributing
Open an [issue](https://github.com/yourusername/lytux/issues) or fork this repo and submit a PR, linking any relevant open issues. Any contributions are much appreciated!

## Acknowledgments
Lytux is built upon the strong foundation of Arch Linux and the ArchISO project. Special thanks to the open-source community!

## License
Lytux is released under the [GPL-3](LICENSE)
