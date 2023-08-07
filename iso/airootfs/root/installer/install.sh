#!/bin/bash

. helpers.sh

packages=(
#- dependencies
  'sed' # stream editor
#-

#- core (essential)
  'base' # system packages
  'linux' # kernel
  'linux-headers' # kernel headers
  'sudo' # superuser do
#-

#- console
  'kitty' # terminal emulator
#-

#- audio
  'pulseaudio' # audio server
#-

#- networking
  'networkmanager' # wifi
#-

#- bluetooth
  'bluez' # bluetooth protocol stack
#-

#- window manager/desktop environment
  'hyprland' # compositor/wm
  'hyprpapr' # wallpaper setter
  'waybar' # status bar
#-

#- text editor
  'vim' # vi improved
#

#- browser
  'firefox'
#
)

[[ $BOOTLOADER == 'grub' ]]&& packages+=('grub' 'os-prober') # bootloader
case $UCODE in
  amd-ucode) packages+=('amd-ucode');; # amd microcode updates
  intel-ucode) packages+=('intel-ucode');; # intel microcode updates
esac

lsblk -o NAME,FSTYPE,MOUNTPOINTS,SIZE
read -rp 'Automatically partition (consume entire disk)? [y/N]: '; true_reply&& . auto-part.sh

mountpoint -q /mnt||{ printf 'Root filesystem not mounted on /mnt\n'; exit 1; }

[[ -f /mnt/boot/"$UCODE".img ]]&& rm /mnt/boot/"$UCODE".img
[[ -f /mnt/boot/vmlinuz-linux ]]&& rm /mnt/boot/vmlinuz-linux
[[ -f /mnt/boot/initramfs-linux.img ]]&& rm /mnt/boot/initram*
pacstrap -MG /mnt "${packages[@]}"

genfstab -U /mnt >/mnt/etc/fstab

cp {chroot,helpers}.sh /mnt/
cp -r /etc/{pacman.conf,pacman.d} /mnt/etc/
arch-chroot /mnt bash chroot.sh