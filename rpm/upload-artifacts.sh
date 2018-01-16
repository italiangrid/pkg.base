#!/bin/bash
set -ex

required_env="PKG_NEXUS_USERNAME PKG_NEXUS_PASSWORD PKG_NEXUS_HOST PKG_NEXUS_REPONAME BUILD_PLATFORM"

for v in ${required_env}; do
    if [ ! -n "${!v}" ]; then
        echo "${v} is required to upload artifacts"
        exit 1
    fi
done

nexus-assets-upload \
    -u ${PKG_NEXUS_USERNAME} \
    -p ${PKG_NEXUS_PASSWORD} \
    -H ${PKG_NEXUS_HOST} \
    -r ${PKG_NEXUS_REPONAME} \
    -d /stage-area/${BUILD_PLATFORM}
