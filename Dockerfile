FROM ubuntu:trusty
MAINTAINER chenhang <cxdongzhou@gmail.com>

# replace sources
ADD sources.list /etc/apt/sources.list

# change timezone
RUN echo "Asia/Shanghai" > /etc/timezone && \
                dpkg-reconfigure -f noninteractive tzdata

# no Upstart or DBus
# https://github.com/dotcloud/docker/issues/1724#issuecomment-26294856
RUN apt-mark hold initscripts udev plymouth mountall
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl

# install package and configuration
RUN apt-get update && apt-get install -y --no-install-recommends xterm vim supervisor
RUN apt-get install -y --no-install-recommends x11vnc xvfb
RUN rm /etc/X11/app-defaults/XTerm
COPY XTerm /etc/X11/app-defaults/XTerm

COPY noVNC /noVNC/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 6080

CMD ["/usr/bin/supervisord"]
