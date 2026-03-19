#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: Logging and Log Management ==="
echo "Setting up environment..."

# Create application log directory
mkdir -p /var/log/myapp
chmod 755 /var/log/myapp

# Ensure rsyslog is available (systemd image)
# Start rsyslog if present and not running
if command -v rsyslogd &>/dev/null; then
  rsyslogd 2>/dev/null || true
fi

# Generate sample log entries using logger
for i in $(seq 1 20); do
  logger -t myapp "INFO: Application started — instance $i"
done
for i in $(seq 1 5); do
  logger -t myapp -p user.warning "WARN: High memory usage detected — check $i"
done
for i in $(seq 1 3); do
  logger -t myapp -p user.error "ERROR: Database connection timeout — attempt $i"
done

# Write sample structured log to application log directory
cat > /var/log/myapp/app.log <<'LOG'
2026-03-19T00:00:01Z INFO  Application starting on port 8080
2026-03-19T00:00:02Z INFO  Connected to database at 127.0.0.1:5432
2026-03-19T00:01:00Z INFO  Health check passed
2026-03-19T00:02:00Z WARN  Response time 450ms exceeds threshold (400ms)
2026-03-19T00:03:00Z ERROR Database connection lost — retrying in 5s
2026-03-19T00:03:05Z INFO  Database reconnected
2026-03-19T00:04:00Z INFO  Health check passed
2026-03-19T00:05:00Z INFO  Health check passed
LOG

cat <<'INSTRUCTIONS'

Your task: configure log rotation for the myapp application logs.

Sample log entries have been written to /var/log/myapp/app.log
and also sent to the system journal via the logger command.

Exercises:
  1. Browse existing logs:
       ls -la /var/log/myapp/
       cat /var/log/myapp/app.log

  2. Use journalctl to filter logs by application tag:
       journalctl -t myapp --no-pager
       journalctl -t myapp -p warning --no-pager

  3. Create a logrotate configuration for myapp:
       sudo nano /etc/logrotate.d/myapp

     Contents:
       /var/log/myapp/*.log {
           daily
           rotate 7
           compress
           delaycompress
           missingok
           notifempty
           create 644 root root
       }

  4. Test the logrotate configuration (dry run):
       sudo logrotate -d /etc/logrotate.d/myapp

  5. Force a rotation to verify it works:
       sudo logrotate -f /etc/logrotate.d/myapp
       ls -la /var/log/myapp/

  6. Filter system journal by time:
       journalctl --since "5 minutes ago" --no-pager

When done, run: bash /usr/local/lib/learn-systems/verify/03-logging.sh

INSTRUCTIONS

echo "Lab ready!"
echo "  /var/log/myapp/app.log has sample entries"
echo "  System journal has entries tagged 'myapp'"
echo "When done, run: bash /usr/local/lib/learn-systems/verify/03-logging.sh"
exec /bin/bash
