# Copyright 2018 clair authors
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

FROM golang:1.10-alpine AS build-env
LABEL maintainer "Jimmy Zelinskie <jimi@redhat.com>"

ARG GIT_TAG

RUN apk add --no-cache git bzr rpm xz supervisor gcc musl-dev

# Build cfssl and jwtproxy
RUN go get -u github.com/cloudflare/cfssl/cmd/cfssl
RUN go get -u github.com/cloudflare/cfssl/cmd/cfssljson
RUN go get -u github.com/coreos/jwtproxy/cmd/jwtproxy

# Build clair
RUN go get -u -d github.com/coreos/clair/cmd/clair
WORKDIR /go/src/github.com/coreos/clair
RUN git checkout $GIT_TAG
RUN go install github.com/coreos/clair/cmd/clair

FROM alpine:3.7 AS runtime-env
LABEL maintainer "Jimmy Zelinskie <jimi@redhat.com>"

RUN apk add --no-cache supervisor ca-certificates \
                       git bzr rpm xz

# Copy built binaries into the runtime image
COPY --from=build-env /go/bin/cfssl /usr/local/bin/cfssl
COPY --from=build-env /go/bin/cfssljson /usr/local/bin/cfssljson
COPY --from=build-env /go/bin/clair /usr/local/bin/clair
COPY --from=build-env /go/bin/jwtproxy /usr/local/bin/jwtproxy

# Add the init scripts
ADD generate_mitm_ca.sh /generate_mitm_ca.sh
ADD boot.sh /boot.sh
ADD supervisord.conf /supervisord.conf

VOLUME /config
EXPOSE 6060 6061

CMD ["sh", "/boot.sh"]
