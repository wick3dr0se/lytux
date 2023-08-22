#!/bin/bash

deinit_term
printf '\e[2J\e[H'

if (( UEFI )); then
  _msg 'System booted in UEFI mode; Bootloader set to systemd-boot.'
else
  _msg 'System booted in BIOS or CSM mode; Bootloader set to GRUB.'
  installPackages+=('grub' 'os-prober')
fi

timedatectl set-ntp true
timedatectl status

if [[ -d /mnt/boot ]]; then
  _msg "$(awk '/\/mnt\/boot/{print $3}' /proc/mounts) Boot partition found!"
  
  [[ -f /mnt/boot/"$UCODE".img ]]&& rm /mnt/boot/"$UCODE".img
  [[ -f /mnt/boot/vmlinuz-linux ]]&& rm /mnt/boot/vmlinuz-linux
  [[ -f /mnt/boot/initramfs-linux.img ]]&& rm /mnt/boot/initram*
else
  _fatal 'No boot partition found!'
fi

if mountpoint -q /mnt; then
  _msg "$(awk '/\/mnt /{print $3}' /proc/mounts) root partition found!"
else
  _fatal 'No root partition found!'
fi

swapon --show|| _warn 'No swap partition or file found!'

lsblk -o NAME,FSTYPE,MOUNTPOINTS,SIZE

# mirrors

_msg "Installing ${#installPackages[@]} packages to new root!"
pacstrap -GK /mnt "${installPackages[@]} $UCODE"

_msg 'Generating file system table!'
genfstab -U /mnt >/mnt/etc/fstab

cp -r "$srcPath/chroot.sh" /mnt
arch-chroot /mnt . chroot-install.sh
