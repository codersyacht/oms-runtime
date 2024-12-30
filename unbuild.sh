#!/bin/bash

docker stop omsruntime

docker rm omsruntime

docker rmi cp.icr.io/cp/ibm-oms-enterprise/om-base:10.0.2409.1-amd64

sudo rm -rf /opt/ssfs

sudo rm -rf /opt/ibm/wlp

sudo rm -rf /opt/java_home.txt
