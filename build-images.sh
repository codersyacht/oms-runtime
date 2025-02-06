#!/bin/bash

cd /opt/ssfs/runtime/bin

./setupfiles.sh

echo "setupfiles execution completed"

./install3rdParty.sh yfsextn 1_0 -j /opt/ssfs/runtime/ThirdPartyJars/* -targetJVM EVERY

echo "3rd party jars installation completed"

./dbverify.sh

echo "dbverify completed"

cd /opt/ssfs/runtime/container-scripts/imagebuild

./generateImages.sh --MODE=app,agent --DEV_MODE=true --EXPORT=false

echo "Custom build completed"

echo "Generated images"

buildah images

buildah tag om-app:10.0 docker.io/codersyacht/oms-app:${INSTALL_VERSION}-${DB_NAME}-${TAG_VERSION}

buildah tag om-agent:10.0 docker.io/codersyacht/oms-agent:${INSTALL_VERSION}-${DB_NAME}-${TAG_VERSION}

buildah login -u codersyacht -p "$(<docker-key)" docker.io

buildah push docker.io/codersyacht/oms-app:${INSTALL_VERSION}-${DB_NAME}-${TAG_VERSION}

buildah push docker.io/codersyacht/oms-agent:${INSTALL_VERSION}-${DB_NAME}-${TAG_VERSION}

echo "Custom Images Push conmpleted"
