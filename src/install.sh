#!/bin/bash

packages=(
  'kitty' # terminal

#- audio
  'pulseaudio' # audio server
  'pavucontrol' # audio ui
#-

#- networking
  'networkmanager' # wifi
  'network-manager-applet' # wifi ui
#-

#- bluetooth
  'bluez' # bluetooth protocol stack
  'blueberry' # bluetooth ui
#-

#- window manager/desktop environment
  'xorg-server' # x server
  'xorg-xinit' # start x
  'i3' # i3 window manager
  'i3blocks' # i3bar blocks
#-
)

(( UEFI ))|| packages+=('grub' 'os-prober') # bootloader

while read -r line; do
  if [[ $line == 'vendor_id'* ]]; then
    vendor="${line#*:}"
    case "${vendor//[[:space:]]}" in
      AuthenticAMD) packages+=('amd-ucode');; # amd microcode updates
      GenuineIntel) packages+=('intel-ucode');; # intel microcode udpates
    esac
    break
  fi
done </proc/cpuinfo

#timedatectl set-ntp true

lsblk -o NAME,FSTYPE,MOUNTPOINTS,SIZE

read -rp 'Enter desired disk block device path e.g. /dev/sda, to auto-partition (consume entire disk); Leave blank to skip/manually partition: '
[[ $REPLY ]]&&{ diskBlockPath="/dev/${REPLY#/dev/}"; . auto-partition.sh; }

mountpoint -q /mnt||{ printf 'Root filesystem not mounted on /mnt\n'; exit 1; }

pacstrap -MG /mnt "${packages[@]}"

genfstab -U /mnt >/mnt/etc/fstab

cp helpers.sh chroot.sh /mnt/
arch-chroot /mnt ./chroot.sh
