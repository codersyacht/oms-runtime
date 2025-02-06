export PRESENT_WORK_DIR=`pwd`

export INSTALL_VERSION=10.0.2409.1-amd64

export DB_NAME=pg

export TAG_VERSION=v2

echo "Present Working Directory " ${PRESENT_WORK_DIR}

export ENTITLED_REGISTRY=cp.icr.io

export ENTITLED_REGISTRY_USER=cp

export ENTITLED_REGISTRY_KEY="$(<ibm-entitlement-key)"

docker login -u $ENTITLED_REGISTRY_USER -p $ENTITLED_REGISTRY_KEY $ENTITLED_REGISTRY

docker pull cp.icr.io/cp/ibm-oms-enterprise/om-base:${INSTALL_VERSION}

docker images

docker volume create omsruntime

docker run -e LICENSE=accept -e LANG -e INSTALL_VERSION=${INSTALL_VERSION} -e DB_NAME=${DB_NAME} -e TAG_VERSION=${TAG_VERSION} --privileged -v omsruntime:/images  -idt --name omsruntime cp.icr.io/cp/ibm-oms-enterprise/om-base:${INSTALL_VERSION}

docker ps

mkdir -p ${PRESENT_WORK_DIR}/opt/ssfs/runtime/dbjar/jdbc/postgresql

wget -O ${PRESENT_WORK_DIR}/ssfs/runtime/dbjar/jdbc/postgresql/postgresql.jar https://repo1.maven.org/maven2/org/postgresql/postgresql/42.2.24/postgresql-42.2.24.jar

cp ${PRESENT_WORK_DIR}/ssfs/runtime/dbjar/jdbc/postgresql/postgresql.jar ${PRESENT_WORK_DIR}/ThirdPartyJars/

echo "Copying runtime overrides"
docker cp ${PRESENT_WORK_DIR}/ssfs/runtime/. omsruntime:/opt/ssfs/runtime/

echo "Copying third party jars"
docker exec -it omsruntime mkdir -p /opt/ssfs/runtime/ThirdPartyJars

docker cp ${PRESENT_WORK_DIR}/ThirdPartyJars/. omsruntime:/opt/ssfs/runtime/ThirdPartyJars/

echo "Copying image build script"
docker cp ${PRESENT_WORK_DIR}/build-images.sh omsruntime:/opt/ssfs/

echo "Copying docker key"
docker cp ${PRESENT_WORK_DIR}/docker-key omsruntime:/opt/ssfs/runtime/container-scripts/imagebuild/
