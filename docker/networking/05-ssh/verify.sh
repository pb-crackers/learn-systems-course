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

echo "=== Verifying: SSH Key-Based Authentication ==="
echo ""

# Check 1: SSH key pair exists (ed25519 or rsa)
if [ -f ~/.ssh/id_ed25519 ] && [ -f ~/.ssh/id_ed25519.pub ]; then
  check "Ed25519 key pair exists (~/.ssh/id_ed25519 and id_ed25519.pub)" "pass"
elif [ -f ~/.ssh/id_rsa ] && [ -f ~/.ssh/id_rsa.pub ]; then
  check "RSA key pair exists (~/.ssh/id_rsa and id_rsa.pub)" "pass"
else
  check "No SSH key pair found — run: ssh-keygen -t ed25519 -C 'lab-key' -f ~/.ssh/id_ed25519 -N ''" "fail"
fi

# Check 2: Key-based SSH to sshd-server succeeds without password
if ssh -o BatchMode=yes -o StrictHostKeyChecking=no -o ConnectTimeout=5 student@sshd-server exit 2>/dev/null; then
  check "Key-based SSH to sshd-server succeeds without password prompt" "pass"
else
  check "Key-based SSH failed — did you run ssh-copy-id to install your public key? (run: ssh-copy-id student@sshd-server)" "fail"
fi

# Check 3: ~/.ssh/config file exists and contains sshd-server entry
if [ -f ~/.ssh/config ] && grep -q "sshd-server\|Host" ~/.ssh/config; then
  check "~/.ssh/config file exists and contains SSH host configuration" "pass"
else
  check "Create ~/.ssh/config with a Host sshd-server entry for convenience" "fail"
fi

echo ""
if [ "$FAIL" -eq 0 ]; then
  printf "\033[32mRESULT: PASS\033[0m — All %d checks passed.\n" "$PASS"
else
  printf "\033[31mRESULT: FAIL\033[0m — %d of %d checks failed.\n" "$FAIL" "$((PASS + FAIL))"
  exit 1
fi
