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

ARG GIT_TAG
FROM clair-jwt:${GIT_TAG}-centos7-build-env AS build-env
FROM registry.access.redhat.com/rhel7/rhel
LABEL maintainer "Sida Chen <sidchen@redhat.com>"

ARG SUBSCRIPTION_KEY
RUN test -n "$SUBSCRIPTION_KEY" # Subscription key is required

# Install subscription key
ADD ${SUBSCRIPTION_KEY} /tmp/
RUN subscription-manager import --certificate=/tmp/${SUBSCRIPTION_KEY}
RUN rm -f /tmp/${SUBSCRIPTION_KEY}

# Install init system and Clair depended binaries
RUN yum install -y python-setuptools git rpm xz
RUN rpm --version | grep -q 'version 4' # ensure rpm is version 4
RUN easy_install supervisor

# Remove subscription key
RUN subscription-manager remove --all

# Copy built binaries into the runtime image
COPY --from=build-env /go/bin/cfssl /usr/local/bin/cfssl
COPY --from=build-env /go/bin/cfssljson /usr/local/bin/cfssljson
COPY --from=build-env /go/bin/clair /usr/local/bin/clair
COPY --from=build-env /go/bin/jwtproxy /usr/local/bin/jwtproxy

# Add the init scripts
ADD generate_mitm_ca.rhel.sh /generate_mitm_ca.sh
ADD boot.sh /boot.sh
ADD supervisord.conf /supervisord.conf

VOLUME /config
VOLUME /certs
EXPOSE 6060 6061

CMD ["sh", "/boot.sh"]
