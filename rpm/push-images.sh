#!/bin/bash
set -ex
tags=${tags:-"centos5 centos6 centos7 rawhide"}

if [ -n "${DOCKER_REGISTRY_HOST}" ]; then
  for t in ${tags}; do
    docker tag -f  italiangrid/pkg.base:${t} ${DOCKER_REGISTRY_HOST}/italiangrid/pkg.base:${t}
    docker push ${DOCKER_REGISTRY_HOST}/italiangrid/pkg.base:${t}
  done
fi

if [ -n "${PUSH_TO_DOCKERHUB}" ]; then
  for t in ${tags}; do
    docker push italiangrid/pkg.base:${t}
  done
fi
