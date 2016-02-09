#!/bin/bash
cat << EOF > /etc/yum.repos.d/build-stage-area.repo
[build-stage-area]
name=build-stage-area
baseurl=file:///stage-area/${BUILD_PLATFORM}
protect=1
enabled=1
priority=1
gpgcheck=0
EOF
