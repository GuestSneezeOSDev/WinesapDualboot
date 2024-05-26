#!/bin/bash

# Define the device path (change accordingly)
DEVICE="/dev/sda"

# Function to partition the disk
partition_disk() {
    # Partition 1: ext4 with label winesapos-boot0
    parted -s "$DEVICE" mkpart primary ext4 0% 1000MiB
    e2label "$DEVICE"1 winesapos-boot0

    # Partition 2: btrfs with label winesapos-root0
    parted -s "$DEVICE" mkpart primary btrfs 1000MiB 100%
    btrfs filesystem label "$DEVICE"2 winesapos-root0
}

# Main function
main() {
    # Check if GParted is installed
    if ! command -v parted &> /dev/null; then
        echo "GParted is not installed. Please install it first."
        exit 1
    fi

    # Check if the script is running as root
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root."
        exit 1
    fi

    # Display the device information
    echo "Partitioning device: $DEVICE"
    echo "WARNING: This will erase all data on $DEVICE. Proceed with caution!"

    # Prompt user for confirmation
    read -p "Do you want to proceed? (y/n): " choice
    case "$choice" in
        y|Y ) partition_disk;;
        n|N ) echo "Partitioning aborted."; exit 0;;
        * ) echo "Invalid choice. Exiting."; exit 1;;
    esac
}

# Run the main function
main

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

# this part downloads tars
sudo tar --extract --keep-old-files --verbose --file /run/media/winesap/wos-drive/winesapos-${WINESAPOS_VERSION}-minimal-rootfs.tar.zst --directory /mnt/

# configure mr bootloader
grep -v -P "winesapos|WOS" /mnt/etc/fstab | sudo tee /mnt/etc/fstab
genfstab -L /mnt | sudo tee -a /mnt/etc/fstab
sudo mount --rbind /dev /mnt/dev
sudo mount --rbind /sys /mnt/sys
sudo mount -t proc /proc /mnt/proc
sudo chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=winesapOS
sudo chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
sudo chroot /mnt mkinitcpio -P
sudo sync
