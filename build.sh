#!/bin/bash
set -eux

BUILDAH="buildah --storage-driver overlay2"
BASE_REGISTRY="registry.fedoraproject.org"
BASE_IMAGE="fedora:26"
BUILT_IMAGE="vrutkovs/buildroot:latest"

$BUILDAH inspect -t image $BASE_IMAGE > /dev/null
if [ $? != 0 ]; then
  skopeo copy docker://$BASE_REGISTRY/$BASE_IMAGE containers-storage:$BASE_IMAGE
fi
$BUILDAH bud --pull=false --tag $BUILT_IMAGE  .
$BUILDAH push $BUILT_IMAGE docker-daemon:$BUILT_IMAGE
