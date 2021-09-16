#!/bin/bash

RCTL_FILE="rctl-linux-amd64.tar.bz2"

wget $RCTL_URL
if [ $? -eq 0 ];
then
    echo "[+] Successfully Downloaded RCTL binary"
fi
tar -xvf $RCTL_FILE

#Check rctl version
./rctl version

CLUSTER_STATUS_ITERATIONS=1
CLUSTER_HEALTH_ITERATIONS=1
PROVISION_STATUS_ITERATIONS=1
sleep 60
CLUSTER_STATUS=`./rctl get cluster -p madhuair ${CLUSTER_NAME} -o json |jq '.status'|cut -d'"' -f2`
PROVISION_STATUS=`./rctl get cluster -p madhuair ${CLUSTER_NAME} -o json |jq '.provision.status' |cut -d'"' -f2`
while [ "$CLUSTER_STATUS" != "READY" ]  &&  [ "$PROVISION_STATUS" != "CLUSTER_PROVISION_COMPLETE" ]
do
  sleep 60
  if [[ $CLUSTER_STATUS_ITERATIONS -ge 50 ]];
  then
    break
  fi
  CLUSTER_STATUS_ITERATIONS=$((CLUSTER_STATUS_ITERATIONS+1))
  CLUSTER_STATUS=`./rctl get cluster -p madhuair ${CLUSTER_NAME} -o json |jq '.status'|cut -d'"' -f2`
  if [[ $CLUSTER_STATUS == "PROVISION_FAILED" ]];
  then
    echo -e " !! Cluster provision failed !!  "
    echo -e " !! Exiting !!  " && exit -1
  fi

  PROVISION_STATUS=`./rctl get cluster -p madhuair ${CLUSTER_NAME} -o json |jq '.provision.status' |cut -d'"' -f2`

  if [[ $PROVISION_STATUS == "INFRA_CREATION_FAILED" ]];
  then
    echo -e " !! Cluster provision failed !!  "
    echo -e " !! Exiting !!  " && exit -1
  fi

  if [[ $PROVISION_STATUS == "BOOTSTRAP_CREATION_FAILED" ]];
  then
    echo -e " !! Cluster provision failed !!  "
    echo -e " !! Exiting !!  " && exit -1
  fi

  PROVISION_STATE=`./rctl get cluster -p madhuair ${CLUSTER_NAME} -o json | jq '.provision.running_state' |cut -d'"' -f2`

  echo "$PROVISION_STATE in progress"
done
if [[ $CLUSTER_STATUS != "READY" ]];
then
    echo -e " !! Cluster provision failed !!  "
    echo -e " !! Exiting !!  " && exit -1
fi
if [[ $CLUSTER_STATUS == "READY" ]];
then
    echo "[+] Cluster Provisioned Successfully waiting for it to be healthy"
    CLUSTER_HEALTH=`./rctl get cluster -p madhuair ${CLUSTER_NAME} -o json | jq '.health' |cut -d'"' -f2`
    while [ "$CLUSTER_HEALTH" != 1 ]
    do
      echo "Iteration-${CLUSTER_HEALTH_ITERATIONS} : Waiting 60 seconds for cluster to be healthy..."
      sleep 60
      if [[ $CLUSTER_HEALTH_ITERATIONS -ge 15 ]];
      then
        break
      fi
      CLUSTER_HEALTH_ITERATIONS=$((CLUSTER_HEALTH_ITERATIONS+1))
      CLUSTER_HEALTH=`./rctl get cluster -p madhuair ${CLUSTER_NAME} -o json | jq '.health' |cut -d'"' -f2`
    done
fi

if [[ $CLUSTER_HEALTH == 0 ]];
then
    echo -e " !! Cluster is not healthy !!  "
    echo -e " !! Exiting !!  " && exit -1
fi
if [[ $CLUSTER_HEALTH == 1 ]];
then
    echo "[+] Cluster Provisioned Successfully and is Healthy"
fi
#Adding Sleep and re Verifying Provision Status as Cluster goes for Update after some time
sleep 200
PROVISION_STATUS=`./rctl get cluster -p madhuair ${CLUSTER_NAME} -o json |jq '.provision.status' |cut -d'"' -f2`
while [ "$PROVISION_STATUS" != "CLUSTER_PROVISION_COMPLETE" ]
do
  sleep 60
  if [[ $PROVISION_STATUS_ITERATIONS -ge 15 ]];
  then
    break
  fi
  PROVISION_STATUS_ITERATIONS=$((PROVISION_STATUS_ITERATIONS+1))

  PROVISION_STATUS=`./rctl get cluster -p madhuair ${CLUSTER_NAME} -o json |jq '.provision.status' |cut -d'"' -f2`

  if [[ $PROVISION_STATUS == "INFRA_CREATION_FAILED" ]];
  then
    echo -e " !! Cluster provision failed !!  "
    echo -e " !! Exiting !!  " && exit -1
  fi

  if [[ $PROVISION_STATUS == "UPDATE_FAILED" ]];
  then
    echo -e " !! Cluster Update failed !!  "
    echo -e " !! Exiting !!  " && exit -1
  fi

  PROVISION_STATE=`./rctl get cluster -p madhuair ${CLUSTER_NAME} -o json | jq '.provision.running_state' |cut -d'"' -f2`

  echo "$PROVISION_STATE in progress"
done
