FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt upgrade -y && \
    apt install curl -y && \
    apt clean && \
    apt autoclean && \
    find /var/lib/apt/lists/ -maxdepth 1 -type f -print0 | xargs -0 rm

# INSTALL JAVA    
RUN apt update && \
    apt-get install openjdk-11-jdk -y && \
    java -version && \
    apt clean && \
    apt autoclean && \
    find /var/lib/apt/lists/ -maxdepth 1 -type f -print0 | xargs -0 rm

WORKDIR /root/
# INSTALL HALYARD
RUN curl -O https://raw.githubusercontent.com/spinnaker/halyard/master/install/debian/InstallHalyard.sh && \
    useradd halyard && \
    bash InstallHalyard.sh --user halyard -y && \
    echo ". /etc/bash_completion.d/hal" >> /root/.bashrc && \
    apt clean && \
    apt autoclean && \
    find /var/lib/apt/lists/ -maxdepth 1 -type f -print0 | xargs -0 rm

# INSTALL kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    kubectl version --client

LABEL org.opencontainers.image.source="https://github.com/ahmetozer/halyard-container"