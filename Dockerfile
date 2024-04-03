FROM nickblah/luajit:2.1.0-beta3-luarocks-jammy

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get update && \
    apt-get install -y dumb-init gcc libc-dev nodejs git
RUN luarocks install busted

RUN busted --version

ENTRYPOINT ["busted", "--lua=luajit-2.1.0-beta3","--verbose", "--output=gtest"]
