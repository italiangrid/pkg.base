#!/bin/bash
set -ex
tags=${tags:-"almalinux9base almalinux9java8 almalinux9java11 almalinux9java17"}
docker_opts=${docker_opts:-"--rm=true --no-cache=true"}

for t in ${tags}; do
    docker build \
      ${docker_opts} \
      -t italiangrid/pkg.base:${t} -f Dockerfile.${t} .
done
