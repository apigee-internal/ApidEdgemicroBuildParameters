FROM ubuntu:yakkety

USER root
ENV GOPATH /go

COPY apid_config.yaml /demo/config/apid_config.yaml
COPY startServices.sh /demo/startServices.sh
RUN chmod +x /demo/startServices.sh

RUN apt-get update \
  && apt-get -y install curl git glide golang-1.7 openjdk-8-jre-headless openssh-server sudo unzip vim xz-utils
RUN mkdir -p /go/src/github.com/30x \
 && (cp /usr/lib/go-1.7/bin/go /usr/bin) \
 && (cd /go/src/github.com/30x; git clone https://github.com/30x/apid_build.git; cd apid_build; git checkout greg-docker-build) \
 && (cd /go/src/github.com/30x/apid_build; glide install; go build) \
 && cp /go/src/github.com/30x/apid_build/apid_build /demo/apid \
 && mkdir /demo/db

RUN mkdir /install \
  && (cd /install; curl -L https://nodejs.org/dist/v6.9.1/node-v6.9.1-linux-x64.tar.xz | tar xJf -) \
  && (cd /install/node-v6.9.1-linux-x64; tar cf - .) | (cd /usr/local; tar xf -)

RUN \
    (cd /demo; git clone https://github.com/apigee-internal/microgateway.git) \
 && (cd /demo/microgateway; git checkout new-config-start; npm install; npm update) \

RUN useradd -m -s /bin/bash -p '$1$58lUq/.L$.Fm8ONIXKW1qN.2GpfjL0.' demo \
 && mkdir /var/run/sshd \
 && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
 && usermod -aG sudo demo \
 && chown -R demo /demo \
 && mkdir /home/demo/.edgemicro \
 && chown demo /home/demo/.edgemicro

CMD [ "/demo/startServices.sh" ]
