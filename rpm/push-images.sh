#!/bin/bash
set -ex
tags=${tags:-"centos6 centos6devtoolset7 centos7 centos8"}

if [ -n "${DOCKER_REGISTRY_HOST}" ]; then
  for t in ${tags}; do
    docker tag italiangrid/pkg.base:${t} ${DOCKER_REGISTRY_HOST}/italiangrid/pkg.base:${t}
    docker push ${DOCKER_REGISTRY_HOST}/italiangrid/pkg.base:${t}
  done
fi

if [ -n "${PUSH_TO_DOCKERHUB}" ]; then
  for t in ${tags}; do
    docker push italiangrid/pkg.base:${t}
  done
fi
