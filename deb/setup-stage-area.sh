#!/bin/bash
set -ex

stage_area_dir=/stage-area/${BUILD_PLATFORM}

if [ -n "${PKG_STAGE_DIR}" ]; then
  stage_area_dir=${PKG_STAGE_DIR}
fi

cat << EOF > /etc/apt/sources.list.d/build-stage-area.list
deb file:/${stage_area_dir} ./
EOF

mkdir -p ${stage_area_dir}

if [ ! -f "${stage_area_dir}/Packages.gz" ]; then
  cd ${stage_area_dir}
  dpkg-scanpackages -m . | gzip --fast > Packages.gz
  
  chown -R ${BUILD_USER}:${BUILD_USER} ${stage_area_dir}
fi
