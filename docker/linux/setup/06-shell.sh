#!/usr/bin/env bash
set -euo pipefail
echo "=== Lab: Shell Fundamentals ==="
echo "Setting up environment..."

mkdir -p /tmp/exercise

# Create sample files for redirect and pipeline exercises
cat <<'MIXEDFILE' > /tmp/exercise/mixed-output.sh
#!/usr/bin/env bash
echo "This goes to stdout"
echo "This is an ERROR message" >&2
echo "More stdout output"
echo "Another ERROR" >&2
MIXEDFILE
chmod +x /tmp/exercise/mixed-output.sh

# Create a sample data file for pipeline exercises
cat <<'DATAFILE' > /tmp/exercise/servers.txt
web-01.prod.example.com 10.0.1.10 nginx
web-02.prod.example.com 10.0.1.11 nginx
db-01.prod.example.com 10.0.2.10 postgres
db-02.prod.example.com 10.0.2.11 postgres
cache-01.prod.example.com 10.0.3.10 redis
worker-01.prod.example.com 10.0.4.10 celery
worker-02.prod.example.com 10.0.4.11 celery
worker-03.prod.example.com 10.0.4.12 celery
DATAFILE

cat <<'INSTRUCTIONS'

Your task: understand how the shell manages its environment, and compose
multi-stage pipelines. These are daily tools for log analysis, configuration
management, and debugging CI/CD issues.

Exercises:
  1. Capture environment variables:
       env
     or: printenv
     Save the output to /tmp/exercise/env-output.txt

  2. Explore PATH — understand how the shell finds commands:
       echo $PATH
       which ls
       which bash
     Add a directory to PATH:
       export PATH="$PATH:/opt/custom/bin"
       echo $PATH

  3. Build a multi-stage pipeline and save the result:
     Count how many web servers are in servers.txt:
       grep "nginx" /tmp/exercise/servers.txt | wc -l
     Count unique service types:
       awk '{print $3}' /tmp/exercise/servers.txt | sort | uniq -c | sort -rn
     Save any pipeline result to /tmp/exercise/pipeline-result.txt

  4. Redirect both stdout and stderr to a single file:
       /tmp/exercise/mixed-output.sh > /tmp/exercise/combined-output.txt 2>&1
     Check both streams are captured:
       cat /tmp/exercise/combined-output.txt

  5. Understand stdin/stdout/stderr file descriptors:
       ls /proc/$$/fd/    # see the shell's open file descriptors
       # 0=stdin, 1=stdout, 2=stderr

When done, run: bash /usr/local/lib/learn-systems/verify/06-shell.sh

INSTRUCTIONS

echo ""
echo "Lab ready! You are in $(pwd)"
echo "Sample files at: /tmp/exercise/"
echo "When done, run: bash /usr/local/lib/learn-systems/verify/06-shell.sh"
exec /bin/bash
