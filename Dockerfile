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
        PyYAML \
        python2-pdc-client \
        python2-modulemd \
        fedpkg \
        buildah \
        skopeo && \
    dnf clean all

ENV OSBS_CLIENT_REMOTE https://github.com/vrutkovs/osbs-client.git
ENV OSBS_CLIENT_COMMIT e9564e8334a2e249b0260632633ffdc423daaadf
RUN pip install -U --no-deps --force-reinstall git+$OSBS_CLIENT_REMOTE@$OSBS_CLIENT_COMMIT

ENV ATOMIC_REACTOR_REMOTE https://github.com/vrutkovs/atomic-reactor.git
ENV ATOMIC_REACTOR_COMMIT 5d1482f5d0380b3f896c3f2b9c46911db077b464
RUN pip install -U --no-deps --force-reinstall git+$ATOMIC_REACTOR_REMOTE@$ATOMIC_REACTOR_COMMIT

ADD entrypoint.sh osbs-box-update-hosts /usr/local/bin/

CMD ["entrypoint.sh"]
