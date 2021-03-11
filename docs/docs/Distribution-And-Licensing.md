> **NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, 
> and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). 
> Copyright 2021 The MITRE Corporation. All Rights Reserved.

Disclaimer
=====================

The Open Media Processing Framework (OpenMPF) software is provided as raw source code. This is to avoid any potential licensing issues that may arise from distributing a pre-compiled executable that is linked to dependencies that are licensed under a copyleft license or have patent restrictions. Generally, it is acceptable to build and execute software with these dependencies for non-commercial in-house use.

By distributing the OpenMPF software as raw source code the development team is able to keep most of the software clean from copyleft and patent issues so that it can be published under a more open Apache license and freely distributed to interested parties.

> **IMPORTANT:** It is the responsibility of the end users who build the OpenMPF software to abide by all of the non-commercial and re-distribution restrictions imposed by the dependencies that the OpenMPF software uses. Building OpenMPF and linking in these dependencies at build time or run time may result in creating a derivative work under the terms of the GNU General Public License. Refer to [Acknowledgements](Acknowledgements/index.html) for more information about these dependencies.

In general, it is only acceptable to use and distribute the executable form of the OpenMPF, which includes generated Docker images, "in house", which is loosely defined as internally with an organization. The OpenMPF should only be distributed to third parties in raw source code form and those parties will be responsible for creating their own executables and Docker images.


License Considerations
=====================
We are not lawyers and provide this information to the best of our ability in an attempt to honor all licensing agreements and clarify the potential responsibilities of OpenMPF users.


Software Distribution
--------------------------------
The OpenMPF Docker images are released under [GPLv2](www.gnu.org/licenses/old-licenses/gpl-2.0.html), unless otherwise stated.


### ffmpeg-devel Integration ###
The software in the Workflow Manager image, and most C++ component images, is dynamically linked with a version of OpenCV that is in turn linked with a version of ffmpeg-devel built with "`--enable-gpl --enable-nonfree --enable-libx264 --enable-libx265`". Distribution of software that includes the latter two encoders must be released under GPLv2 and cannot be used commercially without obtaining the appropriate licenses from [x264 LLC / CoreCodec](https://x264.org/) or [MulticoreWare](https://x265.org/). See [here](http://x265.org/x265-licensing-faq/) for more information.

Note that the OpenMPF core is built with, but does not require, the x264 or x265 encoders. In some cases, such as when generating video markup, users have the option to use x264, or an alternative encoder such as vp9 or mjpeg.


Usage Royalties
------------------------

### x264 and x256 Encoders ###
If someone uses a component that makes use of the x264 or x256 encoders in FFmpeg for commercial applications, then that person should obtain the appropriate licenses from [x264 LLC / CoreCodec](https://x264.org/) or [MulticoreWare](http://x265.org/), respectively.


### "h264" and "hevc" Decoders ###
FFmpeg comes bundled with its own native "h264" and "hevc" decoders, which OpenMPF may use depending on the media types provided when creating jobs. Although released under LGPL, use of these decoders for commercial applications may still require the payment of royalties to patent holders. The FFmpeg group states on their [Legal page](http://www.ffmpeg.org/legal.html):
> Q: Does FFmpeg use patented algorithms?
> A: We do not know, we are not lawyers so we are not qualified to answer this. Also we have never read patents to implement any part of FFmpeg, so even if we were qualified we could not answer it as we do not know what is patented.

> There have been cases where companies have used FFmpeg in their products. These companies found out that once you start trying to make money from patented technologies, the owners of the patents will come after their licensing fees. Notably, MPEG LA is vigilant and diligent about collecting for MPEG-related technologies.