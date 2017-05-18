#!/bin/bash
set -ex
tags=${tags:-"ubuntu1604"}

for t in ${tags}; do
    docker build --pull=true \
      --rm=true --no-cache=true \
      -t italiangrid/pkg.base:${t} -f Dockerfile.${t} .
done
