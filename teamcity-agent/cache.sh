mkdir -p /cache
mkdir -p /cache/m2 && ln -s /cache/m2 /root/.m2
mkdir -p /cache/gradle && ln -s /cache/gradle /root/.gradle
mkdir -p /cache/npm && ln -s /cache/npm /root/.npm
mkdir -p /cache/bun && ln -s /cache/npm /root/.bun
mkdir -p /cache/pnpm /root/.local/share/ && ln -s /cache/pnpm /root/.local/share/pnpm
mkdir -p /cache/yarn /usr/local/share/.cache/ && ln -s /usr/local/share/.cache/yarn
mkdir -p /cache/rust && ln -s /cache/rust /root/.cargo
mkdir -p /cache/cargo-xwin && ln -s /cache/cargo-xwin /root/.cache/cargo-xwin/
