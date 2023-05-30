FROM ubuntu:23.04

ARG SSH_PRVKEY
ARG SSH_PUBKEY

RUN echo "Hello, running test build"
RUN echo "${SSH_PRVKEY}"

# OS updates and install
RUN apt-get -qq update
RUN apt-get install sudo apt-utils wget curl git -qq -y
RUN DEBIAN_FRONTEND=noninteractive TZ=Asia/Kuala_Lumpur apt-get -y install tzdata
RUN apt-get -qq upgrade

# Create test user and add to sudoers
RUN useradd -m wayk
RUN usermod -aG sudo wayk
RUN echo "wayk   ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers

# Add dotfiles and chown
ADD . /home/wayk/.dotfiles
RUN chown -R wayk:wayk /home/wayk

# Switch wayk
USER wayk
ENV HOME /home/wayk

# Authorize SSH Host
RUN mkdir -p /home/wayk/.ssh && \
    chmod 0700 /home/wayk/.ssh && \
    ssh-keyscan github.com > /home/wayk/.ssh/known_hosts

# Add the keys and set permissions
RUN echo "${SSH_PRVKEY}" > /home/wayk/.ssh/id_ed25519 && \
    echo "${SSH_PUBKEY}" > /home/wayk/.ssh/id_ed25519.pub && \
    chmod 600 /home/wayk/.ssh/id_ed25519 && \
    chmod 600 /home/wayk/.ssh/id_ed25519.pub

CMD ["/bin/bash", "/home/wayk/.dotfiles/bin/dotfiles"]
