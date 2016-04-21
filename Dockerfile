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

FROM quay.io/coreos/clair:v1.1.0

MAINTAINER Quentin Machu <quentin.machu@coreos.com>

RUN apt-get update && \
    apt-get install -y supervisor && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* # 18MAR2016

ADD ./binary_dependencies/jwtproxy /usr/bin/jwtproxy

ADD supervisord.conf supervisord.conf

ENTRYPOINT ["supervisord", "-c"]
CMD ["supervisord.conf"]
