#!/usr/bin/env bash
set -euo pipefail

PASS=0
FAIL=0

check() {
  local desc="$1"
  local result="$2"
  if [ "$result" = "pass" ]; then
    printf "  \033[32mPASS\033[0m: %s\n" "$desc"
    PASS=$((PASS + 1))
  else
    printf "  \033[31mFAIL\033[0m: %s\n" "$desc"
    FAIL=$((FAIL + 1))
  fi
}

echo "=== Verifying: System Monitoring ==="
echo ""

# Check 1: uptime command is available and produces output
if uptime &>/dev/null 2>&1; then
  LOAD=$(uptime | grep -oE 'load average.*')
  check "uptime produces load average output ($LOAD)" "pass"
else
  check "uptime command is available" "fail"
fi

# Check 2: vmstat is installed and produces output
if command -v vmstat &>/dev/null && vmstat 1 1 &>/dev/null 2>&1; then
  check "vmstat is installed and produces output" "pass"
else
  check "vmstat is available (sysstat package required)" "fail"
fi

# Check 3: iostat is installed (from sysstat package)
if command -v iostat &>/dev/null; then
  check "iostat is installed (sysstat package)" "pass"
else
  check "iostat is installed (install: apt-get install -y sysstat)" "fail"
fi

# Check 4: top is installed
if command -v top &>/dev/null; then
  check "top is installed and available" "pass"
else
  check "top command is available (install: apt-get install -y procps)" "fail"
fi

# Check 5: scenario scripts are present
if [ -f /usr/local/bin/scenario-cpu.sh ] && \
   [ -f /usr/local/bin/scenario-io.sh ] && \
   [ -f /usr/local/bin/scenario-memory.sh ]; then
  check "Monitoring scenario scripts are installed at /usr/local/bin/" "pass"
else
  check "Scenario scripts present (run setup: bash /usr/local/lib/learn-systems/setup/06-monitoring.sh)" "fail"
fi

# Check 6: learner captured load average (look for an output file)
# Learner should have run uptime and redirected output — we check for common save locations
if [ -f /tmp/load-average.txt ] || [ -f /home/student/load-average.txt ] || \
   [ -f /tmp/uptime.txt ] || [ -f /home/student/uptime.txt ]; then
  check "Load average captured to a file (found output file)" "pass"
else
  # Soft check — not blocking. Learner may have just observed interactively.
  printf "  \033[33mSKIP\033[0m: Load average file not found (optional: run: uptime > /tmp/load-average.txt)\n"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
