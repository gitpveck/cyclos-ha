#!/bin/bash
# Simple sequence of lxc commands to setup a bunch of LXC containers running centos6
# You need to create seperate files named after and;containing the hostname for each container in the directory this script is executed from.
# Create a default container wuth sshd running and your ssh pubkey copied to the root account. This container is used on the DEF variable (lxc launch images:centos/6/amd64 c6-def)
# you also need the LXD dnsmasq service avialable for resolving the container hostnames which is typically the ip adddress the LXD bridge listens on.  ( see with ip addr)
DEF=c6-def

rm  ~/.ssh/known_hosts

for cont in c6-lxc0{1,2,3,4,5} ; do
echo $cont > $cont
lxc delete $cont --force
lxc copy  $DEF $cont
lxc start  $cont
lxc file push $cont $cont/etc/hostname
lxc restart $cont --force
sleep 7
ssh-keyscan -H $cont >> ~/.ssh/known_hosts
rm $cont
done
