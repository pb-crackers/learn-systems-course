#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: Operating Systems ==="
echo "Setting up environment..."

mkdir -p /tmp/exercise

cat <<'INSTRUCTIONS'

Your task: explore how the Linux kernel exposes OS internals through the
/proc virtual filesystem, and observe system calls in action using strace.

Exercises:
  1. Find the running kernel version:
       uname -r
     Save the output to /tmp/exercise/kernel-version.txt

  2. Trace system calls made by a simple command (ls):
       strace ls /tmp 2>/tmp/exercise/strace-output.txt
     The strace output goes to stderr — redirecting 2> sends it to the file.
     (strace writes to stderr to avoid polluting the command's stdout)

  3. Read the command line of PID 1 (the init process):
       cat /proc/1/cmdline | tr '\0' ' '
     Save the output to /tmp/exercise/init-cmdline.txt

  4. Explore /proc further:
       ls /proc/1/           # see all files the kernel exposes per-process
       cat /proc/1/status    # process status: state, memory, capabilities

  5. Count how many processes are running:
       ls /proc | grep -E '^[0-9]+$' | wc -l

When done, run: bash /usr/local/lib/learn-systems/verify/02-os.sh

INSTRUCTIONS

echo ""
echo "Lab ready! You are in $(pwd)"
echo "When done, run: bash /usr/local/lib/learn-systems/verify/02-os.sh"
exec /bin/bash
