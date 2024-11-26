#!/bin/bash

export PRESENT_WORK_DIR=`pwd`

echo "Present Working Directory " ${PRESENT_WORK_DIR}

export ENTITLED_REGISTRY=cp.icr.io

export ENTITLED_REGISTRY_USER=cp

export ENTITLED_REGISTRY_KEY="$(<ibm-entitlement-key)"

docker login -u $ENTITLED_REGISTRY_USER -p $ENTITLED_REGISTRY_KEY $ENTITLED_REGISTRY

docker pull cp.icr.io/cp/ibm-oms-enterprise/om-base:10.0.2409.1-amd64

docker images

docker volume create omsruntime

docker run -e LICENSE=accept -e LANG --privileged -v omsruntime:/images  -idt --name omsruntime cp.icr.io/cp/ibm-oms-enterprise/om-base:10.0.2409.1-amd64

docker ps

mkdir -p ${PRESENT_WORK_DIR}/opt/ssfs/runtime/dbjar/jdbc/postgresql

wget -O ${PRESENT_WORK_DIR}/opt/ssfs/runtime/dbjar/jdbc/postgresql/postgresql.jar https://repo1.maven.org/maven2/org/postgresql/postgresql/42.2.24/postgresql-42.2.24.jar

docker cp ${PRESENT_WORK_DIR}/opt/ssfs/runtime/* omsruntime:/opt/ssfs/runtime/

docker exec -it omsruntime mkdir -p /opt/ssfs/runtime/ThirdPartyJars

docker cp ${PRESENT_WORK_DIR}/ThirdPartyJars/* omsruntime:/opt/ssfs/runtime/ThirdPartyJars/
