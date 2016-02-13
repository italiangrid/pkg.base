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

# Run build
make
