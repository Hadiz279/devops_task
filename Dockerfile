# docker/Dockerfile.ssh
FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Install minimal packages + openssh-server + monitoring tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      openssh-server sudo curl ca-certificates \
      htop sysstat net-tools python3 python3-apt && \
    rm -rf /var/lib/apt/lists/*

# Create sshd run dir and user 'ubuntu'
RUN mkdir /var/run/sshd && \
    useradd -m -s /bin/bash ubuntu && echo "ubuntu:ubuntu" | chpasswd && \
    adduser ubuntu sudo

# Prepare for key-based auth; Ansible will populate authorized_keys
RUN mkdir -p /home/ubuntu/.ssh && chown ubuntu:ubuntu /home/ubuntu/.ssh

EXPOSE 80
# Run SSHD in foreground (so container stays up)
CMD ["/usr/sbin/sshd","-D"]

