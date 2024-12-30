#!/bin/bash


sudo touch /opt/java_home.txt

sudo chown admin:admin /opt/java_home.txt

sudo echo "export JAVA_HOME=/opt/ssfs/runtime/jdk" >> /opt/java_home.txt

sudo echo "export PATH=/opt/ssfs/runtime/jdk/bin:$PATH" >> /opt/java_home.txt

echo "content of /opt/java_home.txt"

cat /opt/java_home.txt

sudo mkdir -p /opt/ssfs

sudo chown admin:admin -R /opt/ssfs

export PRESENT_WORK_DIR=`pwd`

echo "Present Working Directory " ${PRESENT_WORK_DIR}

docker cp omsruntime:/opt/ssfs/runtime /opt/ssfs/

mkdir -p /opt/ssfs/jndi

cp /home/admin/apps/oms-runtime/jndi/.bindings /opt/ssfs/jndi/

cd /opt/ssfs/runtime/bin

./buildear.sh -Dappserver=websphere -Dwarfiles=smcfs,sbc,sma -Dearfile=smcfs.ear -Ddevmode=true -Dnowebservice=true -Dnodocear=true create-ear

cd /opt/ibm

sudo wget -O wlp.zip https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/24.0.0.11/wlp-webProfile8-24.0.0.11.zip

sudo unzip wlp.zip

sudo rm wlp.zip

sudo chown admin:admin -R wlp

export JAVA_HOME=/opt/ssfs/runtime/jdk/

export PATH=$JAVA_HOME/bin:$PATH

java -version

cd wlp/bin

./server create omsserver

./installUtility install servlet-3.1

cp /opt/ssfs/runtime/external_deployments/smcfs.ear /opt/ibm/wlp/usr/servers/omsserver/dropins

cp ${PRESENT_WORK_DIR}/opt/ibm/wlp/usr/servers/omsserver/jvm.options /opt/ibm/wlp/usr/servers/omsserver/jvm.options

cp ${PRESENT_WORK_DIR}/opt/ibm/wlp/usr/servers/omsserver/server.xml /opt/ibm/wlp/usr/servers/omsserver/server.xml
