FROM akorn/luarocks:luajit2.1-alpine

RUN apk add --no-cache nodejs npm git

RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing dumb-init gcc libc-dev
RUN luarocks install busted

RUN busted --version

ENTRYPOINT ["busted", "--lua=luajit-2.1.0-beta3","--verbose", "--output=gtest"]
