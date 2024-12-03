**NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, and is subject to the
Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). Copyright 2024 The MITRE Corporation. All Rights Reserved.

# Introduction

A subset of OpenMPF components are capable of running on NVIDIA GPUs. GPU support is through the NVIDIA CUDA libraries 
and runtime. This guide provides information needed for new component developers that would like to use NVIDIA GPUs 
to accelerate their component processing, and for users of the existing components that provide GPU support.

# Building a Component

OpenMPF components that use GPUs are built with the NVIDIA nvcc compiler. Information about the nvcc compiler can be 
found [here](https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html). The compiler accepts a number of 
flags to optimize the code generated, and the output of the compiler is called a "fatbin", since it may contain 
versions of the CUDA code compiled for multiple GPU architectures. This section discusses the nvcc compiler flags that 
are used within OpenMPF to tell the nvcc compiler what to include in the compiled output.

The nvcc compiler can generate two types of code: ELF code for a specific GPU architecture, and PTX code, which is the 
NVIDIA virtual machine and instruction set architecture that is generated in the first phase of nvcc compilation. 
You can learn more about PTX [here](https://docs.nvidia.com/cuda/parallel-thread-execution/index.html). A fatbin may 
have one or the other type of code, or both, for one or a set of different architectures. 

OpenMPF components should be built for maximum portability across NVIDIA GPU architectures. The nvcc flags 
to accomplish this are described in this 
[table](https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html#options-for-steering-gpu-code-generation).
If you are using CMake to build the component, the compute capabilities can also be specified using the target property
`CUDA_ARCHITECTURES`, which is documented [here](https://cmake.org/cmake/help/latest/prop_tgt/CUDA_ARCHITECTURES.html#prop_tgt:CUDA_ARCHITECTURES).

# OpenCV GPU Support

In OpenMPF, OpenCV is built with CUDA support, including the CUDA Deep Neural Network library, cuDNN. C++ components
that use OpenCV CUDA support will have built-in access to it through the base C++ builder and executor Docker images, and
the above-mentioned GPU compile flags will have already been set when OpenCV was built.


> **NOTE:** Most OpenMPF GPU components are written so that they can run on the CPU only, as well as using GPU hardware. 
> If the component is built on a system that does not have the NVIDIA CUDA Toolkit installed, then the build will 
> default to compiling for the CPU. It is recommended that developers of new GPU components make every attempt to 
> follow this model, so that other users are not burdened with installing the NVIDIA CUDA Toolkit when they have no 
> plans to run on GPU hardware.
