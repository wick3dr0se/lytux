#!/bin/bash
# automatic partitioning script

read -rp 'Enter desired disk block device path, e.g. /dev/sda (leave blank to skip/manually partition): ' diskBlockPath 
diskBlockPath="/dev/${diskBlockPath#/dev/}"

if [[ $BOOTLOADER == 'system-boot' ]]; then
  # create uefi gpt partition table
  parted "$diskBlockPath" mklabel gpt
  # create efi system boot partition
  parted "$diskBlockPath" mkpart 'EFI system partition' fat32 1MiB 512MiB
  # turn boot esp(efi) flag on
  parted "$diskBlockPath" set 1 esp on
  # create root partition
  parted "$diskBlockPath" mkpart 'Linux x86 filesystem' ext4 512MiB 100%

  # format efi system partition to fat32 filesystem
  mkfs.fat -F32 "${diskBlockPath}1"
  # format root partition to ext4 filesystem
  mkfs.ext4 "${diskBlockPath}2"

  # mount root partition to /
  mount "${diskBlockPath}2" /mnt
  # mount efi system partition to /boot
  mount -m "${diskBlockPath}1" /mnt/boot
else
  # create bios mbr table
  parted "$diskBlockPath" mklabel msdos
  # create primary (root with boot)
  parted "$diskBlockPath" mkpart primary ext4 1MiB 100%
  # turn boot flag on
  parted "$diskBlockPath" set 1 boot on
    
  # format primary partition to ext4 filesystem
  mkfs.ext4 "${diskBlockPath}1"

  # mount primary partition to /
  mount "${diskBlockPath}1" /mnt
fi
