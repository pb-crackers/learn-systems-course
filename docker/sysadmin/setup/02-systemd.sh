#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: systemd Service Management ==="
echo "Setting up environment..."

# Create the target script that the service will run
cat > /usr/local/bin/hello.sh <<'SCRIPT'
#!/usr/bin/env bash
while true; do
  echo "$(date '+%Y-%m-%d %H:%M:%S') hello-service: heartbeat"
  sleep 5
done
SCRIPT
chmod +x /usr/local/bin/hello.sh

cat <<'INSTRUCTIONS'

Your task: create and manage a systemd service for the hello.sh script.
The script at /usr/local/bin/hello.sh runs a continuous heartbeat loop.

Exercises:
  1. Create a systemd unit file at /etc/systemd/system/hello.service:
       sudo nano /etc/systemd/system/hello.service

     Contents:
       [Unit]
       Description=Hello World Service
       After=network.target

       [Service]
       Type=simple
       ExecStart=/usr/local/bin/hello.sh
       Restart=on-failure
       RestartSec=5s
       StandardOutput=journal
       StandardError=journal

       [Install]
       WantedBy=multi-user.target

  2. Reload the systemd daemon to discover the new unit:
       sudo systemctl daemon-reload

  3. Start and enable the service:
       sudo systemctl start hello
       sudo systemctl enable hello

  4. Verify the service is running:
       sudo systemctl status hello
       sudo journalctl -u hello -f   (Ctrl+C to stop)

  5. Practice the service lifecycle:
       sudo systemctl stop hello
       sudo systemctl restart hello
       sudo systemctl disable hello

  6. Read logs from the last boot:
       sudo journalctl -u hello -b

When done, run: bash /usr/local/lib/learn-systems/verify/02-systemd.sh

NOTE: This lab requires the systemd container (Dockerfile.systemd).
Run with: docker run -d --name sysadmin-systemd --privileged \
  --tmpfs /tmp --tmpfs /run --tmpfs /run/lock \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro sysadmin-systemd
Then: docker exec -it sysadmin-systemd bash

INSTRUCTIONS

echo "Lab ready! /usr/local/bin/hello.sh is installed."
echo "When done, run: bash /usr/local/lib/learn-systems/verify/02-systemd.sh"
exec /bin/bash
