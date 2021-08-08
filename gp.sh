#!/bin/bash
install_dependencies () {
    sudo apt update;
    sudo apt install -y git-core gnupg flex bison build-essential zip \
    curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 \
    libncurses5-dev lib32ncurses5-dev x11proto-core-dev libx11-dev \
    lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig ccache
}

d_and_init_repo () {
    sudo curl https://storage.googleapis.com/git-repo-downloads/repo -o /usr/local/bin/repo
    sudo chmod a+x /usr/local/bin/repo
    repo init --depth=1 --submodules -c -u https://android.googlesource.com/platform/manifest
}

repo_sync () {
    repo sync -j$(nproc);
}

add_marlin() {
    [[ ! -d .repo/local_manifests]] && mkdir -p .repo/local_manifests
    cat EOF | tee -a .repo/local_manifests/roomservice.xml
<project name=/devices/google/marlin path=/devices/google/marlin />
}
case $1 in
    -d)
        install_dependencies
    ;;
    -r)
        d_and_init_repo
        add_marlin
    ;;
    -s)
        repo_sync
    ;;
esac