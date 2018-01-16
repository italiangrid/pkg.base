#!/bin/bash
set -ex
tags=${tags:-"centos6 centos7 rawhide"}

for t in ${tags}; do
    docker build --pull=true \
      --rm=true --no-cache=true \
      -t italiangrid/pkg.base:${t} -f Dockerfile.${t} .
done
