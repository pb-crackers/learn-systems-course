#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: Package Management ==="
echo "Setting up environment..."

mkdir -p /tmp/exercise

# Run apt-get update now so the learner can install packages without waiting
echo "Updating package index (this may take a moment)..."
apt-get update -qq

cat <<'INSTRUCTIONS'

Your task: explore the two-layer Debian package management system (dpkg + apt),
install a package, query its files, and understand dependency resolution.
These are daily tasks: Dockerfiles, provisioning scripts, and server setup
all rely on apt working correctly.

The package index has been pre-updated for you (apt-get update already ran).

Exercises:
  1. Install the 'tree' package:
       apt-get install -y tree
     Test it: tree /tmp/exercise

  2. Query which files the tree package installed:
       dpkg -L tree
     Save the output to /tmp/exercise/tree-files.txt

  3. Check the tree package is installed and see its details:
       dpkg -s tree

  4. Query the dependencies of 'curl':
       apt-cache depends curl
     Save the output to /tmp/exercise/curl-deps.txt

  5. Find which package owns a file (reverse lookup):
       dpkg -S /usr/bin/curl

  6. Search for packages by keyword:
       apt-cache search compression | head -10

  7. View the repository sources:
       cat /etc/apt/sources.list

When done, run: bash /usr/local/lib/learn-systems/verify/09-packages.sh

INSTRUCTIONS

echo ""
echo "Lab ready! You are in $(pwd)"
echo "Package index is fresh — run: apt-get install -y tree"
echo "When done, run: bash /usr/local/lib/learn-systems/verify/09-packages.sh"
exec /bin/bash
