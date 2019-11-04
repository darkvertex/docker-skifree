# Start from minimalist image:
FROM debian:stretch-slim

# Metadata labels as described in:
# http://label-schema.org/rc1/
# https://github.com/opencontainers/image-spec/blob/master/annotations.md
ARG BUILD_TITLE="Docker SkiFree"
ARG BUILD_DESCRIPTION="Vintage Windows game 'SkiFree' running in WINE via X forwarding for Docker on Linux."
ARG BUILD_REPO_URL="https://github.com/darkvertex/docker-skifree/"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="${BUILD_TITLE}"
LABEL org.opencontainers.image.name="${BUILD_TITLE}"
LABEL org.label-schema.description="${BUILD_DESCRIPTION}"
LABEL org.opencontainers.image.description="${BUILD_DESCRIPTION}"
LABEL org.label-schema.vcs-url="${BUILD_REPO_URL}"
LABEL org.opencontainers.image.source="${BUILD_REPO_URL}"
LABEL org.label-schema.docker.cmd='docker run -it --rm -e DISPLAY=$DISPLAY --user `id -u` -v="/tmp/.X11-unix:/tmp/.X11-unix" alanf/skifree-wine'

# Install "wine" and "wine32":
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    wine wine32 \
    && rm -rf /var/lib/apt/lists/*

# Deploy "tini" for better interruption signal handling:
ADD https://github.com/krallin/tini/releases/download/v0.18.0/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Deploy 32bit SkiFree from the official author's website:
ENV SKI_PATH=/usr/share/ski32.exe
ADD http://ski.ihoc.net/ski32.exe $SKI_PATH
RUN chmod 777 $SKI_PATH

# Make a dummy home dir (wine needs it) and runs SkiFree:
CMD mkdir -p /tmp/dummyhome && export HOME=/tmp/dummyhome && wine $SKI_PATH
