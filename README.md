# WinesapDualboot
I AM NOT RESPONSIBLE IF I BREAK YOUR DEVICE THIS SCRIPT IS STILL NEW AND IS NOT OFFICIAL
## REQUIRED STEPS BEFORE USING
- Requires at least a 100 GB partition (Made in windows)
- Secureboot is disabled
- Download the latest `winesapos-${WINESAPOS_VERSION}-minimal-rootfs.tar.zst` [release](https://github.com/LukeShortCloud/winesapOS/releases)

## NEXT STEPS
- Boot into a WinesapOS version 4.10 flash drive and select the `nobara` kernel
- open terminal and type `sudo pacman -S bash` then
- type in `lsblk` in the terminal to make sure you found the correct drive (edit the code to the drive you want)
- download the script from this github site
- change the file to the new partiton you want it in from the `lsblk` list
- after that type this in the terminal `sudo ./path/to/winesapdualboot.sh`
- reboot the computer and remove the usb you used for the installer
- once booted into winesapos type this to add windows to the boot menu :
```
# Enable os-prober. It is disabled by default.
sudo crudini --ini-options=nospace --set /etc/default/grub "" GRUB_DISABLE_OS_PROBER false
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
WinesapDualboot also works on :

- WinesapOS
- GuestSneezeOS
