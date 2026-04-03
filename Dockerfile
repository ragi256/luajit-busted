FROM ubuntu:noble

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git curl unzip ca-certificates \
    lua5.1 liblua5.1-0-dev && \
    rm -rf /var/lib/apt/lists/*

# LuaJIT 2.1.0-beta3 source build (pinned to match FluentBit v1.9.10 runtime)
RUN curl -fsSL https://github.com/LuaJIT/LuaJIT/archive/v2.1.0-beta3.tar.gz | tar xz && \
    cd LuaJIT-2.1.0-beta3 && \
    make && make install PREFIX=/usr/local && \
    ln -sf /usr/local/bin/luajit-2.1.0-beta3 /usr/local/bin/luajit && \
    cd .. && rm -rf LuaJIT-2.1.0-beta3 && \
    ldconfig

# luarocks (configured with system Lua 5.1 to avoid LuaJIT manifest size limit)
RUN curl -fsSL https://luarocks.org/releases/luarocks-3.11.1.tar.gz | tar xz && \
    cd luarocks-3.11.1 && \
    ./configure --with-lua-include=/usr/include/lua5.1 && \
    make && make install && \
    cd .. && rm -rf luarocks-3.11.1

# Install busted via system Lua (avoids LuaJIT 65536 constants limit on manifests)
# Rocks are installed to /usr/local/lib/luarocks which is shared with LuaJIT
RUN luarocks install busted

RUN busted --version

ENTRYPOINT ["busted", "--lua=luajit-2.1.0-beta3", "--verbose", "--output=gtest"]
