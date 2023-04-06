#!/bin/bash

set -eEuo pipefail

UEFI=0
[[ -d /sys/firmware/efi ]]&& UEFI=1

if (( UEFI )); then
  bootloader='systemd-boot'
else
  bootloader='grub'
fi

true_reply(){
  [[ ${REPLY,,} =~ ^y(es)?$ ]]&& :
}