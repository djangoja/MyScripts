#!/bin/bash
# a script for Ubuntu19.04 to install Amber18
# put Amber18.tar.bz2 and AmberTools18.tar.bz2 into same folder

# unpack Compressed packages
tar -xvf Amber18.tar.bz2 
tar -xvf AmberTools18.tar.bz2

# install some dependencies
sudo apt-get install csh flex bison patch gcc gfortran g++ make build-essential xorg-dev xutils-dev libbz2-dev zlib1g-dev -y
 
# compile amber18
sleep 5
cd amber18

# check whether there is NVIDIA graphics card
gc=`lspci | grep -i nvidia`
if [ ! -n "$gc" ]; then
	echo "You have not installed CUDA, now installing CUDA"
	wget https://developer.download.nvidia.cn/compute/cuda/repos/ubuntu1804/x86_64/cuda-10-1_10.1.105-1_amd64.deb
	sudo apt-get update -y
	sudo apt-get install cuda -y
	echo "add cuda path to .bashrc"
	echo "export PATH=\$PATH:/usr/local/cuda-10.0/bin" >> ~/.bashrc
	echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:/usr/local/cuda-10.0/lib64" >> ~/.bashrc
	source ~/.bashrc
else
	echo "You have installed CUDA"
fi


# for cpu version
# yes| ./configure gnu
# before installing gpu version, cuda must been installed.
yes| ./configure -cuda gnu

# set environment variable
source amber.sh

# install(make test will waste more time)
make -j4 && make test && make install

echo "Amber18 has been installed successfully"

