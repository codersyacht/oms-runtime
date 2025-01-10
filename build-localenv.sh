#!/bin/bash


touch /home/admin/apps/java_home.txt

echo "export JAVA_HOME=/home/admin/apps/ssfs/runtime/jdk" >> /home/admin/apps/java_home.txt

echo "export PATH=/home/admin/apps/ssfs/runtime/jdk/bin:$PATH" >> /home/admin/apps/java_home.txt

echo "content of /home/admin/apps/java_home.txt"

cat /home/admin/apps/java_home.txt

mkdir -p /home/admin/apps/ssfs

export PRESENT_WORK_DIR=`pwd`

echo "Present Working Directory " ${PRESENT_WORK_DIR}

sudo mkdir -p /opt/ssfs

sudo chown admin:admin -R /opt/ssfs

docker cp omsruntime:/opt/ssfs/runtime /opt/ssfs/

sed -i "s|/opt|/home/admin/apps|g" /opt/ssfs/runtime/properties/sandbox.cfg

cd /opt/ssfs/runtime/bin

echo "*****************Executing setupfiles*****************"

./setupfiles.sh

echo "*****************Completed setupfiles*****************"

sudo mv /opt/ssfs /home/admin/apps/

mkdir -p /home/admin/apps/ssfs/jndi

cp /home/admin/apps/oms-runtime/jndi/.bindings /home/admin/apps/ssfs/jndi/

cd /home/admin/apps/ssfs/runtime/bin

echo "*****************Executing setupfiles*****************"

./setupfiles.sh

echo "*****************Completed setupfiles*****************"

./buildear.sh -Dappserver=websphere -Dwarfiles=smcfs,sbc,sma -Dearfile=smcfs.ear -Ddevmode=true -Dnowebservice=true -Dnodocear=true create-ear

cd /home/admin/apps/

wget -O wlp.zip https://public.dhe.ibm.com/ibmdl/export/pub/software/websphere/wasdev/downloads/wlp/24.0.0.11/wlp-webProfile8-24.0.0.11.zip

unzip wlp.zip

rm wlp.zip

export JAVA_HOME=/home/admin/apps/ssfs/runtime/jdk/

export PATH=$JAVA_HOME/bin:$PATH

java -version

cd wlp/bin

./server create omsserver

./installUtility install servlet-3.1

cp /home/admin/apps/ssfs/runtime/external_deployments/smcfs.ear /home/admin/apps/wlp/usr/servers/omsserver/dropins

cp ${PRESENT_WORK_DIR}/wlp/usr/servers/omsserver/jvm.options //home/admin/apps/wlp/usr/servers/omsserver/jvm.options

cp ${PRESENT_WORK_DIR}/wlp/usr/servers/omsserver/server.xml /home/admin/apps/wlp/usr/servers/omsserver/server.xml

