#!/bin/bash
# script sets up a C++ build environment

# configure install location
ROOT_DIR="/tmp/test"

# number of jobs for make
JOBS=4

# configure versions
CMAKE_VERSION=3.17.2
OPENSSL_VERSION=1.1.1
ZLIB_VERSION=1.2.11

# create directory if not exists
mkdir -p ${ROOT_DIR}

# navigate to directory
cd ${ROOT_DIR}

# download zlib
wget https://zlib.net/zlib-${ZLIB_VERSION}.tar.gz
tar -zxvf zlib-${ZLIB_VERSION}.tar.gz

# build zlib
cd zlib-${ZLIB_VERSION}
./configure
make -j${JOBS}
cd ..

# configure zlib path
echo "ZLIB_HOME=\"${ROOT_DIR}/zlib-${ZLIB_VERSION}\"" >> ~/.bashrc.tmp
echo "export PATH=\${ZLIB_HOME}:\$PATH" >> ~/.bashrc.tmp
source ~/.bashrc.tmp

# clone openssl
git clone https://github.com/openssl/openssl.git
cd openssl 
git checkout OpenSSL_1_1_1a
./config --prefix=${ROOT_DIR} --openssldir=${ROOT_DIR} shared zlib
make CFLAGS="-I${ROOT_DIR}/zlib-${ZLIB_VERSION}" LDLIBS="-l${ROOT_DIR}/zlib-${ZLIB_VERSION}"
cd ..

# configure openssl path
echo "export OPENSSL_ROOT_DIR=\"${ROOT_DIR}/openssl\"" >> ~/.bashrc.tmp
echo "export OPENSSL_INCLUDE_DIR=\"${ROOT_DIR}/openssl/include\"" >> ~/.bashrc.tmp
echo "export OPENSSL_CRYPTO_LIBRARY=\"${OPENSSL_ROOT_DIR}/crypto\"" >> ~/bahsrc.tmp
source ~/.bashrc.tmp

# download cmake
wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz .
tar -zxvf cmake-${CMAKE_VERSION}.tar.gz .
cd cmake-${CMAKE_VERSION}

# build cmake
mkdir build
cd build
cmake CFLAGS="-I \$OPENSSL_INCLUDE_DIR  -I\$ZLIB_HOME -L\$OPENSSL_ROOT_DIR -L\$OPENSSL_CRYPTO_LIBRARY -L\$ZLIB_HOME -lssl -lcrypto -lz" ../

# configure cmake path
echo "export CMAKE_HOME=\"${ROOT_DIR}/cmake-${CMAKE_VERSION}/build/bin\"" >> ~/.bashrc.tmp
echo "export PATH=\$CMAKE_HOME:\$PATH" >> ~/.bashrc.tmp

# print results
source ~/.bashrc.tmp
echo "successfully built cmake version ${CMAKE_VERSION}"
