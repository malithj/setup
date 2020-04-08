#!/bin/bash
# build llvm release candidate

# configure install location
ROOT_DIR="/tmp/test"

# number of jobs for make
JOBS=4

# configure versions
LLVM_VERSION=10.0.0

# navigate to directory
cd ${ROOT_DIR}

# download llvm-project and checkout tag
git clone https://github.com/llvm/llvm-project.git
git checkout  llvmorg-${LLVM_VERSION}
cd llvm-project

# build llvm and clang
mkdir build
cd build
cmake -DLLVM_ENABLE_PROJECTS=clang -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ../llvm
make

# configure paths
echo "export LLVM_PATH=\"${ROOT_DIR}/llvm-project/build/bin\"" >> ~/.bashrc.tmp
echo "export LLVM_LIB=\"${ROOT_DIR}/llvm-project/build/lib/\"" >> ~/.bashrc.tmp
echo "export PATH=\$LLVM_PATH:\$LLVM_LIB:\$PATH" >> ~/.bashrc.tmp

# print message on success
source ~/.bashrc.tmp
echo "successfully built LLVM version {LLVM_VERSION}"
