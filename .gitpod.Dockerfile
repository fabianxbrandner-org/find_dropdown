FROM gitpod/workspace-full

USER root

RUN apt-get update && apt-get -y install git curl unzip

RUN apt-get autoremove -y \
        && apt-get clean -y \
        && rm -rf /var/lib/apt/lists/*

RUN mkdir /home/gitpod  || echo "/home/gitpod already exists"
WORKDIR /home/gitpod

USER gitpod

ENV PUB_CACHE=/workspace/.pub_cache
ENV PATH="/home/gitpod/flutter/bin:$PATH"

RUN sudo mkdir ${PUB_CACHE}|| echo "${PUB_CACHE} already exists"
RUN sudo chmod -R 777 ${PUB_CACHE}

RUN git clone -b stable https://github.com/flutter/flutter && \
        /home/gitpod/flutter/bin/flutter config

# add executables to PATH
RUN echo 'export PATH=${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin:${PUB_CACHE}/bin:${FLUTTER_HOME}/.pub-cache/bin:$PATH' >>~/.bashrc
RUN echo 'export FLUTTER_ROOT=${FLUTTER_HOME}' >>~/.bashrc

RUN brew install fastlane
RUN /home/gitpod/flutter/bin/flutter upgrade
