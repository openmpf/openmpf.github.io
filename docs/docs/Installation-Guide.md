> **NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007).
Copyright 2018 The MITRE Corporation. All Rights Reserved.

> **WARNING:** As of Release 3.0.0, this guide is no longer supported. It is left here for historical reasons and will be removed in a future release.  It was last tested with Release 2.1.0. We now support creating Docker images and deploying those containers. Please refer to the openmpf-docker [README](https://github.com/openmpf/openmpf-docker/blob/master/README.md).

# Minimum Resource Requirements

## Hardware
OpenMPF performs best when processing is distributed across a cluster of computers; a minimum of one dedicated server is required that provides the following:

  - 4 Central Processing Units (CPUs)
  - 4GB Random Access Memory (RAM), *although in any operational use case environment at least 16GB of RAM is recommended*
  - 40GB hard disk space, *with additional space to store media and processed objects*

In a cluster configuration, participating servers are referred to as *nodes*, with one controlling node designated as the *master* node and the others designated as *child* nodes.  In this case, a shared file system accessible to all participating nodes is also required.

The *master* contains the Workflow manager, ActiveMQ, MySQL, an instance of the OpenMPF process manager, named the *Node Manager*. A *child* contains only a node manager and processing components/algorithms.

Below is an example layout of an OpenMPF cluster consisting of 3 nodes:

![System Layout](img/system_layout.png "System Layout")

## Operating System and Software
OpenMPF runs on the CentOS 7 operating system, with Linux firewall (iptables) disabled and Linux SELINUX in permissive state (disabled is the preferred state to limit logging activity).

> **IMPORTANT:** Make sure that the machine on which OpenMPF will be deployed is running the same version of CentOS 7 as the machine which generated the OpenMPF deployment package; otherwise you may encounter library dependency issues. For more information about the CentOS 7 version, refer to the [CentOS setup section](Build-Environment-Setup-Guide/index.html#set-up-the-minimal-centos-7-vm) of the Build Guide.

A browser is required in order to utilize the OpenMPF Web User Interface (UI). The officially supported browsers are FireFox and Chrome. Although other browsers might work, they have not been thoroughly tested and might not display or function properly.

## OpenMPF Pre-Installation
> **IMPORTANT:** Please verify that all steps in the Pre-installation Checklist are completed **prior** to cluster configuration.

## Pre-Installation Checklist

1. OpenMPF must be installed on CentOS 7.

2. DNS or host entries for the master node and child nodes must be present on all hosts in the OpenMPF cluster.

3. If this is a multi-node setup, create a shared storage space that all of the hosts in the OpenMPF cluster can access. Once the "mpf" user is created, you will need to mount this space on all of the hosts.

4. NTP should be set up on each of the hosts in the OpenMPF cluster so that their times are synchronized; otherwise, the log viewer may behave incorrectly when it updates in real time.

5. If using HTTPS, a valid keystore must exist on the master node. Self signed certificates can be used but are not recommended for use in production environment. For instructions for created a self-signed certificate and keystore, see [Creating a Keystore](#creating-a-keystore).

## OpenMPF Installation

> **NOTE:** You only need to complete the following steps on the OpenMPF master node:

**1. Install and Configure OpenMPF Management Software **

Copy the OpenMPF release package .tar.gz, (e.g. openmpf-open-source-0.9.0+master.tar.gz) to the OpenMPF master node.

From the OpenMPF master node, unpack the OpenMPF package.

```
tar zxvf <latest .tar.gz>
cd mpf-release
sudo sh install-mpf.sh
```

** 2. Configure the OpenMPF Cluster **

> **NOTE:** A master node will __**not**__ run any services unless it is also designated and configured as a child. Think of a child as a worker in the OpenMPF cluster. Thus, in a single server environment it is mandatory to designate the host as both a master and child in order to do any meaningful processing (e.g. detection). By default, the master only runs the workflow manager web app, AMQ, Redis and MySQL.

When prompted for username and password, use the same username and password you used to log in to the master node.

When prompted for hostnames, only put in the hostnames (e.g., node-1), DO NOT put in the fully qualified domain name (e.g., node-1.example.org) or OpenMPF will behave in strange ways.

```
sudo sh /opt/mpf/manage/configure-cluster.sh
```

** 3. Ensure the Shared Storage Space Exists**

By default, OpenMPF uses the /opt/mpf/share directory to share data between nodes. If that directory doesn't exist, then create it now:

If this is a single-node setup, then run:

```
mkdir /opt/mpf/share
```

If this is a multi-node setup, then shared storage must be mounted to /opt/mpf/share on all the hosts in the OpenMPF cluster. OpenMPF relies on the use of shared storage to transmit media between nodes. The "mpf" user (id=376) must be able to read/write from/to the shared storage. If the "mpf" user did not previously exist on the hosts, it was created in the previous step.


** 4. Push OpenMPF Configuration to OpenMPF Nodes**

Early in the script you will be prompted for the OpenMPF password. Use "mpf".


```
# As the "mpf" user (you may need to log out and log back in):
. /opt/mpf/manage/push-configuration.sh
```

** 5. Complete Node Configuration **

OpenMPF is now running (no reboot required).

To complete node configuration:

  1. From the master node, browse to: http://localhost:8080/workflow-manager
  2. Login as the administrator (username: "admin" / password: "mpfadm")
  3. Go to the Nodes page and add detection services as desired

## Updating Site Configuration

You can add or remove nodes and change other configuration options once OpenMPF has already been installed.

```
# As the "mpf" user:
mpf stop
sudo sh /opt/mpf/manage/configure-cluster.sh
/opt/mpf/manage/push-configuration.sh
```

## Creating a Keystore

> **IMPORTANT:** Using a self-signed certificate is not recommended for a production environment.

These instructions will create a keystore with a self-signed certificate at /home/mpf/.keystore.

1. Open a new terminal window.
2. `sudo systemctl stop tomcat7`
3. `cd /home/mpf`
4. `keytool -genkey -alias tomcat -keyalg RSA`
5. At the prompt, enter a keystore password of: `mpf123`
6. Re-enter the keystore password of: `mpf123`
7. At the `What is your first and last name?` prompt, press the Enter key for a blank value.
8. At the `What is the name of your organizational unit?` , press the Enter key for a blank value.
9. At the `What is the name of your organization?` prompt, press the Enter key for a blank value.
10. At the `What is the name of your City or Locality?` prompt, press the Enter key for a blank value.
11. At the `What is the name of your State or Province?` prompt, press the Enter key for a blank value.
12. At the `What is the two-letter country code for this unit?` prompt, press the Enter key for a blank value.
13. At the `Is CN=Unknown, OU=Unknown, O=Unknown, L=Unknown, ST=Unknown, C=Unknown correct?` prompt, press the Enter key to accept the values.
14. At the `Enter key password for <tomcat>` prompt, press the Enter key for a blank value.
15. Verify the file `/home/mpf/.keystore` was created at the current time.
