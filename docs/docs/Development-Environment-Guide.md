> **NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2019 The MITRE Corporation. All Rights Reserved.

> **WARNING:** This guide is a work in progress and may not be completely accurate or comprehensive. Since transitioning to Docker deployment, this guide has not been fully tested.

# Overview

The following instructions are for setting up an environment for building OpenMPF outside of Docker.

If your environment is behind a proxy server, please refer to the [Proxy Configuration](#proxy-configuration) and [SSL Inspection](#ssl-inspection) appendix sections before continuing. Keep them in mind throughout this guide and perform the configuration steps as necessary.


# Install CentOS 7

The recommended minimum system specifications are:

- **Memory**: 8192MB
- **CPU**: 4
- **Disk**: 40GB on a SSD

Install [CentOS 7](https://www.centos.org/download/). Most developers use a virtual machine for development.


# Install System Dependencies Using Package Managers

## Configure Additional Repositories

1. Install the Remi Repo for Redis:
    1. `wget -P /home/mpf/Downloads "http://rpms.remirepo.net/RPM-GPG-KEY-remi"`
    2. `wget -P /home/mpf/Downloads "http://rpms.famillecollet.com/enterprise/remi-release-7.rpm"`
    3. `sudo rpm --import /home/mpf/Downloads/RPM-GPG-KEY-remi`
    4. `sudo rpm -Uvh /home/mpf/Downloads/remi-release-7.rpm`
    5. `sudo yum-config-manager --enable remi`
2. Create an `/apps` directory and package subdirectories:
    1. `sudo mkdir -p /apps/install/lib`
    2. `sudo mkdir -p /apps/bin/apache`
    3. `sudo mkdir /apps/ansible`
    4. `sudo mkdir -p /apps/source/cmake_sources`
    5. `sudo mkdir /apps/source/apache_sources`
    6. `sudo mkdir /apps/source/google_sources`
    7. `sudo mkdir /apps/source/opencv_sources`
    8. `sudo mkdir /apps/source/ffmpeg_sources`
    9. `sudo mkdir /apps/source/dlib-sources`
    10. `sudo mkdir /apps/source/openalpr_sources`
    11. `sudo mkdir /apps/source/ansible_sources`
    12. `sudo chown -R mpf:mpf /apps`
    13. `sudo chmod -R 755 /apps`
3. Create the OpenMPF `ldconfig` file:
    <br>`sudo touch /etc/ld.so.conf.d/mpf-x86_64.conf`
4. Add `/apps/install/lib` to the OpenMPF `ldconfig` file:
    <br>`sudo sh -c 'echo "/apps/install/lib" >> /etc/ld.so.conf.d/mpf-x86_64.conf'`
5. Update the shared library cache:
    <br>`sudo ldconfig`

## Install System Dependencies via Yum

Use `yum` to install packages:

`sudo yum install -y asciidoc autoconf automake boost boost-devel cmake3 curl freetype-devel gcc-c++ git graphviz gstreamer-plugins-base-devel gtk2-devel gtkglext-devel gtkglext-libs jasper jasper-devel libavc1394-devel libcurl-devel libdc1394-devel libffi-devel libICE-devel libjpeg-turbo-devel libpng-devel libSM-devel libtiff-devel libtool libv4l-devel libXinerama-devel libXmu-devel libXt-devel log4cplus log4cplus-devel log4cxx log4cxx-devel make mercurial mesa-libGL-devel mesa-libGLU-devel nasm ncurses-devel numpy openssl-devel pangox-compat pangox-compat-devel perl-CPAN-Meta-YAML perl-DBI perl-Digest-MD5 perl-File-Find-Rule perl-File-Find-Rule-Perl perl-JSON perl-JSON-PP perl-List-Compare perl-Number-Compare perl-Params-Util perl-Parse-CPAN-Meta php pkgconfig qt qt-devel qt-x11 redis rpm-build sshpass tbb tbb-devel tree unzip uuid-devel wget yasm yum-utils zlib-devel`


# Get the OpenMPF Source Code

1. Clone the OpenMPF projects repository:
    1. `cd /home/mpf`
    2. `git clone https://github.com/openmpf/openmpf-projects.git --recursive`

2. Install the OpenMPF command line tools:
    <br> `sudo pip3 install /home/mpf/openmpf-projects/openmpf/trunk/bin/mpf-scripts`

3. Copy the mpf user profile script from the extracted source code:
    <br> `sudo cp /home/mpf/openmpf-projects/openmpf/trunk/mpf-install/src/main/scripts/mpf-profile.sh /etc/profile.d/mpf.sh`

4. Add `/apps/install/bin` to the system `PATH` variable:
    1. `sudo sh -c 'echo "PATH=\$PATH:/apps/install/bin" >> /etc/profile.d/mpf.sh'`
    2. `. /etc/profile.d/mpf.sh`

For more information on the command line tools, please refer to the [Command Line Tools](#command-line-tools) section below.

## Add Maven Dependencies

Some Maven dependencies needed for OpenMPF are not publicly available.

1. Download   [mpf-maven-deps.tar.gz](https://github.com/openmpf/openmpf-build-tools/blob/master/mpf-maven-deps.tar.gz) to `/home/mpf/openmpf-projects/openmpf-build-tools/mpf-maven-deps.tar.gz`.
2. Set up the local Maven repository:
    1. `cd /home/mpf`
    2. `mkdir -p .m2/repository`
3. Extract the archive to the local Maven repository:
<br>`tar xvzf /home/mpf/openmpf-projects/openmpf-build-tools/mpf-maven-deps.tar.gz -C /home/mpf/.m2/repository/`


# Build and Install System Dependencies in Dockerfiles

Refer to the `openmpf_build` [Dockerfile](https://github.com/openmpf/openmpf-docker/blob/develop/openmpf_build/Dockerfile), and execute the `RUN` steps to build/install the required dependencies in your local development environment. Use your best judgement. You will need to run some commands with `sudo` root privileges. Some of these may be redundant with the steps you've followed so far. Installation of the NVIDIA CUDA Toolkit is optional. Refer to the [NVIDIA CUDA Toolkit](#nvidia-cuda-toolkit) section below.

The `openmpf_build` Dockerfile may not include the dependencies you need to develop specific components. Refer to the Dockerfile for each of those components to determine which dependencies they require.

## NVIDIA CUDA Toolkit

Installation of the NVIDIA CUDA Toolkit is optional, and only necessary if you need to run a component on a GPU. Many components that support GPU processing also support execution on the CPU, and if this toolkit is not found in the build environment, the build system will automatically build those components for CPU processing only. For a discussion of NVIDIA GPU support in OpenMPF components, see the [GPU Support Guide](GPU-Support-Guide/index.html).

> **NOTE:** To run OpenMPF components that use the NVIDIA GPUs, you must ensure that the deployment machine has the same version of this Toolkit installed, including the NVIDIA GPU drivers. The instructions here are for a development environment only, and thus do not include steps to install the drivers. If you also need to set up the deployment machine, please see the full instructions at <https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html>.


# Build and Install Additional System Dependencies

## Apache ActiveMQ 5.13.0
For reference only: <http://activemq.apache.org>

1. `cd /apps/bin/apache`
2. `wget -O /apps/bin/apache/apache-activemq-5.13.0-bin.tar.gz "https://archive.apache.org/dist/activemq/5.13.0/apache-activemq-5.13.0-bin.tar.gz"`
3. `sudo tar xvzf apache-activemq-5.13.0-bin.tar.gz -C /opt/`
4. `sudo chown -R mpf:mpf /opt/apache-activemq-5.13.0`
5. `sudo chmod -R 755 /opt/apache-activemq-5.13.0`
6. `sudo ln -s /opt/apache-activemq-5.13.0 /opt/activemq`

## Apache Ant 1.9.6
For reference only: <http://ant.apache.org>

1. `cd /apps/bin/apache `
2. `wget -O /apps/bin/apache/apache-ant-1.9.6-bin.tar.gz "https://archive.apache.org/dist/ant/binaries/apache-ant-1.9.6-bin.tar.gz"`
3. `tar xzvf apache-ant-1.9.6-bin.tar.gz`
4. `sudo cp -R /apps/bin/apache/apache-ant-1.9.6 /apps/install/`
5. `sudo chown -R mpf:mpf /apps/install/apache-ant-1.9.6`
6. `sudo sed -i '/^PATH/s/$/:\/apps\/install\/apache-ant-1.9.6\/bin/' /etc/profile.d/mpf.sh`
7. `. /etc/profile.d/mpf.sh`

## PostgreSQL
1. Add PostgreSQL repository:
<br>`sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm`
2. Install postgres with yum:
<br>`sudo yum install -y postgresql12-server`
3. Initialize postgres:
<br>`sudo /usr/pgsql-12/bin/postgresql-12-setup initdb`
4. Modify the default authentication method for localhost.
    - Open `/var/lib/pgsql/12/data/pg_hba.conf` in a text editor.
    - Find the line containing:<br>
        ```
        host    all             all             127.0.0.1/32            ident
        ```
      <br>It should be line 82. Change "ident" to "md5".
    - Find the line containing:<br>
        ```
        host    all             all             ::1/128                 ident
        ```
      <br>It should be line 84. Change "ident" to "md5".
5. Start postgres:
<br>`sudo service postgresql-12 start`
6. Create the mpf user. When prompted for a password use "password":
<br>`sudo -i -u postgres createuser -P mpf`
7. Create the mpf database with the mpf user as the owner:
<br>`sudo -i -u postgres createdb -O mpf mpf`


## Python 3.8
1. Install build dependencies:
   <br> `sudo yum install -y yum-utils`
   <br>`sudo yum-builddep -y python3`

2. Download the source code: 
   <br>`curl https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tar.xz | tar --extract --xz`
   
3. Build Python:
   <br> `cd Python-3.8.2`
   <br> `./configure --enable-optimizations --with-lto --enable-shared`
   <br> `make -j8`
   <br> `sudo make install`
   <br> `sudo ln -s /usr/local/lib/libpython3.8.so.1.0 /usr/lib64/libpython3.8.so.1.0`
   <br> `sudo ln -sf /usr/local/bin/python3 /bin/python3`
   <br> `sudo ln -sf /usr/local/bin/python3.8 /bin/python3.8`
   <br> `sudo ln -sf /usr/local/bin/pip3 /bin/pip3`
   <br> `sudo ln -sf /usr/local/bin/pip3.8 /bin/pip3.8`
   
4. Make sure the output of running `python3 --version` is `Python 3.8.2`.

5. Make sure the output of running `sudo python3 --version` is `Python 3.8.2`.

6. Make sure the output of running `pip3 --version` ends with `(python 3.8)`.

7. Make sure the output of running `sudo pip3 --version` ends with `(python 3.8)`.

8. Upgrade pip:
   <br> `sudo pip3 install --upgrade pip`

9. Install wheel:
   <br> `sudo pip3 install wheel`


# Configure System Dependencies

# Configure ActiveMQ

Some additional manual configuration of ActiveMQ is required. For each step, open the specified file in a text editor, make the change, and save the file. If ActiveMQ is running, please stop it before making these changes.

**Use Additional Memory**

In `/opt/activemq/bin/env` (line 27), comment out the line:

```
ACTIVEMQ_OPTS_MEMORY="-Xms64M -Xmx1G"
```

so that it reads:

```
#ACTIVEMQ_OPTS_MEMORY="-Xms64M -Xmx1G"
```

**Disable Persistence**

In `/opt/activemq/conf/activemq.xml` (line 40), change the line:

```
<broker xmlns="http://activemq.apache.org/schema/core" brokerName="localhost" dataDirectory="${activemq.data}">
```

so that it reads:

```
<broker xmlns="http://activemq.apache.org/schema/core" brokerName="localhost" dataDirectory="${activemq.data}" persistent="false">
```

**Respect Priorities**

In `/opt/activemq/conf/activemq.xml` (line 44) under the line:

```
<policyEntries>
```

add the line:

```
<policyEntry queue=">" prioritizedMessages="true" useCache="false" expireMessagesPeriod="0" queuePrefetch="1" />
```

**Enable JMX**

In `/opt/activemq/conf/activemq.xml` (line 72, after making the above addition), change the line:

```
<managementContext createConnector="false"/>
```

so that it reads:

```
<managementContext createConnector="true"/>
```

**Change Log Conversion Pattern**

In `/opt/activemq/conf/log4j.properties` (line 52), change the line:

```
log4j.appender.logfile.layout.ConversionPattern=%d | %-5p | %m | %c | %t%n
```

so that it reads:

```
log4j.appender.logfile.layout.ConversionPattern=%d %p [%t] %c - %m%n
```

# Configure Redis

Redis should be set to run in the background (i.e. as a daemon process).

In `/etc/redis.conf` (line 136), change the line:

```
daemonize no
```

so that it reads:

```
daemonize yes
```

# Configure Users

To change the default user password settings, modify `/home/mpf/openmpf-projects/openmpf/trunk/workflow-manager/src/main/resources/properties/user.properties`. Note that the default settings are public knowledge, which could be a security risk.

Note that `mpf remove-user` and `mpf add-user` commands explained in the [Command Line Tools](#command-line-tools) section do not modify the `user.properties` file. If you remove a user using the `mpf remove-user` command, the changes will take effect at runtime, but an entry may still exist for that user in the `user.properties` file. If so, then the user account will be recreated the next time the Workflow Manager is restarted.

# Configure Tomcat with HTTP

When developing OpenMPF on a local machine, it is often most convenient to configure Tomcat to use HTTP instead of HTTPS.

1. Open the file `/opt/apache-tomcat/conf/server.xml` in a text editor.
2. Below the commented out section on lines 87 through 90, remove the following lines if they exist:
<pre><code>&#60;Connector SSLEnabled="true" acceptCount="100" clientAuth="false"
	disableUploadTimeout="true" enableLookups="false" maxThreads="25"
	port="8443" keystoreFile="/home/mpf/.keystore" keystorePass="mpf123"
	protocol="org.apache.coyote.http11.Http11NioProtocol" scheme="https"
	secure="true" sslProtocol="TLS" /&#62;</code></pre>
3. Save and close the file.
4. Create the file `/opt/apache-tomcat/bin/setenv.sh` and open it in a text editor.
5. Add the following line:
<pre><code>export CATALINA_OPTS="-server -Xms256m -XX:PermSize=512m -XX:MaxPermSize=512m -Djava.library.path=$MPF_HOME/lib -Dtransport.guarantee='NONE' -Dweb.rest.protocol='http'"</code></pre>
6. Save and close the file.

# (Optional) Configure Tomcat with HTTPS

Alternatively, OpenMPF can also be run using HTTPS instead of HTTP.

**Generate a self-signed certificate and keystore**

A valid keystore is required to run OpenMPF with HTTPS support. These instructions will generate a keystore that should be used for local builds only. When deploying OpenMPF, a keystore containing a valid certificate trust chain should be used.

1. Open a new terminal window.
2.  `sudo systemctl stop tomcat7`
3. `cd /home/mpf`
4. `$JAVA_HOME/bin/keytool -genkey -alias tomcat -keyalg RSA`
5. At the prompt, enter a keystore password of: `mpf123`
6. Re-enter the keystore password of: `mpf123`
7. At the `What is your first and last name?` prompt, press the Enter key for a blank value.
8. At the `What is the name of your organizational unit?` , press the Enter key for a blank value.
9. At the `What is the name of your organization?` prompt, press the Enter key for a blank value.
10. At the `What is the name of your City or Locality?` prompt, press the Enter key for a blank value.
11. At the `What is the name of your State or Province?` prompt, press the Enter key for a blank value.
12. At the `What is the two-letter country code for this unit?` prompt, press the Enter key for a blank value.
13. At the `Is CN=Unknown, OU=Unknown, O=Unknown, L=Unknown, ST=Unknown, C=Unknown correct?` prompt, type `yes` and press the Enter key to accept the values.
14. At the `Enter key password for <tomcat>` prompt, press the Enter key for a blank value.
15. Verify the file `/home/mpf/.keystore` was created at the current time.

**Tomcat Configuration**

1. Open the file `/opt/apache-tomcat/conf/server.xml` in a text editor.
2. Below the commented out section on lines 87 through 90, add the following lines:
<pre><code>&#60;Connector SSLEnabled="true" acceptCount="100" clientAuth="false"
	disableUploadTimeout="true" enableLookups="false" maxThreads="25"
	port="8443" keystoreFile="/home/mpf/.keystore" keystorePass="mpf123"
	protocol="org.apache.coyote.http11.Http11NioProtocol" scheme="https"
	secure="true" sslProtocol="TLS" /&#62;</code></pre>
3. Save and close the file.
4. Create the file `/opt/apache-tomcat/bin/setenv.sh` and open it in a text editor.
5. Add the following line:
<pre><code>export CATALINA_OPTS="-server -Xms256m -XX:PermSize=512m -XX:MaxPermSize=512m -Djava.library.path=$MPF_HOME/lib -Dtransport.guarantee='CONFIDENTIAL' -Dweb.rest.protocol='https'"</code></pre>
6. Save and close the file.

**Using an IDE**

If running Tomcat from an IDE, such as IntelliJ, then `-Dtransport.guarantee="CONFIDENTIAL" -Dweb.rest.protocol="https"` should be added at the end of the Tomcat VM arguments for your Tomcat run configuration. It is not necessary to add these arguments when running tomcat from the command line or a systemd command because of the configured `CATALINA_OPTS` variable.


# Build and Run the OpenMPF Workflow Manager Web Application

Run the following commands to build OpenMPF and launch the web application. Use this value for `<configFile>`:
<br>`/home/mpf/openmpf-projects/openmpf/trunk/jenkins/scripts/config_files/openmpf-open-source-package.json`

1. `cd /home/mpf/openmpf-projects/openmpf`
2. Copy the development properties file into place:

    ```
    cp trunk/workflow-manager/src/main/resources/properties/mpf-private-example.properties trunk/workflow-manager/src/main/resources/properties/mpf-private.properties
    ```

3. Open `/etc/ansible/hosts` in a text editor. `sudo` is required to edit this file.
4. If they do not already exist, add these two lines above `# Ex 1: Ungrouped hosts, specify before any group headers.` (line 11):

    ```
    [mpf-child]
    localhost.localdomain
    ```

5. Save and close the file.
6. `mvn clean install -DskipTests -Dmaven.test.skip=true -DskipITs -Dmaven.tomcat.skip=true  -Dcomponents.build.package.json=<configFile> -Dstartup.auto.registration.skip=false -Dcomponents.build.dir=/home/mpf/openmpf-projects/openmpf/mpf-component-build`
7. `cd /home/mpf/openmpf-projects/openmpf/trunk/workflow-manager`
8. `rm -rf /opt/apache-tomcat/webapps/workflow-manager*`
9. `cp target/workflow-manager.war /opt/apache-tomcat/webapps/workflow-manager.war`
10. `cd ../..`
11. `sudo cp trunk/install/libexec/node-manager /etc/init.d/`
12. `sudo systemctl daemon-reload`
13. `mpf start`

The web application should start running in the background as a daemon. Look for this log message in the Tomcat log (`/opt/apache-tomcat/logs/catalina.out`) with a time value indicating the Workflow Manager has finished starting:

```
INFO: Server startup in 39030 ms
```

After startup, the Workflow Manager will be available at <http://localhost:8080/workflow-manager> (or <https://localhost:8443/workflow-manager> if configured to use HTTPS instead of HTTP). Browse to this URL using FireFox or Chrome.

If you want to test regular user capabilities, log in as the "mpf" user with the "mpf123" password. Please see the [OpenMPF User Guide](User-Guide/index.html) for more information. Alternatively, if you want to test admin capabilities then log in as "admin" user with the "mpfadm" password. Please see the [OpenMPF Admin Guide](Admin-Guide/index.html) for more information. When finished using OpenMPF, run `mpf stop`.

The preferred method to start and stop services for OpenMPF is with the `mpf start` and `mpf stop` commands. For additional information on these commands, please see the [Command Line Tools](Admin-Guide/index.html#command-line-tools) section of the [OpenMPF Admin Guide](Admin-Guide/index.html). These will start and stop the ActiveMQ, PostgreSQL, Redis, Node Manager, and Tomcat system processes.

For debugging purposes, it may be helpful to manually start the Tomcat service in a separate terminal window to display the log output. To do that, use `mpf start --xtc` to start ActiveMQ, PostgreSQL, Redis, and the Node Manager without starting Tomcat. Then, in another terminal windows run:

```
/opt/apache-tomcat/bin/catalina.sh run
```

Press `ctrl-c` in the Tomcat window to stop Tomcat.


# (Optional) Test OpenMPF

Run the following commands to build OpenMPF and run the integration tests. Use this value for `<configFile>`:
<br>`/home/mpf/openmpf-projects/openmpf/trunk/jenkins/scripts/config_files/openmpf-open-source-package.json`

1. `cd /home/mpf/openmpf-projects/openmpf`
2. Copy the development properties file into place:

    ```
    cp trunk/workflow-manager/src/main/resources/properties/mpf-private-example.properties trunk/workflow-manager/src/main/resources/properties/mpf-private.properties
    ```

3. Open the file `/etc/ansible/hosts` in a text editor. `sudo` is required to edit this file.
4. If they do not already exist, add these two lines above `# Ex 1: Ungrouped hosts, specify before any group headers.` (line 11):

    ```
    [mpf-child]
    localhost.localdomain
    ```

5. Save and close the file.
6. `mvn clean install -DskipTests -Dmaven.test.skip=true -DskipITs -Dmaven.tomcat.skip=true -Dcomponents.build.package.json=<configFile> -Dcomponents.build.dir=/home/mpf/openmpf-projects/openmpf/mpf-component-build -Dstartup.auto.registration.skip=false`
7. `sudo cp /home/mpf/openmpf-projects/openmpf/trunk/install/libexec/node-manager /etc/init.d/`
8. `sudo systemctl daemon-reload`
9. `mpf start --xtc`
10. `mvn verify -Pjenkins -Dtransport.guarantee="NONE" -Dweb.rest.protocol="http" -Dcomponents.build.package.json=<configFile> -Dstartup.auto.registration.skip=false -Dcomponents.build.dir=/home/mpf/openmpf-projects/openmpf/mpf-component-build`
11. `mpf stop --xtc`

Please see the appendix section [Known Issues](#known-issues) regarding any `java.lang.InterruptedException: null` warning log messages observed when running the tests.

Run this command to clean up and remove all traces of the test run:

1. `mpf clean --delete-uploaded-media --delete-logs`
2. Type "Y" and press Enter.

If you choose not to run `mpf clean` before following the [Build and Run the OpenMPF Workflow Manager Web Application](build-and-run-the-openmpf-workflow-manager-web-application) steps, the Job Status table will be pre-populated with some entries; however, the input media, markup, and JSON output objects for those jobs will not be available.

---

# **Appendices**

# Command Line Tools

OpenMPF installs command line tools that can be accessed through a terminal on the development machine. All of the tools take the form of actions: `mpf <action> [options ...]`. Note that tab-completion is enabled for ease of use.

Execute `mpf --help` for general documentation and `mpf <action> --help` for documentation about a specific action.

  - **Start / Stop Actions**: Actions for starting and stopping the OpenMPF system dependencies, including PostgreSQL, ActiveMQ, Redis, Tomcat, and the node managers on the various nodes in the OpenMPF cluster.
    - `mpf status`: displays a message indicating whether each of the system dependencies is running or not
    - `mpf start`: starts all of the system dependencies
    - `mpf stop`: stops all of the system dependencies
    - `mpf restart` : stops and then starts all of the system dependencies
  - **User Actions**: Actions for managing Workflow Manager user accounts. If changes are made to an existing user then that user will need to log off or the Workflow Manager will need to be restarted for the changes to take effect.
    - `mpf list-users` : lists all of the existing user accounts and their role (non-admin or admin)
    - `mpf add-user <username> <role>`: adds a new user account; will be prompted to enter the account password
    - `mpf remove-user <username>` : removes an existing user account
    - `mpf change-role <username> <role>` : change the role (non-admin to admin or vice versa) for an existing user
    - `mpf change-password <username>`: change the password for an existing user; will be prompted to enter the new account password
  - **Clean Actions**: Actions to remove old data and revert the system to a new install state. User accounts, registered components, as well as custom actions, tasks, and pipelines, are preserved.
    - `mpf clean`: cleans out old job information and results, pending job requests, marked up media files, and ActiveMQ data, but preserves log files and uploaded media
    - `mpf clean --delete-logs --delete-uploaded-media`: the same as `mpf clean` but also deletes log files and uploaded media
- **Node Action**: Actions for managing node membership in the OpenMPF cluster.
    - `mpf list-nodes`: If the Workflow Manager is running, get the current JGroups view; otherwise, list the core nodes

# Known Issues

The following are known issues that are related to setting up and running OpenMPF. For a more complete list of known issues, please see the OpenMPF [Release Notes](Release-Notes/index.html) and [workboard](https://github.com/orgs/openmpf/projects/3?card_filter_query=label%3Abug).

**Test Exceptions**

When running the tests, you may observe warning log messages similar to this:

```
//2016-07-25 16:16:27,848 WARN [Time-limited test] org.mitre.mpf.mst.TestSystem - Exception occurred while waiting. Assuming that the job has completed (but failed)
java.lang.InterruptedException: null
	at java.lang.Object.wait(Native Method) ~[na:1.8.0_60]
	at java.lang.Object.wait(Object.java:502) ~[na:1.8.0_60]
	at org.mitre.mpf.mst.TestSystem.waitFor(TestSystem.java:209) [test-classes/:na]
	at org.mitre.mpf.mst.TestSystem.runPipelineOnMedia(TestSystem.java:201) [test-classes/:na]
	at org.mitre.mpf.mst.TestSystemOnDiff.runSpeechSphinxDetectAudio(TestSystemOnDiff.java:250) [test-classes/:na]
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method) ~[na:1.8.0_60]
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62) ~[na:1.8.0_60]
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43) ~[na:1.8.0_60]
	at java.lang.reflect.Method.invoke(Method.java:497) ~[na:1.8.0_60]
	at org.junit.runners.model.FrameworkMethod$1.runReflectiveCall(FrameworkMethod.java:50) [junit-4.12.jar:4.12]
	at org.junit.internal.runners.model.ReflectiveCallable.run(ReflectiveCallable.java:12) [junit-4.12.jar:4.12]
	at org.junit.runners.model.FrameworkMethod.invokeExplosively(FrameworkMethod.java:47) [junit-4.12.jar:4.12]
	at org.junit.internal.runners.statements.InvokeMethod.evaluate(InvokeMethod.java:17) [junit-4.12.jar:4.12]
	at org.springframework.test.context.junit4.statements.RunBeforeTestMethodCallbacks.evaluate(RunBeforeTestMethodCallbacks.java:75) [spring-test-4.2.5.RELEASE.jar:4.2.5.RELEASE]
	at org.springframework.test.context.junit4.statements.RunAfterTestMethodCallbacks.evaluate(RunAfterTestMethodCallbacks.java:86) [spring-test-4.2.5.RELEASE.jar:4.2.5.RELEASE]
	at org.springframework.test.context.junit4.statements.SpringRepeat.evaluate(SpringRepeat.java:84) [spring-test-4.2.5.RELEASE.jar:4.2.5.RELEASE]
	at org.junit.internal.runners.statements.FailOnTimeout$CallableStatement.call(FailOnTimeout.java:298) [junit-4.12.jar:4.12]
	at org.junit.internal.runners.statements.FailOnTimeout$CallableStatement.call(FailOnTimeout.java:292) [junit-4.12.jar:4.12]
	at java.util.concurrent.FutureTask.run(FutureTask.java:266) [na:1.8.0_60]
	at java.lang.Thread.run(Thread.java:745) [na:1.8.0_60]//
```

This does not necessarily indicate any type of software bug. The most likely cause for this message is that a test has timed out. Increasing the available system resources or increasing the test timeout values may help.


# Proxy Configuration

**Yum Package Manager Proxy Configuration**

Before using the yum package manager,  it may be necessary to configure it to work with your environment's proxy settings. If credentials are not required, it is not necessary to add them to the yum configuration.

1. `sudo bash -c 'echo "proxy=<address>:<port>" >> /etc/yum.conf'`
2. `sudo bash -c 'echo "proxy_username=<username>" >> /etc/yum.conf'`
3. `sudo bash -c 'echo "proxy_password=<password>" >> /etc/yum.conf'`

**Proxy Environment Variables**

If your build environment is behind a proxy server, some applications and tools will need to be configured to use it. To configure an HTTP and HTTPS proxy, run the following commands. If credentials are not required, leave those fields blank.

1. `sudo bash -c 'echo "export http_proxy=<username>:<password>@<url>:<port>" >> /etc/profile.d/mpf.sh`
2. `. /etc/profile.d/mpf.sh`
3. `sudo bash -c 'echo "export https_proxy='${http_proxy}'" >> /etc/profile.d/mpf.sh'`
4. `sudo bash -c 'echo "export HTTP_PROXY='${http_proxy}'" >> /etc/profile.d/mpf.sh'`
5. `sudo bash -c 'echo "export HTTPS_PROXY='${http_proxy}'" >> /etc/profile.d/mpf.sh'`
6. `. /etc/profile.d/mpf.sh`

**Git Proxy Configuration**

If your build environment is behind a proxy server, git will need to be configured to use it. The following command will set the git global proxy. If the environment variable `$http_proxy` is not set, use the full proxy server address, port, and credentials (if needed).

```
git config --global http.proxy $http_proxy
```

**Firefox Proxy Configuration**

Before running the integration tests and the web application, it may be necessary to configure Firefox with your environment's proxy settings.

1. In a new terminal window, type `firefox` and press enter. This will launch a new Firefox window.
2. In the new Firefox window, enter `about:preferences#advanced` in the URL text box and press enter.
3. In the left sidebar click "Advanced", then click the `Network` tab, and in the `Connection` section press the "Settings..." button.
4. Enter the proxy settings for your environment.
5. In the "No Proxy for:" text box, verify that `localhost` is included.
6. Press the "OK" button.
7. Close all open Firefox instances.

**Maven Proxy Configuration**

Before using Maven, it may be necessary to configure it to work with your environment's proxy settings. Open a new terminal window and run these commands. Afterwards, continue with adding the additional maven dependencies.

1. `cd /home/mpf`
2. `mkdir -p .m2`
3. `cp /opt/apache-maven/conf/settings.xml .m2/`
4. Open the file `.m2/settings.xml` in a text editor.
5. Navigate to the `<proxies>` section (line 85).
6. There is a commented-out example proxy server specification. Copy and paste the example specification below the commented-out section, but before the end of the closing `</proxies>` tag.
7. Fill in your environment's proxy server information. For additional help and information, please see the Apache Maven guide to configuring a proxy server at <https://maven.apache.org/guides/mini/guide-proxies.html>.


# SSL Inspection

If your build environment is behind a proxy server that performs SSL inspection, some applications and tools will need to be configured to accommodate it. The following steps will add trusted certificates to your development machine.

Additional information on Java keytool can be found at <https://docs.oracle.com/javase/8/docs/technotes/tools/unix/keytool.html>.

1. Download any certificates needed for using SSL in your build environment to `/home/mpf/Downloads`.
2. For each certificate, run this command, filling in the values for certificate alias, certificate name, and keystore passphrase:
    <br> `sudo $JAVA_HOME/bin/keytool -import -alias <certificate alias> -file /home/mpf/Downloads/<certificate name>.crt -keystore "$JAVA_HOME/jre/lib/security/cacerts" -storepass <keystore passphrase> -noprompt`
3. For each certificate, run this command, filling in the value for certificate name:
    <br> `sudo cp /home/mpf/Downloads/<certificate name>.crt /tmp`
4. For each certificate, run this command, filling in the values for certificate name:
    <br> `sudo -u root -H sh -c "openssl x509 -in /tmp/<certificate name>.crt    -text > /etc/pki/ca-trust/source/anchors/<certificate name>.pem"`
5. Run these commands once:
    1. `sudo -u root -H sh -c "update-ca-trust enable"`
    2. `sudo -u root -H sh -c "update-ca-trust extract"`
6. Run these commands once, filling in the value for the root certificate name:
    1. `sudo cp /etc/pki/tls/certs/ca-bundle.crt /etc/pki/tls/certs/ca-bundle.crt.original`
    2. `sudo -u root -H sh -c "cat /etc/pki/ca-trust/source/anchors/<root certificate name>.pem >> /etc/pki/tls/certs/ca-bundle.crt"`

Alternatively, if adding certificates is not an option, or difficulties are encountered, you may optionally skip SSL certificate verification for these tools. This is not recommended:

**wget**

1. `cd /home/mpf`
2. `touch /home/mpf/.wgetrc`
3. In a text editor, open the file `/home/mpf/.wgetrc`
4. Add this line:

    ```
    check_certificate=off
    ```

5. Save and close the file.
6. `. /home/mpf/.wgetrc`

**git**

1. `cd /home/mpf`
2. `git config http.sslVerify false`
3. `git config --global http.sslVerify false`

**maven**

1. In a text editor, open the file `/etc/profile.d/mpf.sh`
2. At the bottom of the file, add this line:
<pre><code>export MAVEN_OPTS="-Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true"</code></pre>
3. Save and close the file.
4. `. /etc/profile.d/mpf.sh`


# Development Tools

When developing for OpenMPF, you may find the following tools helpful:

- **Jenkins**: <https://jenkins.io>
- **IntelliJ**: <https://www.jetbrains.com/idea/>
- **CLion**: <https://www.jetbrains.com/clion>
- **PyCharm**: <https://www.jetbrains.com/pycharm>
