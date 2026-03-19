#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: How Computers Work ==="
echo "Setting up environment..."

mkdir -p /tmp/exercise

cat <<'INSTRUCTIONS'

Your task: profile the hardware of this "server" using the Linux kernel's
/proc and /sys interfaces. You are a junior DevOps engineer who needs to
document the hardware before deciding whether to scale up or migrate the
workload.

Exercises:
  1. Count CPU cores (logical CPUs):
       grep -c '^processor' /proc/cpuinfo
     Save the number to /tmp/exercise/cpu-cores.txt

  2. Read total memory from the kernel:
       grep MemTotal /proc/meminfo
     Save the line (or just the value) to /tmp/exercise/total-memory.txt

  3. List block devices:
       lsblk
     Save the output to /tmp/exercise/block-devices.txt

  4. Check disk usage on mounted filesystems:
       df -h
     (observe — no file to create for this one)

  5. Explore /proc further:
       cat /proc/loadavg
       cat /proc/uptime

When done, run: bash /usr/local/lib/learn-systems/verify/01-computers.sh

INSTRUCTIONS

echo ""
echo "Lab ready! You are in $(pwd)"
echo "When done, run: bash /usr/local/lib/learn-systems/verify/01-computers.sh"
exec /bin/bash
