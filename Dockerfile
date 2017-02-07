FROM fedora:25

LABEL name=vrutkovs/buildroot
LABEL version=1.0.pip
LABEL release=1
LABEL com.redhat.component=osbs-fedora-buildroot

RUN dnf -y update && \
    dnf -y install \
         git \
        koji \
        nfs-utils \
        python-docker-py \
        python-pip \
        python-setuptools \
        python-simplejson \
        golang-github-cpuguy83-go-md2man && \
    dnf clean all

RUN \
    cd /opt/ && git clone -b master https://github.com/projectatomic/osbs-client.git && cd osbs-client && python setup.py install && \
    cd /opt/ && git clone -b master https://github.com/projectatomic/atomic-reactor.git && cd atomic-reactor && python setup.py install && \
    cd /opt/ && git clone -b master https://github.com/release-engineering/dockpulp.git && cd dockpulp && python setup.py install && \
    cd /opt/ && git clone -b master https://github.com/goldmann/docker-squash.git && cd docker-squash && python setup.py install

CMD ["atomic-reactor", "--verbose", "inside-build", "--input", "osv3"]

