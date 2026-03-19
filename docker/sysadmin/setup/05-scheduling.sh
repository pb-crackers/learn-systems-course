#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: Process Scheduling ==="
echo "Setting up environment..."

# Create the scripts that learner will schedule
cat > /usr/local/bin/backup.sh <<'SCRIPT'
#!/usr/bin/env bash
# Simulated backup script
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
BACKUP_DIR=/var/backups/myapp
mkdir -p "$BACKUP_DIR"
echo "$TIMESTAMP: Backup completed — 0 bytes (simulation)" >> "$BACKUP_DIR/backup.log"
echo "Backup complete: $TIMESTAMP"
SCRIPT
chmod +x /usr/local/bin/backup.sh

cat > /usr/local/bin/report.sh <<'SCRIPT'
#!/usr/bin/env bash
# Simulated daily report script
REPORT_DIR=/var/log/reports
mkdir -p "$REPORT_DIR"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
{
  echo "=== System Report $TIMESTAMP ==="
  echo "Uptime: $(uptime)"
  echo "Disk usage:"
  df -h /
  echo "Memory:"
  free -h
} >> "$REPORT_DIR/daily.log"
echo "Report written: $REPORT_DIR/daily.log"
SCRIPT
chmod +x /usr/local/bin/report.sh

# Create directories for output
mkdir -p /var/backups/myapp /var/log/reports

# Start cron daemon if not running
service cron start 2>/dev/null || crond 2>/dev/null || true

cat <<'INSTRUCTIONS'

Your task: schedule backup.sh and report.sh using both cron and systemd timers.

Scripts available:
  /usr/local/bin/backup.sh  — writes to /var/backups/myapp/backup.log
  /usr/local/bin/report.sh  — writes to /var/log/reports/daily.log

Exercises:
  1. Test the scripts manually first:
       bash /usr/local/bin/backup.sh
       bash /usr/local/bin/report.sh

  2. Schedule backup.sh with cron (every 2 minutes for testing):
       crontab -e
       Add this line:
         */2 * * * * /usr/local/bin/backup.sh

  3. List your crontab to confirm:
       crontab -l

  4. Wait 2-3 minutes and check the log:
       cat /var/backups/myapp/backup.log

  5. Create a systemd timer pair for report.sh:
     Create /etc/systemd/system/report.service:
       [Unit]
       Description=Daily System Report

       [Service]
       Type=oneshot
       ExecStart=/usr/local/bin/report.sh

     Create /etc/systemd/system/report.timer:
       [Unit]
       Description=Daily Report Timer

       [Timer]
       OnCalendar=*-*-* 09:00:00
       Persistent=true

       [Install]
       WantedBy=timers.target

  6. Activate the timer:
       sudo systemctl daemon-reload
       sudo systemctl enable --now report.timer
       sudo systemctl list-timers --all

  7. Use `at` to run a one-off task:
       echo "/usr/local/bin/report.sh" | at now + 1 minute
       atq   # list pending at jobs

When done, run: bash /usr/local/lib/learn-systems/verify/05-scheduling.sh

INSTRUCTIONS

echo "Lab ready!"
echo "  /usr/local/bin/backup.sh and report.sh are installed"
echo "  cron daemon started"
echo "When done, run: bash /usr/local/lib/learn-systems/verify/05-scheduling.sh"
exec /bin/bash
