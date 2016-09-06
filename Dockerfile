# Copyright 2015 clair authors
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

FROM golang:1.7
MAINTAINER Quentin Machu <quentin.machu@coreos.com>

VOLUME /config
EXPOSE 6060 6061

RUN apt-get update && \
    apt-get install -y bzr rpm xz-utils supervisor && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* # 06SEP2016

RUN go get -u github.com/cloudflare/cfssl/cmd/cfssl
RUN go get -u github.com/cloudflare/cfssl/cmd/cfssljson
RUN go get -u github.com/coreos/jwtproxy/cmd/jwtproxy # 06SEP2016
RUN go get -u github.com/coreos/clair/cmd/clair
RUN cd /go/src/github.com/coreos/clair && git checkout v1.2.4 && go install github.com/coreos/clair/cmd/clair

ADD generate_mitm_ca.sh /generate_mitm_ca.sh
ADD boot.sh /boot.sh
ADD supervisord.conf /supervisord.conf

CMD ["/boot.sh"]
