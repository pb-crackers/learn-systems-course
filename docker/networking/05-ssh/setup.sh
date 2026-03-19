#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: SSH Key-Based Authentication ==="
echo "Setting up environment..."

mkdir -p /tmp/exercise

# Clear known_hosts to avoid "Host key verification failed" from previous runs
# (sshd-server generates new host keys each time it starts)
rm -f ~/.ssh/known_hosts

cat <<'INSTRUCTIONS'

You need to access a database server behind a firewall — only reachable
via SSH. This lab teaches you to set up key-based authentication so you
can connect without a password, and configure ~/.ssh/config for convenience.

The lab has a running SSH server at hostname "sshd-server" with:
  - Username: student
  - Password: changeme (for initial setup only — you will switch to keys)

Exercises:

  1. Generate an Ed25519 key pair (current best practice):
       ssh-keygen -t ed25519 -C "lab-key" -f ~/.ssh/id_ed25519 -N ""
     This creates:
       ~/.ssh/id_ed25519      — private key (never share this)
       ~/.ssh/id_ed25519.pub  — public key (safe to share)

  2. Copy the public key to the SSH server (password required this once):
       ssh-copy-id -i ~/.ssh/id_ed25519.pub student@sshd-server
     When prompted for password, enter: changeme

  3. Verify key-based authentication works (should not ask for a password):
       ssh -o StrictHostKeyChecking=no student@sshd-server "whoami && hostname"

  4. Create an SSH config file for convenience:
       mkdir -p ~/.ssh && chmod 700 ~/.ssh
       cat > ~/.ssh/config <<'EOF'
Host sshd-server
    HostName sshd-server
    User student
    IdentityFile ~/.ssh/id_ed25519
    StrictHostKeyChecking no
EOF
       chmod 600 ~/.ssh/config

  5. Connect using the config (shorter command):
       ssh sshd-server "echo connected successfully"

  6. Copy a file to the remote server using scp:
       echo "hello from client" > /tmp/exercise/test-file.txt
       scp /tmp/exercise/test-file.txt student@sshd-server:/tmp/

  7. Run a command on the remote server via SSH (non-interactive):
       ssh sshd-server "ip addr show && ss -tlnp"

NOTE: If you see "WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!" run:
  rm ~/.ssh/known_hosts
and retry. This happens when the server container is recreated.

When done, run: bash /verify/05-ssh.sh

INSTRUCTIONS

echo ""
echo "Lab ready! SSH server is at hostname 'sshd-server'"
echo "When done, run: bash /verify/05-ssh.sh"
exec /bin/bash
