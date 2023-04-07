#!/bin/bash

set -eEuo pipefail

true_reply(){
  [[ ${REPLY,,} =~ ^y(es)?$ ]]&& :
}

if [[ -d /sys/firmware/efi ]]; then
  BOOTLOADER='systemd-boot'
else
  BOOTLOADER='grub'
fi

while read -r line; do
  if [[ $line == 'vendor_id'* ]]; then
    VENDOR="${line#*:}" VENDOR="${VENDOR//[[:space:]]}"
    case $VENDOR in
      AuthenticAMD) UCODE='amd-ucode';; # amd microcode updates
      GenuineIntel) UCODE='intel-ucode';; # intel microcode udpates
    esac
    break
  fi
done </proc/cpuinfo
