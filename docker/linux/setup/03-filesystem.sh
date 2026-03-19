#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: Linux Filesystem ==="
echo "Setting up environment..."

mkdir -p /tmp/exercise/subdir-a
mkdir -p /tmp/exercise/subdir-b

# Create an original file to practice hard/soft links on
echo "This is the original file content." > /tmp/exercise/original.txt
echo "Config file A" > /tmp/exercise/subdir-a/config-a.txt
echo "Config file B" > /tmp/exercise/subdir-b/config-b.txt

cat <<'INSTRUCTIONS'

Your task: explore the Linux filesystem through inodes, hard links, and
symbolic links. These concepts underlie everything from how log rotation
works to how package managers replace files atomically.

Exercises:
  1. Create a hard link to the original file:
       ln /tmp/exercise/original.txt /tmp/exercise/hardlink.txt
     Verify they share the same inode:
       stat -c '%i %n' /tmp/exercise/original.txt /tmp/exercise/hardlink.txt

  2. Create a symbolic link:
       ln -s /tmp/exercise/original.txt /tmp/exercise/softlink.txt
     Verify it is a symlink:
       ls -la /tmp/exercise/softlink.txt

  3. List files with inodes visible:
       ls -lai /tmp/exercise/
     Save the output to /tmp/exercise/inode-listing.txt

  4. Capture mount information:
       findmnt
     Save the output to /tmp/exercise/mount-info.txt

  5. Explore the /proc and /sys virtual filesystems:
       ls /proc
       ls /sys/block/

When done, run: bash /usr/local/lib/learn-systems/verify/03-filesystem.sh

INSTRUCTIONS

echo ""
echo "Lab ready! You are in $(pwd)"
echo "Files created: /tmp/exercise/original.txt (and subdirectories)"
echo "When done, run: bash /usr/local/lib/learn-systems/verify/03-filesystem.sh"
exec /bin/bash
