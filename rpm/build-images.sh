#!/bin/bash
set -ex
tags=${tags:-"centos6 centos6devtools7 centos7"}

for t in ${tags}; do
    docker build \
      --rm=true --no-cache=true \
      -t italiangrid/pkg.base:${t} -f Dockerfile.${t} .
done
