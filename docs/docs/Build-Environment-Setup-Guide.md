> **NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2018 The MITRE Corporation. All Rights Reserved.

> **WARNING:** As of Release 3.0.0, this guide is no longer supported. It is left here for reference and will be removed in a future release. It was last tested with Release 2.1.0. We now support creating Docker images and deploying those containers. Please refer to the openmpf-docker [README](https://github.com/openmpf/openmpf-docker/blob/master/README.md).

# General Information

The Open Media Processing Framework (OpenMPF) software is distributed to interested parties as a raw source code package. This is to avoid any potential licensing issues that may arise from distributing a pre-compiled executable that is linked to dependencies that are licensed under a copyleft license or have patent restrictions. Generally, it is acceptable build and execute software with these dependencies for non-commercial in-house use.

By distributing the OpenMPF software as raw source code the development team is able to keep most of the software clean from copyleft and patent issues so that it can be published under a more open Apache license and freely distributed to interested parties.

> **IMPORTANT:** It is the responsibility of the end users who follow this guide, and otherwise build the OpenMPF software to create an executable, to abide by all of the non-commercial and re-distribution restrictions imposed by the dependencies that the OpenMPF software uses. Building the OpenMPF and linking in these dependencies at build time or run time results in creating a derivative work under the terms of the GNU General Public License. Refer to the About page within the OpenMPF for more information about these dependencies.

In general, it is only acceptable to use and distribute the executable form of the OpenMPF "in house", which is loosely defined as internally with an organization. The OpenMPF should only be distributed to third parties in raw source code form and those parties will be responsible for creating their own executable.

This guide provides comprehensive instructions for setting up a build environment and generating an OpenMPF deployment package that contains the executable form of the software. This package is self-contained so that it can be installed on a minimal CentOS 7 system without Internet connectivity. This package can be freely distributed and installed in-house, but not distributed to third parties.

# Set Up the Minimal CentOS 7 VM

The following instructions are for setting up a VM for building an OpenMPF deployment package. This VM is not necessarily a machine on which the OpenMPF will be deployed and run. Those machines may have other requirements. For more information refer to the [OpenMPF Installation Guide](Installation-Guide/index.html).

- This guide assumes a starting point of CentOS 7 with a minimal installation.
- Download the CentOS 7 (1708) minimal iso from [here](http://archive.kernel.org/centos-vault/7.4.1708/isos/x86_64/CentOS-7-x86_64-Minimal-1708.iso) prior to starting these steps. As of writing this guide, the last version of the iso we tested is CentOS-7-x86_64-Minimal-1708.iso. If a more modern version of CentOS is available, we recommend not using it; otherwise, you may encounter library dependency issues during deployment.
- Oracle Virtual Box is used as the virtualization platform. Another platform such as VMware or a physical system can be used but are not supported. As of writing this guide, the last version of Virtual Box we tested is 5.2.4 r119785.


1. Create a new VM with these settings:
    - **Name**: ’OpenMPF Build’. (This guide assumes the name ‘OpenMPF Build’, but any name can be used.)
    - **Type**: Linux
    - **Version**: Red Hat (64-bit)

2. The recommended minimum virtual system specifications are:
    - **Memory**: 8192MB
    - **CPU**: 4
    - **Disk**: 40GB on a SSD.

3. Network settings may vary based on your local environment. Connectivity to the public Internet is assumed. The network settings used in this guide are:
    - **Attached to**: NAT
    - **Advanced -> Adapter Type**: Intel PRO/1000 MT Desktop (82540EM)
    - **Cable Connected**: Checked

# Install CentOS 7

> **NOTE:** If your build environment is behind a proxy server, please read the appendix section [Proxy Configuration](#proxy-configuration) for instructions to configure the yum package manager before continuing.

1. Open the ‘Settings’ for the OpenMPF Build VM.
2. Select the ‘Storage’ menu item.
3. In the ‘Storage Tree’ section under the ‘Controller: IDE’ item, select the optical disc icon.
4. Under the ‘Attributes’ section, select the optical disc icon with a small black arrow. This will bring up a menu.
5. Select ‘Choose Virtual Optical Disc file…’
6. Choose the CentOS 7 minimal iso file.
7. Press the ‘OK’ button to exit the OpenMPF Build VM settings.
8. Right click on the OpenMPF Build VM and select ‘Start’ and ‘Normal Start’. A new window will open with the running VM.
9. On the ‘CentOS 7’ screen, select ‘Install CentOS 7’ with the keyboard and press the Enter key.
10. Select the appropriate language and press the ‘Continue’ button.
11. On the ‘Installation Summary’ screen, select the ‘Installation Destination’ icon.
12. Press the ‘Done’ button to accept the defaults.
13. On the ‘Installation Summary’ screen, select the ‘Network & Host Name’ icon. There should be one interface listed.
14. Set the slider switch to ‘On’.
15. Press the ‘Configure’ button, select the ‘General’ tab, and check the box for ‘Automatically connect to this network when available’.
16. Press the 'Save' button.
17. Each interface should show its status as ‘Connected’ with an IPv4 address.
18. Leave the hostname as ‘localhost.localdomain’.
19. Press the ‘Done’ button.
20. Use the default values for everything else and press 'Begin Installation'.
21. Set a password for the root account.
22. Under ‘User Creation’, create a new user:
    - **Full Name**: mpf
    - **User Name**: mpf
        - Check the box for ‘Make this user administrator’
    - **Password**: mpf
23. When installation is finished, press the ‘Reboot’ button.
24. At the login prompt, login as user ‘mpf’ and password ‘mpf’.
25. Install the epel repository and Delta RPM:
    <br> `sudo yum install -y epel-release deltarpm`
26. Perform an initial system update:
    <br> `sudo yum update -y`
27. Install Gnome Desktop Environment and some packages needed for the Virtual Box Guest Additions:
    <br> `sudo yum groups install -y "GNOME Desktop"`
28. Install packages needed for the Virtual Box Guest Additions:
    <br> `sudo yum install gcc kernel-devel bzip2`
   > <br> **NOTE:** You may have to specify a kernel version when installing ‘kernel-devel‘ as a Virtual Box guest addition. For example: `sudo yum install kernel-devel-3.10.0-327.el7.x86_64`.
29. Reboot the system:
    <br> `sudo reboot now`
30. To accept the license agreement, enter ‘1’, then enter ‘2’, then enter ‘c’ to continue.
31. At the login prompt, login as user ‘mpf’ and password ‘mpf’.
32. On your host system, click the top border of the window running the OpenMPF Build VM, then select ‘Devices’ from the top menu bar, and then ‘Insert Guest Additions CD Image...’
33. Install the Virtual Box Guest Additions:
    1. `sudo mount /dev/cdrom /mnt`
    2. `cd /mnt`
    3. `sudo ./VBoxLinuxAdditions.run`
34. `sudo systemctl set-default graphical.target`
35. `sudo reboot now`
36. At the graphical login screen, select the 'mpf' user.
37. Enter 'mpf' as the password.
38. A welcome screen will come up on the first launch of the Gnome desktop environment. Press the 'Next' button on the 'Language' page.
39. Press the 'Next' button on the 'Typing' page.
40. Press the 'Next' button on the 'Privacy' page.
41. Press the 'Skip' button on the 'Online Accounts' page.
42. Press the 'Start using CentOS Linux' button.
43. Close the 'Getting Started' window that appears.
44. On the desktop, right click the 'VBOXADDITIONS_5.0.22_108108' icon and select 'Eject'.
45. On your host system in the Virtual Box Application, select the OpenMPF Build VM menu item ‘Devices’, then ‘Shared Clipboard’, then "Bidirectional". This will enable the ability to copy and paste commands from this document into the VM.
46. On your host system in the Virtual Box Application, select the OpenMPF Build VM menu item ‘Devices’, then ‘Drag and Drop’, then "Bidirectional". This will enable the ability to drag files from the host system to the guest VM.

# Set Up the OpenMPF Build Environment

> **NOTE:** If your build environment is behind a proxy server, please read the appendix section [Proxy Configuration](#proxy-configuration) for instructions to configure the yum package manager, as well as the appendix section [SSL Inspection](#ssl-inspection), before continuing.

At the time of writing, all URLs provided in this section were verified as working.

## Configure Additional Repositories
Open a terminal window and perform the following steps:

1. Install the Oracle MySQL Community Release Repository:
    1. `wget -P /home/mpf/Downloads "http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm"`
    2. `sudo rpm -ivh /home/mpf/Downloads/mysql-community-release-el7-5.noarch.rpm`
2. Install the Remi Repo for Redis:
    1. `wget -P /home/mpf/Downloads "http://rpms.remirepo.net/RPM-GPG-KEY-remi"`
    2. `wget -P /home/mpf/Downloads "http://rpms.famillecollet.com/enterprise/remi-release-7.rpm"`
    3. `sudo rpm --import /home/mpf/Downloads/RPM-GPG-KEY-remi`
    4. `sudo rpm -Uvh /home/mpf/Downloads/remi-release-7.rpm`
    5. `sudo yum-config-manager --enable remi`
3. Create an ‘/apps’ directory and package subdirectories:
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
4. Create the OpenMPF ldconfig file:
    <br>`sudo touch /etc/ld.so.conf.d/mpf-x86_64.conf`
5. Add /apps/install/lib to the OpenMPF ldconfig file:
    <br>`sudo sh -c 'echo "/apps/install/lib" >> /etc/ld.so.conf.d/mpf-x86_64.conf'`
6. Update the shared library cache:
    <br>`sudo ldconfig`


## Install RPM Dependencies

The following RPM packages will need to be downloaded and installed. Use of the yum package manager is recommended:

`sudo yum install -y asciidoc autoconf automake boost boost-devel cmake3 curl freetype-devel gcc-c++ git graphviz gstreamer-plugins-base-devel gtk2-devel gtkglext-devel gtkglext-libs jasper jasper-devel libavc1394-devel libcurl-devel libdc1394-devel libffi-devel libICE-devel libjpeg-turbo-devel libpng-devel libSM-devel libtiff-devel libtool libv4l-devel libXinerama-devel libXmu-devel libXt-devel log4cplus log4cplus-devel log4cxx log4cxx-devel make mercurial mesa-libGL-devel mesa-libGLU-devel mysql-community-client mysql-community-server nasm ncurses-devel numpy openssl-devel pangox-compat pangox-compat-devel perl-CPAN-Meta-YAML perl-DBD-MySQL perl-DBI perl-Digest-MD5 perl-File-Find-Rule perl-File-Find-Rule-Perl perl-JSON perl-JSON-PP perl-List-Compare perl-Number-Compare perl-Params-Util perl-Parse-CPAN-Meta php pkgconfig python-devel python-httplib2 python-jinja2 python-keyczar python2-paramiko python2-pip python-setuptools python-six PyYAML qt qt-devel qt-x11 redis rpm-build sshpass tbb tbb-devel tree unzip uuid-devel wget yasm yum-utils zlib-devel`

The version of pip available in the yum repository is old and must be upgraded with the following command:
`sudo pip install --upgrade pip`

## Get the OpenMPF Source Code
Open a terminal window and perform the following steps:

1. Clone the OpenMPF repository
    1. `cd /home/mpf`
    2. `git clone https://github.com/openmpf/openmpf-projects.git --recursive`
    3. (Optional) The HTTPS repository URL requires configuring your Github account with a certificate pair. The HTTP URL may be used without any certificates:
        ```
        git clone http://github.com/openmpf/openmpf-projects.git --recursive
        ```

2. Copy the mpf user profile script from the extracted source code:
    <br> `sudo cp /home/mpf/openmpf-projects/openmpf/trunk/mpf-install/src/main/scripts/mpf-profile.sh /etc/profile.d/mpf.sh`

3. Add /apps/install/bin to the system PATH variable:
    1. `sudo sh -c 'echo "PATH=\$PATH:/apps/install/bin" >> /etc/profile.d/mpf.sh'`
    2. `. /etc/profile.d/mpf.sh`

## Install Binary Packages

> **NOTE:** If your environment is behind a proxy server that performs SSL inspection, please read the appendix section [SSL Inspection](#ssl-inspection) before continuing.

The following binary packages will need to be downloaded and installed:

1. Oracle JDK:
    1. Open a web browser and navigate to <http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html>.
    2. In the "Java SE Development Kit 8u144" section, click the radio button to "Accept License Agreement".
   > <br> **NOTE:** If that version of the JDK is not available on that page, then look for it on <http://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html>. You will be required to either sign in with an existing account, or create a new account.
    3. Click on the "jdk-8u144-linux-x64.rpm" link to begin the download.
    4. Move the downloaded file to `/apps/bin/jdk-8u144-linux-x64.rpm`.
    5. `sudo yum -y localinstall --nogpgcheck /apps/bin/jdk-8u144-linux-x64.rpm`
    6. `sudo alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_144/jre/bin/java 20000`
    7. `sudo alternatives --install /usr/bin/jar jar /usr/java/jdk1.8.0_144/bin/jar 20000`
    8. `sudo alternatives --install /usr/bin/javac javac /usr/java/jdk1.8.0_144/bin/javac 20000`
    9. `sudo alternatives --install /usr/bin/javaws javaws /usr/java/jdk1.8.0_144/jre/bin/javaws 20000`
    10. `sudo alternatives --set java /usr/java/jdk1.8.0_144/jre/bin/java`
    11. `sudo alternatives --set javaws /usr/java/jdk1.8.0_144/jre/bin/javaws`
    12. `sudo alternatives --set javac /usr/java/jdk1.8.0_144/bin/javac`
    13. `sudo alternatives --set jar /usr/java/jdk1.8.0_144/bin/jar`
   > <br> **NOTE:** If this command to set the `jar` alternative fails with the following error:
   >
   > *failed to read link /usr/bin/jar: No such file or directory*
   >
   > Then you should run the following commands again:
   > <br> `sudo alternatives --install /usr/bin/jar jar /usr/java/jdk1.8.0_144/bin/jar 20000`
   > <br> `sudo alternatives --set jar /usr/java/jdk1.8.0_144/bin/jar`
    14. `. /etc/profile.d/mpf.sh`

2. Apache ActiveMQ 5.13.0:
    <br>For reference only: <http://activemq.apache.org>
    1. `cd /apps/bin/apache`
    2. `wget -O /apps/bin/apache/apache-activemq-5.13.0-bin.tar.gz "https://archive.apache.org/dist/activemq/5.13.0/apache-activemq-5.13.0-bin.tar.gz"`
    3. `sudo tar xvzf apache-activemq-5.13.0-bin.tar.gz -C /opt/`
    4. `sudo chown -R mpf:mpf /opt/apache-activemq-5.13.0`
    5. `sudo chmod -R 755 /opt/apache-activemq-5.13.0`
    6. `sudo ln -s /opt/apache-activemq-5.13.0 /opt/activemq`
3. Apache Tomcat 7.0.72:
    <br>For reference only: <http://tomcat.apache.org>
    1. `cd /apps/bin/apache `
    2. `wget -O /apps/bin/apache/apache-tomcat-7.0.72.tar.gz "http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.72/bin/apache-tomcat-7.0.72.tar.gz"`
    3. `tar xzvf apache-tomcat-7.0.72.tar.gz`
    4. `sudo mkdir -p /usr/share/apache-tomcat`
    5. `sudo cp -Rf /apps/bin/apache/apache-tomcat-7.0.72/* /usr/share/apache-tomcat/`
    6. `sudo chown -R mpf:mpf /usr/share/apache-tomcat`
    7. `sudo chmod -R 755 /usr/share/apache-tomcat`
    8. `sudo ln -s /usr/share/apache-tomcat /opt/apache-tomcat`
    9. `sudo perl -i -p0e 's/<!--\n    <Manager pathname="" \/>\n      -->.*?/<!-- -->\n    <Manager pathname="" \/>/s' /opt/apache-tomcat/conf/context.xml`
    10. `sudo rm -rf /opt/apache-tomcat/webapps/*`
4. Apache Ant 1.9.6:
    <br>For reference only: <http://ant.apache.org>
    1. `cd /apps/bin/apache `
    2. `wget -O /apps/bin/apache/apache-ant-1.9.6-bin.tar.gz "https://archive.apache.org/dist/ant/binaries/apache-ant-1.9.6-bin.tar.gz"`
    3. `tar xzvf apache-ant-1.9.6-bin.tar.gz`
    4. `sudo cp -R /apps/bin/apache/apache-ant-1.9.6 /apps/install/`
    5. `sudo chown -R mpf:mpf /apps/install/apache-ant-1.9.6`
    6. `sudo sed -i '/^PATH/s/$/:\/apps\/install\/apache-ant-1.9.6\/bin/' /etc/profile.d/mpf.sh`
    7. `. /etc/profile.d/mpf.sh`
- Apache Maven 3.3.3:
    <br>For reference only: <https://maven.apache.org>
    1. `cd /apps/bin/apache`
    2. `wget -O /apps/bin/apache/apache-maven-3.3.3-bin.tar.gz "https://archive.apache.org/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz"`
    3. `tar xzvf apache-maven-3.3.3-bin.tar.gz`
    4. `sudo mkdir /opt/apache-maven`
    5. `sudo cp -Rf /apps/bin/apache/apache-maven-3.3.3/* /opt/apache-maven/`
    6. `sudo chown -R mpf:mpf /opt/apache-maven`
    7. `sudo sed -i '/^PATH/s/$/:\/opt\/apache-maven\/bin/' /etc/profile.d/mpf.sh`
    8. `sudo sh -c 'echo "M2_HOME=/opt/apache-maven" >> /etc/profile.d/mpf.sh'`
    9. `. /etc/profile.d/mpf.sh`

## Install Python Packages

1. C Foreign Function Interface (CFFI):
    1. `cd /home/mpf`
    2. `sudo -E easy_install -U cffi`
2. OpenMPF Administrative Tools:
    <br> `sudo -E pip install /home/mpf/openmpf-projects/openmpf/trunk/bin/mpf-scripts`
3. Virtualenv:
    <br> `sudo -E pip install virtualenv`
4. Wheel:
    <br> `sudo -E pip install wheel`

## Build Dependencies

> **NOTE:** If your build environment is behind a proxy server, please read the appendix section [Proxy Configuration](#proxy-configuration) for instructions to configure the yum package manager, as well as the appendix section [SSL Inspection](#ssl-inspection), before continuing.

The following source packages will need to be downloaded, built, and installed:

1. Cmake 2.8.12.2:
    <br>For reference only: <https://cmake.org>
    1. `cd /apps/source/cmake_sources`
    2. `wget -O /apps/source/cmake_sources/cmake-2.8.12.2.tar.gz "https://cmake.org/files/v2.8/cmake-2.8.12.2.tar.gz"`
    3. `tar xvzf cmake-2.8.12.2.tar.gz`
    4. `cd cmake-2.8.12.2`
    5. `chmod +x *`
    6. `./configure --prefix=/apps/install`
    7. `make -j`
    8. `sudo make install`
    9. `sudo ldconfig`
    10. `sudo ln -s /apps/install/bin/cmake /usr/local/bin/cmake`

2. FFmpeg 3.3.3:
    <br><br>**NOTE:** FFmpeg can be built with different encoders and modules that are individually licensed. It is recommended to check each developer’s documentation for the most up-to-date licensing information.
    1. opencore-amr:
        <br>For reference only: <https://sourceforge.net/projects/opencore-amr>
        1. `cd /apps/source/ffmpeg_sources`
        2. `wget -O /apps/source/ffmpeg_sources/opencore-amr-0.1.4.tar.gz "https://downloads.sf.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.4.tar.gz"`
        3. `tar xvzf opencore-amr-0.1.4.tar.gz`
        4. `cd opencore-amr-0.1.4`
        5. `autoreconf -fiv`
        6. `./configure --prefix="/apps/install" --enable-shared`
        7. `make`
        8. `sudo make install`
        9. `make distclean`
        10. `sudo ldconfig`
    2. libfdk_aac:
        <br>For reference only: <https://github.com/mstorsjo/fdk-aac>
        1. `cd /apps/source/ffmpeg_sources`
        2. `wget -O /apps/source/ffmpeg_sources/fdk-aac-0.1.5.tar.gz "https://github.com/mstorsjo/fdk-aac/archive/v0.1.5.tar.gz"`
        3. `tar xvzf fdk-aac-0.1.5.tar.gz`
        4. `cd fdk-aac-0.1.5`
        5. `autoreconf -fiv`
        6. `./configure --prefix="/apps/install" --enable-shared`
        7. `make`
        8. `sudo make install`
        9. `make distclean`
        10. `sudo ldconfig`
    3. libmp3lame:
        <br>For reference only: <http://lame.sourceforge.net>
        1. `cd /apps/source/ffmpeg_sources`
        2. `wget -O /apps/source/ffmpeg_sources/lame-3.99.5.tar.gz "http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz"`
        3. `tar xzvf lame-3.99.5.tar.gz`
        4. `cd lame-3.99.5`
        5. `./configure --prefix="/apps/install" --bindir="/apps/install/bin" --enable-shared --enable-nasm`
        6. `make`
        7. `sudo make install`
        8. `make distclean`
        9. `sudo ldconfig`
    4. libogg:
        <br>For reference only: <https://www.xiph.org/ogg>
        1. `cd /apps/source/ffmpeg_sources`
        2. `wget -O /apps/source/ffmpeg_sources/libogg-1.3.2.tar.gz "http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz"`
        3. `tar xvzf libogg-1.3.2.tar.gz`
        4. `cd libogg-1.3.2`
        5. `./configure --prefix="/apps/install" --enable-shared`
        6. `make`
        7. `sudo make install`
        8. `make distclean`
        9. `sudo ldconfig`
    5. libopus:
        <br>For reference only: <https://www.opus-codec.org>
        1. `cd /apps/source/ffmpeg_sources`
        2. `wget -O /apps/source/ffmpeg_sources/libopus-1.2.tar.gz "https://archive.mozilla.org/pub/opus/opus-1.2.tar.gz"`
        3. `tar xzvf libopus-1.2.tar.gz`
        4. `cd opus-1.2`
        5. `autoreconf -fiv`
        6. `./configure --prefix="/apps/install" --enable-shared`
        7. `make`
        8. `sudo make install`
        9. `make distclean`
        10. `sudo ldconfig`
    6. libspeex:
        <br>For reference only: <https://www.speex.org>
        1. `cd /apps/source/ffmpeg_sources`
        2. `wget -O /apps/source/ffmpeg_sources/speex-1.2rc2.tar.gz "http://downloads.xiph.org/releases/speex/speex-1.2rc2.tar.gz"`
        3. `tar xvzf speex-1.2rc2.tar.gz`
        4. `cd speex-1.2rc2`
        5. `LDFLAGS="-L/apps/install/lib" CPPFLAGS="-I/apps/install/include" ./configure --prefix="/apps/install" --enable-shared`
        6. `make`
        7. `sudo make install`
        8. `make distclean`
        9. `sudo ldconfig`
    7. libvorbis:
        <br>For reference only: <https://xiph.org/vorbis>
        1. `cd /apps/source/ffmpeg_sources`
        2. `wget -O /apps/source/ffmpeg_sources/libvorbis-1.3.5.tar.gz "http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.gz"`
        3. `tar xzvf libvorbis-1.3.5.tar.gz`
        4. `cd libvorbis-1.3.5`
        5. `LDFLAGS="-L/apps/install/lib" CPPFLAGS="-I/apps/install/include" ./configure --prefix="/apps/install" --with-ogg="/apps/install" --enable-shared`
        6. `make`
        7. `sudo make install`
        8. `make distclean`
        9. `sudo ldconfig`
    8. libtheora:
        <br>For reference only: <https://www.theora.org>
        1. `cd /apps/source/ffmpeg_sources`
        2. `wget -O /apps/source/ffmpeg_sources/libtheora-1.1.1.tar.gz "http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.gz"`
        3. `tar xzvf libtheora-1.1.1.tar.gz`
        4. `cd libtheora-1.1.1`
        5. `./configure --prefix="/apps/install" --with-ogg="/apps/install" --enable-shared`
        6. `make`
        7. `sudo make install`
        8. `make distclean`
        9. `sudo ldconfig`
    9. libvpx:
        <br>For reference only: <https://www.webmproject.org/code/>
        1. `cd /apps/source/ffmpeg_sources`
        2. `wget -O /apps/source/ffmpeg_sources/v1.6.1.tar.gz "https://codeload.github.com/webmproject/libvpx/tar.gz/v1.6.1"`
        3. `tar xvzf v1.6.1.tar.gz`
        4. `cd libvpx-1.6.1`
        5. `./configure --prefix="/apps/install" --enable-shared --enable-vp8 --enable-vp9 --enable-pic --disable-debug --disable-examples --disable-docs`
        6. `make`
        7. `sudo make install`
        8. `make distclean`
        9. `sudo ldconfig`
    10. libx264:
        <br>For reference only: <http://www.videolan.org/developers/x264.html>
        1. `cd /apps/source/ffmpeg_sources`
        2. `wget -O /apps/source/ffmpeg_sources/x264-snapshot-20170226-2245-stable.tar.bz2 "ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20170226-2245-stable.tar.bz2"`
        3. `tar xvjf x264-snapshot-20170226-2245-stable.tar.bz2`
        4. `cd x264-snapshot-20170226-2245-stable`
        5. `PKG_CONFIG_PATH="/apps/install/lib/pkgconfig" ./configure --prefix="/apps/install" --bindir="/apps/install" --enable-shared --disable-cli`
        6. `sudo sed -i '/^PATH/s/$/:\/apps\/install\/lib\/pkgconfig/' /etc/profile.d/mpf.sh`
        7. `sudo sh -c 'echo "export PKG_CONFIG_PATH=/apps/install/lib/pkgconfig" >> /etc/profile.d/mpf.sh'`
        8. `. /etc/profile.d/mpf.sh`
        9. `make`
        10. `sudo make install`
        11. `make distclean`
        12. `sudo ldconfig`
    11. libx265:
        <br>For reference only: <http://x265.org>
        1. `cd /apps/source/ffmpeg_sources`
        2. `wget -O x265_2.3.tar.gz "https://download.videolan.org/pub/videolan/x265/x265_2.3.tar.gz"`
        3. `tar xzvf x265_2.3.tar.gz`
        4. `cd x265_2.3/build/linux`
        5. `MAKEFLAGS="-j" ./multilib.sh`
        > <br> **NOTE:**  The above command will take some time to complete and will appear to do nothing after printing out `[100%] Built target encoder`. Please be patient and wait for the command to complete.</b>
        6. `cd 8bit`
        7. `cmake ../../../source -DEXTRA_LIB="x265_main10.a;x265_main12.a" -DEXTRA_LINK_FLAGS=-L. -DLINKED_10BIT=ON -DLINKED_12BIT=ON -DCMAKE_INSTALL_PREFIX="/apps/install"`
        8. `sudo  make install`
        9. `make clean`
        10. `cd ../10bit`
        11. `make clean`
        12. `cd ../12bit`
        13. `make clean`
        14. `sudo ldconfig`
    12. xvidcore:
        <br>For reference only: <https://labs.xvid.com>
        1. `cd /apps/source/ffmpeg_sources`
        2. `wget -O /apps/source/ffmpeg_sources/xvidcore-1.3.4.tar.gz "http://downloads.xvid.org/downloads/xvidcore-1.3.4.tar.gz"`
        3. `tar zxvf xvidcore-1.3.4.tar.gz`
        4. `cd xvidcore/build/generic`
        5. `./configure --prefix="/apps/install"`
        6. `make`
        7. `sudo make install`
        8. `make distclean`
        9. `sudo ldconfig`
    13. FFmpeg:
        <br>For reference only: <https://ffmpeg.org>
        1. `cd /apps/source/ffmpeg_sources`
        2. `git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg`
        3. `cd ffmpeg`
        4. `git checkout release/3.3`
        5. `PKG_CONFIG_PATH="/apps/install/lib/pkgconfig" ./configure --bindir="/apps/install/bin" --disable-libsoxr --enable-avresample --enable-gpl --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libfdk_aac --enable-libmp3lame --enable-libopus --enable-libspeex --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-libxvid --enable-nonfree --enable-openssl --enable-shared --enable-version3 --extra-cflags="-I/apps/install/include" --extra-ldflags="-L/apps/install/lib" --extra-libs=-ldl --prefix="/apps/install"`
        6. `make`
        7. `sudo make install`
        8. `make distclean`
        9. `sudo ln -s /apps/install/bin/ffmpeg /usr/bin/ffmpeg`
        10. `sudo sh -c 'echo "export CXXFLAGS=-isystem\ /apps/install/include" >> /etc/profile.d/mpf.sh'`
        11. `. /etc/profile.d/mpf.sh`
        12. `sudo ldconfig`
3. Google protocol buffers 2.5.0:
    <br>For reference only: <https://developers.google.com/protocol-buffers>
    1. `cd /apps/source/google_sources`
    2. `wget -O /apps/source/google_sources/protobuf-2.5.0.tar.gz "https://github.com/google/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz"`
    3. `tar xvzf protobuf-2.5.0.tar.gz`
    4. `cd protobuf-2.5.0`
    5. `./configure --prefix=/apps/install`
    6. `make -j8`
    7. `sudo make install`
    8. `make distclean`
    9. `sudo ldconfig`
    10. `sudo ln -s /apps/install/bin/protoc /usr/local/bin/protoc`
    11. `sudo ln -s /usr/lib64/libuuid.so.1.3.0 /usr/lib64/libuuid.so`
4. Apr 1.5.2:
    <br>For reference only: <https://apr.apache.org>
    1. `cd /apps/source/apache_sources`
    2. `wget -O /apps/source/apache_sources/apr-1.5.2.tar.gz "http://archive.apache.org/dist/apr/apr-1.5.2.tar.gz"`
    3. `tar -zxvf apr-1.5.2.tar.gz`
    4. `cd /apps/source/apache_sources/apr-1.5.2`
    5. `./configure --prefix=/apps/install`
    6. `make -j8`
    7. `sudo make install`
    8. `make distclean`
    9. `sudo ldconfig`
5. Apr-util 1.5.4:
    <br>For reference only: <https://apr.apache.org>
    1. `cd /apps/source/apache_sources`
    2. `wget -O /apps/source/apache_sources/apr-util-1.5.4.tar.gz "http://archive.apache.org/dist/apr/apr-util-1.5.4.tar.gz"`
    3. `tar -xzvf apr-util-1.5.4.tar.gz`
    4. `cd /apps/source/apache_sources/apr-util-1.5.4`
    5. `./configure --with-apr=/apps/install --prefix=/apps/install`
    6. `make -j8`
    7. `sudo make install`
    8. `make distclean`
    9. `sudo ldconfig`
6. Activemqcpp 3.9.0:
    <br>For reference only: <http://activemq.apache.org/cms>
    1. `cd /apps/source/apache_sources`
    2. `wget -O /apps/source/apache_sources/activemq-cpp-library-3.9.0-src.tar.gz "https://archive.apache.org/dist/activemq/activemq-cpp/3.9.0/activemq-cpp-library-3.9.0-src.tar.gz"`
    3. `tar zxvf activemq-cpp-library-3.9.0-src.tar.gz`
    4. `cd /apps/source/apache_sources/activemq-cpp-library-3.9.0`
    5. `./autogen.sh`
    6. `./configure --disable-ssl --prefix=/apps/install`
    7. `make -j8`
    8. `sudo make install`
    9. `make distclean`
    10. `sudo ldconfig`
    11. `sudo ln -s /apps/install/lib/libactivemq-cpp.so.19.0.0 /usr/lib/libactivemq-cpp.so`
7. OpenCV 3.3.0
    <br>For reference only: <http://opencv.org>
    1. `cd /apps/source/opencv_sources`
    2. `git clone https://github.com/opencv/opencv.git`
    3. `cd opencv`
    4. `git checkout 3.3.0`
    5. `mkdir release`
    6. `cd release`
    7. `PKG_CONFIG_PATH="/apps/install/lib/pkgconfig" cmake3 -DCMAKE_BUILD_TYPE=Release -DWITH_GSTREAMER:BOOL="0" -DWITH_OPENMP:BOOL="1" -DBUILD_opencv_apps:BOOL="0" -DWITH_OPENCLAMDBLAS:BOOL="0" -DWITH_CUDA:BOOL="0" -DCLAMDFFT_ROOT_DIR:PATH="CLAMDFFT_ROOT_DIR-NOTFOUND" -DBUILD_opencv_aruco:BOOL="0" -DCMAKE_INSTALL_PREFIX:PATH="/apps/install/opencv3.3.0" -DWITH_WEBP:BOOL="0" -DBZIP2_LIBRARIES:FILEPATH="BZIP2_LIBRARIES-NOTFOUND" -DWITH_GIGEAPI:BOOL="0" -DWITH_JPEG:BOOL="1" -DWITH_CUFFT:BOOL="0" -DWITH_IPP:BOOL="0" -DWITH_V4L:BOOL="1" -DWITH_GDAL:BOOL="0" -DWITH_OPENCLAMDFFT:BOOL="0" -DWITH_GPHOTO2:BOOL="0" -DWITH_VTK:BOOL="0" -DWITH_GTK_2_X:BOOL="0" -DBUILD_opencv_world:BOOL="0" -DWITH_TIFF:BOOL="1" -DWITH_1394:BOOL="0" -DWITH_EIGEN:BOOL="0" -DWITH_LIBV4L:BOOL="0" -DBUILD_opencv_ts:BOOL="0" -DWITH_MATLAB:BOOL="0" -DWITH_OPENCL:BOOL="0" -DWITH_PVAPI:BOOL="0" -DENABLE_CXX11:BOOL=“1” ..`
    8. `make -j4`
    9. `sudo make install`
    10. `sudo sh -c 'echo "/apps/install/opencv3.3.0/lib" >> /etc/ld.so.conf.d/mpf-x86_64.conf'`
    11. `sudo ln -sf /apps/install/opencv3.3.0 /opt/opencv-3.3.0`
    12. `sudo ln -sf /apps/install/opencv3.3.0/include/opencv2 /usr/local/include/opencv2`
    13. `sudo ln -sf /apps/install/opencv3.3.0/include/opencv /usr/local/include/opencv`
    14. `sudo ldconfig`
    15. `export OpenCV_DIR=/opt/opencv-3.3.0/share/OpenCV`
8. Leptonica 1.72:
    <br>For reference only: <https://github.com/DanBloomberg/leptonica>
    1. `cd /apps/source/openalpr_sources`
    2. `wget -O /apps/source/openalpr_sources/leptonica-1.72.tar.gz "https://github.com/DanBloomberg/leptonica/archive/v1.72.tar.gz"`
    3. `tar xvzf leptonica-1.72.tar.gz`
    4. `sudo mkdir /usr/local/src/openalpr`
    5. `sudo cp -R /apps/source/openalpr_sources/leptonica-1.72 /usr/local/src/openalpr/`
    6. `sudo chown -R mpf:mpf /usr/local/src/openalpr`
    7. `sudo chmod -R 755 /usr/local/src/openalpr`
    8. `cd /usr/local/src/openalpr/leptonica-1.72`
    9. `./configure --prefix=/usr/local`
    10. `make --directory /usr/local/src/openalpr/leptonica-1.72 -j`
    11. `sudo make --directory /usr/local/src/openalpr/leptonica-1.72 install`
    12. `make --directory /usr/local/src/openalpr/leptonica-1.72 distclean`
    13. `sudo ldconfig`
9. Tesseract 3.04.00:
    <br>For reference only: <https://github.com/tesseract-ocr>
    1. `cd /apps/source/openalpr_sources`
    2. `wget -O /apps/source/openalpr_sources/tesseract-3.04.00.tar.gz "https://github.com/tesseract-ocr/tesseract/archive/3.04.00.tar.gz"`
    3. `tar xvzf tesseract-3.04.00.tar.gz`
    4. `wget -O /apps/source/openalpr_sources/tessdata-3.04.00.tar.gz https://github.com/tesseract-ocr/tessdata/archive/3.04.00.tar.gz`
    5. `tar xvzf tessdata-3.04.00.tar.gz`
    6. `sudo mkdir -p /usr/local/src/openalpr/tesseract-ocr`
    7. `sudo cp -a /apps/source/openalpr_sources/tessdata-3.04.00/. /usr/local/src/openalpr/tesseract-ocr/tessdata/`
    8. `sudo cp -a /apps/source/openalpr_sources/tesseract-3.04.00/. /usr/local/src/openalpr/tesseract-ocr/`
    9. `sudo chown -R mpf:mpf /usr/local/src/openalpr`
    10. `sudo chmod -R 755 /usr/local/src/openalpr`
    11. `cd /usr/local/src/openalpr/tesseract-ocr`
    12. `sh autogen.sh`
    13. `./configure`
    14. `make --directory /usr/local/src/openalpr/tesseract-ocr -j`
    15. `sudo make --directory /usr/local/src/openalpr/tesseract-ocr install`
    16. `sudo ldconfig`
10. OpenALPR 2.3.0:
    <br>For reference only: <https://github.com/openalpr/openalpr>
    1. `cd /apps/source/openalpr_sources`
    2. `git clone https://github.com/openalpr/openalpr.git`
    3. `cd openalpr`
    4. `git checkout 469c4fd6d782ac63a55246d1073b0f88edd0d230`
    5. `cp -a /apps/source/openalpr_sources/openalpr /usr/local/src/openalpr/`
    6. `mkdir -p /usr/local/src/openalpr/openalpr/src/build`
    7. `cd /usr/local/src/openalpr/openalpr/src/build`
    8. `cmake3 -j --DCmake3 -j_INSTALL_PREFIX:PATH=/usr -D WITH_DAEMON=OFF ../`
    10. `make --directory /usr/local/src/openalpr/openalpr/src/build -j`
    11. `sudo make --directory /usr/local/src/openalpr/openalpr/src/build install`
    12. `sudo ln -sf /usr/local/src/openalpr/openalpr /usr/share/openalpr`
    13. `sudo cp -a /usr/local/lib/libopenalpr.so /usr/lib/libopenalpr.so`
    14. `sudo cp /usr/local/lib/libopenalpr.so.2 /usr/lib/libopenalpr.so.2`
    15. `sudo sh -c 'echo "export TESSDATA_PREFIX=/usr/local/src/openalpr/openalpr/runtime_data/ocr" >> /etc/profile.d/mpf.sh'`
    16. `sudo ldconfig`
    17. `. /etc/profile.d/mpf.sh`
11. dlib:
    <br>For reference only: <http://dlib.net>
    1. `cd /apps/source`
    2. `wget -O /apps/source/config4cpp.tar.gz "http://www.config4star.org/download/config4cpp.tar.gz"`
    3. `tar xvzf config4cpp.tar.gz`
    4. `cd config4cpp`
    5. `make`
    6. `cd /apps/source/dlib-sources`
    7. `wget -O /apps/source/dlib-sources/dlib-18.18.tar.bz2 "http://dlib.net/files/dlib-18.18.tar.bz2"`
    8. `tar xvjf dlib-18.18.tar.bz2`
    9. `cd dlib-18.18/dlib`
    10. `mkdir build`
    11. `cd build`
    12. `cmake3 ../`
    13. `cmake3 --build . --config Release`
    14. `sudo make install`
12. Ansible:
    <br>For reference only: <https://github.com/ansible/ansible>
    1. `cd /apps/source/ansible_sources`
    2. `git clone https://github.com/ansible/ansible.git --recursive`
    3. `cd ansible`
    4. `git checkout e71cce777685f96223856d5e6cf506a9ea2ef3ff`
    5. `git submodule update --init --recursive`
    6. `cd /apps/source/ansible_sources/ansible/lib/ansible/modules/core`
    7. `git checkout 36f512abc1a75b01ae7207c74cdfbcb54a84be54`
    8. `cd /apps/source/ansible_sources/ansible/lib/ansible/modules/extras`
    9. `git checkout 32338612b38d1ddfd0d42b1245c597010da02970`
    10. `cd /apps/source/ansible_sources/ansible`
    11. `make rpm`
    12. `sudo rpm -Uvh ./rpm-build/ansible-*.noarch.rpm`

## (Optional) Install the NVIDIA CUDA Toolkit

> **NOTE:** Installation of the NVIDIA CUDA Toolkit is optional, and only necessary if you need to run a component on a GPU. All components that support GPU processing also support execution on the CPU, and if this toolkit is not found in the build environment, the build system will automatically build those components for CPU processing only. For a discussion of NVIDIA GPU support in OpenMPF components, see the [GPU Support Guide](GPU-Support-Guide/index.html).

> **NOTE:** To run OpenMPF components that use the NVIDIA GPUs, you must ensure that the deployment machine has the same version of this Toolkit installed, including the NVIDIA GPU drivers. The instructions here are for a build environment only, and thus do not include steps to install the drivers. If you also need to set up the deployment machine, please see the full instructions at <https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html>.

1. `cd /apps/source/cuda`
2. `wget -O cuda_9.0.176_384.81_linux.run "https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run"`
   > <br>  **NOTE:** If this URI fails, you can also download the installer from <https://developer.nvidia.com/cuda-90-download-archive?target_os=Linux&target_arch=x86_64&target_distro=CentOS&target_version=7&target_type=runfilelocal>
3. Run `sudo sh cuda_9.0.176_384.81_linux.run --toolkit --toolkitpath=/apps/install/cuda-9.0 --silent --verbose`
   > <br>  **NOTE:** Using the `--silent` option implies that you accept all of the end-user license agreements (EULAs). If you wish to review the EULAs, and manually accept them, then don't use this flag.
4. After the install finishes, make sure `/usr/local/cuda` is a symbolic link to `/apps/install/cuda-9.0`:
    <br>`ls -l /usr/local/cuda`
5. Add `/usr/local/cuda/bin` to the system PATH variable:
    1. `sudo sh -c 'echo "PATH=\$PATH:/usr/local/cuda/bin" >> /etc/profile.d/mpf.sh'`
    2. `. /etc/profile.d/mpf.sh`
6. Add `/usr/local/cuda/lib64` to the OpenMPF ldconfig file:
    <br>`sudo sh -c 'echo "/usr/local/cuda/lib64" >> /etc/ld.so.conf.d/mpf-x86_64.conf'`



## Configure MySQL

1. `sudo systemctl start mysqld`
2. `mysql -u root --execute "UPDATE mysql.user SET Password=PASSWORD('password') WHERE User='root';flush privileges;"`
3. `mysql -u root -ppassword --execute "create database mpf"`
4. `mysql -u root -ppassword --execute "create user 'mpf'@'%' IDENTIFIED by 'mpf';flush privileges;"`
5. `mysql -u root -ppassword --execute "create user 'mpf'@'$(hostname)' IDENTIFIED by 'mpf';flush privileges;"`
6. `mysql -u root -ppassword --execute "create user 'mpf'@'localhost' IDENTIFIED by 'mpf';flush privileges;"`
7. `mysql -u root -ppassword --execute "grant all privileges on mpf.* to 'mpf';flush privileges;"`
8. `sudo systemctl enable mysqld.service`
9. `sudo chkconfig --level 2345 mysqld on`

## Configure ActiveMQ

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

## Configure Redis

Redis should be set to run in the background (i.e. as a daemon process).

In `/etc/redis.conf` (line 136), change the line:

```
daemonize no
```

so that it reads:

```
daemonize yes
```

## Configure HTTPS

**Generate a self-signed certificate and keystore**

> **NOTE:**  A valid keystore is required to run the OpenMPF with HTTPS support. These instructions will generate a keystore that should be used for local builds only. When deploying OpenMPF, a keystore containing a valid certificate trust chain should be used.

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

If running Tomcat from an IDE, such as IntelliJ, then `-Dtransport.guarantee="CONFIDENTIAL" -Dweb.rest.protocol="https"` should be added at the end of the Tomcat VM arguments for your Tomcat run configuration. It is not necessary to add these arguments when running tomcat from the command line or a systemd command because of configured `CATALINA_OPTS` variable.

## (Optional) Configure HTTP
The OpenMPF can also be run using HTTP instead of HTTPS.

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

## Add Maven Dependencies

Some Maven dependencies needed for the OpenMPF were not publicly available at the time this guide was written. These have been provided with the the OpenMPF source code located here <https://github.com/openmpf/openmpf-build-tools/blob/master/mpf-maven-deps.tar.gz>. These steps assume the archive `mpf-maven-deps.tar.gz` is at `/home/mpf/openmpf-projects/openmpf-build-tools/mpf-maven-deps.tar.gz`.

1. Set up the local Maven repository:
    1. `cd /home/mpf`
    2. `mkdir -p .m2/repository`
2. Extract the archive to the local Maven repository:
<br>`tar xvzf /home/mpf/openmpf-projects/openmpf-build-tools/mpf-maven-deps.tar.gz -C /home/mpf/.m2/repository/`

# Build and Package the OpenMPF

The OpenMPF uses Apache Maven to automate software builds. The `mvn` commands in this guide are assumed to be run at the command line.

## Directory Structure

The OpenMPF packaging script makes use of a directory /mpfdata with the following structure:

```
  mpfdata - the top level directory containing the structure and non-source code artifacts to be packaged for distribution.
  ├── ansible
  │   └── install
  │       └── repo
  │           ├── files - Any other uncategorized files needed by the OpenMPF.
  │           ├── pip - Dependency packages needed for the OpenMPF administration scripts. Installed with Python pip during deployment.
  │           ├── rpms - Contains all of the RPM packages needed for installing and running the OpenMPF. Installed with the yum package manager during deployment.
  │           │   ├── management - RPM  packages needed for the OpenMPF deployment process.
  │           │   ├── mpf - The OpenMPF RPM packages.
  │           │   └── mpf-deps - RPM packages needed by the OpenMPF.
  │           └── tars - Binary packages in tar archives needed by the OpenMPF.
  └── releases - Contains the release package(s) that will be built.
```

Create the build environment structure:

1. `sudo mkdir -p /mpfdata/ansible/install/repo/rpms/management`
2. `sudo mkdir /mpfdata/ansible/install/repo/rpms/mpf`
3. `sudo mkdir /mpfdata/ansible/install/repo/rpms/mpf-deps`
4. `sudo mkdir /mpfdata/ansible/install/repo/files`
5. `sudo mkdir /mpfdata/ansible/install/repo/pip`
6. `sudo mkdir /mpfdata/ansible/install/repo/tars`
7. `sudo mkdir /mpfdata/releases`
8. `sudo chown -R mpf:mpf /mpfdata`

## Download Dependencies for the OpenMPF Package

As with the OpenMPF Build VM, the OpenMPF deployment package is targeted for a minimal install of CentOS 7. Required third-party dependencies are packaged with the OpenMPF installation files. The `CreateCustomPackage.pl` script will only add the dependencies present in the `/mpfdata/ansible/install/repo/` directory.

The following steps place dependency packages in `/mpfdata/ansible/install/repo`. Depending on which dependencies are already installed on your target system(s), some or all of these dependencies may or may not be needed:

1. `yumdownloader --exclude=*.i?86 --archlist=x86_64 adwaita-cursor-theme adwaita-icon-theme at-spi2-atk at-spi2-core cairo-gobject colord-libs createrepo deltarpm ebtables gcc glibc glibc-common glibc-devel glibc-headers gtk3 httpd httpd-tools json-glib kernel-headers lcms2 libffi-devel libgusb libmng libselinux-python libtomcrypt libtommath libXevie libxml2 libxml2-python libXtst libyaml mailcap mpfr openssh openssh-askpass openssh-clients openssh-server pciutils py-bcrypt python python2-crypto python2-cryptography python-babel python-backports python-backports-ssl_match_hostname python-cffi python-chardet python-crypto python-deltarpm python-devel python-ecdsa python-enum34 python-httplib2 python-idna python-ipaddress python-jinja2 python-keyczar python-kitchen python-libs python-markupsafe python-paramiko python-passlib python-pip python-virtualenv python-ply python-ptyprocess python-pyasn1 python-pycparser python-setuptools python-simplejson python-six python-slip python-slip-dbus PyYAML qt qt-settings qt-x11 rest sshpass yum-utils --destdir /mpfdata/ansible/install/repo/rpms/management -C`
2. `yumdownloader --exclude=*.i?86 --archlist=x86_64 apr apr-util apr-util-ldap atk avahi-libs cairo cdparanoia-libs cpp cups-libs fontconfig fontpackages-filesystem gdk-pixbuf2 graphite2 gsm gstreamer gstreamer1 gstreamer1-plugins-base gstreamer-plugins-base gstreamer-tools gtk-update-icon-cache gtk2 gtk3 harfbuzz hicolor-icon-theme iso-codes jasper-libs jbigkit-libs jemalloc libdc1394 libICE libjpeg-turbo libmng libmpc libogg libpng libraw1394 libSM libthai libtheora libtiff libusbx libv4l libvisual libvorbis libvpx libwayland-client libwayland-server libX11 libX11-common libXau libxcb libXcomposite libXcursor libXdamage libXext libXfixes libXft libXi libXinerama libxml2 libXrandr libXrender libxshmfence libXv libXxf86vm log4cxx lyx-fonts mesa-libEGL mesa-libgbm mesa-libGL mesa-libglapi mesa-libGLU mysql-community-client mysql-community-common mysql-community-libs mysql-community-server mysql-connector-python MySQL-python net-tools openjpeg-libs openssh openssh-clients openssh-server opus orc pango perl perl-Carp perl-Compress-Raw-Bzip2 perl-Compress-Raw-Zlib perl-constant perl-Data-Dumper perl-DBD-MySQL perl-DBI perl-Encode perl-Exporter perl-File-Path perl-File-Temp perl-Filter perl-Getopt-Long perl-HTTP-Tiny perl-IO-Compress perl-libs perl-macros perl-Net-Daemon perl-parent perl-PathTools perl-PlRPC perl-Pod-Escapes perl-podlators perl-Pod-Perldoc perl-Pod-Simple perl-Pod-Usage perl-Scalar-List-Utils perl-Socket perl-Storable perl-Text-ParseWords perl-threads perl-threads-shared perl-Time-HiRes perl-Time-Local pixman redis SDL speex unzip xml-common --destdir /mpfdata/ansible/install/repo/rpms/mpf-deps -C`
3. `cp /apps/source/ansible_sources/ansible/rpm-build/ansible-*.noarch.rpm /mpfdata/ansible/install/repo/rpms/management/`
4. Assuming you've followed the steps in the [Install Binary Packages](#install-binary-packages) section to download the JDK:
   <br> `cp /apps/bin/jdk-8u144-linux-x64.rpm /mpfdata/ansible/install/repo/rpms/mpf-deps/jdk-8u144-linux-x64.rpm`
5. Open a web browser and navigate to <http://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html>.
6. In the "Java SE Runtime Environment 8u144" section, click the radio button to "Accept License Agreement".
   > <br> **NOTE:** If that version of the JRE is not available on that page, then look for it on <http://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html>. You will be required to either sign in with an existing account, or create a new account.
7. Click on the "jre-8u144-linux-x64.rpm" link to begin the download.
8. Move the downloaded file to `/mpfdata/ansible/install/repo/rpms/mpf-deps/jre-8u144-linux-x64.rpm`.
9. Assuming you've followed the steps in the [Install Binary Packages](#install-binary-packages) section to download Apache ActiveMQ:
   <br> `cp /apps/bin/apache/apache-activemq-5.13.0-bin.tar.gz /mpfdata/ansible/install/repo/tars/apache-activemq-5.13.0-bin.tar.gz`
10. Assuming you've followed the steps in the [Install Binary Packages](#install-binary-packages) section to download Apache Tomcat:
      <br> `cp /apps/bin/apache/apache-tomcat-7.0.72.tar.gz /mpfdata/ansible/install/repo/tars/apache-tomcat-7.0.72.tar.gz`
11. `cd /mpfdata/ansible/install/repo/pip`
12. `pip download argcomplete argh bcrypt cffi pycparser PyMySQL six`


## Build the OpenMPF Package

> **NOTE:** If your build environment is behind a proxy server, please read the appendix section [Proxy Configuration](#proxy-configuration) for instructions to configure Maven before continuing.

In the instructions below, provide a positive integer value for ``<buildNum>``. If this is your first build, provide a "1". If this is your second build then provide a "2", so on and so forth. The build number will be displayed on the login screen.

Use the following value for `<configFile>`:
<br>`/home/mpf/openmpf-projects/openmpf/trunk/jenkins/scripts/config_files/openmpf-open-source-package.json`

1. Remove the development properties file:
    1. `cd /home/mpf/openmpf-projects/openmpf`
    2. `rm -f trunk/workflow-manager/src/main/resources/properties/mpf-private.properties`

2. (Optional) run maven clean if there has been a previous software build:
    <br> `mvn clean`
3. Run the Perl `PackageRPMS.pl` script. This will compile the code artifacts, place them in the local maven repository, and create the necessary component RPMs and tar files.
    1. `cd /home/mpf/openmpf-projects/openmpf/trunk/jenkins/scripts`
    2. `perl PackageRPMS.pl /home/mpf/openmpf-projects/openmpf master 0 <buildNum> <configFile>`
    > **NOTE:** The following warning is acceptable and can be safely ignored:
    <br>`[WARNING] The requested profile "create-tar" could not be activated because it does not exist.`
4. After the build is complete, the final package is created by running the Perl script `CreateCustomPackage.pl`:
    1. `cd /home/mpf/openmpf-projects/openmpf/trunk/jenkins/scripts`
    2. `perl CreateCustomPackage.pl /home/mpf/openmpf-projects/openmpf master <buildNum> <configFile>`
5. The package `openmpf-*+master-0.tar.gz` will be under `/mpfdata/releases/`.
6. (Optional) Copy the development properties file back if you wish to run the OpenMPF on the OpenMPF Build VM:
<br>`cp /home/mpf/openmpf-projects/openmpf/trunk/workflow-manager/src/main/resources/properties/mpf-private-example.properties /home/mpf/openmpf-projects/openmpf/trunk/workflow-manager/src/main/resources/properties/mpf-private.properties`


# (Optional) Test the OpenMPF

> **NOTE:** If your build environment is behind a proxy server, please read the appendix section [Proxy Configuration](#proxy-configuration) for instructions to configure Firefox before continuing.

Run these commands to build the OpenMPF and run the integration tests:

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
9. `mpf start --xtc` (This command will start ActiveMQ, MySQL, Redis, and node-manager; not Tomcat.)
10. `mvn verify -Dtransport.guarantee="NONE" -Dweb.rest.protocol="http" -Dcomponents.build.package.json=<configFile> -Dstartup.auto.registration.skip=false -Dcomponents.build.dir=/home/mpf/openmpf-projects/openmpf/mpf-component-build`
11. `mpf stop --xtc` (This command will stop node-manager, Redis, MySQL, and ActiveMQ; not Tomcat.)

> **NOTE:** Please see the appendix section [Known Issues](#known-issues) regarding any `java.lang.InterruptedException: null` warning log messages observed when running the tests.

Run this command to clean up and remove all traces of the test run:

1. `mpf clean --delete-uploaded-media --delete-logs`
2. Type "Y" and press Enter.

If you choose not to clean up before following the steps below to build and run the web application, the Job Status table will be pre-populated with some entries; however, the input media, markup, and JSON output objects for those jobs will not be available.

# (Optional) Build and Run the Web Application

> **NOTE:** If your build environment is behind a proxy server, please read the appendix section [Proxy Configuration](#proxy-configuration) for instructions to configure Firefox before continuing.

Run these commands to build the OpenMPF and launch the web application:

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
6. `mvn clean install -DskipTests -Dmaven.test.skip=true -DskipITs -Dmaven.tomcat.skip=true  -Dcomponents.build.package.json=<configFile> -Dstartup.auto.registration.skip=false -Dcomponents.build.dir=/home/mpf/openmpf-projects/openmpf/mpf-component-build`
7. `cd /home/mpf/openmpf-projects/openmpf/trunk/workflow-manager`
8. `rm -rf /opt/apache-tomcat/webapps/workflow-manager*`
9. `cp target/workflow-manager.war /opt/apache-tomcat/webapps/workflow-manager.war`
10. `cd ../..`
11. `sudo cp trunk/install/libexec/node-manager /etc/init.d/`
12. `sudo systemctl daemon-reload`
13. `mpf start`

The web application should start running in the background as a daemon. Look for this log message in the Tomcat log (`/opt/apache-tomcat/logs/catalina.out`) with a time value indicating the workflow-manager has finished starting:

```
INFO: Server startup in 39030 ms
```

After startup, the workflow-manager will be available at <http://localhost:8443/workflow-manager> (or <http://localhost:8080/workflow-manager> if configured to use HTTP instead of HTTPS). Connect to this URL with FireFox. Chrome is also supported, but is not pre-installed on the VM.

If you want to test regular user capabilities, log in as 'mpf'. Please see the [OpenMPF User Guide](User-Guide/index.html) for more information. Alternatively, if you want to test admin capabilities then log in as 'admin'. Please see the [OpenMPF Admin Guide](Admin-Guide/index.html) for more information. When finished testing using the browser (or other external clients), go back to the terminal window used to launch Tomcat and enter the stop command `mpf stop`.

> **NOTE:** Through the use of port forwarding, the workflow-manager can also be accessed from your guest operating system. Please see the Virtual Box documentation <https://www.virtualbox.org/manual/ch06.html#natforward> for configuring port forwarding.

The preferred method to start and stop services for OpenMPF is with the `mpf start` and `mpf stop` commands. For additional information on these commands, please see the [Command Line Tools](Admin-Guide/index.html#command-line-tools) section of the [OpenMPF Admin Guide](Admin-Guide/index.html). These will start and stop ActiveMQ, MySQL, Redis, node-manager, and Tomcat, respectively. Alternatively, to perform these actions manually, the following commands can be used in a terminal window:

**Starting**

```
/opt/activemq/bin/activemq start
sudo systemctl start mysqld
sudo redis-server /etc/redis.conf
sudo systemctl start node-manager
/opt/apache-tomcat/bin/catalina.sh run
```

**Stopping**

```
/opt/apache-tomcat/bin/catalina.sh run
# Wait 60 seconds for tomcat to stop.
sudo systemctl stop node-manager
redis-cli flushall
redis-cli shutdown
sudo systemctl stop mysqld
/opt/activemq/bin/activemq stop
```

> **NOTE:** For debugging purposes, it may be helpful to manually start the Tomcat service in a separate terminal window. This will display the log output directly to the terminal. Wait at least one minute for Tomcat to exit and the node manager to perform some cleanup tasks. If the node manager is stopped too early after quitting Tomcat, some of the processes it was responsible for launching may continue to run.

## Default Credentials
- **Regular User**
    - **username:** mpf
    - **password:** mpf123
- **Administrator**
    - **username:** admin
    - **password:** mpfadm

# Deploy the OpenMPF

Please see the [OpenMPF Installation Guide](Installation-Guide/index.html).

---

# **Appendices**

# Known Issues

The following are known issues that are related to setting up and running the OpenMPF on a build VM. For a more complete list of known issues, please see the OpenMPF Release Notes.

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

**Time Differences Between OpenMPF Nodes**

When installing OpenMPF on multiple nodes, an NTP service should be set up on each of the systems in the cluster so that their times are synchronized. Otherwise, the log viewer may behave incorrectly when it updates in real time.

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
   <br> `git config --global http.proxy $http_proxy`

**Firefox Proxy Configuration**

Before running the integration tests and the web application, it may be necessary to configure Firefox with your environment's proxy settings.

1. In a new terminal window, type `firefox` and press enter. This will launch a new Firefox window.
2. In the new Firefox window, enter `about:preferences#advanced` in the URL text box and press enter.
3. In the left sidebar click 'Advanced', then click the `Network` tab, and in the `Connection` section press the 'Settings...' button.
4. Enter the proxy settings for your environment.
5. In the 'No Proxy for:' text box, verify that `localhost` is included.
6. Press the 'OK' button.
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

If your build environment is behind a proxy server that performs SSL inspection, some applications and tools will need to be configured to accommodate it. The following steps will add trusted certificates to the OpenMPF VM.

Additional information on Java keytool can be found at <https://docs.oracle.com/javase/8/docs/technotes/tools/unix/keytool.html>.

1. Download any certificates needed for using SSL in your build environment to `/home/mpf/Downloads`.
2. Verify that `$JAVA_HOME` is set correctly.
    <br> Running this command: `echo $JAVA_HOME` should produce this output: `/usr/java/latest`
3. For each certificate, run this command, filling in the values for certificate alias, certificate name, and keystore passphrase:
    <br> `sudo $JAVA_HOME/bin/keytool -import -alias <certificate alias> -file /home/mpf/Downloads/<certificate name>.crt -keystore "$JAVA_HOME/jre/lib/security/cacerts" -storepass <keystore passphrase> -noprompt`
4. For each certificate, run this command, filling in the value for certificate name:
    <br> `sudo cp /home/mpf/Downloads/<certificate name>.crt /tmp`
5. For each certificate, run this command, filling in the values for certificate name:
    <br> `sudo -u root -H sh -c "openssl x509 -in /tmp/<certificate name>.crt    -text > /etc/pki/ca-trust/source/anchors/<certificate name>.pem"`
6. Run these commands once:
    1. `sudo -u root -H sh -c "update-ca-trust enable"`
    2. `sudo -u root -H sh -c "update-ca-trust extract"`
7. Run these commands once, filling in the value for the root certificate name:
    1. `sudo cp /etc/pki/tls/certs/ca-bundle.crt /etc/pki/tls/certs/ca-bundle.crt.original`
    2. `sudo -u root -H sh -c "cat /etc/pki/ca-trust/source/anchors/<root certificate name>.pem >> /etc/pki/tls/certs/ca-bundle.crt"`

Alternatively, if adding certificates is not an option or difficulties are encountered, you may optionally skip SSL certificate verification for these tools. This is not recommended:

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

# Build and Test Environment

When developing for the OpenMPF, you may find the following tools helpful:

- **Jenkins**: <https://jenkins.io>
- **Phabricator**: <https://www.phacility.com/phabricator>
- **IntelliJ**: <https://www.jetbrains.com/idea/>
- **CLion**: <https://www.jetbrains.com/clion>
