#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: Processes ==="
echo "Setting up environment..."

mkdir -p /tmp/exercise

# Start a long-running background process that the learner needs to find
# Using a named script so pgrep can find it reliably by name
cat <<'BGSCRIPT' > /tmp/exercise/runaway.sh
#!/usr/bin/env bash
# Simulates a CPU-consuming runaway process
while true; do
  : # no-op busy loop — uses CPU
done
BGSCRIPT
chmod +x /tmp/exercise/runaway.sh

# Launch it in background — learner must find and manage it
/tmp/exercise/runaway.sh &
BGPID=$!
echo "$BGPID" > /tmp/exercise/.runaway-pid

cat <<'INSTRUCTIONS'

Your task: a server has a runaway process consuming CPU. You need to find it,
inspect it via /proc, and stop it gracefully. This is the fundamental skill
for any production incident involving stuck or misbehaving processes.

Background: a "runaway.sh" process was launched automatically. Find it.

Exercises:
  1. Find the runaway process:
       ps aux | grep runaway
     Or: pgrep -l runaway
     Save the PID to /tmp/exercise/found-pid.txt
       echo <PID> > /tmp/exercise/found-pid.txt

  2. Read the process's command line from /proc:
       cat /proc/<PID>/cmdline | tr '\0' ' '
     Save the output to /tmp/exercise/process-cmdline.txt

  3. Check the process's state and memory:
       grep -E 'Name|State|Pid|PPid|VmRSS' /proc/<PID>/status

  4. Send SIGTERM to stop it gracefully:
       kill <PID>
     Confirm it stopped:
       ps aux | grep runaway | grep -v grep

  5. Record that you sent the signal:
       echo "Sent SIGTERM to <PID>" > /tmp/exercise/signal-sent.txt

  6. Practice SIGSTOP/SIGCONT with a sleep process:
       sleep 300 &
       SLEEP_PID=$!
       kill -STOP $SLEEP_PID
       ps aux | grep sleep     # STAT should show 'T' (stopped)
       kill -CONT $SLEEP_PID
       kill $SLEEP_PID

  7. Use kill -0 to test if a process exists without signaling:
       kill -0 <PID> 2>/dev/null && echo "alive" || echo "not running"

When done, run: bash /usr/local/lib/learn-systems/verify/05-processes.sh

INSTRUCTIONS

echo ""
echo "Lab ready! You are in $(pwd)"
echo "A runaway process is running in the background — find it with: ps aux | grep runaway"
echo "When done, run: bash /usr/local/lib/learn-systems/verify/05-processes.sh"
exec /bin/bash
