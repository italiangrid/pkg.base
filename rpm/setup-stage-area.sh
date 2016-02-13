#!/bin/bash
set -ex

stage_area_dir=/stage-area/${BUILD_PLATFORM}

if [ -n "${PKG_STAGE_DIR}" ]; then
  stage_area_dir=${PKG_STAGE_DIR}
fi

cat << EOF > /etc/yum.repos.d/build-stage-area.repo
[build-stage-area]
name=build-stage-area
baseurl=file://${stage_area_dir}
protect=1
enabled=1
priority=1
gpgcheck=0
EOF

mkdir -p ${stage_area_dir}

if [ ! -d "${stage_area_dir}/repodata" ]; then
  createrepo ${stage_area_dir}
  chown -R build:build ${stage_area_dir}
fi

