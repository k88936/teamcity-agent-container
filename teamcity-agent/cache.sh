#!/bin/sh
set -e

link_cache() {
    src=$1
    dest=$2

    mkdir -p "$src"
    mkdir -p "$(dirname "$dest")"
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        cp -a "$dest"/. "$src"/
        rm -rf "$dest"
    fi
    ln -sfn "$src" "$dest"
}

mkdir -p /cache/m2 /cache/gradle /cache/npm /cache/bun /cache/pnpm /cache/pnpm/store /cache/pnpm/cache /cache/yarn /cache/rust /cache/cargo-xwin

link_cache /cache/m2 /root/.m2
link_cache /cache/gradle /root/.gradle
link_cache /cache/npm /root/.npm
link_cache /cache/pnpm /root/.local/share/pnpm
link_cache /cache/yarn /usr/local/share/.cache/yarn
link_cache /cache/rust /root/.cargo

# Bun used to share the npm cache directory. Move it once so both caches stay separate.
if [ -d /cache/npm/install/cache ] && [ ! -e /cache/bun/install/cache ]; then
    mkdir -p /cache/bun/install
    mv /cache/npm/install/cache /cache/bun/install/cache
fi
link_cache /cache/bun /root/.bun

# The image ships the xwin SDK outside the cache volume; seed the volume once, then
# keep all runtime updates on the persistent volume.
if [ -d /opt/cargo-xwin-cache ] && [ -z "$(ls -A /cache/cargo-xwin)" ]; then
    cp -a /opt/cargo-xwin-cache/. /cache/cargo-xwin/
fi
if [ -d /root/.cache/cargo-xwin ] && [ ! -L /root/.cache/cargo-xwin ]; then
    if [ -z "$(ls -A /cache/cargo-xwin)" ]; then
        cp -a /root/.cache/cargo-xwin/. /cache/cargo-xwin/
    fi
    rm -rf /root/.cache/cargo-xwin
fi
rm -f /cache/cargo-xwin/cargo-xwin
link_cache /cache/cargo-xwin /root/.cache/cargo-xwin
