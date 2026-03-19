#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: Disk Management ==="
echo "Setting up environment..."

# Create a loopback file to simulate a real block device.
# This requires --privileged container mode.
# The loopback device is not persistent across container restarts —
# run this setup script at the start of each session.

DISK_IMG=/tmp/disk.img
LOOP_DEV=/dev/loop0

if [ -f "$DISK_IMG" ]; then
  echo "  Disk image already exists at $DISK_IMG"
else
  echo "  Creating 512M disk image at $DISK_IMG..."
  truncate -s 512M "$DISK_IMG"
fi

# Set up loopback device (clear existing first if in use)
if losetup "$LOOP_DEV" &>/dev/null 2>&1; then
  echo "  $LOOP_DEV already in use — detaching..."
  losetup -d "$LOOP_DEV" 2>/dev/null || true
fi

echo "  Attaching $DISK_IMG to $LOOP_DEV..."
losetup "$LOOP_DEV" "$DISK_IMG"

# Create mount point
mkdir -p /mnt/data

cat <<'INSTRUCTIONS'

Your task: partition, format, mount, and persist the loopback block device.
A 512 MB disk image has been attached at /dev/loop0.

NOTE: This lab requires --privileged container mode.

Exercises:
  1. Inspect the block device:
       lsblk
       lsblk -f /dev/loop0

  2. Partition the disk with fdisk:
       sudo fdisk /dev/loop0
       Commands inside fdisk:
         n  → new partition
         p  → primary partition
         1  → partition number 1
         (press Enter twice for default first/last sector — uses whole disk)
         w  → write and exit

  3. Refresh kernel partition table:
       sudo partprobe /dev/loop0

  4. Format the partition with ext4:
       sudo mkfs.ext4 /dev/loop0p1

  5. Mount the partition:
       sudo mount /dev/loop0p1 /mnt/data
       df -h /mnt/data

  6. Write a test file to confirm the mount:
       echo "mounted successfully" | sudo tee /mnt/data/test.txt
       cat /mnt/data/test.txt

  7. Add a persistent fstab entry (use UUID for reliability):
       sudo blkid /dev/loop0p1   # copy the UUID
       echo "UUID=<your-uuid> /mnt/data ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab
       (replace <your-uuid> with the actual UUID from blkid)

  8. Verify fstab works:
       sudo umount /mnt/data
       sudo mount -a
       df -h /mnt/data

When done, run: bash /usr/local/lib/learn-systems/verify/04-disk.sh

WARNING: /dev/loop0 is not persistent — if you exit the container and re-enter,
run this setup script again: bash /usr/local/lib/learn-systems/setup/04-disk.sh

INSTRUCTIONS

echo "Lab ready!"
echo "  /dev/loop0 is attached (512M loopback device)"
echo "  /mnt/data is ready as mount point"
echo "When done, run: bash /usr/local/lib/learn-systems/verify/04-disk.sh"
exec /bin/bash
