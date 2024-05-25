# WinesapDualboot
I AM NOT RESPONSIBLE IF I BREAK YOUR DEVICE THIS SCRIPT IS STILL NEW
## REQUIRED STEPS BEFORE USING
- Requires at least a 100 GB partition (Made in windows)
- Secureboot is disabled
- Download the latest winesapos-${WINESAPOS_VERSION}-minimal-rootfs.tar.zst [release](https://github.com/LukeShortCloud/winesapOS/releases)

## NEXT STEPS
- Boot into a WinesapOS version 4.10 flash drive and select the `nobara` kernel
- open terminal and type `sudo pacman -S bash` then
- type in `lsblk` in the terminal to make sure you found the correct drive (edit the code to the drive you want)
- make a new sh file called `winesapdualboot.sh` with the following code here
- after you made the sh file type in `sudo ./path/to/winesapdualboot.sh`
- reboot the computer and remove the usb you used for the installer
- once booted into winesapos type this to add windows to the boot menu :
```
# Enable os-prober. It is disabled by default.
sudo crudini --ini-options=nospace --set /etc/default/grub "" GRUB_DISABLE_OS_PROBER false
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
  
# Code for drive types

## CODE (NVME drives)
```
#!/bin/bash
sudo mount -t btrfs -o subvol=/,compress-force=zstd:1,discard,noatime,nodiratime -L winesapos-root0 /
sudo btrfs subvolume create /mnt/.snapshots
sudo btrfs subvolume create /mnt/home
sudo mount -t btrfs -o subvol=/home,compress-force=zstd:1,discard,noatime,nodiratime -L winesapos-root0 /mnt/home
sudo btrfs subvolume create /mnt/home/.snapshots
sudo btrfs subvolume create /mnt/swap
sudo mount -t btrfs -o subvol=/swap,compress-force=zstd:1,discard,noatime,nodiratime -L winesapos-root0 /mnt/swap
sudo mkdir /mnt/boot
sudo mount --label winesapos-boot0 /mnt/boot
sudo mkdir /mnt/boot/efi
sudo mount /dev/nvme01p1 /mnt/boot/efi
```

## CODE (SSD)
```
#!/bin/bash
sudo mount -t btrfs -o subvol=/,compress-force=zstd:1,discard,noatime,nodiratime -L winesapos-root0 /
sudo btrfs subvolume create /mnt/.snapshots
sudo btrfs subvolume create /mnt/home
sudo mount -t btrfs -o subvol=/home,compress-force=zstd:1,discard,noatime,nodiratime -L winesapos-root0 /mnt/home
sudo btrfs subvolume create /mnt/home/.snapshots
sudo btrfs subvolume create /mnt/swap
sudo mount -t btrfs -o subvol=/swap,compress-force=zstd:1,discard,noatime,nodiratime -L winesapos-root0 /mnt/swap
sudo mkdir /mnt/boot
sudo mount --label winesapos-boot0 /mnt/boot
sudo mkdir /mnt/boot/efi
sudo mount /dev/sda1 /mnt/boot/efi
```
