FROM owtaylor/fedora-buildroot:latest

LABEL name=vrutkovs/buildroot
LABEL version=1.0
LABEL release=1
LABEL com.redhat.component=osbs-fedora-buildroot

ENV OSBS_CLIENT_REMOTE https://github.com/vrutkovs/osbs-client.git
ENV OSBS_CLIENT_COMMIT 06a42383751dd195da7fd56fb34cf8b82663012d
#RUN pip install --upgrade --no-deps git+$OSBS_CLIENT_REMOTE@$OSBS_CLIENT_COMMIT
RUN rm -rf /tmp/osbs-client && \
    git clone $OSBS_CLIENT_REMOTE /tmp/osbs-client && \
    cd /tmp/osbs-client && \
    git checkout $OSBS_CLIENT_COMMIT && \
    python setup.py install && \
    install -D -t /usr/share/osbs inputs/*.json

ENV ATOMIC_REACTOR_REMOTE https://github.com/vrutkovs/atomic-reactor.git
ENV ATOMIC_REACTOR_COMMIT 63e2cb94e5f98a72053c4668c504ae65a62797e9
RUN pip install --upgrade --no-deps --force-reinstall git+$ATOMIC_REACTOR_REMOTE@$ATOMIC_REACTOR_COMMIT

#CMD ["atomic-reactor", "--verbose", "inside-build", "--input", "osv3"]
CMD ["entrypoint.sh"]
