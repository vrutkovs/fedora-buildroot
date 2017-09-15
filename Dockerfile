FROM fedora:26

LABEL name=vrutkovs/buildroot
LABEL version=1.0
LABEL release=1
LABEL com.redhat.component=osbs-fedora-buildroot

ARG UPDATES_TESTING

RUN dnf update -y && dnf install -y dnf-plugins-core && \
    if [ $UPDATES_TESTING ]; then dnf config-manager --set-enable updates-testing; fi && \
    dnf -y update && \
    dnf -y install \
        atomic-reactor \
        git \
        koji \
        nfs-utils \
        fedpkg \
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
        desktop-file-utils \
        flatpak \
        ostree && \
    dnf clean all

ENV OSBS_CLIENT_REMOTE https://github.com/projectatomic/osbs-client.git
ENV OSBS_CLIENT_COMMIT master
RUN pip install --upgrade --no-deps --force-reinstall git+$OSBS_CLIENT_REMOTE@$OSBS_CLIENT_COMMIT

ENV ATOMIC_REACTOR_REMOTE https://github.com/projectatomic/atomic-reactor.git
ENV ATOMIC_REACTOR_COMMIT master
RUN pip install --upgrade --no-deps --force-reinstall git+$ATOMIC_REACTOR_REMOTE@$ATOMIC_REACTOR_COMMIT


CMD ["atomic-reactor-2", "--verbose", "inside-build", "--input", "osv3"]
