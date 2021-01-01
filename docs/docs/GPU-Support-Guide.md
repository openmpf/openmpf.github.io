> **NOTICE:** This software (or technical data) was produced for the U.S. Government under contract, 
> and is subject to the Rights in Data-General Clause 52.227-14, Alt. IV (DEC 2007). 
> Copyright 2021 The MITRE Corporation. All Rights Reserved.

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

By default, the OpenMPF components are built for maximum portability across NVIDIA GPU architectures. The nvcc flags 
to accomplish this are described in this 
[table](https://docs.nvidia.com/cuda/cuda-compiler-driver-nvcc/index.html#options-for-steering-gpu-code-generation). 
OpenMPF uses the `-gencode` flag, with the `-arch=compute_30` and `-code=compute_30` flags. This generates PTX code 
for the minimum compute capability; at runtime, the NVIDIA driver will just-in-time compile the PTX code for the 
architecture the code is running on.

## Customizing the GPU Compile Flags

OpenMPF currently has only one GPU component, the Darknet object detection and classification component. Our testing 
with this component on a variety of NVIDIA GPU architectures has found an insignificant difference in the run time for 
different architectures using this approach, and so we have opted to provide maximum runtime portability. For any new 
components that may be developed, this may not be the case, and similar testing should be undertaken to determine the 
correct set of flags for that component. The nvcc compiler flags are configured by setting the `CUDA_NVCC_FLAGS` 
CMake variable in the individual component's CMakeLists.txt file. An example of setting `CUDA_NVCC_FLAGS` can be found 
[here](https://github.com/openmpf/openmpf-components/blob/master/cpp/DarknetDetection/darknet_lib/CMakeLists.txt).


> **NOTE:** OpenMPF GPU components are written so that they can run on the CPU only, as well as using GPU hardware. 
> If the component is built on a system that does not have the NVIDIA CUDA Toolkit installed, then the build will 
> default to compiling for the CPU. It is recommended that developers of new GPU components make every attempt to 
> follow this model, so that other users are not burdened with installing the NVIDIA CUDA Toolkit when they have no 
> plans to run on GPU hardware.
