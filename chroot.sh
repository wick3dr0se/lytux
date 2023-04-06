#!/bin/bash

. helpers.sh

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

hwclock --systohc

read -rp 'Enter a locale [en_US]: '
locale="${REPLY#.*}" locale="${locale:-en_US}"

sed -i "s/^#($locale.UTF-8)/\1/" /etc/locale.gen
locale-gen

printf 'LANG=%s.UTF-8' "$locale" >/etc/locale.conf

read -rp 'Enter desired hostname (system identity): '
printf '%s\n' "$REPLY" >/etc/hostname

cat <<EOF
127.0.0.1    localhost  
::1          localhost
EOF

read -srp 'Enter desired root user password: '
printf '%s\n%s\n' "$REPLY" | passwd

read -rp 'Enter a new user name (leave blank to skip): '
[[ $REPLY ]]&&{ passwd -l root; useradd -mG sudo "$REPLY"; }

systemctl enable bluetooth NetworkManager

read -rp "Install $bootloader bootloader? [Y\n]: "
true_reply&&{
  if (( UEFI )); then
    bootctl --path=/boot install

    read -rp 'Enter root block device path, e.g. /dev/sdX2: '
    rootBlockPath="/dev/${REPLY#/dev/}"

    loaderEntry=(
      'title  WickedLinux'
      'linux  /vmlinuz-linux'
      'initrd /initramfs-linux.img'
      "options  root=$rootBlockPath rw quiet"
    )
    for _ in "${loaderEntry[@]}"; do
      printf '%s\n' "$_" >/boot/loader/entries/wicked.conf
    done

    loaderConf=(
      'default wicked'
      'timeout 3'
      'console-mode max'
    )
    for _ in "${loaderConf[@]}"; do
      printf '%s\n' "$_" >/boot/loader/loader.conf
    done
  else
    grub-install --target=i386-pc "$rootBlockPath"
  fi
}
