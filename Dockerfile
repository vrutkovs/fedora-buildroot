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

RUN pip install git+https://github.com/vrutkovs/osbs-client.git@buildah-plugin && \
    cp inputs/* /usr/share/osbs/inputs
RUN pip install git+https://github.com/vrutkovs/atomic-reactor.git@buildah-plugin

CMD ["/usr/bin/atomic-reactor", "--verbose", "inside-build"]
