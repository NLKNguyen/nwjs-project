FROM alpine:3.4
# In case the main package repositories are down, use the alternative:
# FROM gliderlabs/alpine:3.4

MAINTAINER Nikyle Nguyen <NLKNguyen@MSN.com>

ARG REQUIRED_PACKAGES="sudo nodejs git wget rsync zip"
RUN apk update && apk upgrade \
      && apk add --no-cache ${REQUIRED_PACKAGES}


#### GET NWJS RUNTIME ####
# From http://nwjs.io/downloads/
ARG NWJS_VERSION="0.16.0"
ENV NWJS_VERSION ${NWJS_VERSION}

COPY scripts/download-nwjs.sh /opt/
RUN sh /opt/download-nwjs.sh

# RUN ls /opt

# #### Script to copy NWJS runtime to /project directory ####
# # RUN echo "cp -ru /opt/nwjs /project/" > /opt/copy_nwjs_to_project.sh
# # RUN rsync -a /opt/nwjs/ /project/nwjs
# COPY init.sh  /opt/
# COPY package.sh /opt/

#### ADD NORMAL USER ####
ENV USER alpine
RUN adduser -D ${USER} \
      && echo "${USER}   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers 


#### CREATE WORKING DIRECTORY FOR USER ####
ENV WORKDIR /project
RUN mkdir ${WORKDIR}
RUN chown -R ${USER} ${WORKDIR}

WORKDIR ${WORKDIR}
# USER ${USER}


### CONFIG NPM when installing packages ###
# --no-bin-links by default
RUN npm config set bin-links false
# This is a common issue when running npm install in a Docker or Vagrant VM
# See: https://github.com/npm/npm/issues/9901

# Also --no-optional by default
RUN npm config set optional false
COPY scripts/package.sh /opt/
COPY scripts/tasks.sh /opt/
ENTRYPOINT ["/opt/tasks.sh"]
CMD ["-h"]
# CMD ["/bin/sh", "/opt/init.sh"]
# CMD ["/bin/ash"]

