#!/bin/bash
if [ -z "$1" ]
  then
    echo "No VM name passed"
    echo "Usage: backup_vm.sh VM_NAME"
    exit 1
fi

VM=$1

virsh dominfo $VM 2>&1 > /dev/null
status=$?

if  [ $status -ne 0 ]
  then
  echo "Wrong VM name!"
  exit 1
fi

DIR=/var/lib/libvirt/backups/$VM-`date  +%d-%m-%Y_%H-%M`
mkdir -pv $DIR
cd $DIR
virsh suspend $VM
virsh dumpxml $VM > $VM.xml
lzop /var/lib/libvirt/images/$VM.qcow2 -o $DIR/$VM.qcow2.lzop
virsh resume $VM
exit 0

