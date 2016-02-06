#!/bin/bash
set -ex
tags="centos6"

if [ -z "${DOCKER_REGISTRY_HOST}" ]; then
  echo "Please define the DOCKER_REGISTRY_HOST environment variable before running this script."
  exit 1
fi

for t in ${tags}; do
  docker tag -f  italiangrid/pkg.base:${t} ${DOCKER_REGISTRY_HOST}/italiangrid/pkg.base:${t}
  docker push ${DOCKER_REGISTRY_HOST}/italiangrid/pkg.base:${t}
done
