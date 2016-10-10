FROM alpine:3.4
# In case the main package repositories are down, use the alternative:
# FROM gliderlabs/alpine:3.4

MAINTAINER Nikyle Nguyen <NLKNguyen@MSN.com>

ARG REQUIRED_PACKAGES="sudo nodejs git wget rsync zip"
RUN apk update && apk upgrade \
      && apk add --no-cache ${REQUIRED_PACKAGES}


#### ADD NORMAL USER ####
ENV USER alpine
RUN adduser -D ${USER} \
      && echo "${USER}   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers 

RUN mkdir -p /opt/
RUN chown -R ${USER} /opt/
USER ${USER}


#### GET NWJS RUNTIME ####
# From http://nwjs.io/downloads/
ARG NWJS_VERSION="0.16.0"
ENV NWJS_VERSION ${NWJS_VERSION}

COPY scripts/download-nwjs.sh /opt/
RUN sh /opt/download-nwjs.sh

# ### CONFIG NPM when installing packages ###
# # --no-bin-links by default
# RUN npm config set bin-links false
# # This is a common issue when running npm install in a Docker or Vagrant VM
# # See: https://github.com/npm/npm/issues/9901

# # Also --no-optional by default
# RUN npm config set optional false

COPY scripts /opt/scripts
COPY shortcuts /opt/shortcuts


WORKDIR /mnt

ENTRYPOINT ["sh", "/opt/scripts/tasks.sh"]
CMD ["-h"]
# CMD ["/bin/sh", "/opt/init.sh"]
# CMD ["/bin/ash"]

