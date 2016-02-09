#!/bin/bash
set -ex
tags=${tags:-"centos5 centos6 centos7"}

for t in ${tags}; do
    docker build -t italiangrid/pkg.base:${t} -f Dockerfile.${t} .
done
