> **NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2020 The MITRE Corporation. All Rights Reserved.

# Docker

OpenMPF is installed using the Docker container platform. Please read the [disclaimer](#disclaimer) below.
 
To use prebuilt Docker images, refer to the "Quick Start" section of the documentation for the OpenMPF Workflow Manager image on [DockerHub](https://hub.docker.com/r/openmpf/openmpf_workflow_manager).
 
For more information, including how to setup Docker, and build and deploy OpenMPF Docker images, refer to the openmpf-docker [README](https://github.com/openmpf/openmpf-docker/blob/master/README.md#getting-started).

Additionally, if you would like to install OpenMPF across multiple physical or virtual machines, then refer to the openmpf-docker [Swarm Deployment Guide](https://github.com/openmpf/openmpf-docker/blob/master/SWARM.md#do-i-need-swarm-deployment). 

# Disclaimer

The Open Media Processing Framework (OpenMPF) software is provided as raw source code. This is to avoid any potential licensing issues that may arise from distributing a pre-compiled executable that is linked to dependencies that are licensed under a copyleft license or have patent restrictions. Generally, it is acceptable to build and execute software with these dependencies for non-commercial in-house use.

By distributing the OpenMPF software as raw source code the development team is able to keep most of the software clean from copyleft and patent issues so that it can be published under a more open Apache license and freely distributed to interested parties.

> **IMPORTANT:** It is the responsibility of the end users who build the OpenMPF software to abide by all of the non-commercial and re-distribution restrictions imposed by the dependencies that the OpenMPF software uses. Building OpenMPF and linking in these dependencies at build time or run time may result in creating a derivative work under the terms of the GNU General Public License. Refer to [Acknowledgements](Acknowledgements/index.html) for more information about these dependencies.

In general, it is only acceptable to use and distribute the executable form of the OpenMPF, which includes generated Docker images, "in house", which is loosely defined as internally with an organization. The OpenMPF should only be distributed to third parties in raw source code form and those parties will be responsible for creating their own executables and Docker images.
