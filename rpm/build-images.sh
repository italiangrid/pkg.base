#!/bin/bash
set -ex
tags=${tags:-"centos5 centos6 centos7"}

for t in ${tags}; do
    # Grab latest centos image
    docker pull centos:${t}
    docker build -t italiangrid/pkg.base:${t} -f Dockerfile.${t} .
done
