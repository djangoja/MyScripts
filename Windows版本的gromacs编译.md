---
toc: true
title: Windows版本的gromacs编译
date: 2018-01-30 22:59:12
tags: Gromacs
id: 15
---
**A brief introduction of windows gromacs compiled by Visual Studio**
<!--more-->

## Software preparation
|[Visual Studio Community 2017](https://www.microsoft.com/zh-cn/download)|[CMake](https://cmake.org/)|
|:-:|:-:|
|[Intel Parallel Studio XE 2019](https://software.intel.com/en-us/parallel-studio-xe)|[CUDA Toolkit](https://developer.nvidia.com/cuda-downloads)|
|[GROMACS 2016.X/2018.X/2019.X](http://www.gromacs.org/)|[Cmder](https://cmder.net/)|

## CMake usage
Firstly, you should unpack installation package of gromacs, then, choosing the path of 'Where is the source code' and 'Where is build the binaries'. Next, click `Configure` button, then we choose 'Visual Studio 15 2017 Win64' option by drop-down list and using default native compliers(cl). If you use other VS version, you need match the corresponding option. The figure as follow:
{% asset_img 1.jpg %}
Clicking `Finish` button, waiting...,, then some errors may occur, a common error is 'Cannot find FFTW 3'. Here, you are able to assign the path of MKL include and MKL library after choosing GMX_FFT_LIBRARY to `MKL`. For example, as follow:
**include:**

```
D:/IntelSWTools/compilers_and_libraries_2016.4.246/windows/mkl/include
```
**library:**
```
D:/IntelSWTools/compilers_and_libraries_2016.4.246/windows/mkl/lib/intel64_win/mkl_core.lib;D:/IntelSWTools/compilers_and_libraries_2016.4.246/windows/mkl/lib/intel64_win/mkl_intel_ilp64.lib;D:/IntelSWTools/compilers_and_libraries_2016.4.246/windows/mkl/lib/intel64_win/mkl_sequential.lib;D:/IntelSWTools/compilers_and_libraries_2016.4.246/windows/mkl/lib/intel64_win/mkl_intel_thread.lib;D:/IntelSWTools/compilers_and_libraries_2016.4.246/windows/compiler/lib/intel64_win/libiomp5md.lib
```
GPU is optional, if you want to compile GPU version, you should open the option of GMX_GPU to ON. Next, re-clicking `Configure` button until you pass cmake or no error, now you can click `Generate` button.
**<font color="#FF0000" size=4>Note:</font>** I don't recommend you use CMake version 3.14, because some error will occur. You can find it in [this website](https://redmine.gromacs.org/issues/2927), I was also in trouble while using 3.14 version.

## VS usage

Open **Gromacs.sln** file in your build path, then choosing `Release` option on toolbar. You should right click on `gmx` solution to choose `Use Intel C++`. Finally, right click again to choose `build` option, now we need wait a long until finish. Then, you can right click `INSTALL` solution to install compiled .exe file to default path(you can find it in **C:/Program Files/Gromacs** folder).

## Finish and usage
You can find the below file after compiling finish.
{% asset_img 2.jpg %}
After setting up correct environment variable on windows, you can use it as below:
{% asset_img 1.gif %}

<font color="#FF0000" size=4>Questions:</font>
I found that the GPU version of GROMACS 5.X could be compiled successfully, but GROMACS 2016/2018.X version only could compile CPU version, not GPU version. It reminds error information `error : identifier "c_oneSixth" is undefined,...`, it also was found in [this website](https://mailman-1.sys.kth.se/pipermail/gromacs.org_gmx-developers/2016-December/009424.html). I can not find a good way to solve this question.

## Supplements（2018.2.6）
## The usage of CMake command-line
### Compiling 2016.4-CPU version
```
cmake .. E:/User-software/gromacs-2016.4 -G "Visual Studio 15 2017 Win64" -DCMAKE_BUILD_TYPE=Release  -DCMAKE_EXE_LINKER_FLAGS=\"/machine:x64\" -DCMAKE_INSTALL_PREFIX=E:\User-software\gromacs -DGMX_COMPILER_WARNINGS=ON -DGMX_DEFAULT_SUFFIX=OFF -DGMX_FFT_LIBRARY=mkl -DMKL_INCLUDE_DIR="D:\IntelSWTools\compilers_and_libraries_2016\windows\mkl\include" -DMKL_LIBRARIES="D:\IntelSWTools\compilers_and_libraries_2016.4.246\windows\mkl\lib\intel64_win\mkl_core.lib;D:\IntelSWTools\compilers_and_libraries_2016.4.246\windows\mkl\lib\intel64_win\mkl_intel_lp64.lib;D:\IntelSWTools\compilers_and_libraries_2016.4.246\windows\mkl\lib\intel64_win\mkl_sequential.lib;D:\IntelSWTools\compilers_and_libraries_2016.4.246\windows\mkl\lib\intel64_win\mkl_intel_thread.lib;D:\IntelSWTools\compilers_and_libraries_2016.4.246\windows\compiler\lib\intel64_win\libiomp5md.lib" -DGMX_GPU=OFF -DGMX_USE_RDTSCP=DETECT
```
### build Gromacs.sln and install .exe to folder
```
cmake --build . --target INSTALL --config Release
```
## Supplements（2018.2.12)
### The above mentioned error that definition variable does not recognize has been solved(gromacs 2016)
**Solution one:** Reference material**[4]**. Simple note: CUDA does not recognize **static const float** that defined floating point type, you can change `const` to `__constant__` for solving it. the changed file is:
```
gromacs-2016.4/src/gromacs/mdlib/nbnxn_cuda/nbnxn_cuda_kernel_utils.cuh
```
changed it to the below:
```
static __constant__ float        c_oneSixth    = 0.16666667f;
static __constant__ float        c_oneTwelveth = 0.08333333f;
```
**Solution two:** Recently, when compiling the Windows gromacs2019.1-gpu version (the compilation process is more time-consuming than the previous version), I found that there was no the above error. When looking at the source code, I found that this section has been changed to the CUDA global variable [bug mention](https://gerrit.gromacs.org/#/c/8456/), as below:
```
static const float   __device__      c_oneSixth    = 0.16666667f;
static const float   __device__      c_oneTwelveth = 0.08333333f;
```
but also met [other question](https://www.kancloud.cn/kangdandan/book/169981)[only occur in VS2017 RTW 15.0], the final I solve it.

### The CUDA version question occurred in full series of Gromacs2018.X
When you use CMake, the error is *CUDA compiler does not seem to be functional*, but in fact CUDA is no problem. You could add Control options `GMX_NVCC_WORKS=ON` in order to skip *nvcc* detection, now cmake will pass correctly. When in the compiling process, undefined **M_PI** problem occurred, this is because the constant is not defined in the VS-related header file, the problem can be found [bug](https://gerrit.gromacs.org/#/c/8456/). The approach given by the developers is to add ``#include <math_constants.h>`` into **src/gromacs/ewald/pme-solve.cu** file and change ```M_PI``` to ```CUDART_PI_F```. It can be seen that the software compiled on different platforms is quite different. Gromacs source code has been constantly updated and improved.

### Eliminating C4819 warning（If necessary）
When you cmake, add `-Xcompiler "/wd 4819"` word into CUDA_NVCC_FLAGS

### One-click installation

Here, I have provided two simple installation scripts. If your previous software environment has been configured correctly, you can use Microsoft [MKL library](https://liuyujie714.github.io/15/mkl-gromacs.bsh) or [FFTW library](https://liuyujie714.github.io/15/fftw-gromacs.bsh) to compile CPU/GPU version of gromacs 5.x/2016.x/2018.x/2019.x.
**<font color="#FF0000" size=4>Note:</font>** MKL library is not recommended, there is no advantages compared with FFTW , and configuration is also troublesome, FFTW software is small, fast compilation; When compiling with VS, it is highly recommended to use the Intel C++ compiler instead of the C++ compiler from VS. The Intel C++ compiler maximizes the efficiency of the software.

### Improve the efficiency of compilation
We noticed that the compiling efficiency is very low by the above setting, that is gromacs is compilied via a single core of CPU. In order to improve the utilization of CPU, we need install [JOM](https://wiki.qt.io/Jom) or [Ninja](https://ninja-build.org/) on Windows, it supports the execution of multiple independent commands in parallel. It is very easy to install on Windows. Finally, you should open VS command prompt (X64) to use Cmake command the above mentioned. Here, you are supposed to replace `-G "Visual Studio 15 2017 Win64"` with `-G "NMake Makefiles JOM" or "Ninja"`. Yes! Now you will use all cores of CPU to compile gromacs by `cmake --build . --target INSTALL --config Release -j 4`, the 4 indicates your core number.

### Video Presentation
[Watching](https://v.youku.com/v_show/id_XNDIyNDYyNDE2NA==.html?spm=a2h0j.11185381.listitem_page1.5!2~A)

## Regressiontest
After installing GROMACS on Linux we usually requires simple tests. For example, you can add the `-DREGRESSIONTEST_DOWNLOAD=ON` option when you `cmake` on Linux. You can download test package on Windows, such as the 2019.3 version of http://gerrit.gromacs.org/download/regressiontests-2019.3.tar.gz. Uncompressing and executing `./gmxtest.pl all ` or `perl gmxtest.pl all` to test all cases.


## Windows x64 GROMACS with CUDA 10.0 （AVX2_256） (Only provided the latest version)
In order to use CUDA acceleration on other Windows OS with GPU, you must install **<font color="#FF0000" size=4>>=411.31</font>** driver version of GPU.

[Gromacs2020+fftw+intel_C+cuda10](https://pan.baidu.com/s/139Si08wi9Aj5jznBh9d3hg) password: **ew9f** 

## Reference
[1] [GROMACS程序编译](http://jerkwin.github.io/9999/11/01/GROMACS%E7%A8%8B%E5%BA%8F%E7%BC%96%E8%AF%91/)
[2] [How to install GROMACS in Windows without Cygwin](http://cdlc.cau.ac.kr/Gromacs/966)
[3] [I need to install GROMACS on windows 10, 64 bit system. Can anyone help me with a step by step tutorial?](https://www.researchgate.net/post/I_need_to_install_GROMACS_on_windows_10_64_bit_system_Can_anyone_help_me_with_a_step_by_step_tutorial)
[4] [Using constant in CUDA kernel: works with int, fails to compile with float](https://stackoverflow.com/questions/26443857/using-constant-in-cuda-kernel-works-with-int-fails-to-compile-with-float?noredirect=1&lq=1)
