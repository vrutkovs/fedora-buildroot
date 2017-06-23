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
        fedpkg \
        buildah \
        skopeo && \
    dnf clean all

ENV OSBS_CLIENT_REMOTE https://github.com/vrutkovs/osbs-client.git
ENV OSBS_CLIENT_COMMIT fabd94f
RUN pip install --force-reinstall git+$OSBS_CLIENT_REMOTE@$OSBS_CLIENT_COMMIT

ENV ATOMIC_REACTOR_REMOTE https://github.com/vrutkovs/atomic-reactor.git
ENV ATOMIC_REACTOR_COMMIT d3b6ec5
RUN pip install --force-reinstall git+$ATOMIC_REACTOR_REMOTE@$ATOMIC_REACTOR_COMMIT

CMD ["/usr/bin/atomic-reactor", "--verbose", "inside-build"]
