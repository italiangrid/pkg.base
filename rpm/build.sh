#!/bin/bash
set -eax

if [[ $# -eq 1 ]]; then
  source $1
fi

set +a

# Setup stage area
make setup-stage-area

# Run pre-build script
make pre-build

# Run build
make
