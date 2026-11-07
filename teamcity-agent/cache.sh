#!/bin/sh

mkdir -p /cache

link_cache() {
    cache=$1
    link=$2

    mkdir -p "$cache" && mkdir -p "$(dirname "$link")" && ln -s "$cache" "$link"
}

link_cache /cache/m2 /root/.m2
link_cache /cache/gradle /root/.gradle
link_cache /cache/npm /root/.npm
mkdir -p /cache/bun
link_cache /cache/npm /root/.bun
link_cache /cache/pnpm /root/.local/share/pnpm
mkdir -p /cache/yarn /usr/local/share/.cache/ && ln -s /usr/local/share/.cache/yarn
link_cache /cache/rust /root/.cargo
