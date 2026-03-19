#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: File Permissions and Ownership ==="
echo "Setting up environment..."

mkdir -p /tmp/exercise/scripts
mkdir -p /tmp/exercise/shared

# Create a sensitive file that is currently world-readable (needs securing)
echo "DB_PASSWORD=supersecret123" > /tmp/exercise/secret.txt
chmod 644 /tmp/exercise/secret.txt  # deliberately insecure — learner must fix this

# Create a deploy script that needs to be made executable
cat <<'SCRIPT' > /tmp/exercise/scripts/deploy.sh
#!/usr/bin/env bash
echo "Deploying application..."
echo "Done."
SCRIPT

# shared/ currently has no sticky bit — learner must set it
chmod 777 /tmp/exercise/shared

cat <<'INSTRUCTIONS'

Your task: secure a web application file structure by applying correct
permissions. This mirrors real-world work: new servers often have files
with insecure default permissions that need to be locked down before deployment.

Current state (needs fixing):
  - /tmp/exercise/secret.txt        — contains credentials, currently 644 (world-readable!)
  - /tmp/exercise/scripts/          — scripts directory, needs correct execute permissions
  - /tmp/exercise/scripts/deploy.sh — deploy script, must be executable by owner
  - /tmp/exercise/shared/           — shared directory, needs sticky bit protection

Exercises:
  1. Secure the credentials file (owner read/write only):
       chmod 600 /tmp/exercise/secret.txt
     Verify: ls -la /tmp/exercise/secret.txt  (should show -rw-------)

  2. Make the scripts/ directory executable by owner (traverse it):
       chmod 750 /tmp/exercise/scripts
     Verify: ls -la /tmp/exercise/  (should show drwxr-x---)

  3. Make the deploy script executable by its owner:
       chmod u+x /tmp/exercise/scripts/deploy.sh
     Verify: ls -la /tmp/exercise/scripts/deploy.sh

  4. Set the sticky bit on the shared/ directory:
       chmod +t /tmp/exercise/shared
     Verify: ls -la /tmp/exercise/  (shared/ should end in 't': drwxrwxrwt)

  5. Observe the /tmp directory — it always has the sticky bit set:
       ls -la / | grep ' tmp'
       stat /tmp

When done, run: bash /usr/local/lib/learn-systems/verify/04-permissions.sh

INSTRUCTIONS

echo ""
echo "Lab ready! You are in $(pwd)"
echo "Secret file at: /tmp/exercise/secret.txt (currently insecure — chmod 600 it!)"
echo "When done, run: bash /usr/local/lib/learn-systems/verify/04-permissions.sh"
exec /bin/bash
