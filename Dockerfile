FROM fedora:26

LABEL name=vrutkovs/buildroot
LABEL version=1.0
LABEL release=1
LABEL com.redhat.component=osbs-fedora-buildroot

RUN dnf update -y --exclude '*glibc*'
RUN dnf install -y dnf-plugins-core
RUN dnf config-manager --set-enable updates-testing
#RUN dnf -y update --refresh
RUN dnf -y install \
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
 	python2-modulemd \
        pdc-client \
        python2-pdc-client \
        desktop-file-utils \
        flatpak \
        ostree && \
    dnf clean all

ENV OSBS_CLIENT_REMOTE https://github.com/vrutkovs/osbs-client.git
ENV OSBS_CLIENT_COMMIT 6081797d43f750666bb4924ba51e9ec6d49d787c
RUN pip install --upgrade --no-deps --force-reinstall git+$OSBS_CLIENT_REMOTE@$OSBS_CLIENT_COMMIT

ENV ATOMIC_REACTOR_REMOTE https://github.com/vrutkovs/atomic-reactor.git
ENV ATOMIC_REACTOR_COMMIT e0379c1c625124bfb0d2b3325a2f2df4e7651cb8
RUN pip install --upgrade --no-deps --force-reinstall git+$ATOMIC_REACTOR_REMOTE@$ATOMIC_REACTOR_COMMIT


CMD ["atomic-reactor", "--verbose", "inside-build", "--input", "osv3"]
