> **NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2016 The MITRE Corporation. All Rights Reserved.

# General Information

The Open Media Processing Framework (OpenMPF) software is distributed as a raw source code package. The reason for this methodology is to allow for publishing under the Apache license to support broad utilization and use-cases. Several of the underlying dependencies can be compiled in ways that introduce copyleft licenses or patent restrictions. Thus, this approach allows the OpenMPF to be built for a variety of use cases and in the general sense, utilized readily for non-commercial in-house use.

> **IMPORTANT:** It is the responsibility of the end users who follow this guide, and otherwise build the OpenMPF software to create an executable, to abide by all of the non-commercial and re-distribution restrictions imposed by the dependencies that the OpenMPF software uses. Building the OpenMPF and linking in these dependencies at build time or run time results in creating a derivative work under the terms of the GNU General Public License. Refer to the About page within the OpenMPF for more information about these dependencies.

This guide provides comprehensive instructions for setting up a build environment and generating an OpenMPF deployment package that contains the executable form of the software. This package is self-contained so that it can be installed on a minimal CentOS 7 system without Internet connectivity.

# Set Up the Minimal CentOS 7 VM

The following instructions are for setting up a VM for building an OpenMPF deployment package. This VM is not necessarily a machine on which the OpenMPF will be deployed and run. Those machines may have other requirements. For more information refer to the (TODO: insert working link) [Installation Guide](insert-link-here).

- This guide assumes a starting point of CentOS 7 with a minimal installation.
- At the time of writing this, the available minimal .iso file is CentOS-7-x86_64-Minimal-1511.iso. It should be downloaded from <https://www.centos.org/download/> prior to starting these steps.
- Oracle Virtual Box 5.0.20-106931 is used as the virtualization platform. Another platform such as VMware or a physical system can be used but are not explicitly tested.

>**NOTE:** You may need to utilize different parameters to suit your operating environment, these parameters utilized for OpenMPF test and build environments.

1. Create a new VM with these settings:
    - **Name**: ’OpenMPF Build’. (This guide assumes the name ‘OpenMPF Build’, but any name can be used.)
    - **Type**: Linux
    - **Version**: Red Hat (64-bit)

2. The recommended minimum virtual system specifications tested are:
    - **Memory**: 8192MB 
    - **CPU**: 4
    - **Disk**: 40GB on a SSD.

3. Network settings may vary based on your local environment. Connectivity to the public Internet is assumed. The network settings used in this guide are:
    - **Attached to**: NAT
    - **Advanced -> Adapter Type**: Intel PRO/1000 MT Desktop (82540EM)
    - **Cable Connected**: Checked

# Installing CentOS 7

