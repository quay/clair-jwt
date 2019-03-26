# Copyright 2019 clair authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM centos:7
LABEL maintainer "Sida Chen <sidchen@redhat.com>"

ARG GIT_TAG
RUN test -n "$GIT_TAG" # Expect Clair GIT TAG to be non-empty.

# Install Golang by retrieving the binary
ENV GO_VERSION=1.11.5
ENV GO_OS=linux
ENV GO_ARC=amd64
RUN curl https://dl.google.com/go/go${GO_VERSION}.${GO_OS}-${GO_ARC}.tar.gz --output go.tar.gz
RUN echo ff54aafedff961eb94792487e827515da683d61a5f9482f668008832631e5d25 go.tar.gz > GOCHECKSUM
RUN sha256sum -c GOCHECKSUM
RUN tar -C /usr/local -xzf go.tar.gz > /dev/null
ENV GOPATH=/go
ENV PATH=$PATH:/usr/local/go/bin:${GOPATH}/bin

# Verify go verion
RUN go version

# Install dependencies
RUN yum install -y --setopt=tsflags=nodocs --setopt=skip_missing_names_on_install=False git hg svn bzr gcc

ENV CFSSL_VERSION=1.3.2
RUN go get -u github.com/cloudflare/cfssl/cmd/cfssl
WORKDIR /go/src/github.com/cloudflare/cfssl
RUN git checkout ${CFSSL_VERSION}
RUN go install github.com/cloudflare/cfssl/cmd/cfssl
RUN go install github.com/cloudflare/cfssl/cmd/cfssljson

RUN go get -u github.com/coreos/jwtproxy/cmd/jwtproxy

# Build Clair with git tag
RUN go get -u -d github.com/coreos/clair/cmd/clair
WORKDIR /go/src/github.com/coreos/clair
RUN git checkout $GIT_TAG
RUN go install github.com/coreos/clair/cmd/clair
