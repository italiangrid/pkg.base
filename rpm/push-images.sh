#!/bin/bash
set -ex
tags=${tags:-"centos6 centos6devtoolset7 centos7 centos8"}

for t in ${tags}; do
  docker push italiangrid/pkg.base:${t}
done
