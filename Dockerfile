FROM fedora:26

LABEL name=vrutkovs/buildroot
LABEL version=1.0
LABEL release=1
LABEL com.redhat.component=osbs-fedora-buildroot

RUN dnf clean all && \
    dnf -y update --refresh && \
    dnf -y install \
        atomic-reactor \
        git \
        koji \
        nfs-utils \
        python-atomic-reactor-koji \
        python-atomic-reactor-metadata \
        python-atomic-reactor-rebuilds \
        python-docker-py \
        python-docker-squash \
        python-osbs-client \
        python-pip \
        python-setuptools \
        python-simplejson \
        golang-github-cpuguy83-go-md2man \
        buildah \
        skopeo && \
    dnf clean all

ENV OSBS_CLIENT_COMMIT da2ad0a

RUN pip install git+https://github.com/vrutkovs/osbs-client.git@$OSBS_CLIENT_COMMIT && \
    git clone https://github.com/vrutkovs/osbs-client.git && \
    cd osbs-client && \
    git checkout $OSBS_CLIENT_COMMIT && \
    cp inputs/* /usr/share/osbs

ENV ATOMIC_REACTOR_COMMIT 0c0cc29
RUN pip install git+https://github.com/vrutkovs/atomic-reactor.git@$ATOMIC_REACTOR_COMMIT

CMD ["/usr/bin/atomic-reactor", "--verbose", "inside-build"]
