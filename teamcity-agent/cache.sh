#!/bin/sh
set -e

mkdir -p /cache/m2 /cache/gradle /cache/npm /cache/bun /cache/pnpm/store /cache/pnpm/cache /cache/yarn /cache/rust
mkdir -p /root/.local/share /usr/local/share/.cache

ln -sfn /cache/m2 /root/.m2
ln -sfn /cache/gradle /root/.gradle
ln -sfn /cache/npm /root/.npm
ln -sfn /cache/pnpm /root/.local/share/pnpm
ln -sfn /cache/yarn /usr/local/share/.cache/yarn
ln -sfn /cache/rust /root/.cargo
ln -sfn /cache/bun /root/.bun
