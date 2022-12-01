#!/bin/bash
set -ex
tags=${tags:-"centos7 centos7java11 centos7java17"}

for t in ${tags}; do
  docker push italiangrid/pkg.base:${t}
done
