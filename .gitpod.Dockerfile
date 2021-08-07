FROM gitpod/workspace-full

USER gitpod

# Install custom tools, runtime, etc. using apt-get
# For example, the command below would install "bastet" - a command line tetris clone:
#
# RUN sudo apt-get -q update && \
#     sudo apt-get install -yq bastet && \
#     sudo rm -rf /var/lib/apt/lists/*
#
# More information: https://www.gitpod.io/docs/config-docker/
RUN echo "dash dash/sh boolean false" | sudo debconf-set-selections && \
    sudo dpkg-reconfigure -p critical dash

RUN sudo apt-get update && \
    sudo apt-get install -y git-core gnupg flex bison build-essential \
    zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
    libncurses5-dev lib32ncurses5-dev x11proto-core-dev libx11-dev \
    lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig \
    && sudo apt-get clean \
    && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN sudo curl https://storage.googleapis.com/git-repo-downloads/repo -o /usr/local/bin/repo
RUN sudo chmod 755 /usr/local/bin/*

RUN echo "export USE_CCACHE=1" | sudo tee -a /etc/profile.d/android
ENV USE_CCACHE 1
ENV CCACHE_DIR /ccache

COPY entry.sh /script/entry.sh
RUN sudo chmod 755 /script/entry.sh

ENTRYPOINT ["/script/entry.sh"]
