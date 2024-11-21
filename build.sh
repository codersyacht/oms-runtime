#!/bin/bash

export PRESENT_WORK_DIR=`pwd`

echo "Present Working Directory " ${PRESENT_WORK_DIR}

export PRESENT_WORK_DIR=

export ENTITLED_REGISTRY=cp.icr.io

export ENTITLED_REGISTRY_USER=cp

export ENTITLED_REGISTRY_KEY="$(<ibm-entitlement-key)"

docker login -u $ENTITLED_REGISTRY_USER -p $ENTITLED_REGISTRY_KEY $ENTITLED_REGISTRY

docker pull cp.icr.io/cp/ibm-oms-enterprise/om-base:10.0.2409.1-amd64

docker images

docker volume create omsruntime

docker run -e LICENSE=accept -e LANG --privileged -v omsruntime:/images  -idt --name omsruntime cp.icr.io/cp/ibm-oms-enterprise/om-base:10.0.2409.1-amd64

docker ps

docker exec -it -w /opt/ssfs/runtime/bin omsruntime ./sci_ant.sh -f buildApplicationManagerClient.xml

sudo mkdir -p /opt/ssfs

sudo chmod -R 777  /opt/ssfs

sudo chown -R admin:admin /opt/ssfs

docker cp omsruntime:/opt/ssfs/runtime /opt/ssfs

mkdir -p /opt/ssfs/3rdpartyjars

cd /opt/ssfs/3rdpartyjars

wget -O postgresql.jar https://repo1.maven.org/maven2/org/postgresql/postgresql/42.2.24/postgresql-42.2.24.jar

pwd

ls

cd /opt/ssfs/runtime/bin

echo "Executing install3rdParty"

./install3rdParty.sh yfsextn 1_0 -j /opt/ssfs/3rdpartyjars/* -targetJVM EVERY

cp ${PRESENT_WORK_DIR}/sandbox.cfg_postgres /opt/ssfs/runtime/properties/sandbox.cfg

cp ${PRESENT_WORK_DIR}/customer_overrides.properties /opt/ssfs/runtime/properties/customer_overrides.properties

echo "Executing setupfiles"

./setupfiles.sh

echo "Executing dbverify"

./dbverify.sh

echo "Executing deployer"

./deployer.sh -t entitydeployer

echo "Executing loadFactoryDefault"

./loadFactoryDefaults.sh

echo "Executing buildear"

./buildear.sh -Dappserver=websphere -Dwarfiles=smcfs,sbc,sma -Dearfile=smcfs.ear -Ddevmode=true -Dnowebservice=true -Dnodocear=true create-ear


cd /opt/ssfs/

export JAVA_HOME=/opt/ssfs/runtime/jdk

export PATH=$JAVA_HOME/bin:$PATH 

mkdir jndi

cp ${PRESENT_WORK_DIR}/.bindings /opt/ssfs/jndi/

wget -O wlp.zip https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/24.0.0.11/wlp-webProfile8-24.0.0.11.zip

unzip wlp.zip

rm wlp.zip

cd /opt/ssfs/wlp/bin

./installUtility install servlet-3.1

./server create omsserver

cd /opt/ssfs/wlp/usr/servers/omsserver

rm server.xml

mv ${PRESENT_WORK_DIR}/server.xml /opt/ssfs/wlp/usr/servers/omsserver/server.xml

mv ${PRESENT_WORK_DIR}/jvm.options /opt/ssfs/wlp/usr/servers/omsserver/jvm.options

cp /opt/ssfs/runtime/external_deployments/smcfs.ear /opt/ssfs/wlp/usr/servers/omsserver/dropins/

cd /opt/ssfs/wlp/usr/servers/omsserver/bin

./server start omsserver
