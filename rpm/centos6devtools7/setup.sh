#!/bin/bash

yum -y install centos-release-scl
yum -y install devtoolset-7-toolchain \
		devtoolset-7-libasan-devel \
		devtoolset-7-libubsan-devel \
		devtoolset-7-valgrind \
		devtoolset-7-perftools \
		devtoolset-7-gdb-gdbserver

