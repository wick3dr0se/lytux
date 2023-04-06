#!/bin/bash

. helpers.sh

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

hwclock --systohc

read -rp 'Enter a locale [en_US]: '
locale="${REPLY#.*}" locale="${locale:-en_US}"

sed "/$locale.UTF-8/s/^#//" -i /etc/locale.gen
locale-gen

printf 'UTC\n' >/etc/locale.conf

read -rp 'Enter desired hostname (system identity): '
printf '%s\n' "$REPLY" >/etc/hostname

cat <<EOF
127.0.0.1    localhost  
::1          localhost
EOF

for((;;)){
  read -srp 'Enter desired root user password: '
  read -srp 'Confirm password: ' CONFIRM

  if [[ $REPLY == $CONFIRM ]]; then
    printf '%s\n%s' "$REPLY" "$CONFIRM"| passwd
    break
  else
    printf 'Password mismatch.. Try again\n'
  fi
}

read -rp 'Enter a new user name (leave blank to skip): '
[[ $REPLY ]]&&{ passwd -l root; useradd -mG wheel "$REPLY"; }

systemctl enable bluetooth NetworkManager

read -rp "Install $bootloader bootloader? [Y\n]: "
REPLY="${REPLY:-y}"; true_reply&&{
  if (( UEFI )); then
    bootctl --path=/boot install

    loaderEntry=(
      'title  WickedLinux'
      'linux  /vmlinuz-linux'
      'initrd /initramfs-linux.img'
      "options  root=$(df -h /mnt| awk 'FNR==2 {print $1}') rw quiet"
    )
    for _ in "${loaderEntry[@]}"; do
      printf '%s\n' "$_" >>/boot/loader/entries/wicked.conf
    done

    loaderConf=(
      'default wicked'
      'timeout 3'
      'console-mode max'
    )
    for _ in "${loaderConf[@]}"; do
      printf '%s\n' "$_" >>/boot/loader/loader.conf
    done
  else
    grub-install --target=i386-pc "$rootBlockPath"
  fi
}
