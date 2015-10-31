FROM ubuntu:14.04.3

MAINTAINER adam v0.1

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y wget git && \
    rm -rf /var/lib/apt/lists/*

# Add jenkins user with "jenkins" password
RUN adduser -disabled-password --gecos '' --quiet jenkins && \
    echo "jenkins:jenkins" | chpasswd

# Install a basic SSH server
RUN apt-get update && \
    apt-get install -y openssh-server && \
    sed -i 's|session    required     pam_loginuid.so|session    optional pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    rm -rf /var/lib/apt/lists/*

# as per https://developer.android.com/sdk/index.html#Requirements
# install Oracle java 7 
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get -y install oracle-java7-installer && \
    rm -rf /var/lib/apt/lists/*

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
