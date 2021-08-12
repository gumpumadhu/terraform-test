#!/bin/bash

CLUSTER_STATUS=``
# shellcheck disable=SC1073
CMD=`sudo su`
echo $CMD
while True
do
  sleep 60
  if [[ $CLUSTER_STATUS_ITERATIONS -ge 30 ]];
  then
    break
  fi
  CLUSTER_STATUS_ITERATIONS=$((CLUSTER_STATUS_ITERATIONS+1))
  CLUSTER_STATUS=`sudo kubectl get pods -A`
  echo $CLUSTER_STATUS
  if [[ $CLUSTER_STATUS != *"rafay-system   controller-manager"* ]];
  then
    echo -e " !! Cluster not up !!  "
    echo -e " Rechecking after 60 sec  "
  else
    echo -e " !! Cluster is up !!  "
    sleep 120
    exit 1
  fi
done
echo -e " !! Cluster not up after 30 min!!  "
