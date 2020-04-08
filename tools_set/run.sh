#!/bin/bash
# build tools required

# configure install location
ROOT_DIR="/tmp/test"

# number of jobs for make
JOBS=4

# configure versions
MERCURIAL_VERSION=5.3

# navigate to directory
cd ${ROOT_DIR}

# download mercurial
wget https://www.mercurial-scm.org/release/mercurial-${MERCURIAL_VERSION}.tar.gz
tar -zxvf mercurial-${MERCURIAL_VERSION}.tar.gz
cd mercurial-${MERCURIAL_VERSION}

# build mercurial local to the folder
make local

# configure paths
echo "export HG_PATH=\"${ROOT_DIR}/mercurial-${MERCURIAL_VERSION}\"" >> ~/.bashrc.tmp
echo "export PATH=\$HG_PATH:\$PATH" >> ~/.bashrc.tmp

# print message on success
source ~/.bashrc.tmp
echo "successfully built MERCURIAL version {MERCURIAL_VERSION}"
