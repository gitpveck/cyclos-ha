# Cyclos in kubernetes

Create a [kubernetes cluster](http://kubernetes.io/docs/user-guide/) and deploy a cyclos application stack with a stolon postgresql setup.
[stolon](https://github.com/gitpveck/stolon/tree/master/examples/kubernetes) can provide a high available postgreSQL cluster inside kubernetes.
We are using a fork of stolon to meet the postgresql needs for the cyclos application.

## Set up 2 nodes 

Create 2 Fedora 23 /4G RAM/ 2 virt cpus nodes. The cpu and memory specs are based on some reasonable performance. Of course lower resource specs can be used.
Scripts are included in the contrib directory to create these on a KVM based environment. 

## Install kubernetes

### The installation is done using ansible. A great configuration and installation automation tool.

Ansible is available in most GNU/Linux flavours as a standard package and can be installed using the applicable package manager (Debian / apt  Redhat/ yum or dnf archlinux/ pacman etc..)

Note that the python-netaddr package is a dependency needed for the installation but is not always installed by default. Install when not present.

Before the ansible playbooks can be executed complete the following steps first.

The instructions here assume the hostnames kubernetes in going to be installed on are : 

* fed23-kub01
* fed23-kub02


### configure keybased root access on the target hosts

```
ssh-copy-id root@fed23-kub01
```

```
ssh-copy-id root@fed23-kub02
```

### Update config files

change to the ansible subdirectory

Add or update the inventory file with the target hosts. If you use our example hostnames nothing needs to be changed.

Make sure ansible_user=root in group_vars/all.yml is uncommented

```
run ./setup.sh
```

Check kubernetes cluster by running 

```
kubectl get no
```

on the master node (fed23-kub01)

The nodes should show "ready" state

## Create HA Stolon postgresql cluster in kubernetes

continue on the 'master' node. In our example this is fed23-kub01

login as root and change to the cyclos-pod directory

Configure the etcd node to be used by the stolon cluster in all stolon yaml files by substituting the ST${COMPONENT}_STORE_ENDPOINTS environment variables.
In this example we use the kubernetes master node fed23-kub01 which runs etcd for the kubernetes cluster.

### Create the stolon cluster

This is a snippet from the [stolon kubernetes](https://github.com/gitpveck/stolon/tree/master/examples/kubernetes) documentation

#### Create the sentinel(s) 

```
kubectl create -f stolon-sentinel.yaml
```
This will create a replication controller with one pod executing the stolon sentinel. You can also increase the number of replicas for stolon sentinels in the rc definition or do it later.


#### Create the keeper's password secret

This creates a password secret that can be used by the keeper to set up the initial database user. This example uses the value 'password1' but you will want to replace the value with a Base64-encoded password of your choice.

```
kubectl create -f secret.yaml
```

#### Create the first stolon keeper

Note: In this example the stolon keeper is a replication controller that, for every pod replica, uses a volume for stolon and postgreSQL data of emptyDir type. So it'll go away when the related pod is destroyed. This is just for easy testing. In production you should use a persistent volume. Actually (kubernetes 1.0), for working with persistent volumes you should define a different replication controller with replicas=1 for every keeper instance.

```
kubectl create -f stolon-keeper.yaml
```

This will create a replication controller that will create one pod executing the stolon keeper. The first keeper will initialize an empty postgreSQL instance and the sentinel will elect it as the master.

Once the leader sentinel has elected the first master and created the initial cluster view you can add additional stolon keepers. Will do this later.


#### Create the proxies

```
kubectl create -f stolon-proxy.yaml
```

Also the proxies can be created from the start with multiple replicas.

### Create the proxy service

The proxy service is used as an entry point with a fixed ip and dns name for accessing the proxies.

```
kubectl create -f stolon-proxy-service.yaml
```

Now scale the keeper

```
kubectl scale --replicas=2 rc stolon-keeper-rc
```

This creates a slave running..

### Create cyclos database in the stolon cluster

This part is not automated yet but should be in the future.

First run a postgresql pod. This in order to connect to the stolon proxy service via that pod.
This is for creating the cyclos and extensions. 

```
kubectl run postgres-inst --image=postgres
```
We are now going to create the cyclos database and extensions using this pod.

Get the pod name :

```
kubectl get pod postgres-inst
```

Something like 'postgres-inst-3467469619-9c7zi' should show as the name of the pod.

Create the database

```
kubectl exec postgres-inst-3467469619-9c7zi -i --tty -- psql --host stolon-proxy-service postgres --port 5432 -U stolon -W -c "CREATE DATABASE cyclos"
```




