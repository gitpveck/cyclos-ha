#!/bin/bash

if [ $# != 2 ]
  then
    echo "Usage: $0 name virtualdiskpath"
    echo "For example: $0 VM1 /kvm_data/kub_fedora/fed23_kub01_dsk01.img"
    exit 1
fi

NAME=$1
DISK=$2

if [ -f ${DISK} ]
  then
    virt-install -r 1024 -n ${NAME} --disk ${DISK},bus=virtio,cache=none,io=native -w network=default \
    --location 'http://mirror.i3d.net//pub/fedora/linux/releases/23/Server/x86_64/os/' --nographics \
    --extra-args "console=ttyS0,115200 serial"

  else
    echo "${DISK} not found ! Can not create ${NAME}"
fi
