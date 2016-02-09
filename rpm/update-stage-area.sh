#!/bin/bash
set -ex

mkdir -p /stage-area/${BUILD_PLATFORM}
createrepo /stage-area/${BUILD_PLATFORM}
