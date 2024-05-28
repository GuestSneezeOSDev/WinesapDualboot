# Enable os-prober. It is disabled by default.
sudo crudini --ini-options=nospace --set /etc/default/grub "" GRUB_DISABLE_OS_PROBER false
sudo grub-mkconfig -o /boot/grub/grub.cfg
