#!/bin/bash
#
# The location of the images used in this script are derived from the following URL : https://raymii.org/s/articles/virt-install_introduction_and_copy_paste_distro_install_commands.html#CentOS_6
#

CNTS6='http://mirror.i3d.net/pub/centos/6/os/x86_64/'
CNTS7='http://mirror.i3d.net/pub/centos/7/os/x86_64/'
FED23='http://mirror.i3d.net//pub/fedora/linux/releases/23/Server/x86_64/os/'

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
    read -p "Enter which OS to install: 1) Centos6 2) Centos7 3) Fedora23" a
    case $a in
      '1')
        echo " Starting Centos6 installation..."
        virt-install -r 1024 -n ${NAME} --disk ${DISK},bus=virtio,cache=none,io=native -w network=default \
        --location ${CNTS6} --nographics --extra-args "console=ttyS0,115200 serial"
      ;;
   
      '2')
        echo " Starting Centos7 installation..."
        virt-install -r 1024 -n ${NAME} --disk ${DISK},bus=virtio,cache=none,io=native -w network=default \
        --location ${CNTS7} --nographics --extra-args "console=ttyS0,115200 serial"
      ;;
      
      '3')
        echo " Starting Centos7 installation..."
        virt-install -r 1024 -n ${NAME} --disk ${DISK},bus=virtio,cache=none,io=native -w network=default \
        --location ${FED23} --nographics --extra-args "console=ttyS0,115200 serial"
      ;;
     
      *)
      echo "please enter 1,2 or 3"
    esac
  else
    echo "${DISK} not found ! Can not create ${NAME}"
fi
