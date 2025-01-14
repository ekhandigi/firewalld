FROM registry.access.redhat.com/ubi8/ubi

LABEL description="Firewalld daemon and command line interface"
MAINTAINER Firewalld Maintainers <firewalld-users@lists.fedorahosted.org>

# firewalld build/runtime dependencies
#
RUN dnf -y install automake autoconf make intltool \
                   docbook-style-xsl python3-nftables \
                   python3-gobject-base libxslt glib2-devel

# firewalld testsuite dependencies
#
RUN dnf -y install diffutils procps iproute dbus-daemon python3-devel

# build firewalld
#
COPY . /tmp/firewalld
RUN cd /tmp/firewalld \
    && ./autogen.sh \
    && ./configure --prefix=/usr PYTHON=/usr/libexec/platform-python \
    && make \
    && make install \
    && rm -rf /tmp/firewalld

# remove build dependencies
#
RUN dnf -y remove automake autoconf make intltool \
                  docbook-style-xsl libxslt glib2-devel \
    && dnf -y autoremove \
    && dnf clean all

CMD ["firewalld", "--nofork", "--nopid"]
