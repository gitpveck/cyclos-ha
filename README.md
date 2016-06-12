# cyclos-ha

Environment setup 

Create kubernetes cluster

# Set up 2 nodes test cluster :

Create 2 Fedora 23 /4G RAM/ 2 virt cpus nodes. The cpu and memory specs are based on some reasonable performance. Of course you lower specs can be used.
Scripts are included in the contrib directory to create these on a KVM based environment 

# Run ansible play

Clone kubernetes contrib repository 

git clone https://github.com/gitpveck/contrib.git

python-netaddr is required to be installed before starting the ansible play. (ansible uses python2 so make sure the python2 version is installed)

root access is required on the target hosts

cd ansible

Create inventory file. 

Add the hosts for installation.

Update group_vars/all.yml and uncomment ansible_user=root if you plan to run this as root on the target hosts

run ./setup.sh


# Create HA Stolon postgresql cluster in kubernetes
Clone the following repos

git clone https://github.com/gitpveck/stolon.git


# Create cyclos pod in kubernetes
