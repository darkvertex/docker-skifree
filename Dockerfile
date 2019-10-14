# Start from minimalist image:
FROM debian:stretch-slim

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
