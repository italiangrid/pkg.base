#!/bin/bash
set -ex
tags=${tags:-"centos7 centos7java11 centos7java17 centos8"}
docker_opts=${docker_opts:-"--rm=true --no-cache=true"}

for t in ${tags}; do
    docker build \
      ${docker_opts} \
      -t italiangrid/pkg.base:${t} -f Dockerfile.${t} .
done
