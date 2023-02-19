#!/bin/bash

VM_NAME=$1
multipass delete -p $VM_NAME
ssh-keygen -R $VM_NAME.local
