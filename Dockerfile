FROM ubuntu:16.04

ENV version=2.3 \
    type=pump \
    remotehost="" \
    remoteport=7473 \
    localport=7473 \
    password="1234"
RUN apt-get update -y && \
    apt-get install -y curl xz-utils && \
    apt-get install -y openssh-server && \
    curl -SL https://github.com/pipesocks/pipesocks/releases/download/$version/pipesocks-$version-linux.tar.xz | \
    tar -xJ && \
    apt-get remove -y curl xz-utils && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* \
    mkdir /var/run/sshd \
    echo 'root:password' |chpasswd \
    sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config 

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
