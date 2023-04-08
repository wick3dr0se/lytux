#!/bin/bash

. helpers.sh

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

hwclock --systohc

read -rp 'Enter a locale [en_US]: ' locale
locale="${locale#.*}" locale="${locale:-en_US}"

sed "/$locale.UTF-8/s/^#//" -i /etc/locale.gen; locale-gen

printf 'LANG=%s.UTF-8\n' "$locale" >/etc/locale.conf

read -rp 'Enter desired hostname (system identity): ' hostname
printf '%s\n' "$hostname" >/etc/hostname

cat <<HOSTS >/etc/hosts
127.0.0.1    localhost  
::1          localhost
HOSTS

for((;;)){
  read -srp 'Enter desired root user password: ' rootPass
  [[ $rootPass ]]&& printf '\n'
  read -srp 'Confirm password: ' rootPassConfirm

  if [[ $rootPass&& $rootPass == "$rootPassConfirm" ]]; then
    printf '%s\n%s' "$rootPass" "$rootPass"| passwd &>/dev/null
    printf '\nPassword successfully set\n'
    break
  else
    printf 'Password mismatch.. Try again\n'
  fi
}

read -rp 'Enter a new user name (leave blank to skip): ' username
[[ $username ]]&&{
  passwd -l root &>/dev/null
  printf 'Locked root user password\n'

  id "$username" &>/dev/null&&{ userdel "$username"; rm -r /home/"${username:?}"; }&& :
  useradd -mG wheel "$username"
  passwd -d "$username" &>/dev/null
  printf 'User %s created without password\n' "$username"
}

systemctl enable bluetooth NetworkManager

read -rp "Install $BOOTLOADER bootloader? [Y\n]: "
REPLY="${REPLY:-y}"; true_reply&&{
  if [[ $BOOTLOADER == 'systemd-boot' ]]; then
    bootctl --path=/boot install

    loaderEntry=(
      'title Wicked Linux'
      'linux /vmlinuz-linux'
      "initrd /$UCODE.img"
      'initrd /initramfs-linux.img'
      "options root=$(df -h /| awk 'FNR==2 {print $1}') rw quiet"
    )
    [[ -d /boot/loader/entries/wicked.conf ]]&& rm /boot/loader/entries/wicked.conf
    for _ in "${loaderEntry[@]}"; do
      printf '%s\n' "$_" >>/boot/loader/entries/wicked.conf
    done

    loaderConf=(
      'default wicked'
      'timeout 3'
      'console-mode max'
    )
    [[ -d /boot/loader/loader.conf ]]&& rm /boot/loader/loader.conf
    for _ in "${loaderConf[@]}"; do
      printf '%s\n' "$_" >>/boot/loader/loader.conf
    done
  else
    grub-install --target=i386-pc "$(df -h /| awk 'FNR==2 {print $1}')"
  fi
}
