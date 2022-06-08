#!/bin/bash

mkdir -p "$HOME/tmp"
PIDFILE="$HOME/tmp/github-runner.pid"

if [ -e "${PIDFILE}" ] && (ps -u $(whoami) -opid= |
                           grep -P "^\s*$(cat ${PIDFILE})$" &> /dev/null); then
  echo "Already running."
  exit 99
fi

/work/noaa/nems/spack-stack/actions-runner/run.sh > $HOME/tmp/github-runner.log &

echo $! > "${PIDFILE}"
chmod 644 "${PIDFILE}"
