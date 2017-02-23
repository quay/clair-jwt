# Copyright 2017 clair authors
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

FROM golang:1.8-alpine
MAINTAINER Jimmy Zelinskie <jimmy.zelinskie@coreos.com>

VOLUME /config
EXPOSE 6060 6061
ARG GIT_TAG

RUN apk add --no-cache git bzr rpm xz supervisor gcc musl-dev && \
    go get -u github.com/cloudflare/cfssl/cmd/cfssl && \
    go get -u github.com/cloudflare/cfssl/cmd/cfssljson && \
    apk del gcc && \
    go get -u github.com/coreos/jwtproxy/cmd/jwtproxy && \
    go get -u -d github.com/coreos/clair/cmd/clair && \
    cd /go/src/github.com/coreos/clair && \
    git checkout $GIT_TAG && \
    go install github.com/coreos/clair/cmd/clair && \
    rm -rf /usr/local/go $GOPATH/src $GOPATH/pkg # 22FEB2017

ADD generate_mitm_ca.sh /generate_mitm_ca.sh
ADD boot.sh /boot.sh
ADD supervisord.conf /supervisord.conf

CMD ["sh", "/boot.sh"]