> **NOTE:** If your build environment is behind a proxy server, please read the appendix section **[Proxy Configuration](https://github.com/openmpf/openmpf/wiki/Build-Environment-Setup-Guide#proxy-configuration)** for instructions to configure the yum package manager before continuing.

1. Open the ‘Settings’ for the OpenMPF Build VM.
- Select the ‘Storage’ menu item.
- In the ‘Storage Tree’ section under the ‘Controller: IDE’ item, select the optical disc icon.
- Under the ‘Attributes’ section, select the optical disc icon with a small black arrow. This will bring up a menu.
- Select ‘Choose Virtual Optical Disc file…’
- Choose the ‘CentOS-7-x86_64-Minimal-1511.iso’ file.
- Press the ‘OK’ button to exit the OpenMPF Build VM settings.
- Right click on the OpenMPF Build VM and select ‘Start’ and ‘Normal Start’. A new window will open with the running VM.
- On the ‘CentOS 7’ screen, select ‘Install CentOS 7’ with the keyboard and press the Enter key.
- Select the appropriate language and press the ‘Continue’ button.
- On the ‘Installation Summary’ screen, select the ‘Installation Destination’ icon.
- Press the ‘Done’ button to accept the defaults.
- On the ‘Installation Summary’ screen, select the ‘Network & Host Name’ icon. There should be one interface listed.
- Set the slider switch to ‘On’.
- Press the ‘Configure’ button, select the ‘General’ tab, and check the box for ‘Automatically connect to this network when available’.
- Press the 'Save' button.
- Each interface should show its status as ‘Connected’ with an IPv4 address.
- Leave the hostname as ‘localhost.localdomain’.
- Press the ‘Done’ button.
- Use the default values for everything else and press 'Begin Installation'.
- Set a password for the root account.
- Under ‘User Creation’, create a new user:
    - **Full Name**: mpf
    - **User Name**: mpf
        - Check the box for ‘Make this user administrator’
    - **Password**: mpf
- When installation is finished, press the ‘Finish Configuration’ button.
- When configuration is finished, press the ‘Reboot’ button.
- At the login prompt, login as user ‘mpf’ and password ‘mpf’.
- Install the epel repository and Delta RPM:
    - `sudo yum install –y epel-release deltarpm`
- Perform an initial system update:
    - `sudo yum update –y`
- Install Gnome Desktop Environment and some packages needed for the Virtual Box Guest Additions:
    - `sudo yum groups install –y "GNOME Desktop"`
- Install packages needed for the Virtual Box Guest Additions:
    - `sudo yum install gcc kernel-devel bzip2`
   > **NOTE:** You may have to specify a kernel version when installing ‘kernel-devel‘ as a Virtual Box guest addition. For example:
   > - `sudo yum install kernel-devel-3.10.0-327.el7.x86_64`.
- Reboot the system:
    - `sudo reboot now`
- At the login prompt, login as user ‘mpf’ and password ‘mpf’.
- Switch user to root with this command:
    - `sudo su –`
- On your host system in the Virtual Box Application, select the OpenMPF Build VM menu item ‘Devices’ and then ‘Insert Guest Additions CD image…’
- Install the Virtual Box Guest Additions:
    - `mount /dev/cdrom /mnt`
    - `cd /mnt`
    - `./VBoxLinuxAdditions.run`
    - `systemctl set-default graphical.target`
    - `reboot now`
- After the reboot, a license acceptance screen will come up. Select the 'License Information' icon.
- Read the license. If you accept it, select the 'I accept the license agreement.' check box.
- Press the 'Done' button.
- Press the 'Finish Configuration' button.
- At the graphical login screen, select the 'mpf' user.
- Enter 'mpf' as the password.
- A welcome screen will come up on the first launch of the Gnome desktop environment. Press the 'Next' button on the 'Language' page.
- Press the 'Next' button on the 'Typing' page.
- Press the 'Skip' button on the 'Online Accounts' page.
- Press the 'Start using CentOS Linux' button.
- Close the 'Getting Started' window that appears.
- On the desktop, right click the 'VBOXADDITIONS_5.0.22_108108' icon and select 'Eject'.
- On your host system in the Virtual Box Application, select the OpenMPF Build VM menu item ‘Devices’, then ‘Shared Clipboard’, then "Bidirectional". This will enable the ability to copy and paste commands from this document into the VM.
- On your host system in the Virtual Box Application, select the OpenMPF Build VM menu item ‘Devices’, then ‘Drag and Drop’, then "Bidirectional". This will enable the ability to drag files from the host system to the guest VM.

# Set Up the OpenMPF Build Environment

> **NOTE:** If your build environment is behind a proxy server, please read the appendix section **[Proxy Configuration](https://github.com/openmpf/openmpf/wiki/Build-Environment-Setup-Guide#proxy-configuration)**  for instructions to configure the yum package manager before continuing.

At the time of writing, all URLs provided in this section were verified as working.

## Configure Additional Repositories

Open a terminal window and perform the following steps:

- Copy the OpenMPF source archive (provided separately) to the path `/home/mpf` on the VM. This can be accomplished in several ways, including the use of a shared folder, SCP, or drag and drop from the host system. For more information on configuring a shared folder in a Virtual Box VM, please see the developer's documentation (<https://www.virtualbox.org/manual/ch04.html#sharedfolders>).
- Extract the OpenMPF source archive. This will create a /home/mpf/mpf directory which contains the source code:
    - `tar xvzf mpf-*-source.tar.gz -C /home/mpf/`
- Copy the mpf user profile script from the extracted source code:
    - `sudo cp /home/mpf/mpf/trunk/mpf-install/src/main/scripts/mpf-profile.sh /etc/profile.d/mpf.sh`
- Install the Oracle MySQL Community Release Repository:
    - `wget -P /home/mpf/Downloads "http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm"`
    - `sudo rpm -ivh /home/mpf/Downloads/mysql-community-release-el7-5.noarch.rpm`
- Install the Remi Repo for Redis:
    - `wget -P /home/mpf/Downloads "http://rpms.remirepo.net/RPM-GPG-KEY-remi"`
    - `wget -P /home/mpf/Downloads "http://rpms.famillecollet.com/enterprise/remi-release-7.rpm"`
    - `sudo rpm --import /home/mpf/Downloads/RPM-GPG-KEY-remi`
    - `sudo rpm -Uvh /home/mpf/Downloads/remi-release-7.rpm`
    - `sudo yum-config-manager --enable remi`
- Create an ‘/apps’ directory and package subdirectories:
    - `sudo mkdir -p /apps/source/cmake_sources`
    - `sudo mkdir -p /apps/install/lib`
    - `sudo mkdir -p /apps/bin/apache`
    - `sudo mkdir /apps/ansible`
    - `sudo mkdir /apps/source/apache_sources`
    - `sudo mkdir /apps/source/google_sources`
    - `sudo mkdir /apps/source/opencv_sources`
    - `sudo mkdir /apps/source/ffmpeg_sources`
    - `sudo mkdir /apps/source/dlib_sources`
    - `sudo mkdir /apps/source/openalpr_sources`
    - `sudo mkdir /apps/source/ansible_sources`
    - `sudo chown -R mpf:mpf /apps`
    - `sudo chmod -R 755 /apps`
- Add /apps/install/bin to the system PATH variable:
    - `sudo sh -c 'echo "PATH=\$PATH:/apps/install/bin" >> /etc/profile.d/mpf.sh'`
    - `. /etc/profile.d/mpf.sh`
- Create the OpenMPF ldconfig file:
    - `sudo touch /etc/ld.so.conf.d/mpf-x86_64.conf`
- Add /apps/install/lib to the OpenMPF ldconfig file:
    - `sudo sh -c 'echo "/apps/install/lib" >> /etc/ld.so.conf.d/mpf-x86_64.conf'`
- Update the shared library cache:
    - `sudo ldconfig`

## RPM Dependencies

The following RPM packages will need to be downloaded and installed. Use of the yum package manager is recommended:

`sudo yum install -y asciidoc autoconf automake boost boost-devel cmake-gui freetype-devel gcc-c++ git graphviz gstreamer-plugins-base-devel gtk2-devel gtkglext-devel gtkglext-libs jasper jasper-devel libavc1394-devel libdc1394-devel libffi-devel libICE-devel libjpeg-devel libjpeg-turbo-devel libpng-devel libSM-devel libtiff-devel libtool libv4l-devel libXinerama-devel libXmu-devel libXt-devel log4cxx log4cxx-devel make mercurial mesa-libGL-devel mesa-libGLU-devel mysql mysql-community-server nasm ncurses-devel numpy pangox-compat pangox-compat-devel perl-CPAN-Meta-YAML perl-DBD-MySQL perl-DBI perl-Digest-MD5 perl-File-Find-Rule perl-File-Find-Rule-Perl perl-JSON perl-JSON-PP perl-List-Compare perl-Number-Compare perl-Params-Util perl-Parse-CPAN-Meta php pkgconfig python-devel python-httplib2 python-jinja2 python-keyczar python-paramiko python-pip python-setuptools python-six PyYAML qt qt-devel qt-x11 redis rpm-build sshpass tbb tbb-devel tree unzip uuid-devel wget yasm yum-utils zlib-devel`

## Binary Packages

> **NOTE:** If your environment is behind a proxy server that performs SSL inspection, please read the appendix section **[SSL Inspection](https://github.com/openmpf/openmpf/wiki/Build-Environment-Setup-Guide#ssl-inspection)** before continuing.

The following binary packages will need to be downloaded and installed:

1. Oracle JDK:
    - For reference only: <http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html>
    - `cd /home/mpf`
    - `wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.rpm" -O /apps/bin/jdk-8u60-linux-x64.rpm`
    - `sudo yum -y localinstall --nogpgcheck /apps/bin/jdk-8u60-linux-x64.rpm`
    - `sudo alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_60/jre/bin/java 20000`
    - `sudo alternatives --install /usr/bin/jar jar /usr/java/jdk1.8.0_60/bin/jar 20000`
    - `sudo alternatives --install /usr/bin/javac javac /usr/java/jdk1.8.0_60/bin/javac 20000`
    - `sudo alternatives --install /usr/bin/javaws javaws /usr/java/jdk1.8.0_60/jre/bin/javaws 20000`
    - `sudo alternatives --set java /usr/java/jdk1.8.0_60/jre/bin/java`
    - `sudo alternatives --set javaws /usr/java/jdk1.8.0_60/jre/bin/javaws`
    - `sudo alternatives --set javac /usr/java/jdk1.8.0_60/bin/javac`
    - `sudo alternatives --set jar /usr/java/jdk1.8.0_60/bin/jar`
   > **NOTE:** If this command to set the `jar` alternative fails with the following error:
   >
   > *failed to read link /usr/bin/jar: No such file or directory*
   >
   > You should run the following commands again:
   > - `sudo alternatives --install /usr/bin/jar jar /usr/java/jdk1.8.0_60/bin/jar 20000`
   > - `sudo alternatives --set jar /usr/java/jdk1.8.0_60/bin/jar`
    - `. /etc/profile.d/mpf.sh`
- Apache ActiveMQ 5.13.0:
    - For reference only: <http://activemq.apache.org>
    - `cd /apps/bin/apache`
    - `wget -O /apps/bin/apache/apache-activemq-5.13.0-bin.tar.gz "https://archive.apache.org/dist/activemq/5.13.0/apache-activemq-5.13.0-bin.tar.gz"`
    - `sudo tar xvzf apache-activemq-5.13.0-bin.tar.gz -C /opt/`
    - `sudo chown -R mpf:mpf /opt/apache-activemq-5.13.0`
    - `sudo chmod -R 755 /opt/apache-activemq-5.13.0`
    - `sudo ln -s /opt/apache-activemq-5.13.0 /opt/activemq`
- Apache Tomcat 7.0.72:
    - For reference only: <http://tomcat.apache.org>
    - `cd /apps/bin/apache `
    - `wget -O /apps/bin/apache/apache-tomcat-7.0.72.tar.gz "http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.72/bin/apache-tomcat-7.0.72.tar.gz"`
    - `tar xzvf apache-tomcat-7.0.72.tar.gz`
    - `sudo mkdir -p /usr/share/apache-tomcat`
    - `sudo cp -Rf /apps/bin/apache/apache-tomcat-7.0.72/* /usr/share/apache-tomcat/`
    - `sudo chown -R mpf:mpf /usr/share/apache-tomcat`
    - `sudo chmod -R 755 /usr/share/apache-tomcat`
    - `sudo ln -s /usr/share/apache-tomcat /opt/apache-tomcat`
    - `sudo perl -i -p0e 's/<!--\n    <Manager pathname="" \/>\n      -->.*?/<!-- -->\n    <Manager pathname="" \/>/s' /opt/apache-tomcat/conf/context.xml`
    - `sudo perl -i -p0e 's/<\/Context>/    <Resources cachingAllowed="true" cacheMaxSize="100000" \/>\n<\/Context>/s' /opt/apache-tomcat/conf/context.xml`
    - `sudo rm -rf /opt/apache-tomcat/webapps/*`
- Apache Ant 1.9.6:
    - For reference only: <http://ant.apache.org>
    - `cd /apps/bin/apache `
    - `wget -O /apps/bin/apache/apache-ant-1.9.6-bin.tar.gz "https://archive.apache.org/dist/ant/binaries/apache-ant-1.9.6-bin.tar.gz"`
    - `tar xzvf apache-ant-1.9.6-bin.tar.gz`
    - `sudo cp -R /apps/bin/apache/apache-ant-1.9.6 /apps/install/`
    - `sudo chown -R mpf:mpf /apps/install/apache-ant-1.9.6`
    - `sudo sed -i '/^PATH/s/$/:\/apps\/install\/apache-ant-1.9.6\/bin/' /etc/profile.d/mpf.sh`
    - `. /etc/profile.d/mpf.sh`
- Apache Maven 3.3.3:
    - For reference only: <https://maven.apache.org>
    - `cd /apps/bin/apache`
    - `wget -O /apps/bin/apache/apache-maven-3.3.3-bin.tar.gz "https://archive.apache.org/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz"`
    - `tar xzvf apache-maven-3.3.3-bin.tar.gz`
    - `sudo mkdir /opt/apache-maven`
    - `sudo cp -Rf /apps/bin/apache/apache-maven-3.3.3/* /opt/apache-maven/`
    - `sudo chown -R mpf:mpf /opt/apache-maven`
    - `sudo sed -i '/^PATH/s/$/:\/opt\/apache-maven\/bin/' /etc/profile.d/mpf.sh`
    - `sudo sh -c 'echo "M2_HOME=/opt/apache-maven" >> /etc/profile.d/mpf.sh'`
    - `. /etc/profile.d/mpf.sh`

## Python Packages
1. C Foreign Function Interface (CFFI):
    - `cd /home/mpf`
    - `sudo -E easy_install -U cffi`
- OpenMPF Administrative Tools:
    - `sudo -E pip install /home/mpf/mpf/trunk/bin/mpf-scripts`

## Building Dependencies

> **NOTE:** If your build environment is behind a proxy server, please read the appendix section **[Proxy Configuration](https://github.com/openmpf/openmpf/wiki/Build-Environment-Setup-Guide#proxy-configuration)**  for instructions to configure git before continuing.

The following source packages will need to be downloaded, built, and installed:

1. Cmake 2.8.12.2:
    - For reference only: <https://cmake.org>
    - `cd /apps/source/cmake_sources`
    - `wget -O /apps/source/cmake_sources/cmake-2.8.12.2.tar.gz "https://cmake.org/files/v2.8/cmake-2.8.12.2.tar.gz"`
    - `tar xvzf cmake-2.8.12.2.tar.gz`
    - `cd cmake-2.8.12.2`
    - `chmod +x *`
    - `./configure --prefix=/apps/install`
    - `make -j8`
    - `sudo make install`
    - `sudo ldconfig`
    - `sudo ln -s /apps/install/bin/cmake /usr/local/bin/cmake`
- FFmpeg 2.6.3:
  > **NOTE:** FFmpeg can be built with different encoders and modules that are individually licensed. It is recommended to check each developer’s documentation for the most up-to-date licensing information.
    - yasm:
        - For reference only: <http://yasm.tortall.net>
        - `cd /apps/source/ffmpeg_sources`
        - `git clone --depth 1 http://github.com/yasm/yasm.git`
        - `cd yasm`
        - `autoreconf -fiv`
        - `./configure --prefix="/apps/install" --bindir="/apps/install/bin"`
        - `make`
        - `sudo make install`
        - `make distclean`
        - `sudo ldconfig`
    - xvidcore:
        - For reference only: <https://labs.xvid.com>
        - `cd /apps/source/ffmpeg_sources`
        - `wget -O /apps/source/ffmpeg_sources/xvidcore-1.3.2.tar.gz "http://downloads.xvid.org/downloads/xvidcore-1.3.2.tar.gz"`
        - `tar zxvf xvidcore-1.3.2.tar.gz`
        - `cd xvidcore/build/generic`
        - `./configure --prefix="/apps/install"`
        - `make`
        - `sudo make install`
        - `make distclean`
        - `sudo ldconfig`
    - libx264:
        - For reference only: <http://www.videolan.org/developers/x264.html>
        - `cd /apps/source/ffmpeg_sources`
        - `wget -O /apps/source/ffmpeg_sources/x264-snapshot-20140223-2245-stable.tar.bz2 "ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20140223-2245-stable.tar.bz2"`
        - `tar xvjf x264-snapshot-20140223-2245-stable.tar.bz2`
        - `cd x264-snapshot-20140223-2245-stable`
        - `PKG_CONFIG_PATH="/apps/install/lib/pkgconfig" ./configure --prefix="/apps/install" --bindir="/apps/install" --enable-shared`
        - `sudo sed -i '/^PATH/s/$/:\/apps\/install\/lib\/pkgconfig/' /etc/profile.d/mpf.sh`
        - `sudo sh -c 'echo "export PKG_CONFIG_PATH=/apps/install/lib/pkgconfig" >> /etc/profile.d/mpf.sh'`
        - `. /etc/profile.d/mpf.sh`
        - `make`
        - `sudo make install`
        - `make distclean`
        - `sudo ldconfig`
    - opencore-amr:
        - For reference only: <https://sourceforge.net/projects/opencore-amr>
        - `cd /apps/source/ffmpeg_sources`
        - `wget -O /apps/source/ffmpeg_sources/opencore-amr-0.1.3.tar.gz "http://downloads.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.3.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fopencore-amr%2Ffiles%2Fopencore-amr%2F&ts=1467223123&use_mirror=tenet"`
        - `tar xvzf opencore-amr-0.1.3.tar.gz`
        - `cd opencore-amr-0.1.3`
        - `autoreconf -fiv`
        - `./configure --prefix="/apps/install" --enable-shared`
        - `make`
        - `sudo make install`
        - `make distclean`
        - `sudo ldconfig`
    - libmp3lame:
        - For reference only: <http://lame.sourceforge.net>
        - `cd /apps/source/ffmpeg_sources`
        - `wget -O /apps/source/ffmpeg_sources/lame-3.99.5.tar.gz "http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz"`
        - `tar xzvf lame-3.99.5.tar.gz`
        - `cd lame-3.99.5`
        - `./configure --prefix="/apps/install" --bindir="/apps/install/bin" --enable-shared --enable-nasm`
        - `make`
        - `sudo make install`
        - `make distclean`
        - `sudo ldconfig`
    - libogg:
        - For reference only: <https://www.xiph.org/ogg>
        - `cd /apps/source/ffmpeg_sources`
        - `wget -O /apps/source/ffmpeg_sources/libogg-1.3.2.tar.gz "http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz"`
        - `tar xvzf libogg-1.3.2.tar.gz`
        - `cd libogg-1.3.2`
        - `./configure --prefix="/apps/install" --enable-shared`
        - `make`
        - `sudo make install`
        - `make distclean`
        - `sudo ldconfig`
    - libvorbis:
        - For reference only: <https://xiph.org/vorbis>
        - `cd /apps/source/ffmpeg_sources`
        - `wget -O /apps/source/ffmpeg_sources/libvorbis-1.3.4.tar.gz "http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz"`
        - `tar xzvf libvorbis-1.3.4.tar.gz`
        - `cd libvorbis-1.3.4`
        - `LDFLAGS="-L/apps/install/lib" CPPFLAGS="-I/apps/install/include" ./configure --prefix="/apps/install" --with-ogg="/apps/install" --enable-shared`
        - `make`
        - `sudo make install`
        - `make distclean`
        - `sudo ldconfig`
    - libtheora:
        - For reference only: <https://www.theora.org>
        - `cd /apps/source/ffmpeg_sources`
        - `wget -O /apps/source/ffmpeg_sources/libtheora-1.1.1.tar.bz2 "http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2"`
        - `tar -xvjf libtheora-1.1.1.tar.bz2`
        - `cd libtheora-1.1.1`
        - `./configure --prefix="/apps/install" --enable-shared`
        - `make`
        - `sudo make install`
        - `make distclean`
        - `sudo ldconfig`
    - FFmpeg:
        - For reference only: <https://ffmpeg.org>
        - `cd /apps/source/ffmpeg_sources`
        - `git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg`
        - `cd ffmpeg`
        - `git checkout af5917698bd44f136fd0ff00a9e5f8b5f92f2d58`
        - `PKG_CONFIG_PATH="/apps/install/lib/pkgconfig" ./configure --prefix="/apps/install" --extra-cflags="-I/apps/install/include" --extra-ldflags="-L/apps/install/lib" --bindir="/apps/install/bin" --enable-gpl --enable-nonfree --enable-libtheora --enable-libfreetype --enable-libmp3lame --enable-libvorbis --enable-libx264 --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-version3 --enable-shared --disable-libsoxr`
        - `make`
        - `sudo make install`
        - `make distclean`
        - `sudo ldconfig`
- Google protocol buffers 2.5.0:
    - For reference only: <https://developers.google.com/protocol-buffers>
    - `cd /apps/source/google_sources`
    - `wget -O /apps/source/google_sources/protobuf-2.5.0.tar.gz "https://github.com/google/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz"`
    - `tar xvzf protobuf-2.5.0.tar.gz`
    - `cd protobuf-2.5.0`
    - `./configure --prefix=/apps/install`
    - `make -j8`
    - `sudo make install`
    - `make distclean`
    - `sudo ldconfig`
    - `sudo sh -c 'echo "export CXXFLAGS=-isystem\ /apps/install/include" >> /etc/profile.d/mpf.sh'`
    - `sudo ln -s /apps/install/bin/protoc /usr/local/bin/protoc`
    - `sudo ln -s /usr/lib64/libuuid.so.1.3.0 /usr/lib64/libuuid.so`
- Apr 1.5.2:
    - For reference only: <https://apr.apache.org>
    - `cd /apps/source/apache_sources`
    - `wget -O /apps/source/apache_sources/apr-1.5.2.tar.gz "http://archive.apache.org/dist/apr/apr-1.5.2.tar.gz"`
    - `tar -zxvf apr-1.5.2.tar.gz`
    - `cd /apps/source/apache_sources/apr-1.5.2`
    - `./configure --prefix=/apps/install`
    - `make -j8`
    - `sudo make install`
    - `make distclean`
    - `sudo ldconfig`
- Apr-util 1.5.4:
    - For reference only: <https://apr.apache.org>
    - `cd /apps/source/apache_sources`
    - `wget -O /apps/source/apache_sources/apr-util-1.5.4.tar.gz "http://archive.apache.org/dist/apr/apr-util-1.5.4.tar.gz"`
    - `tar -xzvf apr-util-1.5.4.tar.gz`
    - `cd /apps/source/apache_sources/apr-util-1.5.4`
    - `./configure --with-apr=/apps/install --prefix=/apps/install`
    - `make -j8`
    - `sudo make install`
    - `make distclean`
    - `sudo ldconfig`
- Activemqcpp 3.9.0:
    - For reference only: <http://activemq.apache.org/cms>
    - `cd /apps/source/apache_sources`
    - `wget -O /apps/source/apache_sources/activemq-cpp-library-3.9.0-src.tar.gz "https://archive.apache.org/dist/activemq/activemq-cpp/3.9.0/activemq-cpp-library-3.9.0-src.tar.gz"`
    - `tar zxvf activemq-cpp-library-3.9.0-src.tar.gz`
    - `cd /apps/source/apache_sources/activemq-cpp-library-3.9.0`
    - `./autogen.sh`
    - `./configure --disable-ssl --prefix=/apps/install`
    - `make -j8`
    - `sudo make install`
    - `make distclean`
    - `sudo ldconfig`
    - `sudo ln -s /apps/install/lib/libactivemq-cpp.so.19.0.0 /usr/lib/libactivemq-cpp.so`
- openCV 2.4.9:
    - For reference only: <http://opencv.org>
    - `sudo ln -s /usr/include/gdk-pixbuf-2.0/gdk-pixbuf /usr/include/gtk-2.0/gdk-pixbuf`
    - `cd /apps/source/opencv_sources`
    - `wget -O /apps/source/opencv_sources/opencv-2.4.9.zip "http://downloads.sourceforge.net/project/opencvlibrary/opencv-unix/2.4.9/opencv-2.4.9.zip?r=http%3A%2F%2Fopencv.org%2Fdownloads.html&ts=1467141570&use_mirror=heanet"`
    - `unzip -o opencv-2.4.9.zip`
    - `cd opencv-2.4.9`
    - `mkdir release`
    - `cd release`
    - `cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/apps/install/opencv2.4.9 ..`
    - `make -j8`
    - `sudo make install`
    - `sudo sh -c 'echo "/apps/install/opencv2.4.9/lib" >> /etc/ld.so.conf.d/mpf-x86_64.conf'`
    - `sudo ldconfig`
    - `sudo ln -s /apps/install/opencv2.4.9/include/opencv2 /usr/include/`
    - `sudo ln -s /apps/install/opencv2.4.9/include/opencv /usr/include/`
    - `sudo sh -c 'echo "export OpenCV_DIR=/apps/install/opencv2.4.9/share/OpenCV/" >> /etc/profile.d/mpf.sh'`
    - `. /etc/profile.d/mpf.sh`
- Leptonica 1.70:
    - For reference only: <https://github.com/DanBloomberg/leptonica>
    - `cd /apps/source/openalpr_sources`
    - `wget -O /apps/source/openalpr_sources/leptonica-1.70.tar.gz "https://github.com/DanBloomberg/leptonica/archive/v1.70.tar.gz"`
    - `sudo mkdir /usr/local/src/openalpr`
    - `sudo tar zxvf leptonica-1.70.tar.gz -C /usr/local/src/openalpr/`
    - `sudo chown -R mpf:mpf /usr/local/src/openalpr`
    - `sudo chmod -R 755 /usr/local/src/openalpr`
    - `cd /usr/local/src/openalpr/leptonica-1.70`
    - `./configure prefix=/usr/local`
    - `make -j8`
    - `sudo make install`
    - `make distclean`
    - `sudo ldconfig`
- Tesseract 3.02.02:
    - For reference only: <https://github.com/tesseract-ocr>
    - `cd /apps/source/openalpr_sources`
    - `wget -O /apps/source/openalpr_sources/3.02.02.tar.gz "https://github.com/tesseract-ocr/tesseract/archive/3.02.02.tar.gz"`
    - `wget -O /apps/source/openalpr_sources/tesseract-ocr-3.02.eng.tar.gz "http://downloads.sourceforge.net/project/tesseract-ocr-alt/tesseract-ocr-3.02.eng.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Ftesseract-ocr-alt%2Ffiles%2F&ts=1468000683&use_mirror=superb-sea2"`
    - `tar zxvf tesseract-ocr-3.02.eng.tar.gz -C /usr/local/src/openalpr/`
    - `tar zxvf 3.02.02.tar.gz -C /usr/local/src/openalpr/`
    - `cd /usr/local/src/openalpr`
    - `cp -r tesseract-3.02.02/* tesseract-ocr/`
    - `cd tesseract-ocr`
    - `./autogen.sh`
    - `./configure`
    - `make -j8`
    - `sudo make install`
    - `sudo ldconfig`
- OpenALPR 1.1.0:
    - For reference only: <https://github.com/openalpr/openalpr>
    - `cd /usr/local/src/openalpr`
    - `git clone https://github.com/openalpr/openalpr.git`
    - `cd /usr/local/src/openalpr/openalpr`
    - `git checkout 765a41685d88901d8a394f211ba72614e491cbfd`
    - `mkdir /usr/local/src/openalpr/openalpr/src/build`
    - `cd /usr/local/src/openalpr/openalpr/src/build`
    - `cmake -j8 --DCmake -j8_INSTALL_PREFIX:PATH=/usr ../`
    - `make -j8`
    - `sudo make install`
    - `sudo ldconfig`
    - `sudo ln -s /usr/local/src/openalpr/openalpr /usr/share/openalpr`
    - `sudo cp -a /usr/local/lib/libopenalpr.so /usr/lib/libopenalpr.so`
    - `sudo cp /usr/local/lib/libopenalpr.so.1 /usr/lib/libopenalpr.so.1`
    - `sudo sh -c 'echo "export TESSDATA_PREFIX=/usr/local/src/openalpr/openalpr/runtime_data/ocr" >> /etc/profile.d/mpf.sh'`
    - `sudo ldconfig`
    - `. /etc/profile.d/mpf.sh`
- openCV 3.1.0:
    - For reference only: <http://opencv.org>
    - `cd /apps/source/opencv_sources`
    - `wget -O /apps/source/opencv_sources/opencv-3.1.0.zip "https://github.com/Itseez/opencv/archive/3.1.0.zip"`
    - `unzip -o opencv-3.1.0.zip`
    - `wget -O /apps/source/opencv_sources/opencv_contrib-3.1.0.tar.gz "https://github.com/Itseez/opencv_contrib/archive/3.1.0.tar.gz"`
    - `tar xvzf opencv_contrib-3.1.0.tar.gz`
    - `cd opencv-3.1.0`
    - `mkdir release`
    - `cd release`
    - `cmake -D CMAKE_BUILD_TYPE=Release -D -DWITH_GSTREAMER:BOOL="0" -DWITH_OPENMP:BOOL="1" -DBUILD_opencv_apps:BOOL="0" -DWITH_OPENCLAMDBLAS:BOOL="0" -DWITH_CUDA:BOOL="0" -DCLAMDFFT_ROOT_DIR:PATH="CLAMDFFT_ROOT_DIR-NOTFOUND" -DBUILD_opencv_aruco:BOOL="0" -DCMAKE_INSTALL_PREFIX:PATH="/apps/install/opencv3.1.0" -DWITH_WEBP:BOOL="0" -DBZIP2_LIBRARIES:FILEPATH="BZIP2_LIBRARIES-NOTFOUND" -DWITH_GIGEAPI:BOOL="0" -DOPENCV_EXTRA_MODULES_PATH:PATH="/apps/source/opencv_sources/opencv_contrib-3.1.0/modules" -DWITH_JPEG:BOOL="1" -DWITH_CUFFT:BOOL="0" -DWITH_IPP:BOOL="0" -DWITH_V4L:BOOL="1" -DWITH_GDAL:BOOL="0" -DWITH_OPENCLAMDFFT:BOOL="0" -DWITH_GPHOTO2:BOOL="0" -DWITH_VTK:BOOL="0" -DWITH_GTK_2_X:BOOL="0" -DBUILD_opencv_world:BOOL="0" -DWITH_TIFF:BOOL="1" -DWITH_1394:BOOL="0" -DWITH_EIGEN:BOOL="0" -DWITH_LIBV4L:BOOL="0" -DBUILD_opencv_ts:BOOL="0" -DWITH_MATLAB:BOOL="0" -DWITH_OPENCL:BOOL="0" -DWITH_PVAPI:BOOL="0" ..`
    - `make -j8`
    - `sudo make install`
    - `sudo sh -c 'echo "/apps/install/opencv3.1.0/lib" >> /etc/ld.so.conf.d/mpf-x86_64.conf'`
    - `sudo ldconfig`
    - `gedit /home/mpf/mpf/mpf_components/CPP/detection/caffeComponent/CMakeLists.txt`
    - Under the `# Find and install OpenCV 3.1` section, locate the line `PATHS /opt/opencv3.1.0)`. Change the value of `PATHS` so this line looks like: `PATHS /apps/install/opencv3.1.0)`
    - Save and close the file.
- dlib:
    - For reference only: <http://dlib.net>
    - `cd /apps/source`
    - `wget -O /apps/source/config4cpp.tar.gz "http://www.config4star.org/download/config4cpp.tar.gz"`
    - `tar xvzf config4cpp.tar.gz`
    - `cd config4cpp`
    - `make`
    - `cd /apps/source/dlib_sources`
    - `wget -O /apps/source/dlib_sources/dlib-18.18.tar.bz2 "http://dlib.net/files/dlib-18.18.tar.bz2"`
    - `tar xvjf dlib-18.18.tar.bz2`
    - `cd dlib-18.18/dlib`
    - `mkdir build`
    - `cd build`
    - `cmake ../`
    - `cmake --build . --config Release`
    - Make sure libdlib.so and libdlib.so.18.18.0 are present in /apps/source/dlib_sources/dlib-18.18/dlib/build
    - `sudo make install`
- Ansible:
    - For reference only: <https://github.com/ansible/ansible>
    - `cd /apps/source/ansible_sources`
    - `git clone https://github.com/ansible/ansible.git --recursive`
    - `cd ansible`
    - `git checkout e71cce777685f96223856d5e6cf506a9ea2ef3ff`
    - `cd /apps/source/ansible_sources/ansible/lib/ansible/modules/core`
    - `git checkout 36f512abc1a75b01ae7207c74cdfbcb54a84be54`
    - `cd /apps/source/ansible_sources/ansible/lib/ansible/modules/extras`
    - `git checkout 32338612b38d1ddfd0d42b1245c597010da02970`
    - `cd /apps/source/ansible_sources/ansible`
    - `make rpm`
    - `sudo rpm -Uvh ./rpm-build/ansible-*.noarch.rpm`

## Configuring MySQL

- `sudo systemctl start mysqld`
- `mysql -u root --execute "UPDATE mysql.user SET Password=PASSWORD('password') WHERE User='root';flush privileges;"`
- `mysql -u root -ppassword --execute "create database mpf"`
- `mysql -u root -ppassword --execute "create user 'mpf'@'%' IDENTIFIED by 'mpf';flush privileges;"`
- `mysql -u root -ppassword --execute "create user 'mpf'@'$(hostname)' IDENTIFIED by 'mpf';flush privileges;"`
- `mysql -u root -ppassword --execute "create user 'mpf'@'localhost' IDENTIFIED by 'mpf';flush privileges;"`
- `mysql -u root -ppassword --execute "grant all privileges on mpf.* to 'mpf';flush privileges;"`
- `sudo systemctl enable mysqld.service`
- `sudo chkconfig --level 2345 mysqld on`

## Configuring ActiveMQ

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

In `/opt/activemq/conf/activemq.xml` (line 71), change the line:

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

## Configuring Redis

Redis should be set to run in the background (i.e. as a daemon process).

In `/etc/redis.conf` (line 128), change the line:

```
daemonize no
```

so that it reads:

```
daemonize yes
```

## HTTPS Configuration

**Generate a self-signed certificate and keystore**

> **NOTE:**  A valid keystore is required to run the OpenMPF with HTTPS support. These instructions will generate a keystore that should be used for local builds only. When deploying the OpenMPF, a keystore containing a valid certificate trust chain should be used.

- Open a new terminal window.
-  `sudo systemctl stop tomcat7`
- `cd /home/mpf`
- `$JAVA_HOME/bin/keytool -genkey -alias tomcat -keyalg RSA`
- At the prompt, enter a keystore password of: `mpf123`
- Re-enter the keystore password of: `mpf123`
- At the `What is your first and last name?` prompt, press the Enter key for a blank value.
- At the `What is the name of your organizational unit?` , press the Enter key for a blank value.
- At the `What is the name of your organization?` prompt, press the Enter key for a blank value.
- At the `What is the name of your City or Locality?` prompt, press the Enter key for a blank value.
- At the `What is the name of your State or Province?` prompt, press the Enter key for a blank value.
- At the `What is the two-letter country code for this unit?` prompt, press the Enter key for a blank value.
- At the `Is CN=Unknown, OU=Unknown, O=Unknown, L=Unknown, ST=Unknown, C=Unknown correct?` prompt, type `yes` and press the Enter key to accept the values.
- At the `Enter key password for <tomcat>` prompt, press the Enter key for a blank value.
- Verify the file `/home/mpf/.keystore` was created at the current time.

**Tomcat Configuration**

- Open the file `/opt/apache-tomcat/conf/server.xml` in a text editor.
- Below the commented out section on lines 87 through 90, add the following lines:

```
  <Connector SSLEnabled="true" acceptCount="100" clientAuth="false"
	disableUploadTimeout="true" enableLookups="false" maxThreads="25"
	port="8443" keystoreFile="/home/mpf/.keystore" keystorePass="mpf123"
	protocol="org.apache.coyote.http11.Http11NioProtocol" scheme="https"
	secure="true" sslProtocol="TLS" />
```

- Save and close the file.
- Create the file `/opt/apache-tomcat/bin/setenv.sh` and open it in a text editor.
- Add the following line:

```
  export CATALINA_OPTS="-server -Xms256m -XX:PermSize=512m -XX:MaxPermSize=512m -Djgroups.tcp.port=7800 -Djava.library.path=$LD_LIBRARY_PATH -Djgroups.tcpping.initial_hosts='$ALL_MPF_NODES' -Dtransport.guarantee='CONFIDENTIAL' -Dweb.rest.protocol='https'"
```

- Save and close the file.

**Using an IDE**

If running Tomcat from an IDE, such as IntelliJ, then `-Dtransport.guarantee="CONFIDENTIAL" -Dweb.rest.protocol="https"` should be added at the end of the Tomcat VM arguments for your Tomcat run configuration. It is not necessary to add these arguments when running tomcat from the command line or a systemd command because of configured `CATALINA_OPTS` variable.

## (Optional) HTTP Configuration
The OpenMPF can also be run using HTTP instead of HTTPS.
- Open the file `/opt/apache-tomcat/conf/server.xml` in a text editor.
- Below the commented out section on lines 87 through 90, remove the following lines if they exist:

```
  <Connector SSLEnabled="true" acceptCount="100" clientAuth="false"
	disableUploadTimeout="true" enableLookups="false" maxThreads="25"
	port="8443" keystoreFile="/home/mpf/.keystore" keystorePass="mpf123"
	protocol="org.apache.coyote.http11.Http11NioProtocol" scheme="https"
	secure="true" sslProtocol="TLS" />
```

- Save and close the file.
- Create the file `/opt/apache-tomcat/bin/setenv.sh` and open it in a text editor.
- Add the following line:

```
  export CATALINA_OPTS="-server -Xms256m -XX:PermSize=512m -XX:MaxPermSize=512m -Djgroups.tcp.port=7800 -Djava.library.path=$LD_LIBRARY_PATH -Djgroups.tcpping.initial_hosts='$ALL_MPF_NODES' -Dtransport.guarantee='NONE' -Dweb.rest.protocol='http'"
```

- Save and close the file.

## Adding Additional Maven Dependencies

Some Maven dependencies needed for the OpenMPF were not publicly available at the time this guide was written. These have been provided in addition to the OpenMPF source code archive. These steps assume the archive `mpf-maven-deps.tar.gz` is at `/home/mpf/mpf-maven-deps.tar.gz`.

1. Set up the local Maven repository:
    - `cd /home/mpf`
    - `mkdir -p .m2/repository`
2. Extract the archive to the local Maven repository:
    - `tar xvzf mpf-maven-deps.tar.gz -C /home/mpf/.m2/repository/`

# Building and Packaging the OpenMPF

> **IMPORTANT:** The `CreateCustomPackage.pl` script used in this section assumes dependency packages needed for deployment are present in their correct location under `/mpfdata/ansible/install/repo/`. For a list of dependencies required for a standard OpenMPF package, please see the appendix section **[Third-party RPMs, tars, and Python Pip packages included with an OpenMPF Package](https://github.com/openmpf/openmpf/wiki/Build-Environment-Setup-Guide#third-party-rpms-tars-and-python-pip-packages-included-with-an-openmpf-package)**.

The OpenMPF uses Apache Maven to automate software builds. The `mvn` commands in this guide are assumed to be run at the command line.

## Build Environment

The OpenMPF packaging script makes use of a directory /mpfdata with the following structure:

```
  mpfdata - the top level directory containing the structure and non-source code artifacts to be packaged for distribution.
  ├── ansible
  │   └── install
  │       └── repo
  │           ├── extComponents - External component archives included with the OpenMPF.
  │           ├── files - Any other uncategorized files needed by the OpenMPF.
  │           ├── pip - Dependency packages needed for the OpenMPF administration scripts. Installed with Python pip during deployment.
  │           ├── rpms - Contains all of the RPM packages needed for installing and running the OpenMPF. Installed with the yum package manager during deployment.
  │           │   ├── management - RPM  packages needed for the OpenMPF deployment process.
  │           │   ├── mpf - The OpenMPF RPM packages.
  │           │   └── mpf-deps - RPM packages needed by the OpenMPF.
  │           └── tars - Binary packages in tar archives needed by the OpenMPF.
  └── releases - Contains the release package(s) that will be built.
```

Create the build environment structure:

- `sudo mkdir -p /mpfdata/ansible/install/repo/rpms/management`
- `sudo mkdir /mpfdata/ansible/install/repo/rpms/mpf`
- `sudo mkdir /mpfdata/ansible/install/repo/rpms/mpf-deps`
- `sudo mkdir /mpfdata/ansible/install/repo/extComponents`
- `sudo mkdir /mpfdata/ansible/install/repo/files`
- `sudo mkdir /mpfdata/ansible/install/repo/pip`
- `sudo mkdir /mpfdata/ansible/install/repo/tars`
- `sudo mkdir /mpfdata/releases`
- `sudo chown -R mpf:mpf /mpfdata`

## Build the Open Source OpenMPF Package

Follow the instructions in the **Build the OpenMPF Package** section below. Use the following values:

#### `<cppComponents>`

`mogMotionComponent,ocvFaceComponent,dlibComponent,caffeComponent,oalprTextComponent,ocvPersonComponent`

#### `<configFile>`

`./config_files/mpf-open-source-package.json`

## Build the OpenMPF Package

> **NOTE:** If your build environment is behind a proxy server, please read the appendix section **[Proxy Configuration](https://github.com/openmpf/openmpf/wiki/Build-Environment-Setup-Guide#proxy-configuration)**  for instructions to configure Maven before continuing.

1. Remove the development properties file:
    - `cd /home/mpf/mpf`
    - `rm -f trunk/workflow-manager/src/main/resources/properties/mpf-private.properties`
2. Run the Maven clean package command with the `create-tar` profile and the `rpm:rpm` goal. This will compile the code artifacts, place them in the local maven repository, and create the necessary component RPMs and tar files.
    - `cd /home/mpf/mpf`
    - `mvn package -Pcreate-tar rpm:rpm -Dmaven.test.skip=true -DskipITs -Dmaven.tomcat.skip=true -DgitBranch=master -DcppComponents=<cppComponents>`

 Note that the order of components in the `-DcppComponents` list is important. Components will be registered in that order. For example, since the OCV face detection component descriptor file depends on MOG motion preprocessor actions, the MOG motion detection component should appear before the OCV face detection component in the list.
3. After the build is complete, the final package is created by running the Perl script `CreateCustomPackage.pl`:
    - `cd /home/mpf/mpf/trunk/jenkins/scripts`
    - `perl CreateCustomPackage.pl /home/mpf/mpf master 0 <configFile>`
4. The package `mpf-complete-0.8.0+master-0.tar.gz` will be under `/mpfdata/releases/`.
5. (Optional) Copy the development properties file back if you wish to run the OpenMPF on the OpenMPF Build VM:
    - `cp /home/mpf/mpf/trunk/workflow-manager/src/main/resources/properties/mpf-private-example.properties /home/mpf/mpf/trunk/workflow-manager/src/main/resources/properties/mpf-private.properties`

# (Optional) Testing the OpenMPF

> **NOTE:** If your build environment is behind a proxy server, please read the appendix section **[Proxy Configuration](https://github.com/openmpf/openmpf/wiki/Build-Environment-Setup-Guide#proxy-configuration)**  for instructions to configure Firefox before continuing.

Run these commands to build the OpenMPF and run the integration tests:

- `cd /home/mpf/mpf`
- Copy the development properties file into place:

  `cp trunk/workflow-manager/src/main/resources/properties/mpf-private-example.properties trunk/workflow-manager/src/main/resources/properties/mpf-private.properties`

- Open the file `/etc/ansible/hosts` in a text editor. `sudo` is required to edit this file.
- If they do not already exist, add these two lines above `# Ex 1: Ungrouped hosts, specify before any group headers.` (line 11):

```
  [mpf-child]
  localhost.localdomain
```

- Save and close the file.
- `mvn clean install -DskipTests -Dmaven.test.skip=true -DskipITs -Dmaven.tomcat.skip=true -DcppComponents=<cppComponents>`
- `sudo cp /home/mpf/mpf/trunk/install/libexec/node-manager /etc/init.d/`
- `sudo systemctl daemon-reload`
- `mpf start --xtc` (This command will start ActiveMQ, MySQL, Redis, and node-manager; not Tomcat.)
- `mvn verify -DcppComponents=<cppComponents> -Dtransport.guarantee='NONE' -Dweb.rest.protocol='http'`
- `mpf stop --xtc` (This command will stop node-manager, Redis, MySQL, and ActiveMQ; not Tomcat.)

> **NOTE:** Please see the appendix section **Known Issues** regarding any `java.lang.InterruptedException: null` warning log messages observed when running the tests.

# (Optional) Building and running the web application

> **NOTE:** If your build environment is behind a proxy server, please read the appendix section **[Proxy Configuration](https://github.com/openmpf/openmpf/wiki/Build-Environment-Setup-Guide#proxy-configuration)**  for instructions to configure Firefox before continuing.

Run these commands to build the OpenMPF and launch the web application:

- `cd /home/mpf/mpf`
- Copy the development properties file into place:
    - `cp trunk/workflow-manager/src/main/resources/properties/mpf-private-example.properties trunk/workflow-manager/src/main/resources/properties/mpf-private.properties`
- Open the file `/etc/ansible/hosts` in a text editor. `sudo` is required to edit this file.
- If they do not already exist, add these two lines above `# Ex 1: Ungrouped hosts, specify before any group headers.` (line 11):

```
  [mpf-child]
  localhost.localdomain
```

- Save and close the file.
- `mvn clean install -DskipTests -Dmaven.test.skip=true -DskipITs -Dmaven.tomcat.skip=true -DcppComponents=<cppComponents>`
- `cd /home/mpf/mpf/trunk/workflow-manager`
- `rm -rf /opt/apache-tomcat/webapps/workflow-manager*`
- `cp target/workflow-manager.war /opt/apache-tomcat/webapps/workflow-manager.war`
- `cd ../..`
- `sudo cp trunk/install/libexec/node-manager /etc/init.d/`
- `sudo systemctl daemon-reload`
- `mpf start`

The web application should start running in the background as a daemon. Look for this log message in the Tomcat log (`/opt/apache-tomcat/logs/catalina.out`) with a time value indicating the workflow-manager has finished starting:

```
INFO: Server startup in 39030 ms
```

After startup, the workflow-manager will be available at <http://localhost:8080/workflow-manager>. Connect to this URL with FireFox. Chrome is also supported, but is not pre-installed on the VM.

If you want to test regular user capabilities, log in as 'mpf'. Please see the (TODO: insert working link) [User Guide](insert-link-here) for more information. Alternatively, if you want to test admin capabilities then log in as 'admin'. Please see the (TODO: insert working link) [Admin Manual](insert-link-here) for more information. When finished testing using the browser (or other external clients), go back to the terminal window used to launch Tomcat and enter the stop command `mpf stop`.

> **NOTE:** Through the use of port forwarding, the workflow-manager can also be accessed from your guest operating system. Please see the Virtual Box documentation <https://www.virtualbox.org/manual/ch06.html#natforward> for configuring port forwarding.

The preferred method to start and stop services for OpenMPF is with the `mpf start` and `mpf stop` commands. For additional information on these commands, please see the (TODO: insert working link) [Command Line Tools](insert-link-here) section of the (TODO: insert working link) [Admin Manual](insert-link-here). These will start and stop ActiveMQ, MySQL, Redis, node-manager, and Tomcat, respectively. Alternatively, to perform these actions manually, the following commands can be used in a terminal window:

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

# Deploying the OpenMPF

Please see the (TODO: insert working link) [Installation Guide](insert-link-here).

---

# **Appendices**

# Known Issues

The following are known issues that are related to setting up and running the OpenMPF on a build VM. For a more complete list of known issues, please see the (TODO: insert working link) [Release Notes](insert-link-here).

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

When installing the OpenMPF on multiple nodes, an NTP service should be set up on each of the systems in the cluster so that their times are synchronized. Otherwise, the log viewer may behave incorrectly when it updates in real time.

# Proxy Configuration

**Yum Package Manager Proxy Configuration**

Before using the yum package manager,  it may be necessary to configure it to work with your environment's proxy settings. If credentials are not required, it is not necessary to add them to the yum configuration.

- `sudo bash -c 'echo "proxy=<address>:<port>" >> /etc/yum.conf'`
- `sudo bash -c 'echo "proxy_username=<username>" >> /etc/yum.conf'`
- `sudo bash -c 'echo "proxy_password=<password>" >> /etc/yum.conf'`

**Proxy Environment Variables**

If your build environment is behind a proxy server, some applications and tools will need to be configured to use it. To configure an HTTP and HTTPS proxy, run the following commands. If credentials are not required, leave those fields blank.

- `sudo bash -c 'echo "export http_proxy=<username>:<password>@<url>:<port>" >> /etc/profile.d/mpf.sh`
- `. /etc/profile.d/mpf.sh`
- `sudo bash -c 'echo "export https_proxy='${http_proxy}'" >> /etc/profile.d/mpf.sh'`
- `sudo bash -c 'echo "export HTTP_PROXY='${http_proxy}'" >> /etc/profile.d/mpf.sh'`
- `sudo bash -c 'echo "export HTTPS_PROXY='${http_proxy}'" >> /etc/profile.d/mpf.sh'`
- `. /etc/profile.d/mpf.sh`

**Git Proxy Configuration**

If your build environment is behind a proxy server, git will need to be configured to use it. The following command will set the git global proxy. If the environment variable `$http_proxy` is not set, use the full proxy server address, port, and credentials (if needed).

- `git config --global http.proxy $http_proxy`

**Firefox Proxy Configuration**

Before running the integration tests and the web application, it may be necessary to configure Firefox with your environment's proxy settings.

- In a new terminal window, type `firefox` and press enter. This will launch a new Firefox window.
- In the new Firefox window, enter `about:preferences#advanced` in the URL text box and press enter.
- In the left sidebar click 'Advanced', then click the `Network` tab, and in the `Connection` section press the 'Settings...' button.
- Enter the proxy settings for your environment.
- In the 'No Proxy for:' text box, verify that `localhost` is included.
- Press the 'OK' button.
- Close all open Firefox instances.

**Maven Proxy Configuration**

Before using Maven, it may be necessary to configure it to work with your environment's proxy settings. Open a new terminal window and run these commands. Afterwards, continue with adding the additional maven dependencies.

- `cd /home/mpf`
- `mkdir -p .m2`
- `cp /opt/apache-maven/conf/settings.xml .m2/`
- Open the file `.m2/settings.xml` in a text editor.
- Navigate to the `<proxies>` section (line 85).
- There is a commented-out example proxy server specification. Copy and paste the example specification below the commented-out section, but before the end of the closing `</proxies>` tag.
- Fill in your environment's proxy server information. For additional help and information, please see the Apache Maven guide to configuring a proxy server at <https://maven.apache.org/guides/mini/guide-proxies.html>.

# SSL Inspection

If your build environment is behind a proxy server that performs SSL inspection, some applications and tools will need to be configured to accommodate it. The following steps will add trusted certificates to the OpenMPF VM.

Additional information on Java keytool can be found at <https://docs.oracle.com/javase/8/docs/technotes/tools/unix/keytool.html>.

- Download any certificates needed for using SSL in your build environment to `/home/mpf/Downloads`.
- Verify that `$JAVA_HOME` is set correctly.
    - Running this command: `echo $JAVA_HOME` should produce this output: `/usr/java/latest`
- For each certificate, run this command, filling in the values for certificate alias, certificate name, and keystore passphrase:
    - `sudo $JAVA_HOME/bin/keytool -import -alias <certificate alias> -file /home/mpf/Downloads/<certificate name>.crt -keystore "$JAVA_HOME/jre/lib/security/cacerts" -storepass <keystore passphrase> -noprompt`
- For each certificate, run this command, filling in the value for certificate name:
    - `sudo cp /home/mpf/Downloads/<certificate name>.crt /tmp`
- For each certificate, run this command, filling in the values for certificate name:
    - `sudo -u root -H sh -c "openssl x509 -in /tmp/<certificate name>.crt    -text > /etc/pki/ca-trust/source/anchors/<certificate name>.pem"`
- Run these commands once:
    - `sudo -u root -H sh -c "update-ca-trust enable"`
    - `sudo -u root -H sh -c "update-ca-trust extract"`
- Run these commands once, filling in the value for the root certificate name:
    - `sudo cp /etc/pki/tls/certs/ca-bundle.crt /etc/pki/tls/certs/ca-bundle.crt.original`
    - `sudo -u root -H sh -c "cat /etc/pki/ca-trust/source/anchors/<root certificate name>.pem >> /etc/pki/tls/certs/ca-bundle.crt"`

Alternatively, if adding certificates is not an option or difficulties are encountered, you may optionally skip SSL certificate verification for these tools. This is not recommended:

**wget**

- `cd /home/mpf`
- `touch /home/mpf/.wgetrc`
- In a text editor, open the file `/home/mpf/.wgetrc`
- Add this line:

```
  check_certificate=off
```

- Save and close the file.
- `. /home/mpf/.wgetrc`

**git**

- `cd /home/mpf`
- `git config http.sslVerify false`
- `git config --global http.sslVerify false`

**maven**

- In a text editor, open the file `/etc/profile.d/mpf.sh`
- At the bottom of the file, add this line:

```
  export MAVEN_OPTS="-Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true"
```

- Save and close the file.
- `. /etc/profile.d/mpf.sh`

# Third-party RPMs, Tars, and Python Pip packages included with an OpenMPF Package

As with the OpenMPF Build VM, the OpenMPF deployment package is targeted for a minimal install of CentOS 7. The **[Package Lists](https://github.com/openmpf/openmpf/wiki/Build-Environment-Setup-Guide#package-lists)** section below lists required third-party dependencies that are packaged with the OpenMPF installation files by the `CreateCustomPackage.pl` script. Depending on which dependencies are already installed on your target system(s), some or all of these dependencies may not be needed. The script will only add the dependencies present in the `/mpfdata/ansible/install/repo/` directory to the package.

The following commands can be used to populate the dependency packages into the `/mpfdata/ansible/install/repo` directory:

- `cd /mpfdata/ansible/install/repo/rpms/management`
- `sudo yumdownloader adwaita-cursor-theme adwaita-icon-theme at-spi2-atk at-spi2-core cairo-gobject colord-libs createrepo deltarpm ebtables firewalld gcc glibc glibc-common glibc-devel glibc-headers gtk3 httpd httpd-tools json-glib kernel-headers lcms2 libffi-devel libgusb libmng libselinux-python libtomcrypt libtommath libXevie libxml2 libxml2-python libXtst libyaml mailcap mpfr openssh openssh-askpass openssh-clients openssh-server pciutils py-bcrypt python python2-crypto python-babel python-backports python-backports-ssl_match_hostname python-cffi python-chardet python-crypto python-deltarpm python-devel python-ecdsa python-httplib2 python-jinja2 python-keyczar python-kitchen python-libs python-markupsafe python-paramiko python-passlib python-pip python-ply python-ptyprocess python-pyasn1 python-pycparser python-setuptools python-simplejson python-six python-slip python-slip-dbus PyYAML qt qt-settings qt-x11 rest sshpass yum-utils    --archlist=x86_64`
- `sudo rm ./*i686*`
- `cd /mpfdata/ansible/install/repo/rpms/mpf-deps`
- `sudo yumdownloader apr apr-util apr-util-ldap atk cairo cdparanoia-libs cpp cups-libs fontconfig fontpackages-filesystem gdk-pixbuf2 graphite2 gsm gstreamer gstreamer1 gstreamer1-plugins-base gstreamer-plugins-base gstreamer-tools gtk2 gtk3 harfbuzz hicolor-icon-theme iso-codes jasper-libs jbigkit-libs jemalloc libdc1394 libICE libjpeg-turbo libmng libmpc libogg libpng libraw1394 libSM libthai libtheora libtiff libusbx libv4l libvisual libvorbis libvpx libX11 libX11-common libXau libxcb libXcomposite libXcursor libXdamage libXext libXfixes libXft libXi libXinerama libxml2 libXrandr libXrender libxshmfence libXv libXxf86vm log4cxx mesa-libEGL mesa-libgbm mesa-libGL mesa-libglapi mesa-libGLU mysql-community-client mysql-community-common mysql-community-libs mysql-community-server mysql-connector-python MySQL-python net-tools openjpeg-libs openssh openssh-clients openssh-server opus orc pango perl perl-Carp perl-Compress-Raw-Bzip2 perl-Compress-Raw-Zlib perl-constant perl-Data-Dumper perl-DBD-MySQL perl-DBI perl-Encode perl-Exporter perl-File-Path perl-File-Temp perl-Filter perl-Getopt-Long perl-HTTP-Tiny perl-IO-Compress perl-libs perl-macros perl-Net-Daemon perl-parent perl-PathTools perl-PlRPC perl-Pod-Escapes perl-podlators perl-Pod-Perldoc perl-Pod-Simple perl-Pod-Usage perl-Scalar-List-Utils perl-Socket perl-Storable perl-Text-ParseWords perl-threads perl-threads-shared perl-Time-HiRes perl-Time-Local pixman redis SDL speex unzip xml-common --archlist=x86_64`
- `sudo rm ./*i686*`
- `cp /apps/source/ansible_sources/ansible/rpm-build/ansible-*.noarch.rpm /mpfdata/ansible/install/repo/rpms/management/`
- `wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.rpm" -O /mpfdata/ansible/install/repo/rpms/mpf-deps/jdk-8u60-linux-x64.rpm`
- Download jre-8u60-linux-x64.rpm and place it in `/mpfdata/ansible/install/repo/rpms/mpf-deps` : <http://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html#jre-8u60-oth-JPR>
    - **NOTE:** Oracle may require an account to download archived versions of the JRE.
- `wget -O /mpfdata/ansible/install/repo/tars/apache-activemq-5.13.0-bin.tar.gz "https://archive.apache.org/dist/activemq/5.13.0/apache-activemq-5.13.0-bin.tar.gz"`
- `wget -O /mpfdata/ansible/install/repo/tars/apache-tomcat-7.0.72.tar.gz "http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.72/bin/apache-tomcat-7.0.72.tar.gz"`
- `wget -O /mpfdata/ansible/install/repo/tars/ffmpeg-git-64bit-static.tar.xz "http://johnvansickle.com/ffmpeg/builds/ffmpeg-git-64bit-static.tar.xz"`
- `cd /mpfdata/ansible/install/repo/pip`
- `pip install --download . argcomplete argh bcrypt cffi pycparser PyMySQL six`

## Package Lists

- **/mpfdata/ansible/install/repo/rpms/management**
    - adwaita-cursor-theme-3.14.1-1.el7.noarch.rpm
    - adwaita-icon-theme-3.14.1-1.el7.noarch.rpm
    - ansible-2.1.1.0-0.git201608081816.e71cce7.HEAD.el7.centos.noarch.rpm
    - at-spi2-atk-2.8.1-4.el7.x86_64.rpm
    - at-spi2-core-2.8.0-6.el7.x86_64.rpm
    - cairo-gobject-1.14.2-1.el7.x86_64.rpm
    - colord-libs-1.2.7-2.el7.x86_64.rpm
    - createrepo-0.9.9-25.el7_2.noarch.rpm
    - deltarpm-3.6-3.el7.x86_64.rpm
    - ebtables-2.0.10-13.el7.x86_64.rpm
    - firewalld-0.3.9-14.el7.noarch.rpm
    - gcc-4.8.5-4.el7.x86_64.rpm
    - glibc-2.17-106.el7_2.6.i686.rpm
    - glibc-2.17-106.el7_2.6.x86_64.rpm
    - glibc-common-2.17-106.el7_2.6.x86_64.rpm
    - glibc-devel-2.17-106.el7_2.4.x86_64.rpm
    - glibc-devel-2.17-106.el7_2.6.i686.rpm
    - glibc-devel-2.17-106.el7_2.6.x86_64.rpm
    - glibc-headers-2.17-106.el7_2.4.x86_64.rpm
    - glibc-headers-2.17-106.el7_2.6.x86_64.rpm
    - gtk3-3.14.13-16.el7.x86_64.rpm
    - httpd-2.4.6-40.el7.centos.x86_64.rpm
    - httpd-tools-2.4.6-40.el7.centos.x86_64.rpm
    - json-glib-1.0.2-1.el7.x86_64.rpm
    - kernel-headers-3.10.0-327.13.1.el7.x86_64.rpm
    - lcms2-2.6-2.el7.x86_64.rpm
    - libffi-devel-3.0.13-16.el7.x86_64.rpm
    - libgusb-0.1.6-3.el7.x86_64.rpm
    - libmng-1.0.10-14.el7.x86_64.rpm
    - libselinux-python-2.2.2-6.el7.x86_64.rpm
    - libtomcrypt-1.17-23.el7.x86_64.rpm
    - libtommath-0.42.0-4.el7.x86_64.rpm
    - libXevie-1.0.3-7.1.el7.x86_64.rpm
    - libxml2-2.9.1-6.el7_2.3.x86_64.rpm
    - libxml2-python-2.9.1-6.el7_2.3.x86_64.rpm
    - libXtst-1.2.2-2.1.el7.x86_64.rpm
    - libyaml-0.1.4-11.el7_0.x86_64.rpm
    - mailcap-2.1.41-2.el7.noarch.rpm
    - mpfr-3.1.1-4.el7.x86_64.rpm
    - openssh-6.6.1p1-23.el7_2.x86_64.rpm
    - openssh-askpass-6.6.1p1-23.el7_2.x86_64.rpm
    - openssh-clients-6.6.1p1-23.el7_2.x86_64.rpm
    - openssh-server-6.6.1p1-23.el7_2.x86_64.rpm
    - pciutils-3.2.1-4.el7.x86_64.rpm
    - py-bcrypt-0.4-4.el7.x86_64.rpm
    - python-2.7.5-39.el7_2.x86_64.rpm
    - python2-crypto-2.6.1-9.el7.x86_64.rpm
    - python-babel-0.9.6-8.el7.noarch.rpm
    - python-backports-1.0-8.el7.x86_64.rpm
    - python-backports-ssl_match_hostname-3.4.0.2-4.el7.noarch.rpm
    - python-cffi-0.8.6-2.el7.x86_64.rpm
    - python-chardet-2.2.1-1.el7_1.noarch.rpm
    - python-crypto-2.6.1-1.el7.centos.x86_64.rpm
    - python-deltarpm-3.6-3.el7.x86_64.rpm
    - python-devel-2.7.5-34.el7.x86_64.rpm
    - python-ecdsa-0.11-3.el7.centos.noarch.rpm
    - python-httplib2-0.7.7-3.el7.noarch.rpm
    - python-jinja2-2.7.2-2.el7.noarch.rpm
    - python-keyczar-0.71c-2.el7.noarch.rpm
    - python-kitchen-1.1.1-5.el7.noarch.rpm
    - python-libs-2.7.5-39.el7_2.x86_64.rpm
    - python-markupsafe-0.11-10.el7.x86_64.rpm
    - python-paramiko-1.15.1-1.el7.noarch.rpm
    - python-passlib-1.6.2-2.el7.noarch.rpm
    - python-pip-7.1.0-1.el7.noarch.rpm
    - python-ply-3.4-10.el7.noarch.rpm
    - python-ptyprocess-0.5-1.el7.noarch.rpm
    - python-pyasn1-0.1.6-2.el7.noarch.rpm
    - python-pycparser-2.14-1.el7.noarch.rpm
    - python-setuptools-0.9.8-4.el7.noarch.rpm
    - python-simplejson-3.3.3-1.el7.x86_64.rpm
    - python-six-1.9.0-2.el7.noarch.rpm
    - python-slip-0.4.0-2.el7.noarch.rpm
    - python-slip-dbus-0.4.0-2.el7.noarch.rpm
    - PyYAML-3.10-11.el7.x86_64.rpm
    - qt-4.8.5-12.el7_2.i686.rpm
    - qt-4.8.5-12.el7_2.x86_64.rpm
    - qt-settings-19-23.5.el7.centos.noarch.rpm
    - qt-x11-4.8.5-12.el7_2.x86_64.rpm
    - rest-0.7.92-3.el7.x86_64.rpm
    - sshpass-1.05-5.el7.x86_64.rpm
    - yum-utils-1.1.31-34.el7.noarch.rpm

- **/mpfdata/ansible/install/repo/rpms/mpf-deps**
    - apr-1.4.8-3.el7.x86_64.rpm
    - apr-util-1.5.2-6.el7.x86_64.rpm
    - apr-util-ldap-1.5.2-6.el7.x86_64.rpm
    - atk-2.14.0-1.el7.x86_64.rpm
    - cairo-1.14.2-1.el7.x86_64.rpm
    - cdparanoia-libs-10.2-17.el7.x86_64.rpm
    - cpp-4.8.5-4.el7.x86_64.rpm
    - cups-libs-1.6.3-22.el7.x86_64.rpm
    - fontconfig-2.10.95-7.el7.x86_64.rpm
    - fontpackages-filesystem-1.44-8.el7.noarch.rpm
    - gdk-pixbuf2-2.31.6-3.el7.x86_64.rpm
    - graphite2-1.2.2-5.el7.x86_64.rpm
    - gsm-1.0.13-11.el7.x86_64.rpm
    - gstreamer-0.10.36-7.el7.x86_64.rpm
    - gstreamer1-1.4.5-1.el7.x86_64.rpm
    - gstreamer1-plugins-base-1.4.5-2.el7.x86_64.rpm
    - gstreamer-plugins-base-0.10.36-10.el7.x86_64.rpm
    - gstreamer-tools-0.10.36-7.el7.x86_64.rpm
    - gtk2-2.24.28-8.el7.x86_64.rpm
    - gtk3-3.14.13-16.el7.x86_64.rpm
    - harfbuzz-0.9.36-1.el7.x86_64.rpm
    - hicolor-icon-theme-0.12-7.el7.noarch.rpm
    - iso-codes-3.46-2.el7.noarch.rpm
    - jasper-libs-1.900.1-29.el7.x86_64.rpm
    - jbigkit-libs-2.0-11.el7.x86_64.rpm
    - jdk-8u60-linux-x64.rpm
    - jemalloc-3.6.0-1.el7.x86_64.rpm
    - jre-8u60-linux-x64.rpm
    - libdc1394-2.2.2-3.el7.x86_64.rpm
    - libICE-1.0.9-2.el7.x86_64.rpm
    - libjpeg-turbo-1.2.90-5.el7.x86_64.rpm
    - libmng-1.0.10-14.el7.x86_64.rpm
    - libmpc-1.0.1-3.el7.x86_64.rpm
    - libogg-1.3.0-7.el7.x86_64.rpm
    - libpng-1.5.13-7.el7_2.x86_64.rpm
    - libraw1394-2.1.0-2.el7.x86_64.rpm
    - libSM-1.2.2-2.el7.x86_64.rpm
    - libthai-0.1.14-9.el7.x86_64.rpm
    - libtheora-1.1.1-8.el7.x86_64.rpm
    - libtiff-4.0.3-14.el7.x86_64.rpm
    - libusbx-1.0.15-4.el7.x86_64.rpm
    - libv4l-0.9.5-4.el7.x86_64.rpm
    - libvisual-0.4.0-16.el7.x86_64.rpm
    - libvorbis-1.3.3-8.el7.x86_64.rpm
    - libvpx-1.3.0-5.el7_0.x86_64.rpm
    - libX11-1.6.3-2.el7.x86_64.rpm
    - libX11-common-1.6.3-2.el7.noarch.rpm
    - libXau-1.0.8-2.1.el7.x86_64.rpm
    - libxcb-1.11-4.el7.x86_64.rpm
    - libXcomposite-0.4.4-4.1.el7.x86_64.rpm
    - libXcursor-1.1.14-2.1.el7.x86_64.rpm
    - libXdamage-1.1.4-4.1.el7.x86_64.rpm
    - libXext-1.3.3-3.el7.x86_64.rpm
    - libXfixes-5.0.1-2.1.el7.x86_64.rpm
    - libXft-2.3.2-2.el7.x86_64.rpm
    - libXi-1.7.4-2.el7.x86_64.rpm
    - libXinerama-1.1.3-2.1.el7.x86_64.rpm
    - libxml2-2.9.1-6.el7_2.2.x86_64.rpm
    - libXrandr-1.4.2-2.el7.x86_64.rpm
    - libXrender-0.9.8-2.1.el7.x86_64.rpm
    - libxshmfence-1.2-1.el7.x86_64.rpm
    - libXv-1.0.10-2.el7.x86_64.rpm
    - libXxf86vm-1.1.3-2.1.el7.x86_64.rpm
    - log4cxx-0.10.0-16.el7.x86_64.rpm
    - mesa-libEGL-10.6.5-3.20150824.el7.x86_64.rpm
    - mesa-libgbm-10.6.5-3.20150824.el7.x86_64.rpm
    - mesa-libGL-10.6.5-3.20150824.el7.x86_64.rpm
    - mesa-libglapi-10.6.5-3.20150824.el7.x86_64.rpm
    - mesa-libGLU-9.0.0-4.el7.x86_64.rpm
    - mysql-community-client-5.6.28-2.el7.x86_64.rpm
    - mysql-community-common-5.6.28-2.el7.x86_64.rpm
    - mysql-community-libs-5.6.28-2.el7.x86_64.rpm
    - mysql-community-server-5.6.28-2.el7.x86_64.rpm
    - mysql-connector-python-1.1.6-1.el7.noarch.rpm
    - mysql-connector-python-2.1.3-1.el7.x86_64.rpm
    - MySQL-python-1.2.3-11.el7.x86_64.rpm
    - net-tools-2.0-0.17.20131004git.el7.x86_64.rpm
    - openjpeg-libs-1.5.1-10.el7.x86_64.rpm
    - openssh-6.6.1p1-25.el7_2.x86_64.rpm
    - openssh-clients-6.6.1p1-25.el7_2.x86_64.rpm
    - openssh-server-6.6.1p1-25.el7_2.x86_64.rpm
    - opus-1.0.2-6.el7.x86_64.rpm
    - orc-0.4.22-5.el7.x86_64.rpm
    - pango-1.36.8-2.el7.x86_64.rpm
    - perl-5.16.3-286.el7.x86_64.rpm
    - perl-Carp-1.26-244.el7.noarch.rpm
    - perl-Compress-Raw-Bzip2-2.061-3.el7.x86_64.rpm
    - perl-Compress-Raw-Zlib-2.061-4.el7.x86_64.rpm
    - perl-constant-1.27-2.el7.noarch.rpm
    - perl-Data-Dumper-2.145-3.el7.x86_64.rpm
    - perl-DBD-MySQL-4.023-5.el7.x86_64.rpm
    - perl-DBI-1.627-4.el7.x86_64.rpm
    - perl-Encode-2.51-7.el7.x86_64.rpm
    - perl-Exporter-5.68-3.el7.noarch.rpm
    - perl-File-Path-2.09-2.el7.noarch.rpm
    - perl-File-Temp-0.23.01-3.el7.noarch.rpm
    - perl-Filter-1.49-3.el7.x86_64.rpm
    - perl-Getopt-Long-2.40-2.el7.noarch.rpm
    - perl-HTTP-Tiny-0.033-3.el7.noarch.rpm
    - perl-IO-Compress-2.061-2.el7.noarch.rpm
    - perl-libs-5.16.3-286.el7.x86_64.rpm
    - perl-macros-5.16.3-286.el7.x86_64.rpm
    - perl-Net-Daemon-0.48-5.el7.noarch.rpm
    - perl-parent-0.225-244.el7.noarch.rpm
    - perl-PathTools-3.40-5.el7.x86_64.rpm
    - perl-PlRPC-0.2020-14.el7.noarch.rpm
    - perl-Pod-Escapes-1.04-286.el7.noarch.rpm
    - perl-podlators-2.5.1-3.el7.noarch.rpm
    - perl-Pod-Perldoc-3.20-4.el7.noarch.rpm
    - perl-Pod-Simple-3.28-4.el7.noarch.rpm
    - perl-Pod-Usage-1.63-3.el7.noarch.rpm
    - perl-Scalar-List-Utils-1.27-248.el7.x86_64.rpm
    - perl-Socket-2.010-3.el7.x86_64.rpm
    - perl-Storable-2.45-3.el7.x86_64.rpm
    - perl-Text-ParseWords-3.29-4.el7.noarch.rpm
    - perl-threads-1.87-4.el7.x86_64.rpm
    - perl-threads-shared-1.43-6.el7.x86_64.rpm
    - perl-Time-HiRes-1.9725-3.el7.x86_64.rpm
    - perl-Time-Local-1.2300-2.el7.noarch.rpm
    - pixman-0.32.6-3.el7.x86_64.rpm
    - redis-3.0.5-1.el7.remi.x86_64.rpm
    - SDL-1.2.15-14.el7.x86_64.rpm
    - speex-1.2-0.19.rc1.el7.x86_64.rpm
    - unzip-6.0-15.el7.x86_64.rpm
    - xml-common-0.6.3-39.el7.noarch.rpm

- **/mpfdata/ansible/install/repo/tars**
    - apache-activemq-5.13.0-bin.tar.gz
    - apache-tomcat-7.0.72.tar.gz
    - ffmpeg-git-64bit-static.tar.xz

- **/mpfdata/ansible/install/repo/pip**
    - argcomplete-1.1.1-py2.py3-none-any.whl
    - argh-0.26.1.tar.gz
    - bcrypt-2.0.0.tar.gz
    - cffi-1.6.0.tar.gz
    - pycparser-2.14.tar.gz
    - PyMySQL-0.7.2-py2.py3-none-any.whl
    - six-1.10.0-py2.py3-none-any.whl

# Build and Test Environment

When developing for the OpenMPF, you may find the following collaboration and continuous integration tools helpful.

> **NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2016 The MITRE Corporation. All Rights Reserved.

# General Information

The Open Media Processing Framework (OpenMPF) software is distributed as a raw source code package. The reason for this methodology is to allow for publishing under the Apache license to support broad utilization and use-cases. Several of the underlying dependencies can be compiled in ways that introduce copyleft licenses or patent restrictions. Thus, this approach allows the OpenMPF to be built for a variety of use cases and in the general sense, utilized readily for non-commercial in-house use.

> **IMPORTANT:** It is the responsibility of the end users who follow this guide, and otherwise build the OpenMPF software to create an executable, to abide by all of the non-commercial and re-distribution restrictions imposed by the dependencies that the OpenMPF software uses. Building the OpenMPF and linking in these dependencies at build time or run time results in creating a derivative work under the terms of the GNU General Public License. Refer to the About page within the OpenMPF for more information about these dependencies.

This guide provides comprehensive instructions for setting up a build environment and generating an OpenMPF deployment package that contains the executable form of the software. This package is self-contained so that it can be installed on a minimal CentOS 7 system without Internet connectivity.

# Set Up the Minimal CentOS 7 VM

The following instructions are for setting up a VM for building an OpenMPF deployment package. This VM is not necessarily a machine on which the OpenMPF will be deployed and run. Those machines may have other requirements. For more information refer to the (TODO: insert working link) [Installation Guide](insert-link-here).

- This guide assumes a starting point of CentOS 7 with a minimal installation.
- At the time of writing this, the available minimal .iso file is CentOS-7-x86_64-Minimal-1511.iso. It should be downloaded from <https://www.centos.org/download/> prior to starting these steps.
- Oracle Virtual Box 5.0.20-106931 is used as the virtualization platform. Another platform such as VMware or a physical system can be used but are not explicitly tested.

>**NOTE:** You may need to utilize different parameters to suit your operating environment, these parameters utilized for OpenMPF test and build environments.

1. Create a new VM with these settings:
    - **Name**: ’OpenMPF Build’. (This guide assumes the name ‘OpenMPF Build’, but any name can be used.)
    - **Type**: Linux
    - **Version**: Red Hat (64-bit)

2. The recommended minimum virtual system specifications tested are:
    - **Memory**: 8192MB 
    - **CPU**: 4
    - **Disk**: 40GB on a SSD.

3. Network settings may vary based on your local environment. Connectivity to the public Internet is assumed. The network settings used in this guide are:
    - **Attached to**: NAT
    - **Advanced -> Adapter Type**: Intel PRO/1000 MT Desktop (82540EM)
    - **Cable Connected**: Checked

# Installing CentOS 7

> **NOTE:** If your build environment is behind a proxy server, please read the appendix section **[Proxy Configuration](https://github.com/openmpf/openmpf/wiki/Build-Environment-Setup-Guide#proxy-configuration)** for instructions to configure the yum package manager before continuing.

1. Open the ‘Settings’ for the OpenMPF Build VM.
- Select the ‘Storage’ menu item.
- In the ‘Storage Tree’ section under the ‘Controller: IDE’ item, select the optical disc icon.
- Under the ‘Attributes’ section, select the optical disc icon with a small black arrow. This will bring up a menu.
- Select ‘Choose Virtual Optical Disc file…’
- Choose the ‘CentOS-7-x86_64-Minimal-1511.iso’ file.
- Press the ‘OK’ button to exit the OpenMPF Build VM settings.
- Right click on the OpenMPF Build VM and select ‘Start’ and ‘Normal Start’. A new window will open with the running VM.
- On the ‘CentOS 7’ screen, select ‘Install CentOS 7’ with the keyboard and press the Enter key.
- Select the appropriate language and press the ‘Continue’ button.
- On the ‘Installation Summary’ screen, select the ‘Installation Destination’ icon.
- Press the ‘Done’ button to accept the defaults.
- On the ‘Installation Summary’ screen, select the ‘Network & Host Name’ icon. There should be one interface listed.
- Set the slider switch to ‘On’.
- Press the ‘Configure’ button, select the ‘General’ tab, and check the box for ‘Automatically connect to this network when available’.
- Press the 'Save' button.
- Each interface should show its status as ‘Connected’ with an IPv4 address.
- Leave the hostname as ‘localhost.localdomain’.
- Press the ‘Done’ button.
- Use the default values for everything else and press 'Begin Installation'.
- Set a password for the root account.
- Under ‘User Creation’, create a new user:
    - **Full Name**: mpf
    - **User Name**: mpf
        - Check the box for ‘Make this user administrator’
    - **Password**: mpf
- When installation is finished, press the ‘Finish Configuration’ button.
- When configuration is finished, press the ‘Reboot’ button.
- At the login prompt, login as user ‘mpf’ and password ‘mpf’.
- Install the epel repository and Delta RPM:
    - `sudo yum install –y epel-release deltarpm`
- Perform an initial system update:
    - `sudo yum update –y`
- Install Gnome Desktop Environment and some packages needed for the Virtual Box Guest Additions:
    - `sudo yum groups install –y "GNOME Desktop"`
- Install packages needed for the Virtual Box Guest Additions:
    - `sudo yum install gcc kernel-devel bzip2`
   > **NOTE:** You may have to specify a kernel version when installing ‘kernel-devel‘ as a Virtual Box guest addition. For example:
   > - `sudo yum install kernel-devel-3.10.0-327.el7.x86_64`.
- Reboot the system:
    - `sudo reboot now`
- At the login prompt, login as user ‘mpf’ and password ‘mpf’.
- Switch user to root with this command:
    - `sudo su –`
- On your host system in the Virtual Box Application, select the OpenMPF Build VM menu item ‘Devices’ and then ‘Insert Guest Additions CD image…’
- Install the Virtual Box Guest Additions:
    - `mount /dev/cdrom /mnt`
    - `cd /mnt`
    - `./VBoxLinuxAdditions.run`
    - `systemctl set-default graphical.target`
    - `reboot now`
- After the reboot, a license acceptance screen will come up. Select the 'License Information' icon.
- Read the license. If you accept it, select the 'I accept the license agreement.' check box.
- Press the 'Done' button.
- Press the 'Finish Configuration' button.
- At the graphical login screen, select the 'mpf' user.
- Enter 'mpf' as the password.
- A welcome screen will come up on the first launch of the Gnome desktop environment. Press the 'Next' button on the 'Language' page.
- Press the 'Next' button on the 'Typing' page.
- Press the 'Skip' button on the 'Online Accounts' page.
- Press the 'Start using CentOS Linux' button.
- Close the 'Getting Started' window that appears.
- On the desktop, right click the 'VBOXADDITIONS_5.0.22_108108' icon and select 'Eject'.
- On your host system in the Virtual Box Application, select the OpenMPF Build VM menu item ‘Devices’, then ‘Shared Clipboard’, then "Bidirectional". This will enable the ability to copy and paste commands from this document into the VM.
- On your host system in the Virtual Box Application, select the OpenMPF Build VM menu item ‘Devices’, then ‘Drag and Drop’, then "Bidirectional". This will enable the ability to drag files from the host system to the guest VM.

# Set Up the OpenMPF Build Environment

> **NOTE:** If your build environment is behind a proxy server, please read the appendix section **[Proxy Configuration](https://github.com/openmpf/openmpf/wiki/Build-Environment-Setup-Guide#proxy-configuration)**  for instructions to configure the yum package manager before continuing.

At the time of writing, all URLs provided in this section were verified as working.

## Configure Additional Repositories

Open a terminal window and perform the following steps:

- Copy the OpenMPF source archive (provided separately) to the path `/home/mpf` on the VM. This can be accomplished in several ways, including the use of a shared folder, SCP, or drag and drop from the host system. For more information on configuring a shared folder in a Virtual Box VM, please see the developer's documentation (<https://www.virtualbox.org/manual/ch04.html#sharedfolders>).
- Extract the OpenMPF source archive. This will create a /home/mpf/mpf directory which contains the source code:
    - `tar xvzf mpf-*-source.tar.gz -C /home/mpf/`
- Copy the mpf user profile script from the extracted source code:
    - `sudo cp /home/mpf/mpf/trunk/mpf-install/src/main/scripts/mpf-profile.sh /etc/profile.d/mpf.sh`
- Install the Oracle MySQL Community Release Repository:
    - `wget -P /home/mpf/Downloads "http://dev.mysql.com/get/mysql-community-release-el7-5.noarch.rpm"`
    - `sudo rpm -ivh /home/mpf/Downloads/mysql-community-release-el7-5.noarch.rpm`
- Install the Remi Repo for Redis:
    - `wget -P /home/mpf/Downloads "http://rpms.remirepo.net/RPM-GPG-KEY-remi"`
    - `wget -P /home/mpf/Downloads "http://rpms.famillecollet.com/enterprise/remi-release-7.rpm"`
    - `sudo rpm --import /home/mpf/Downloads/RPM-GPG-KEY-remi`
    - `sudo rpm -Uvh /home/mpf/Downloads/remi-release-7.rpm`
    - `sudo yum-config-manager --enable remi`
- Create an ‘/apps’ directory and package subdirectories:
    - `sudo mkdir -p /apps/source/cmake_sources`
    - `sudo mkdir -p /apps/install/lib`
    - `sudo mkdir -p /apps/bin/apache`
    - `sudo mkdir /apps/ansible`
    - `sudo mkdir /apps/source/apache_sources`
    - `sudo mkdir /apps/source/google_sources`
    - `sudo mkdir /apps/source/opencv_sources`
    - `sudo mkdir /apps/source/ffmpeg_sources`
    - `sudo mkdir /apps/source/dlib_sources`
    - `sudo mkdir /apps/source/openalpr_sources`
    - `sudo mkdir /apps/source/ansible_sources`
    - `sudo chown -R mpf:mpf /apps`
    - `sudo chmod -R 755 /apps`
- Add /apps/install/bin to the system PATH variable:
    - `sudo sh -c 'echo "PATH=\$PATH:/apps/install/bin" >> /etc/profile.d/mpf.sh'`
    - `. /etc/profile.d/mpf.sh`
- Create the OpenMPF ldconfig file:
    - `sudo touch /etc/ld.so.conf.d/mpf-x86_64.conf`
- Add /apps/install/lib to the OpenMPF ldconfig file:
    - `sudo sh -c 'echo "/apps/install/lib" >> /etc/ld.so.conf.d/mpf-x86_64.conf'`
- Update the shared library cache:
    - `sudo ldconfig`

## RPM Dependencies

The following RPM packages will need to be downloaded and installed. Use of the yum package manager is recommended:

`sudo yum install -y asciidoc autoconf automake boost boost-devel cmake-gui freetype-devel gcc-c++ git graphviz gstreamer-plugins-base-devel gtk2-devel gtkglext-devel gtkglext-libs jasper jasper-devel libavc1394-devel libdc1394-devel libffi-devel libICE-devel libjpeg-devel libjpeg-turbo-devel libpng-devel libSM-devel libtiff-devel libtool libv4l-devel libXinerama-devel libXmu-devel libXt-devel log4cxx log4cxx-devel make mercurial mesa-libGL-devel mesa-libGLU-devel mysql mysql-community-server nasm ncurses-devel numpy pangox-compat pangox-compat-devel perl-CPAN-Meta-YAML perl-DBD-MySQL perl-DBI perl-Digest-MD5 perl-File-Find-Rule perl-File-Find-Rule-Perl perl-JSON perl-JSON-PP perl-List-Compare perl-Number-Compare perl-Params-Util perl-Parse-CPAN-Meta php pkgconfig python-devel python-httplib2 python-jinja2 python-keyczar python-paramiko python-pip python-setuptools python-six PyYAML qt qt-devel qt-x11 redis rpm-build sshpass tbb tbb-devel tree unzip uuid-devel wget yasm yum-utils zlib-devel`

## Binary Packages

> **NOTE:** If your environment is behind a proxy server that performs SSL inspection, please read the appendix section **[SSL Inspection](https://github.com/openmpf/openmpf/wiki/Build-Environment-Setup-Guide#ssl-inspection)** before continuing.

The following binary packages will need to be downloaded and installed:

1. Oracle JDK:
    - For reference only: <http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html>
    - `cd /home/mpf`
    - `wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.rpm" -O /apps/bin/jdk-8u60-linux-x64.rpm`
    - `sudo yum -y localinstall --nogpgcheck /apps/bin/jdk-8u60-linux-x64.rpm`
    - `sudo alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_60/jre/bin/java 20000`
    - `sudo alternatives --install /usr/bin/jar jar /usr/java/jdk1.8.0_60/bin/jar 20000`
    - `sudo alternatives --install /usr/bin/javac javac /usr/java/jdk1.8.0_60/bin/javac 20000`
    - `sudo alternatives --install /usr/bin/javaws javaws /usr/java/jdk1.8.0_60/jre/bin/javaws 20000`
    - `sudo alternatives --set java /usr/java/jdk1.8.0_60/jre/bin/java`
    - `sudo alternatives --set javaws /usr/java/jdk1.8.0_60/jre/bin/javaws`
    - `sudo alternatives --set javac /usr/java/jdk1.8.0_60/bin/javac`
    - `sudo alternatives --set jar /usr/java/jdk1.8.0_60/bin/jar`
   > **NOTE:** If this command to set the `jar` alternative fails with the following error:
   >
   > *failed to read link /usr/bin/jar: No such file or directory*
   >
   > You should run the following commands again:
   > - `sudo alternatives --install /usr/bin/jar jar /usr/java/jdk1.8.0_60/bin/jar 20000`
   > - `sudo alternatives --set jar /usr/java/jdk1.8.0_60/bin/jar`
    - `. /etc/profile.d/mpf.sh`
- Apache ActiveMQ 5.13.0:
    - For reference only: <http://activemq.apache.org>
    - `cd /apps/bin/apache`
    - `wget -O /apps/bin/apache/apache-activemq-5.13.0-bin.tar.gz "https://archive.apache.org/dist/activemq/5.13.0/apache-activemq-5.13.0-bin.tar.gz"`
    - `sudo tar xvzf apache-activemq-5.13.0-bin.tar.gz -C /opt/`
    - `sudo chown -R mpf:mpf /opt/apache-activemq-5.13.0`
    - `sudo chmod -R 755 /opt/apache-activemq-5.13.0`
    - `sudo ln -s /opt/apache-activemq-5.13.0 /opt/activemq`
- Apache Tomcat 7.0.72:
    - For reference only: <http://tomcat.apache.org>
    - `cd /apps/bin/apache `
    - `wget -O /apps/bin/apache/apache-tomcat-7.0.72.tar.gz "http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.72/bin/apache-tomcat-7.0.72.tar.gz"`
    - `tar xzvf apache-tomcat-7.0.72.tar.gz`
    - `sudo mkdir -p /usr/share/apache-tomcat`
    - `sudo cp -Rf /apps/bin/apache/apache-tomcat-7.0.72/* /usr/share/apache-tomcat/`
    - `sudo chown -R mpf:mpf /usr/share/apache-tomcat`
    - `sudo chmod -R 755 /usr/share/apache-tomcat`
    - `sudo ln -s /usr/share/apache-tomcat /opt/apache-tomcat`
    - `sudo perl -i -p0e 's/<!--\n    <Manager pathname="" \/>\n      -->.*?/<!-- -->\n    <Manager pathname="" \/>/s' /opt/apache-tomcat/conf/context.xml`
    - `sudo perl -i -p0e 's/<\/Context>/    <Resources cachingAllowed="true" cacheMaxSize="100000" \/>\n<\/Context>/s' /opt/apache-tomcat/conf/context.xml`
    - `sudo rm -rf /opt/apache-tomcat/webapps/*`
- Apache Ant 1.9.6:
    - For reference only: <http://ant.apache.org>
    - `cd /apps/bin/apache `
    - `wget -O /apps/bin/apache/apache-ant-1.9.6-bin.tar.gz "https://archive.apache.org/dist/ant/binaries/apache-ant-1.9.6-bin.tar.gz"`
    - `tar xzvf apache-ant-1.9.6-bin.tar.gz`
    - `sudo cp -R /apps/bin/apache/apache-ant-1.9.6 /apps/install/`
    - `sudo chown -R mpf:mpf /apps/install/apache-ant-1.9.6`
    - `sudo sed -i '/^PATH/s/$/:\/apps\/install\/apache-ant-1.9.6\/bin/' /etc/profile.d/mpf.sh`
    - `. /etc/profile.d/mpf.sh`
- Apache Maven 3.3.3:
    - For reference only: <https://maven.apache.org>
    - `cd /apps/bin/apache`
    - `wget -O /apps/bin/apache/apache-maven-3.3.3-bin.tar.gz "https://archive.apache.org/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz"`
    - `tar xzvf apache-maven-3.3.3-bin.tar.gz`
    - `sudo mkdir /opt/apache-maven`
    - `sudo cp -Rf /apps/bin/apache/apache-maven-3.3.3/* /opt/apache-maven/`
    - `sudo chown -R mpf:mpf /opt/apache-maven`
    - `sudo sed -i '/^PATH/s/$/:\/opt\/apache-maven\/bin/' /etc/profile.d/mpf.sh`
    - `sudo sh -c 'echo "M2_HOME=/opt/apache-maven" >> /etc/profile.d/mpf.sh'`
    - `. /etc/profile.d/mpf.sh`

## Python Packages
1. C Foreign Function Interface (CFFI):
    - `cd /home/mpf`
    - `sudo -E easy_install -U cffi`
- OpenMPF Administrative Tools:
    - `sudo -E pip install /home/mpf/mpf/trunk/bin/mpf-scripts`

## Building Dependencies

> **NOTE:** If your build environment is behind a proxy server, please read the appendix section **[Proxy Configuration](https://github.com/openmpf/openmpf/wiki/Build-Environment-Setup-Guide#proxy-configuration)**  for instructions to configure git before continuing.

The following source packages will need to be downloaded, built, and installed:

1. Cmake 2.8.12.2:
    - For reference only: <https://cmake.org>
    - `cd /apps/source/cmake_sources`
    - `wget -O /apps/source/cmake_sources/cmake-2.8.12.2.tar.gz "https://cmake.org/files/v2.8/cmake-2.8.12.2.tar.gz"`
    - `tar xvzf cmake-2.8.12.2.tar.gz`
    - `cd cmake-2.8.12.2`
    - `chmod +x *`
    - `./configure --prefix=/apps/install`
    - `make -j8`
    - `sudo make install`
    - `sudo ldconfig`
    - `sudo ln -s /apps/install/bin/cmake /usr/local/bin/cmake`
- FFmpeg 2.6.3:
  > **NOTE:** FFmpeg can be built with different encoders and modules that are individually licensed. It is recommended to check each developer’s documentation for the most up-to-date licensing information.
    - yasm:
        - For reference only: <http://yasm.tortall.net>
        - `cd /apps/source/ffmpeg_sources`
        - `git clone --depth 1 http://github.com/yasm/yasm.git`
        - `cd yasm`
        - `autoreconf -fiv`
        - `./configure --prefix="/apps/install" --bindir="/apps/install/bin"`
        - `make`
        - `sudo make install`
        - `make distclean`
        - `sudo ldconfig`
    - xvidcore:
        - For reference only: <https://labs.xvid.com>
        - `cd /apps/source/ffmpeg_sources`
        - `wget -O /apps/source/ffmpeg_sources/xvidcore-1.3.2.tar.gz "http://downloads.xvid.org/downloads/xvidcore-1.3.2.tar.gz"`
        - `tar zxvf xvidcore-1.3.2.tar.gz`
        - `cd xvidcore/build/generic`
        - `./configure --prefix="/apps/install"`
        - `make`
        - `sudo make install`
        - `make distclean`
        - `sudo ldconfig`
    - libx264:
        - For reference only: <http://www.videolan.org/developers/x264.html>
        - `cd /apps/source/ffmpeg_sources`
        - `wget -O /apps/source/ffmpeg_sources/x264-snapshot-20140223-2245-stable.tar.bz2 "ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20140223-2245-stable.tar.bz2"`
        - `tar xvjf x264-snapshot-20140223-2245-stable.tar.bz2`
        - `cd x264-snapshot-20140223-2245-stable`
        - `PKG_CONFIG_PATH="/apps/install/lib/pkgconfig" ./configure --prefix="/apps/install" --bindir="/apps/install" --enable-shared`
        - `sudo sed -i '/^PATH/s/$/:\/apps\/install\/lib\/pkgconfig/' /etc/profile.d/mpf.sh`
        - `sudo sh -c 'echo "export PKG_CONFIG_PATH=/apps/install/lib/pkgconfig" >> /etc/profile.d/mpf.sh'`
        - `. /etc/profile.d/mpf.sh`
        - `make`
        - `sudo make install`
        - `make distclean`
        - `sudo ldconfig`
    - opencore-amr:
        - For reference only: <https://sourceforge.net/projects/opencore-amr>
        - `cd /apps/source/ffmpeg_sources`
        - `wget -O /apps/source/ffmpeg_sources/opencore-amr-0.1.3.tar.gz "http://downloads.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.3.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Fopencore-amr%2Ffiles%2Fopencore-amr%2F&ts=1467223123&use_mirror=tenet"`
        - `tar xvzf opencore-amr-0.1.3.tar.gz`
        - `cd opencore-amr-0.1.3`
        - `autoreconf -fiv`
        - `./configure --prefix="/apps/install" --enable-shared`
        - `make`
        - `sudo make install`
        - `make distclean`
        - `sudo ldconfig`
    - libmp3lame:
        - For reference only: <http://lame.sourceforge.net>
        - `cd /apps/source/ffmpeg_sources`
        - `wget -O /apps/source/ffmpeg_sources/lame-3.99.5.tar.gz "http://downloads.sourceforge.net/project/lame/lame/3.99/lame-3.99.5.tar.gz"`
        - `tar xzvf lame-3.99.5.tar.gz`
        - `cd lame-3.99.5`
        - `./configure --prefix="/apps/install" --bindir="/apps/install/bin" --enable-shared --enable-nasm`
        - `make`
        - `sudo make install`
        - `make distclean`
        - `sudo ldconfig`
    - libogg:
        - For reference only: <https://www.xiph.org/ogg>
        - `cd /apps/source/ffmpeg_sources`
        - `wget -O /apps/source/ffmpeg_sources/libogg-1.3.2.tar.gz "http://downloads.xiph.org/releases/ogg/libogg-1.3.2.tar.gz"`
        - `tar xvzf libogg-1.3.2.tar.gz`
        - `cd libogg-1.3.2`
        - `./configure --prefix="/apps/install" --enable-shared`
        - `make`
        - `sudo make install`
        - `make distclean`
        - `sudo ldconfig`
    - libvorbis:
        - For reference only: <https://xiph.org/vorbis>
        - `cd /apps/source/ffmpeg_sources`
        - `wget -O /apps/source/ffmpeg_sources/libvorbis-1.3.4.tar.gz "http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.4.tar.gz"`
        - `tar xzvf libvorbis-1.3.4.tar.gz`
        - `cd libvorbis-1.3.4`
        - `LDFLAGS="-L/apps/install/lib" CPPFLAGS="-I/apps/install/include" ./configure --prefix="/apps/install" --with-ogg="/apps/install" --enable-shared`
        - `make`
        - `sudo make install`
        - `make distclean`
        - `sudo ldconfig`
    - libtheora:
        - For reference only: <https://www.theora.org>
        - `cd /apps/source/ffmpeg_sources`
        - `wget -O /apps/source/ffmpeg_sources/libtheora-1.1.1.tar.bz2 "http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2"`
        - `tar -xvjf libtheora-1.1.1.tar.bz2`
        - `cd libtheora-1.1.1`
        - `./configure --prefix="/apps/install" --enable-shared`
        - `make`
        - `sudo make install`
        - `make distclean`
        - `sudo ldconfig`
    - FFmpeg:
        - For reference only: <https://ffmpeg.org>
        - `cd /apps/source/ffmpeg_sources`
        - `git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg`
        - `cd ffmpeg`
        - `git checkout af5917698bd44f136fd0ff00a9e5f8b5f92f2d58`
        - `PKG_CONFIG_PATH="/apps/install/lib/pkgconfig" ./configure --prefix="/apps/install" --extra-cflags="-I/apps/install/include" --extra-ldflags="-L/apps/install/lib" --bindir="/apps/install/bin" --enable-gpl --enable-nonfree --enable-libtheora --enable-libfreetype --enable-libmp3lame --enable-libvorbis --enable-libx264 --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-version3 --enable-shared --disable-libsoxr`
        - `make`
        - `sudo make install`
        - `make distclean`
        - `sudo ldconfig`
- Google protocol buffers 2.5.0:
    - For reference only: <https://developers.google.com/protocol-buffers>
    - `cd /apps/source/google_sources`
    - `wget -O /apps/source/google_sources/protobuf-2.5.0.tar.gz "https://github.com/google/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz"`
    - `tar xvzf protobuf-2.5.0.tar.gz`
    - `cd protobuf-2.5.0`
    - `./configure --prefix=/apps/install`
    - `make -j8`
    - `sudo make install`
    - `make distclean`
    - `sudo ldconfig`
    - `sudo sh -c 'echo "export CXXFLAGS=-isystem\ /apps/install/include" >> /etc/profile.d/mpf.sh'`
    - `sudo ln -s /apps/install/bin/protoc /usr/local/bin/protoc`
    - `sudo ln -s /usr/lib64/libuuid.so.1.3.0 /usr/lib64/libuuid.so`
- Apr 1.5.2:
    - For reference only: <https://apr.apache.org>
    - `cd /apps/source/apache_sources`
    - `wget -O /apps/source/apache_sources/apr-1.5.2.tar.gz "http://archive.apache.org/dist/apr/apr-1.5.2.tar.gz"`
    - `tar -zxvf apr-1.5.2.tar.gz`
    - `cd /apps/source/apache_sources/apr-1.5.2`
    - `./configure --prefix=/apps/install`
    - `make -j8`
    - `sudo make install`
    - `make distclean`
    - `sudo ldconfig`
- Apr-util 1.5.4:
    - For reference only: <https://apr.apache.org>
    - `cd /apps/source/apache_sources`
    - `wget -O /apps/source/apache_sources/apr-util-1.5.4.tar.gz "http://archive.apache.org/dist/apr/apr-util-1.5.4.tar.gz"`
    - `tar -xzvf apr-util-1.5.4.tar.gz`
    - `cd /apps/source/apache_sources/apr-util-1.5.4`
    - `./configure --with-apr=/apps/install --prefix=/apps/install`
    - `make -j8`
    - `sudo make install`
    - `make distclean`
    - `sudo ldconfig`
- Activemqcpp 3.9.0:
    - For reference only: <http://activemq.apache.org/cms>
    - `cd /apps/source/apache_sources`
    - `wget -O /apps/source/apache_sources/activemq-cpp-library-3.9.0-src.tar.gz "https://archive.apache.org/dist/activemq/activemq-cpp/3.9.0/activemq-cpp-library-3.9.0-src.tar.gz"`
    - `tar zxvf activemq-cpp-library-3.9.0-src.tar.gz`
    - `cd /apps/source/apache_sources/activemq-cpp-library-3.9.0`
    - `./autogen.sh`
    - `./configure --disable-ssl --prefix=/apps/install`
    - `make -j8`
    - `sudo make install`
    - `make distclean`
    - `sudo ldconfig`
    - `sudo ln -s /apps/install/lib/libactivemq-cpp.so.19.0.0 /usr/lib/libactivemq-cpp.so`
- openCV 2.4.9:
    - For reference only: <http://opencv.org>
    - `sudo ln -s /usr/include/gdk-pixbuf-2.0/gdk-pixbuf /usr/include/gtk-2.0/gdk-pixbuf`
    - `cd /apps/source/opencv_sources`
    - `wget -O /apps/source/opencv_sources/opencv-2.4.9.zip "http://downloads.sourceforge.net/project/opencvlibrary/opencv-unix/2.4.9/opencv-2.4.9.zip?r=http%3A%2F%2Fopencv.org%2Fdownloads.html&ts=1467141570&use_mirror=heanet"`
    - `unzip -o opencv-2.4.9.zip`
    - `cd opencv-2.4.9`
    - `mkdir release`
    - `cd release`
    - `cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/apps/install/opencv2.4.9 ..`
    - `make -j8`
    - `sudo make install`
    - `sudo sh -c 'echo "/apps/install/opencv2.4.9/lib" >> /etc/ld.so.conf.d/mpf-x86_64.conf'`
    - `sudo ldconfig`
    - `sudo ln -s /apps/install/opencv2.4.9/include/opencv2 /usr/include/`
    - `sudo ln -s /apps/install/opencv2.4.9/include/opencv /usr/include/`
    - `sudo sh -c 'echo "export OpenCV_DIR=/apps/install/opencv2.4.9/share/OpenCV/" >> /etc/profile.d/mpf.sh'`
    - `. /etc/profile.d/mpf.sh`
- Leptonica 1.70:
    - For reference only: <https://github.com/DanBloomberg/leptonica>
    - `cd /apps/source/openalpr_sources`
    - `wget -O /apps/source/openalpr_sources/leptonica-1.70.tar.gz "https://github.com/DanBloomberg/leptonica/archive/v1.70.tar.gz"`
    - `sudo mkdir /usr/local/src/openalpr`
    - `sudo tar zxvf leptonica-1.70.tar.gz -C /usr/local/src/openalpr/`
    - `sudo chown -R mpf:mpf /usr/local/src/openalpr`
    - `sudo chmod -R 755 /usr/local/src/openalpr`
    - `cd /usr/local/src/openalpr/leptonica-1.70`
    - `./configure prefix=/usr/local`
    - `make -j8`
    - `sudo make install`
    - `make distclean`
    - `sudo ldconfig`
- Tesseract 3.02.02:
    - For reference only: <https://github.com/tesseract-ocr>
    - `cd /apps/source/openalpr_sources`
    - `wget -O /apps/source/openalpr_sources/3.02.02.tar.gz "https://github.com/tesseract-ocr/tesseract/archive/3.02.02.tar.gz"`
    - `wget -O /apps/source/openalpr_sources/tesseract-ocr-3.02.eng.tar.gz "http://downloads.sourceforge.net/project/tesseract-ocr-alt/tesseract-ocr-3.02.eng.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Ftesseract-ocr-alt%2Ffiles%2F&ts=1468000683&use_mirror=superb-sea2"`
    - `tar zxvf tesseract-ocr-3.02.eng.tar.gz -C /usr/local/src/openalpr/`
    - `tar zxvf 3.02.02.tar.gz -C /usr/local/src/openalpr/`
    - `cd /usr/local/src/openalpr`
    - `cp -r tesseract-3.02.02/* tesseract-ocr/`
    - `cd tesseract-ocr`
    - `./autogen.sh`
    - `./configure`
    - `make -j8`
    - `sudo make install`
    - `sudo ldconfig`
- OpenALPR 1.1.0:
    - For reference only: <https://github.com/openalpr/openalpr>
    - `cd /usr/local/src/openalpr`
    - `git clone https://github.com/openalpr/openalpr.git`
    - `cd /usr/local/src/openalpr/openalpr`
    - `git checkout 765a41685d88901d8a394f211ba72614e491cbfd`
    - `mkdir /usr/local/src/openalpr/openalpr/src/build`
    - `cd /usr/local/src/openalpr/openalpr/src/build`
    - `cmake -j8 --DCmake -j8_INSTALL_PREFIX:PATH=/usr ../`
    - `make -j8`
    - `sudo make install`
    - `sudo ldconfig`
    - `sudo ln -s /usr/local/src/openalpr/openalpr /usr/share/openalpr`
    - `sudo cp -a /usr/local/lib/libopenalpr.so /usr/lib/libopenalpr.so`
    - `sudo cp /usr/local/lib/libopenalpr.so.1 /usr/lib/libopenalpr.so.1`
    - `sudo sh -c 'echo "export TESSDATA_PREFIX=/usr/local/src/openalpr/openalpr/runtime_data/ocr" >> /etc/profile.d/mpf.sh'`
    - `sudo ldconfig`
    - `. /etc/profile.d/mpf.sh`
- openCV 3.1.0:
    - For reference only: <http://opencv.org>
    - `cd /apps/source/opencv_sources`
    - `wget -O /apps/source/opencv_sources/opencv-3.1.0.zip "https://github.com/Itseez/opencv/archive/3.1.0.zip"`
    - `unzip -o opencv-3.1.0.zip`
    - `wget -O /apps/source/opencv_sources/opencv_contrib-3.1.0.tar.gz "https://github.com/Itseez/opencv_contrib/archive/3.1.0.tar.gz"`
    - `tar xvzf opencv_contrib-3.1.0.tar.gz`
    - `cd opencv-3.1.0`
    - `mkdir release`
    - `cd release`
    - `cmake -D CMAKE_BUILD_TYPE=Release -D -DWITH_GSTREAMER:BOOL="0" -DWITH_OPENMP:BOOL="1" -DBUILD_opencv_apps:BOOL="0" -DWITH_OPENCLAMDBLAS:BOOL="0" -DWITH_CUDA:BOOL="0" -DCLAMDFFT_ROOT_DIR:PATH="CLAMDFFT_ROOT_DIR-NOTFOUND" -DBUILD_opencv_aruco:BOOL="0" -DCMAKE_INSTALL_PREFIX:PATH="/apps/install/opencv3.1.0" -DWITH_WEBP:BOOL="0" -DBZIP2_LIBRARIES:FILEPATH="BZIP2_LIBRARIES-NOTFOUND" -DWITH_GIGEAPI:BOOL="0" -DOPENCV_EXTRA_MODULES_PATH:PATH="/apps/source/opencv_sources/opencv_contrib-3.1.0/modules" -DWITH_JPEG:BOOL="1" -DWITH_CUFFT:BOOL="0" -DWITH_IPP:BOOL="0" -DWITH_V4L:BOOL="1" -DWITH_GDAL:BOOL="0" -DWITH_OPENCLAMDFFT:BOOL="0" -DWITH_GPHOTO2:BOOL="0" -DWITH_VTK:BOOL="0" -DWITH_GTK_2_X:BOOL="0" -DBUILD_opencv_world:BOOL="0" -DWITH_TIFF:BOOL="1" -DWITH_1394:BOOL="0" -DWITH_EIGEN:BOOL="0" -DWITH_LIBV4L:BOOL="0" -DBUILD_opencv_ts:BOOL="0" -DWITH_MATLAB:BOOL="0" -DWITH_OPENCL:BOOL="0" -DWITH_PVAPI:BOOL="0" ..`
    - `make -j8`
    - `sudo make install`
    - `sudo sh -c 'echo "/apps/install/opencv3.1.0/lib" >> /etc/ld.so.conf.d/mpf-x86_64.conf'`
    - `sudo ldconfig`
    - `gedit /home/mpf/mpf/mpf_components/CPP/detection/caffeComponent/CMakeLists.txt`
    - Under the `# Find and install OpenCV 3.1` section, locate the line `PATHS /opt/opencv3.1.0)`. Change the value of `PATHS` so this line looks like: `PATHS /apps/install/opencv3.1.0)`
    - Save and close the file.
- dlib:
    - For reference only: <http://dlib.net>
    - `cd /apps/source`
    - `wget -O /apps/source/config4cpp.tar.gz "http://www.config4star.org/download/config4cpp.tar.gz"`
    - `tar xvzf config4cpp.tar.gz`
    - `cd config4cpp`
    - `make`
    - `cd /apps/source/dlib_sources`
    - `wget -O /apps/source/dlib_sources/dlib-18.18.tar.bz2 "http://dlib.net/files/dlib-18.18.tar.bz2"`
    - `tar xvjf dlib-18.18.tar.bz2`
    - `cd dlib-18.18/dlib`
    - `mkdir build`
    - `cd build`
    - `cmake ../`
    - `cmake --build . --config Release`
    - Make sure libdlib.so and libdlib.so.18.18.0 are present in /apps/source/dlib_sources/dlib-18.18/dlib/build
    - `sudo make install`
- Ansible:
    - For reference only: <https://github.com/ansible/ansible>
    - `cd /apps/source/ansible_sources`
    - `git clone https://github.com/ansible/ansible.git --recursive`
    - `cd ansible`
    - `git checkout e71cce777685f96223856d5e6cf506a9ea2ef3ff`
    - `cd /apps/source/ansible_sources/ansible/lib/ansible/modules/core`
    - `git checkout 36f512abc1a75b01ae7207c74cdfbcb54a84be54`
    - `cd /apps/source/ansible_sources/ansible/lib/ansible/modules/extras`
    - `git checkout 32338612b38d1ddfd0d42b1245c597010da02970`
    - `cd /apps/source/ansible_sources/ansible`
    - `make rpm`
    - `sudo rpm -Uvh ./rpm-build/ansible-*.noarch.rpm`

## Configuring MySQL

- `sudo systemctl start mysqld`
- `mysql -u root --execute "UPDATE mysql.user SET Password=PASSWORD('password') WHERE User='root';flush privileges;"`
- `mysql -u root -ppassword --execute "create database mpf"`
- `mysql -u root -ppassword --execute "create user 'mpf'@'%' IDENTIFIED by 'mpf';flush privileges;"`
- `mysql -u root -ppassword --execute "create user 'mpf'@'$(hostname)' IDENTIFIED by 'mpf';flush privileges;"`
- `mysql -u root -ppassword --execute "create user 'mpf'@'localhost' IDENTIFIED by 'mpf';flush privileges;"`
- `mysql -u root -ppassword --execute "grant all privileges on mpf.* to 'mpf';flush privileges;"`
- `sudo systemctl enable mysqld.service`
- `sudo chkconfig --level 2345 mysqld on`

## Configuring ActiveMQ

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

In `/opt/activemq/conf/activemq.xml` (line 71), change the line:

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

## Configuring Redis

Redis should be set to run in the background (i.e. as a daemon process).

In `/etc/redis.conf` (line 128), change the line:

```
daemonize no
```

so that it reads:

```
daemonize yes
```

## HTTPS Configuration

**Generate a self-signed certificate and keystore**

> **NOTE:**  A valid keystore is required to run the OpenMPF with HTTPS support. These instructions will generate a keystore that should be used for local builds only. When deploying the OpenMPF, a keystore containing a valid certificate trust chain should be used.

- Open a new terminal window.
-  `sudo systemctl stop tomcat7`
- `cd /home/mpf`
- `$JAVA_HOME/bin/keytool -genkey -alias tomcat -keyalg RSA`
- At the prompt, enter a keystore password of: `mpf123`
- Re-enter the keystore password of: `mpf123`
- At the `What is your first and last name?` prompt, press the Enter key for a blank value.
- At the `What is the name of your organizational unit?` , press the Enter key for a blank value.
- At the `What is the name of your organization?` prompt, press the Enter key for a blank value.
- At the `What is the name of your City or Locality?` prompt, press the Enter key for a blank value.
- At the `What is the name of your State or Province?` prompt, press the Enter key for a blank value.
- At the `What is the two-letter country code for this unit?` prompt, press the Enter key for a blank value.
- At the `Is CN=Unknown, OU=Unknown, O=Unknown, L=Unknown, ST=Unknown, C=Unknown correct?` prompt, type `yes` and press the Enter key to accept the values.
- At the `Enter key password for <tomcat>` prompt, press the Enter key for a blank value.
- Verify the file `/home/mpf/.keystore` was created at the current time.

**Tomcat Configuration**

- Open the file `/opt/apache-tomcat/conf/server.xml` in a text editor.
- Below the commented out section on lines 87 through 90, add the following lines:

```
  <Connector SSLEnabled="true" acceptCount="100" clientAuth="false"
	disableUploadTimeout="true" enableLookups="false" maxThreads="25"
	port="8443" keystoreFile="/home/mpf/.keystore" keystorePass="mpf123"
	protocol="org.apache.coyote.http11.Http11NioProtocol" scheme="https"
	secure="true" sslProtocol="TLS" />
```

- Save and close the file.
- Create the file `/opt/apache-tomcat/bin/setenv.sh` and open it in a text editor.
- Add the following line:

```
  export CATALINA_OPTS="-server -Xms256m -XX:PermSize=512m -XX:MaxPermSize=512m -Djgroups.tcp.port=7800 -Djava.library.path=$LD_LIBRARY_PATH -Djgroups.tcpping.initial_hosts='$ALL_MPF_NODES' -Dtransport.guarantee='CONFIDENTIAL' -Dweb.rest.protocol='https'"
```

- Save and close the file.

**Using an IDE**

If running Tomcat from an IDE, such as IntelliJ, then `-Dtransport.guarantee="CONFIDENTIAL" -Dweb.rest.protocol="https"` should be added at the end of the Tomcat VM arguments for your Tomcat run configuration. It is not necessary to add these arguments when running tomcat from the command line or a systemd command because of configured `CATALINA_OPTS` variable.

## (Optional) HTTP Configuration
The OpenMPF can also be run using HTTP instead of HTTPS.
- Open the file `/opt/apache-tomcat/conf/server.xml` in a text editor.
- Below the commented out section on lines 87 through 90, remove the following lines if they exist:

```
  <Connector SSLEnabled="true" acceptCount="100" clientAuth="false"
	disableUploadTimeout="true" enableLookups="false" maxThreads="25"
	port="8443" keystoreFile="/home/mpf/.keystore" keystorePass="mpf123"
	protocol="org.apache.coyote.http11.Http11NioProtocol" scheme="https"
	secure="true" sslProtocol="TLS" />
```

- Save and close the file.
- Create the file `/opt/apache-tomcat/bin/setenv.sh` and open it in a text editor.
- Add the following line:

```
  export CATALINA_OPTS="-server -Xms256m -XX:PermSize=512m -XX:MaxPermSize=512m -Djgroups.tcp.port=7800 -Djava.library.path=$LD_LIBRARY_PATH -Djgroups.tcpping.initial_hosts='$ALL_MPF_NODES' -Dtransport.guarantee='NONE' -Dweb.rest.protocol='http'"
```

- Save and close the file.

## Adding Additional Maven Dependencies

Some Maven dependencies needed for the OpenMPF were not publicly available at the time this guide was written. These have been provided in addition to the OpenMPF source code archive. These steps assume the archive `mpf-maven-deps.tar.gz` is at `/home/mpf/mpf-maven-deps.tar.gz`.

1. Set up the local Maven repository:
    - `cd /home/mpf`
    - `mkdir -p .m2/repository`
2. Extract the archive to the local Maven repository:
    - `tar xvzf mpf-maven-deps.tar.gz -C /home/mpf/.m2/repository/`

# Building and Packaging the OpenMPF

> **IMPORTANT:** The `CreateCustomPackage.pl` script used in this section assumes dependency packages needed for deployment are present in their correct location under `/mpfdata/ansible/install/repo/`. For a list of dependencies required for a standard OpenMPF package, please see the appendix section **[Third-party RPMs, tars, and Python Pip packages included with an OpenMPF Package](https://github.com/openmpf/openmpf/wiki/Build-Environment-Setup-Guide#third-party-rpms-tars-and-python-pip-packages-included-with-an-openmpf-package)**.

The OpenMPF uses Apache Maven to automate software builds. The `mvn` commands in this guide are assumed to be run at the command line.

## Build Environment

The OpenMPF packaging script makes use of a directory /mpfdata with the following structure:

```
  mpfdata - the top level directory containing the structure and non-source code artifacts to be packaged for distribution.
  ├── ansible
  │   └── install
  │       └── repo
  │           ├── extComponents - External component archives included with the OpenMPF.
  │           ├── files - Any other uncategorized files needed by the OpenMPF.
  │           ├── pip - Dependency packages needed for the OpenMPF administration scripts. Installed with Python pip during deployment.
  │           ├── rpms - Contains all of the RPM packages needed for installing and running the OpenMPF. Installed with the yum package manager during deployment.
  │           │   ├── management - RPM  packages needed for the OpenMPF deployment process.
  │           │   ├── mpf - The OpenMPF RPM packages.
  │           │   └── mpf-deps - RPM packages needed by the OpenMPF.
  │           └── tars - Binary packages in tar archives needed by the OpenMPF.
  └── releases - Contains the release package(s) that will be built.
```

Create the build environment structure:

- `sudo mkdir -p /mpfdata/ansible/install/repo/rpms/management`
- `sudo mkdir /mpfdata/ansible/install/repo/rpms/mpf`
- `sudo mkdir /mpfdata/ansible/install/repo/rpms/mpf-deps`
- `sudo mkdir /mpfdata/ansible/install/repo/extComponents`
- `sudo mkdir /mpfdata/ansible/install/repo/files`
- `sudo mkdir /mpfdata/ansible/install/repo/pip`
- `sudo mkdir /mpfdata/ansible/install/repo/tars`
- `sudo mkdir /mpfdata/releases`
- `sudo chown -R mpf:mpf /mpfdata`

## Build the Open Source OpenMPF Package

Follow the instructions in the **Build the OpenMPF Package** section below. Use the following values:

#### `<cppComponents>`

`mogMotionComponent,ocvFaceComponent,dlibComponent,caffeComponent,oalprTextComponent,ocvPersonComponent`

#### `<configFile>`

`./config_files/mpf-open-source-package.json`

## Build the OpenMPF Package

> **NOTE:** If your build environment is behind a proxy server, please read the appendix section **[Proxy Configuration](https://github.com/openmpf/openmpf/wiki/Build-Environment-Setup-Guide#proxy-configuration)**  for instructions to configure Maven before continuing.

1. Remove the development properties file:
    - `cd /home/mpf/mpf`
    - `rm -f trunk/workflow-manager/src/main/resources/properties/mpf-private.properties`
2. Run the Maven clean package command with the `create-tar` profile and the `rpm:rpm` goal. This will compile the code artifacts, place them in the local maven repository, and create the necessary component RPMs and tar files.
    - `cd /home/mpf/mpf`
    - `mvn package -Pcreate-tar rpm:rpm -Dmaven.test.skip=true -DskipITs -Dmaven.tomcat.skip=true -DgitBranch=master -DcppComponents=<cppComponents>`

 Note that the order of components in the `-DcppComponents` list is important. Components will be registered in that order. For example, since the OCV face detection component descriptor file depends on MOG motion preprocessor actions, the MOG motion detection component should appear before the OCV face detection component in the list.
3. After the build is complete, the final package is created by running the Perl script `CreateCustomPackage.pl`:
    - `cd /home/mpf/mpf/trunk/jenkins/scripts`
    - `perl CreateCustomPackage.pl /home/mpf/mpf master 0 <configFile>`
4. The package `mpf-complete-0.8.0+master-0.tar.gz` will be under `/mpfdata/releases/`.
5. (Optional) Copy the development properties file back if you wish to run the OpenMPF on the OpenMPF Build VM:
    - `cp /home/mpf/mpf/trunk/workflow-manager/src/main/resources/properties/mpf-private-example.properties /home/mpf/mpf/trunk/workflow-manager/src/main/resources/properties/mpf-private.properties`

# (Optional) Testing the OpenMPF

> **NOTE:** If your build environment is behind a proxy server, please read the appendix section **[Proxy Configuration](https://github.com/openmpf/openmpf/wiki/Build-Environment-Setup-Guide#proxy-configuration)**  for instructions to configure Firefox before continuing.

Run these commands to build the OpenMPF and run the integration tests:

- `cd /home/mpf/mpf`
- Copy the development properties file into place:

  `cp trunk/workflow-manager/src/main/resources/properties/mpf-private-example.properties trunk/workflow-manager/src/main/resources/properties/mpf-private.properties`

- Open the file `/etc/ansible/hosts` in a text editor. `sudo` is required to edit this file.
- If they do not already exist, add these two lines above `# Ex 1: Ungrouped hosts, specify before any group headers.` (line 11):

```
  [mpf-child]
  localhost.localdomain
```

- Save and close the file.
- `mvn clean install -DskipTests -Dmaven.test.skip=true -DskipITs -Dmaven.tomcat.skip=true -DcppComponents=<cppComponents>`
- `sudo cp /home/mpf/mpf/trunk/install/libexec/node-manager /etc/init.d/`
- `sudo systemctl daemon-reload`
- `mpf start --xtc` (This command will start ActiveMQ, MySQL, Redis, and node-manager; not Tomcat.)
- `mvn verify -DcppComponents=<cppComponents> -Dtransport.guarantee='NONE' -Dweb.rest.protocol='http'`
- `mpf stop --xtc` (This command will stop node-manager, Redis, MySQL, and ActiveMQ; not Tomcat.)

> **NOTE:** Please see the appendix section **Known Issues** regarding any `java.lang.InterruptedException: null` warning log messages observed when running the tests.

# (Optional) Building and running the web application

> **NOTE:** If your build environment is behind a proxy server, please read the appendix section **[Proxy Configuration](https://github.com/openmpf/openmpf/wiki/Build-Environment-Setup-Guide#proxy-configuration)**  for instructions to configure Firefox before continuing.

Run these commands to build the OpenMPF and launch the web application:

- `cd /home/mpf/mpf`
- Copy the development properties file into place:
    - `cp trunk/workflow-manager/src/main/resources/properties/mpf-private-example.properties trunk/workflow-manager/src/main/resources/properties/mpf-private.properties`
- Open the file `/etc/ansible/hosts` in a text editor. `sudo` is required to edit this file.
- If they do not already exist, add these two lines above `# Ex 1: Ungrouped hosts, specify before any group headers.` (line 11):

```
  [mpf-child]
  localhost.localdomain
```

- Save and close the file.
- `mvn clean install -DskipTests -Dmaven.test.skip=true -DskipITs -Dmaven.tomcat.skip=true -DcppComponents=<cppComponents>`
- `cd /home/mpf/mpf/trunk/workflow-manager`
- `rm -rf /opt/apache-tomcat/webapps/workflow-manager*`
- `cp target/workflow-manager.war /opt/apache-tomcat/webapps/workflow-manager.war`
- `cd ../..`
- `sudo cp trunk/install/libexec/node-manager /etc/init.d/`
- `sudo systemctl daemon-reload`
- `mpf start`

The web application should start running in the background as a daemon. Look for this log message in the Tomcat log (`/opt/apache-tomcat/logs/catalina.out`) with a time value indicating the workflow-manager has finished starting:

```
INFO: Server startup in 39030 ms
```

After startup, the workflow-manager will be available at <http://localhost:8080/workflow-manager>. Connect to this URL with FireFox. Chrome is also supported, but is not pre-installed on the VM.

If you want to test regular user capabilities, log in as 'mpf'. Please see the (TODO: insert working link) [User Guide](insert-link-here) for more information. Alternatively, if you want to test admin capabilities then log in as 'admin'. Please see the (TODO: insert working link) [Admin Manual](insert-link-here) for more information. When finished testing using the browser (or other external clients), go back to the terminal window used to launch Tomcat and enter the stop command `mpf stop`.

> **NOTE:** Through the use of port forwarding, the workflow-manager can also be accessed from your guest operating system. Please see the Virtual Box documentation <https://www.virtualbox.org/manual/ch06.html#natforward> for configuring port forwarding.

The preferred method to start and stop services for OpenMPF is with the `mpf start` and `mpf stop` commands. For additional information on these commands, please see the (TODO: insert working link) [Command Line Tools](insert-link-here) section of the (TODO: insert working link) [Admin Manual](insert-link-here). These will start and stop ActiveMQ, MySQL, Redis, node-manager, and Tomcat, respectively. Alternatively, to perform these actions manually, the following commands can be used in a terminal window:

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

# Deploying the OpenMPF

Please see the (TODO: insert working link) [Installation Guide](insert-link-here).

---

# **Appendices**

# Known Issues

The following are known issues that are related to setting up and running the OpenMPF on a build VM. For a more complete list of known issues, please see the (TODO: insert working link) [Release Notes](insert-link-here).

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

When installing the OpenMPF on multiple nodes, an NTP service should be set up on each of the systems in the cluster so that their times are synchronized. Otherwise, the log viewer may behave incorrectly when it updates in real time.

# Proxy Configuration

**Yum Package Manager Proxy Configuration**

Before using the yum package manager,  it may be necessary to configure it to work with your environment's proxy settings. If credentials are not required, it is not necessary to add them to the yum configuration.

- `sudo bash -c 'echo "proxy=<address>:<port>" >> /etc/yum.conf'`
- `sudo bash -c 'echo "proxy_username=<username>" >> /etc/yum.conf'`
- `sudo bash -c 'echo "proxy_password=<password>" >> /etc/yum.conf'`

**Proxy Environment Variables**

If your build environment is behind a proxy server, some applications and tools will need to be configured to use it. To configure an HTTP and HTTPS proxy, run the following commands. If credentials are not required, leave those fields blank.

- `sudo bash -c 'echo "export http_proxy=<username>:<password>@<url>:<port>" >> /etc/profile.d/mpf.sh`
- `. /etc/profile.d/mpf.sh`
- `sudo bash -c 'echo "export https_proxy='${http_proxy}'" >> /etc/profile.d/mpf.sh'`
- `sudo bash -c 'echo "export HTTP_PROXY='${http_proxy}'" >> /etc/profile.d/mpf.sh'`
- `sudo bash -c 'echo "export HTTPS_PROXY='${http_proxy}'" >> /etc/profile.d/mpf.sh'`
- `. /etc/profile.d/mpf.sh`

**Git Proxy Configuration**

If your build environment is behind a proxy server, git will need to be configured to use it. The following command will set the git global proxy. If the environment variable `$http_proxy` is not set, use the full proxy server address, port, and credentials (if needed).

- `git config --global http.proxy $http_proxy`

**Firefox Proxy Configuration**

Before running the integration tests and the web application, it may be necessary to configure Firefox with your environment's proxy settings.

- In a new terminal window, type `firefox` and press enter. This will launch a new Firefox window.
- In the new Firefox window, enter `about:preferences#advanced` in the URL text box and press enter.
- In the left sidebar click 'Advanced', then click the `Network` tab, and in the `Connection` section press the 'Settings...' button.
- Enter the proxy settings for your environment.
- In the 'No Proxy for:' text box, verify that `localhost` is included.
- Press the 'OK' button.
- Close all open Firefox instances.

**Maven Proxy Configuration**

Before using Maven, it may be necessary to configure it to work with your environment's proxy settings. Open a new terminal window and run these commands. Afterwards, continue with adding the additional maven dependencies.

- `cd /home/mpf`
- `mkdir -p .m2`
- `cp /opt/apache-maven/conf/settings.xml .m2/`
- Open the file `.m2/settings.xml` in a text editor.
- Navigate to the `<proxies>` section (line 85).
- There is a commented-out example proxy server specification. Copy and paste the example specification below the commented-out section, but before the end of the closing `</proxies>` tag.
- Fill in your environment's proxy server information. For additional help and information, please see the Apache Maven guide to configuring a proxy server at <https://maven.apache.org/guides/mini/guide-proxies.html>.

# SSL Inspection

If your build environment is behind a proxy server that performs SSL inspection, some applications and tools will need to be configured to accommodate it. The following steps will add trusted certificates to the OpenMPF VM.

Additional information on Java keytool can be found at <https://docs.oracle.com/javase/8/docs/technotes/tools/unix/keytool.html>.

- Download any certificates needed for using SSL in your build environment to `/home/mpf/Downloads`.
- Verify that `$JAVA_HOME` is set correctly.
    - Running this command: `echo $JAVA_HOME` should produce this output: `/usr/java/latest`
- For each certificate, run this command, filling in the values for certificate alias, certificate name, and keystore passphrase:
    - `sudo $JAVA_HOME/bin/keytool -import -alias <certificate alias> -file /home/mpf/Downloads/<certificate name>.crt -keystore "$JAVA_HOME/jre/lib/security/cacerts" -storepass <keystore passphrase> -noprompt`
- For each certificate, run this command, filling in the value for certificate name:
    - `sudo cp /home/mpf/Downloads/<certificate name>.crt /tmp`
- For each certificate, run this command, filling in the values for certificate name:
    - `sudo -u root -H sh -c "openssl x509 -in /tmp/<certificate name>.crt    -text > /etc/pki/ca-trust/source/anchors/<certificate name>.pem"`
- Run these commands once:
    - `sudo -u root -H sh -c "update-ca-trust enable"`
    - `sudo -u root -H sh -c "update-ca-trust extract"`
- Run these commands once, filling in the value for the root certificate name:
    - `sudo cp /etc/pki/tls/certs/ca-bundle.crt /etc/pki/tls/certs/ca-bundle.crt.original`
    - `sudo -u root -H sh -c "cat /etc/pki/ca-trust/source/anchors/<root certificate name>.pem >> /etc/pki/tls/certs/ca-bundle.crt"`

Alternatively, if adding certificates is not an option or difficulties are encountered, you may optionally skip SSL certificate verification for these tools. This is not recommended:

**wget**

- `cd /home/mpf`
- `touch /home/mpf/.wgetrc`
- In a text editor, open the file `/home/mpf/.wgetrc`
- Add this line:

```
  check_certificate=off
```

- Save and close the file.
- `. /home/mpf/.wgetrc`

**git**

- `cd /home/mpf`
- `git config http.sslVerify false`
- `git config --global http.sslVerify false`

**maven**

- In a text editor, open the file `/etc/profile.d/mpf.sh`
- At the bottom of the file, add this line:

```
  export MAVEN_OPTS="-Dmaven.wagon.http.ssl.insecure=true -Dmaven.wagon.http.ssl.allowall=true -Dmaven.wagon.http.ssl.ignore.validity.dates=true"
```

- Save and close the file.
- `. /etc/profile.d/mpf.sh`

# Third-party RPMs, Tars, and Python Pip packages included with an OpenMPF Package

As with the OpenMPF Build VM, the OpenMPF deployment package is targeted for a minimal install of CentOS 7. The **[Package Lists](https://github.com/openmpf/openmpf/wiki/Build-Environment-Setup-Guide#package-lists)** section below lists required third-party dependencies that are packaged with the OpenMPF installation files by the `CreateCustomPackage.pl` script. Depending on which dependencies are already installed on your target system(s), some or all of these dependencies may not be needed. The script will only add the dependencies present in the `/mpfdata/ansible/install/repo/` directory to the package.

The following commands can be used to populate the dependency packages into the `/mpfdata/ansible/install/repo` directory:

- `cd /mpfdata/ansible/install/repo/rpms/management`
- `sudo yumdownloader adwaita-cursor-theme adwaita-icon-theme at-spi2-atk at-spi2-core cairo-gobject colord-libs createrepo deltarpm ebtables firewalld gcc glibc glibc-common glibc-devel glibc-headers gtk3 httpd httpd-tools json-glib kernel-headers lcms2 libffi-devel libgusb libmng libselinux-python libtomcrypt libtommath libXevie libxml2 libxml2-python libXtst libyaml mailcap mpfr openssh openssh-askpass openssh-clients openssh-server pciutils py-bcrypt python python2-crypto python-babel python-backports python-backports-ssl_match_hostname python-cffi python-chardet python-crypto python-deltarpm python-devel python-ecdsa python-httplib2 python-jinja2 python-keyczar python-kitchen python-libs python-markupsafe python-paramiko python-passlib python-pip python-ply python-ptyprocess python-pyasn1 python-pycparser python-setuptools python-simplejson python-six python-slip python-slip-dbus PyYAML qt qt-settings qt-x11 rest sshpass yum-utils    --archlist=x86_64`
- `sudo rm ./*i686*`
- `cd /mpfdata/ansible/install/repo/rpms/mpf-deps`
- `sudo yumdownloader apr apr-util apr-util-ldap atk cairo cdparanoia-libs cpp cups-libs fontconfig fontpackages-filesystem gdk-pixbuf2 graphite2 gsm gstreamer gstreamer1 gstreamer1-plugins-base gstreamer-plugins-base gstreamer-tools gtk2 gtk3 harfbuzz hicolor-icon-theme iso-codes jasper-libs jbigkit-libs jemalloc libdc1394 libICE libjpeg-turbo libmng libmpc libogg libpng libraw1394 libSM libthai libtheora libtiff libusbx libv4l libvisual libvorbis libvpx libX11 libX11-common libXau libxcb libXcomposite libXcursor libXdamage libXext libXfixes libXft libXi libXinerama libxml2 libXrandr libXrender libxshmfence libXv libXxf86vm log4cxx mesa-libEGL mesa-libgbm mesa-libGL mesa-libglapi mesa-libGLU mysql-community-client mysql-community-common mysql-community-libs mysql-community-server mysql-connector-python MySQL-python net-tools openjpeg-libs openssh openssh-clients openssh-server opus orc pango perl perl-Carp perl-Compress-Raw-Bzip2 perl-Compress-Raw-Zlib perl-constant perl-Data-Dumper perl-DBD-MySQL perl-DBI perl-Encode perl-Exporter perl-File-Path perl-File-Temp perl-Filter perl-Getopt-Long perl-HTTP-Tiny perl-IO-Compress perl-libs perl-macros perl-Net-Daemon perl-parent perl-PathTools perl-PlRPC perl-Pod-Escapes perl-podlators perl-Pod-Perldoc perl-Pod-Simple perl-Pod-Usage perl-Scalar-List-Utils perl-Socket perl-Storable perl-Text-ParseWords perl-threads perl-threads-shared perl-Time-HiRes perl-Time-Local pixman redis SDL speex unzip xml-common --archlist=x86_64`
- `sudo rm ./*i686*`
- `cp /apps/source/ansible_sources/ansible/rpm-build/ansible-*.noarch.rpm /mpfdata/ansible/install/repo/rpms/management/`
- `wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.rpm" -O /mpfdata/ansible/install/repo/rpms/mpf-deps/jdk-8u60-linux-x64.rpm`
- Download jre-8u60-linux-x64.rpm and place it in `/mpfdata/ansible/install/repo/rpms/mpf-deps` : <http://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html#jre-8u60-oth-JPR>
    - **NOTE:** Oracle may require an account to download archived versions of the JRE.
- `wget -O /mpfdata/ansible/install/repo/tars/apache-activemq-5.13.0-bin.tar.gz "https://archive.apache.org/dist/activemq/5.13.0/apache-activemq-5.13.0-bin.tar.gz"`
- `wget -O /mpfdata/ansible/install/repo/tars/apache-tomcat-7.0.72.tar.gz "http://archive.apache.org/dist/tomcat/tomcat-7/v7.0.72/bin/apache-tomcat-7.0.72.tar.gz"`
- `wget -O /mpfdata/ansible/install/repo/tars/ffmpeg-git-64bit-static.tar.xz "http://johnvansickle.com/ffmpeg/builds/ffmpeg-git-64bit-static.tar.xz"`
- `cd /mpfdata/ansible/install/repo/pip`
- `pip install --download . argcomplete argh bcrypt cffi pycparser PyMySQL six`

## Package Lists

- **/mpfdata/ansible/install/repo/rpms/management**
    - adwaita-cursor-theme-3.14.1-1.el7.noarch.rpm
    - adwaita-icon-theme-3.14.1-1.el7.noarch.rpm
    - ansible-2.1.1.0-0.git201608081816.e71cce7.HEAD.el7.centos.noarch.rpm
    - at-spi2-atk-2.8.1-4.el7.x86_64.rpm
    - at-spi2-core-2.8.0-6.el7.x86_64.rpm
    - cairo-gobject-1.14.2-1.el7.x86_64.rpm
    - colord-libs-1.2.7-2.el7.x86_64.rpm
    - createrepo-0.9.9-25.el7_2.noarch.rpm
    - deltarpm-3.6-3.el7.x86_64.rpm
    - ebtables-2.0.10-13.el7.x86_64.rpm
    - firewalld-0.3.9-14.el7.noarch.rpm
    - gcc-4.8.5-4.el7.x86_64.rpm
    - glibc-2.17-106.el7_2.6.i686.rpm
    - glibc-2.17-106.el7_2.6.x86_64.rpm
    - glibc-common-2.17-106.el7_2.6.x86_64.rpm
    - glibc-devel-2.17-106.el7_2.4.x86_64.rpm
    - glibc-devel-2.17-106.el7_2.6.i686.rpm
    - glibc-devel-2.17-106.el7_2.6.x86_64.rpm
    - glibc-headers-2.17-106.el7_2.4.x86_64.rpm
    - glibc-headers-2.17-106.el7_2.6.x86_64.rpm
    - gtk3-3.14.13-16.el7.x86_64.rpm
    - httpd-2.4.6-40.el7.centos.x86_64.rpm
    - httpd-tools-2.4.6-40.el7.centos.x86_64.rpm
    - json-glib-1.0.2-1.el7.x86_64.rpm
    - kernel-headers-3.10.0-327.13.1.el7.x86_64.rpm
    - lcms2-2.6-2.el7.x86_64.rpm
    - libffi-devel-3.0.13-16.el7.x86_64.rpm
    - libgusb-0.1.6-3.el7.x86_64.rpm
    - libmng-1.0.10-14.el7.x86_64.rpm
    - libselinux-python-2.2.2-6.el7.x86_64.rpm
    - libtomcrypt-1.17-23.el7.x86_64.rpm
    - libtommath-0.42.0-4.el7.x86_64.rpm
    - libXevie-1.0.3-7.1.el7.x86_64.rpm
    - libxml2-2.9.1-6.el7_2.3.x86_64.rpm
    - libxml2-python-2.9.1-6.el7_2.3.x86_64.rpm
    - libXtst-1.2.2-2.1.el7.x86_64.rpm
    - libyaml-0.1.4-11.el7_0.x86_64.rpm
    - mailcap-2.1.41-2.el7.noarch.rpm
    - mpfr-3.1.1-4.el7.x86_64.rpm
    - openssh-6.6.1p1-23.el7_2.x86_64.rpm
    - openssh-askpass-6.6.1p1-23.el7_2.x86_64.rpm
    - openssh-clients-6.6.1p1-23.el7_2.x86_64.rpm
    - openssh-server-6.6.1p1-23.el7_2.x86_64.rpm
    - pciutils-3.2.1-4.el7.x86_64.rpm
    - py-bcrypt-0.4-4.el7.x86_64.rpm
    - python-2.7.5-39.el7_2.x86_64.rpm
    - python2-crypto-2.6.1-9.el7.x86_64.rpm
    - python-babel-0.9.6-8.el7.noarch.rpm
    - python-backports-1.0-8.el7.x86_64.rpm
    - python-backports-ssl_match_hostname-3.4.0.2-4.el7.noarch.rpm
    - python-cffi-0.8.6-2.el7.x86_64.rpm
    - python-chardet-2.2.1-1.el7_1.noarch.rpm
    - python-crypto-2.6.1-1.el7.centos.x86_64.rpm
    - python-deltarpm-3.6-3.el7.x86_64.rpm
    - python-devel-2.7.5-34.el7.x86_64.rpm
    - python-ecdsa-0.11-3.el7.centos.noarch.rpm
    - python-httplib2-0.7.7-3.el7.noarch.rpm
    - python-jinja2-2.7.2-2.el7.noarch.rpm
    - python-keyczar-0.71c-2.el7.noarch.rpm
    - python-kitchen-1.1.1-5.el7.noarch.rpm
    - python-libs-2.7.5-39.el7_2.x86_64.rpm
    - python-markupsafe-0.11-10.el7.x86_64.rpm
    - python-paramiko-1.15.1-1.el7.noarch.rpm
    - python-passlib-1.6.2-2.el7.noarch.rpm
    - python-pip-7.1.0-1.el7.noarch.rpm
    - python-ply-3.4-10.el7.noarch.rpm
    - python-ptyprocess-0.5-1.el7.noarch.rpm
    - python-pyasn1-0.1.6-2.el7.noarch.rpm
    - python-pycparser-2.14-1.el7.noarch.rpm
    - python-setuptools-0.9.8-4.el7.noarch.rpm
    - python-simplejson-3.3.3-1.el7.x86_64.rpm
    - python-six-1.9.0-2.el7.noarch.rpm
    - python-slip-0.4.0-2.el7.noarch.rpm
    - python-slip-dbus-0.4.0-2.el7.noarch.rpm
    - PyYAML-3.10-11.el7.x86_64.rpm
    - qt-4.8.5-12.el7_2.i686.rpm
    - qt-4.8.5-12.el7_2.x86_64.rpm
    - qt-settings-19-23.5.el7.centos.noarch.rpm
    - qt-x11-4.8.5-12.el7_2.x86_64.rpm
    - rest-0.7.92-3.el7.x86_64.rpm
    - sshpass-1.05-5.el7.x86_64.rpm
    - yum-utils-1.1.31-34.el7.noarch.rpm

- **/mpfdata/ansible/install/repo/rpms/mpf-deps**
    - apr-1.4.8-3.el7.x86_64.rpm
    - apr-util-1.5.2-6.el7.x86_64.rpm
    - apr-util-ldap-1.5.2-6.el7.x86_64.rpm
    - atk-2.14.0-1.el7.x86_64.rpm
    - cairo-1.14.2-1.el7.x86_64.rpm
    - cdparanoia-libs-10.2-17.el7.x86_64.rpm
    - cpp-4.8.5-4.el7.x86_64.rpm
    - cups-libs-1.6.3-22.el7.x86_64.rpm
    - fontconfig-2.10.95-7.el7.x86_64.rpm
    - fontpackages-filesystem-1.44-8.el7.noarch.rpm
    - gdk-pixbuf2-2.31.6-3.el7.x86_64.rpm
    - graphite2-1.2.2-5.el7.x86_64.rpm
    - gsm-1.0.13-11.el7.x86_64.rpm
    - gstreamer-0.10.36-7.el7.x86_64.rpm
    - gstreamer1-1.4.5-1.el7.x86_64.rpm
    - gstreamer1-plugins-base-1.4.5-2.el7.x86_64.rpm
    - gstreamer-plugins-base-0.10.36-10.el7.x86_64.rpm
    - gstreamer-tools-0.10.36-7.el7.x86_64.rpm
    - gtk2-2.24.28-8.el7.x86_64.rpm
    - gtk3-3.14.13-16.el7.x86_64.rpm
    - harfbuzz-0.9.36-1.el7.x86_64.rpm
    - hicolor-icon-theme-0.12-7.el7.noarch.rpm
    - iso-codes-3.46-2.el7.noarch.rpm
    - jasper-libs-1.900.1-29.el7.x86_64.rpm
    - jbigkit-libs-2.0-11.el7.x86_64.rpm
    - jdk-8u60-linux-x64.rpm
    - jemalloc-3.6.0-1.el7.x86_64.rpm
    - jre-8u60-linux-x64.rpm
    - libdc1394-2.2.2-3.el7.x86_64.rpm
    - libICE-1.0.9-2.el7.x86_64.rpm
    - libjpeg-turbo-1.2.90-5.el7.x86_64.rpm
    - libmng-1.0.10-14.el7.x86_64.rpm
    - libmpc-1.0.1-3.el7.x86_64.rpm
    - libogg-1.3.0-7.el7.x86_64.rpm
    - libpng-1.5.13-7.el7_2.x86_64.rpm
    - libraw1394-2.1.0-2.el7.x86_64.rpm
    - libSM-1.2.2-2.el7.x86_64.rpm
    - libthai-0.1.14-9.el7.x86_64.rpm
    - libtheora-1.1.1-8.el7.x86_64.rpm
    - libtiff-4.0.3-14.el7.x86_64.rpm
    - libusbx-1.0.15-4.el7.x86_64.rpm
    - libv4l-0.9.5-4.el7.x86_64.rpm
    - libvisual-0.4.0-16.el7.x86_64.rpm
    - libvorbis-1.3.3-8.el7.x86_64.rpm
    - libvpx-1.3.0-5.el7_0.x86_64.rpm
    - libX11-1.6.3-2.el7.x86_64.rpm
    - libX11-common-1.6.3-2.el7.noarch.rpm
    - libXau-1.0.8-2.1.el7.x86_64.rpm
    - libxcb-1.11-4.el7.x86_64.rpm
    - libXcomposite-0.4.4-4.1.el7.x86_64.rpm
    - libXcursor-1.1.14-2.1.el7.x86_64.rpm
    - libXdamage-1.1.4-4.1.el7.x86_64.rpm
    - libXext-1.3.3-3.el7.x86_64.rpm
    - libXfixes-5.0.1-2.1.el7.x86_64.rpm
    - libXft-2.3.2-2.el7.x86_64.rpm
    - libXi-1.7.4-2.el7.x86_64.rpm
    - libXinerama-1.1.3-2.1.el7.x86_64.rpm
    - libxml2-2.9.1-6.el7_2.2.x86_64.rpm
    - libXrandr-1.4.2-2.el7.x86_64.rpm
    - libXrender-0.9.8-2.1.el7.x86_64.rpm
    - libxshmfence-1.2-1.el7.x86_64.rpm
    - libXv-1.0.10-2.el7.x86_64.rpm
    - libXxf86vm-1.1.3-2.1.el7.x86_64.rpm
    - log4cxx-0.10.0-16.el7.x86_64.rpm
    - mesa-libEGL-10.6.5-3.20150824.el7.x86_64.rpm
    - mesa-libgbm-10.6.5-3.20150824.el7.x86_64.rpm
    - mesa-libGL-10.6.5-3.20150824.el7.x86_64.rpm
    - mesa-libglapi-10.6.5-3.20150824.el7.x86_64.rpm
    - mesa-libGLU-9.0.0-4.el7.x86_64.rpm
    - mysql-community-client-5.6.28-2.el7.x86_64.rpm
    - mysql-community-common-5.6.28-2.el7.x86_64.rpm
    - mysql-community-libs-5.6.28-2.el7.x86_64.rpm
    - mysql-community-server-5.6.28-2.el7.x86_64.rpm
    - mysql-connector-python-1.1.6-1.el7.noarch.rpm
    - mysql-connector-python-2.1.3-1.el7.x86_64.rpm
    - MySQL-python-1.2.3-11.el7.x86_64.rpm
    - net-tools-2.0-0.17.20131004git.el7.x86_64.rpm
    - openjpeg-libs-1.5.1-10.el7.x86_64.rpm
    - openssh-6.6.1p1-25.el7_2.x86_64.rpm
    - openssh-clients-6.6.1p1-25.el7_2.x86_64.rpm
    - openssh-server-6.6.1p1-25.el7_2.x86_64.rpm
    - opus-1.0.2-6.el7.x86_64.rpm
    - orc-0.4.22-5.el7.x86_64.rpm
    - pango-1.36.8-2.el7.x86_64.rpm
    - perl-5.16.3-286.el7.x86_64.rpm
    - perl-Carp-1.26-244.el7.noarch.rpm
    - perl-Compress-Raw-Bzip2-2.061-3.el7.x86_64.rpm
    - perl-Compress-Raw-Zlib-2.061-4.el7.x86_64.rpm
    - perl-constant-1.27-2.el7.noarch.rpm
    - perl-Data-Dumper-2.145-3.el7.x86_64.rpm
    - perl-DBD-MySQL-4.023-5.el7.x86_64.rpm
    - perl-DBI-1.627-4.el7.x86_64.rpm
    - perl-Encode-2.51-7.el7.x86_64.rpm
    - perl-Exporter-5.68-3.el7.noarch.rpm
    - perl-File-Path-2.09-2.el7.noarch.rpm
    - perl-File-Temp-0.23.01-3.el7.noarch.rpm
    - perl-Filter-1.49-3.el7.x86_64.rpm
    - perl-Getopt-Long-2.40-2.el7.noarch.rpm
    - perl-HTTP-Tiny-0.033-3.el7.noarch.rpm
    - perl-IO-Compress-2.061-2.el7.noarch.rpm
    - perl-libs-5.16.3-286.el7.x86_64.rpm
    - perl-macros-5.16.3-286.el7.x86_64.rpm
    - perl-Net-Daemon-0.48-5.el7.noarch.rpm
    - perl-parent-0.225-244.el7.noarch.rpm
    - perl-PathTools-3.40-5.el7.x86_64.rpm
    - perl-PlRPC-0.2020-14.el7.noarch.rpm
    - perl-Pod-Escapes-1.04-286.el7.noarch.rpm
    - perl-podlators-2.5.1-3.el7.noarch.rpm
    - perl-Pod-Perldoc-3.20-4.el7.noarch.rpm
    - perl-Pod-Simple-3.28-4.el7.noarch.rpm
    - perl-Pod-Usage-1.63-3.el7.noarch.rpm
    - perl-Scalar-List-Utils-1.27-248.el7.x86_64.rpm
    - perl-Socket-2.010-3.el7.x86_64.rpm
    - perl-Storable-2.45-3.el7.x86_64.rpm
    - perl-Text-ParseWords-3.29-4.el7.noarch.rpm
    - perl-threads-1.87-4.el7.x86_64.rpm
    - perl-threads-shared-1.43-6.el7.x86_64.rpm
    - perl-Time-HiRes-1.9725-3.el7.x86_64.rpm
    - perl-Time-Local-1.2300-2.el7.noarch.rpm
    - pixman-0.32.6-3.el7.x86_64.rpm
    - redis-3.0.5-1.el7.remi.x86_64.rpm
    - SDL-1.2.15-14.el7.x86_64.rpm
    - speex-1.2-0.19.rc1.el7.x86_64.rpm
    - unzip-6.0-15.el7.x86_64.rpm
    - xml-common-0.6.3-39.el7.noarch.rpm

- **/mpfdata/ansible/install/repo/tars**
    - apache-activemq-5.13.0-bin.tar.gz
    - apache-tomcat-7.0.72.tar.gz
    - ffmpeg-git-64bit-static.tar.xz

- **/mpfdata/ansible/install/repo/pip**
    - argcomplete-1.1.1-py2.py3-none-any.whl
    - argh-0.26.1.tar.gz
    - bcrypt-2.0.0.tar.gz
    - cffi-1.6.0.tar.gz
    - pycparser-2.14.tar.gz
    - PyMySQL-0.7.2-py2.py3-none-any.whl
    - six-1.10.0-py2.py3-none-any.whl

# Build and Test Environment

When developing for the OpenMPF, you may find the following collaboration and continuous integration tools helpful.

**Jenkins**

<https://jenkins.io>

**Phabricator**

<https://www.phacility.com/phabricator/>