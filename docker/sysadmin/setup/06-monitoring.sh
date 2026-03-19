#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: System Monitoring ==="
echo "Setting up environment..."

# Create scenario scripts — CPU-bound, I/O-bound, memory-pressure
# These generate artificial load that learner will identify with monitoring tools

cat > /usr/local/bin/scenario-cpu.sh <<'SCRIPT'
#!/usr/bin/env bash
# CPU-bound scenario: tight computation loop
# Creates high CPU usage with minimal I/O or memory activity
echo "Starting CPU-bound scenario (runs for 60s, then stops)"
echo "Use: top, vmstat 1 5, or htop in another terminal to observe"
end=$((SECONDS + 60))
while [ $SECONDS -lt $end ]; do
  # Tight loop — no sleep, pure CPU consumption
  x=1
  for i in $(seq 1 10000); do x=$((x * 2 % 65537)); done
done
echo "CPU-bound scenario complete"
SCRIPT
chmod +x /usr/local/bin/scenario-cpu.sh

cat > /usr/local/bin/scenario-io.sh <<'SCRIPT'
#!/usr/bin/env bash
# I/O-bound scenario: continuous disk writes
# Creates high I/O wait with moderate CPU usage
echo "Starting I/O-bound scenario (runs for 30s, then stops)"
echo "Use: iostat -x 1, vmstat 1 5 (watch 'wa' column) in another terminal"
end=$((SECONDS + 30))
while [ $SECONDS -lt $end ]; do
  dd if=/dev/urandom of=/tmp/io-test.bin bs=1M count=64 2>/dev/null
  sync
done
rm -f /tmp/io-test.bin
echo "I/O-bound scenario complete"
SCRIPT
chmod +x /usr/local/bin/scenario-io.sh

cat > /usr/local/bin/scenario-memory.sh <<'SCRIPT'
#!/usr/bin/env bash
# Memory pressure scenario: large array allocation
# Creates memory pressure — watch 'free -h' shrink, vmstat si/so if swap exists
echo "Starting memory pressure scenario (holds for 30s, then releases)"
echo "Use: free -h, vmstat 1 5 (watch 'free' memory column) in another terminal"
# Allocate ~200MB using a large bash array
declare -a large_array
for i in $(seq 1 200000); do
  large_array[$i]="padding-data-to-consume-memory-padding-data-$i"
done
echo "Allocated ~200MB. Holding for 30 seconds..."
sleep 30
unset large_array
echo "Memory pressure scenario complete — memory released"
SCRIPT
chmod +x /usr/local/bin/scenario-memory.sh

cat <<'INSTRUCTIONS'

Your task: identify system bottlenecks using Linux monitoring tools.

Three load scenarios are available:
  /usr/local/bin/scenario-cpu.sh    — CPU-bound workload (60s)
  /usr/local/bin/scenario-io.sh     — I/O-bound workload (30s)
  /usr/local/bin/scenario-memory.sh — Memory pressure (30s)

Exercises:
  1. Establish a baseline — observe the system at idle:
       uptime               # load averages at 1, 5, 15 minutes
       vmstat 1 5           # 5 samples, 1 second apart
       top                  # interactive view (q to quit)

  2. Run the CPU scenario in background and observe:
       bash /usr/local/bin/scenario-cpu.sh &
       vmstat 1 10          # watch 'r' (run queue) and 'us' (user CPU) columns
       top                  # identify the high-CPU process

  3. Run the I/O scenario and observe:
       bash /usr/local/bin/scenario-io.sh &
       vmstat 1 10          # watch 'wa' (I/O wait) column
       iostat -x 1 5        # watch '%util' column for the disk device

  4. Run the memory scenario and observe:
       bash /usr/local/bin/scenario-memory.sh &
       free -h              # watch 'available' column shrink
       vmstat 1 10          # watch 'free' and 'buff' columns

  5. Practice identifying the bottleneck type:
       - High 'us' in vmstat → CPU-bound
       - High 'wa' in vmstat → I/O-bound
       - Low 'free' + high 'si'/'so' in vmstat → memory pressure (swap)

When done, run: bash /usr/local/lib/learn-systems/verify/06-monitoring.sh

INSTRUCTIONS

echo "Lab ready!"
echo "  scenario-cpu.sh, scenario-io.sh, scenario-memory.sh installed at /usr/local/bin/"
echo "When done, run: bash /usr/local/lib/learn-systems/verify/06-monitoring.sh"
exec /bin/bash
