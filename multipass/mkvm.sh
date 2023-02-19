#!/bin/bash

VM_NAME=$1
multipass launch -n $VM_NAME --cloud-init ./cloud-config.yaml
ssh ubuntu@$VM_NAME.local
