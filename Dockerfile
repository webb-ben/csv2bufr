###############################################################################
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
###############################################################################

FROM ubuntu:20.04

ENV ECCODES_VER=2.23.0
ENV ECCODES_DIR=/opt/eccodes

RUN echo "Acquire::Check-Valid-Until \"false\";\nAcquire::Check-Date \"false\";" | cat > /etc/apt/apt.conf.d/10no--check-valid-until

RUN apt-get update -y
RUN DEBIAN_FRONTEND="noninteractive" TZ="Europe/Bern" apt-get install -y build-essential curl cmake python3 gfortran python3-pip libffi-dev python3-dev

WORKDIR /tmp/eccodes
RUN curl https://confluence.ecmwf.int/download/attachments/45757960/eccodes-${ECCODES_VER}-Source.tar.gz --output eccodes-${ECCODES_VER}-Source.tar.gz
RUN tar xzf eccodes-${ECCODES_VER}-Source.tar.gz
RUN mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=${ECCODES_DIR} ../eccodes-${ECCODES_VER}-Source && make && ctest && make install
RUN python3 setup.py install
RUN export PATH="$PATH;/opt/eccodes/bin"
RUN cd / && rm -rf /tmp/eccodes
WORKDIR /
