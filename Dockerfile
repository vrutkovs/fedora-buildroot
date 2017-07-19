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
        golang-github-cpuguy83-go-md2man && \
    dnf clean all

CMD ["atomic-reactor-2", "--verbose", "inside-build", "--input", "osv3"]
