**NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, and is subject to the
Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2021 The MITRE Corporation. All Rights Reserved.

<div style="background-color:orange"><p style="color:white; padding:5px"><b>WARNING:</b> This guide is for non-Docker deployments only, such as for local development environments. In a Docker deployment components are run as Docker-managed containers.</p></div>

# JGroups Communication

OpenMPF uses the [JGroups](http://www.jgroups.org) toolkit for passing messages between node-manager processes. One process runs on each OpenMPF Node Manager Docker container, and one master node-manager runs as part of the Workflow Manager web application on the Workflow Manager Docker container. Each of these containers is effectively a "node" in the OpenMPF cluster.

There are two primary aspects of JGroups that an OpenMPF administrator needs to be concerned with:

1. OpenMPF uses the JGroups FILE_PING protocol for peer discovery. Each node uses files stored in `$MPF_HOME/share/nodes/MPF_Channel`. A node will write a file to that directory when the node-manager starts up, and read files in that directory to determine what other nodes are in the OpenMPF cluster.

2. Each OpenMPF node uses network port 7800 for JGroups TCP communication. Please ensure that this port is open in the network firewall on each OpenMPF node, or the firewall is disabled.

If for some reason port 7800 is reserved by another process, JGroups will try the next available port, starting at 7801, then 7802, and so on. Note that within an OpenMPF [development environment](Development-Environment-Guide/index.html) the Workflow Manager web application and node-manager process will run on the same machine, resulting in the use of port 7800 and 7801.

When a node first starts up it will be in its own JGroups cluster. Within a minute it will be merged into the cluster with the other OpenMPF nodes. At that time it will be recognized by the Workflow Manager and become available for running services and processing jobs.
