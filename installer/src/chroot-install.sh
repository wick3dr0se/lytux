#!/bin/bash

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

hwclock --systohc

sed "/$selectedLocale/s/^#//" -i /etc/locale.gen; locale-gen
locale-gen

echo "$selectedLocale" >/etc/locale.conf

read -rep 'Enter desired hostname: ' hostname
echo "$hostname" >/etc/hostname

cat <<EOF >/etc/hosts
127.0.0.1 localhost
::1   localhost
EOF

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

read -rep 'Enter a new user name (leave blank to skip): ' username
[[ $username ]]&&{
  passwd -l root &>/dev/null
  printf 'Locked root user password\n'

  id "$username" &>/dev/null&&{ userdel "$username"; rm -r /home/"${username:?}"; }&& :
  useradd -mG wheel "$username"
  passwd -d "$username" &>/dev/null
  printf 'User %s created without password\n' "$username"
}

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