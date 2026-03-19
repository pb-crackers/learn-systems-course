#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: Shell Scripting ==="
echo "Setting up environment..."

mkdir -p /tmp/exercise

# Create test data files the deploy script should process
mkdir -p /tmp/exercise/config
echo "app_name=myapp" > /tmp/exercise/config/app.cfg
echo "version=1.0.0" >> /tmp/exercise/config/app.cfg
echo "environment=production" >> /tmp/exercise/config/app.cfg

# Create a partially-written script template for the learner to complete
cat <<'TEMPLATE' > /tmp/exercise/deploy.sh
# EXERCISE: Complete this deployment script
# This script needs:
#   1. A proper shebang line (#!/usr/bin/env bash)
#   2. set -euo pipefail for safe execution
#   3. Argument validation (require at least 1 argument: the environment name)
#   4. A function that prints a timestamped log message
#   5. A trap that logs "Deployment interrupted" on EXIT or ERR

# TODO: Add shebang on line 1
# TODO: Add set -euo pipefail

# TODO: Replace this with a real log function
# log() { echo "..." }

# TODO: Add argument validation
# if [ $# -lt 1 ]; then ... fi

TARGET_ENV="${1:-}"

echo "Deploying to environment: $TARGET_ENV"

# TODO: Add a trap for cleanup
# trap "log 'Deployment interrupted'" EXIT ERR

# Read config
if [ -f /tmp/exercise/config/app.cfg ]; then
  source /tmp/exercise/config/app.cfg
  echo "App: $app_name v$version"
fi

echo "Deployment complete."
TEMPLATE

# Do NOT chmod +x the template — learner must do that

cat <<'INSTRUCTIONS'

Your task: complete and harden a deployment script template. Production scripts
must be robust: they need proper error handling, input validation, and cleanup
traps so partial deployments are always noticed and cleaned up.

The incomplete script is at: /tmp/exercise/deploy.sh

Steps to complete it:
  1. Add the shebang as the FIRST line:
       #!/usr/bin/env bash

  2. Add safe-mode flags on the second non-comment line:
       set -euo pipefail

  3. Add a log function above the TARGET_ENV line:
       log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"; }

  4. Add argument validation (exits with non-zero if no arg given):
       if [ $# -lt 1 ]; then
         echo "Usage: $0 <environment>" >&2
         exit 1
       fi

  5. Add a trap for cleanup (put it after the log function):
       trap 'log "Deployment interrupted or completed"' EXIT

  6. Make the script executable:
       chmod +x /tmp/exercise/deploy.sh

  7. Test it runs successfully:
       bash /tmp/exercise/deploy.sh staging

  Use your preferred editor: nano, vim, or vi.

When done, run: bash /usr/local/lib/learn-systems/verify/07-scripting.sh

INSTRUCTIONS

echo ""
echo "Lab ready! You are in $(pwd)"
echo "Script template at: /tmp/exercise/deploy.sh"
echo "Edit it, then run: bash /usr/local/lib/learn-systems/verify/07-scripting.sh"
exec /bin/bash
