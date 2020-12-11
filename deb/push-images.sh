#!/bin/bash
set -ex
tags=${tags:-"ubuntu1604"}

for t in ${tags}; do
  docker push italiangrid/pkg.base:${t}
done
