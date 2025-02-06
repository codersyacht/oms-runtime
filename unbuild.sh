#!/bin/bash

docker stop omsruntime

docker rm omsruntime

docker rmi cp.icr.io/cp/ibm-oms-enterprise/om-base:10.0.2409.1-amd64

sudo rm -rf /home/admin/apps/ssfs

sudo rm -rf /home/admin/apps/wlp

sudo rm -rf /home/admin/apps/java_home.txt
