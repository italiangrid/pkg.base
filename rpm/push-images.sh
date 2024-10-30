#!/bin/bash
set -ex
tags=${tags:-"almalinux9base almalinux9java8 almalinux9java11 almalinux9java17"}

for t in ${tags}; do
  docker push italiangrid/pkg.base:${t}
done
