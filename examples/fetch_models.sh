#!/bin/bash
# Copyright (c) 2021, NVIDIA CORPORATION. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#  * Neither the name of NVIDIA CORPORATION nor the names of its
#    contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

set -e

download () {
  MODEL_URL="https://docs.google.com/uc?export=download&id=$1"
  FILE_NAME=$2
  MD5SUM=$3

  if test -f ${FILE_NAME};
  then
    echo "${FILE_NAME} exists."
    if echo "${MD5SUM}  models.tar.xz" | md5sum -c -;
    then
      echo 'md5sum is correct, skip ...'
      return
    else
      echo "md5sum is not match, deleting ${FILE_NAME}"
      rm -rf ${FILE_NAME}
    fi
  fi

  if command -v aria2c &> /dev/null; then
    aria2c --check-certificate=false ${MODEL_URL}
  else
    echo $?
    wget --no-check-certificate ${MODEL_URL} -O ${FILE_NAME}
  fi

  echo "Finish downloading ${FILE_NAME}"
}

download '1dqkDxDV3teMSex13rYIYTsPJcI1FQlsQ' 'models.aa.tar.xz' '5f82ca0bd23d822273a1eaf29db1c84d'
download '1kmE4Pq4kLE9TtwEkC9IH_DVHHCuKkKEC' 'models.ab.tar.xz' '262ad022740ad853302a00232fa591f8'
download '14RJ3WAQWD0wXSyc6qRAxZVOkkDxUjSQV' 'models.ac.tar.xz' '7f29d150da8734e57b08a345e9537d09'
download '1WjyoC__L1o5L4nv413BIvo76QLwwzBx7' 'models.ad.tar.xz' 'c8376eca9d7d615cffa2dbf3dcc53f05'
download '1-vW4dVsVPmz6AK3rXUTrvdPYopGd6fvz' 'models.ae.tar.xz' '13df7769ef228e769e8deaae85868640'

echo 'Concatenating models.tar.xz'
cat models.a*.tar.xz > models.tar.xz
rm -rf models.a*
echo 'Extracting models.tar.xz'
tar xf models.tar.xz
