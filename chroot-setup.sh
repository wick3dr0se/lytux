#!/bin/bash

_msg 'Setting timezone to UTC!\n'
#ln -sf /usr/share/zoneinfo/UTC /etc/localtime

hwclock --systohc

until [[ $locale ]]; do
  _ask 'Enter a locale (en_US.UTF-8): '
  read -r locale

  sed "/$locale*/s/^#//" -i /etc/locale.gen
  locale-gen
  
  echo "LANG=$locale" >/etc/locale.conf
done

until [[ $hostname ]]; do
  _ask 'Enter a new system hostname: '
  read -r hostname
  
  echo "$hostname" >/etc/hostname
done
_msg "Hostname set to $hostname!"

_ask 'Enter a new username: ' username
read -r username

useradd -mG wheel "$username"

until [[ $userPass ]]; do
  passwd "$username"&& userPass=1
done
_msg "Created user $username!"

_msg 'Uncomment %wheel group to enable sudo priveleges'
sleep .5
EDITOR=vim visudo

until [[ $rootPass ]]; do
  passwd&& rootPass=1
done
_msg 'Root password set!'

systemctl enable bluetooth NetworkManager

if (( UEFI )); then
  bootctl --path=/boot install
  
  loaderEntry=(
    'title Lytux'
    'linux /vmlinuz-linux'
    "initrd /$UCODE.img"
    'initrd /initramfs-linux.img'
    "options root=$(df -h /| awk 'FNR==2 {print $1}') rw quiet"
  )
  
  [[ -f /boot/loader/entries/lytux.conf ]]&& rm /boot/loader/entries/lytux.conf
  for _ in "${loaderEntry[@]}"; do
    echo "$_" >>/boot/loader/entries/lytux.conf
  done
  
  loaderConf=(
    'default lytux'
    'timeout 3'
    'console-mode max'
  )
  
  [[ -f /boot/loader/loader.conf ]]&& rm /boot/loader/loader.conf
  for _ in "${loaderConf[@]}"; do
    echo "$_" >>/boot/loader/loader.conf
  done

  bootctl list
else
  grub-install --target=i386-pc "$(df -h /| awk 'FNR==2 {print $1}')"
fi