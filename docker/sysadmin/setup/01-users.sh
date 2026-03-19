#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: User and Group Management ==="
echo "Setting up environment..."

# Pre-create accounts you will manage during the exercise
useradd -m -s /bin/bash testuser1 2>/dev/null || true
useradd -m -s /bin/bash testuser2 2>/dev/null || true

# Pre-create groups
groupadd devteam 2>/dev/null || true
groupadd ops 2>/dev/null || true

# Ensure sudoers.d directory exists
mkdir -p /etc/sudoers.d
chmod 750 /etc/sudoers.d

cat <<'INSTRUCTIONS'

Your task: manage users and groups on this Linux system.
You are a sysadmin onboarding two new engineers to the devteam and ops groups.

Exercises:
  1. Create a new user called "alice" with a home directory and bash shell:
       sudo useradd -m -s /bin/bash alice

  2. Set alice's password:
       sudo passwd alice

  3. Add alice to the devteam group:
       sudo usermod -aG devteam alice

  4. Create a new user called "bob" and add him to the ops group:
       sudo useradd -m -s /bin/bash bob
       sudo usermod -aG ops bob

  5. Grant alice passwordless sudo access via a sudoers drop-in file:
       echo "alice ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/alice
       sudo chmod 440 /etc/sudoers.d/alice

  6. Verify your work:
       id alice        # shows uid, gid, groups
       groups alice    # shows group list
       sudo -l -U alice  # shows sudo permissions

  7. Inspect the system files:
       grep alice /etc/passwd   # see the account record
       grep devteam /etc/group  # see the group member list

When done, run: bash /usr/local/lib/learn-systems/verify/01-users.sh

INSTRUCTIONS

echo "Lab ready! You are in $(pwd)"
echo "When done, run: bash /usr/local/lib/learn-systems/verify/01-users.sh"
exec /bin/bash
