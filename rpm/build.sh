#!/bin/bash
set -eax

if [[ $# -eq 1 ]]; then
  source $1
fi

set +a

# Print env
env

# Setup stage area
make setup-stage-area

if [ -n "${SUDO_BUILD}" ]; then
  sudo -E /bin/bash -c "make"
else
  make
fi
