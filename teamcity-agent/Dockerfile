FROM archlinux:base-devel
ENV IMAGE_VERSION=4

RUN --mount=type=cache,target=/var/cache/pacman/pkg \
    sed -i '1i Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist \
    && pacman -Syyu --noconfirm \
    && pacman -S --noconfirm --needed sudo git gnupg

RUN sed -i -E '/^OPTIONS=\(/ s/(^|[[:space:]])debug([[:space:])])/\1!debug\2/' /etc/makepkg.conf \
    && grep -Eq '^OPTIONS=.*!debug' /etc/makepkg.conf

RUN useradd -m -s /usr/bin/nologin yay \
    && passwd -l yay \
    && echo 'yay ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/99-yay \
    && chmod 0440 /etc/sudoers.d/99-yay \
    && visudo -c -f /etc/sudoers.d/99-yay

USER yay
RUN git clone https://aur.archlinux.org/yay-bin.git /home/yay/yay-bin \
    && cd /home/yay/yay-bin \
    && makepkg -si --noconfirm --needed \
    && cd /home/yay \
    && rm -rf /home/yay/yay-bin

RUN --mount=type=cache,target=/var/cache/pacman/pkg \
    --mount=type=cache,target=/home/yay/.cache/yay,uid=1000,gid=1000 \
    --mount=type=cache,target=/home/yay/.cargo/registry,uid=1000,gid=1000 \
    --mount=type=cache,target=/home/yay/.cargo/git,uid=1000,gid=1000 \
    yay -S --needed --noconfirm \
        git git-lfs jq zip unzip xz 7zip tar wget curl openssh \
        uv python inetutils net-tools podman podman-compose \
        github-cli aws-cli jdk21-openjdk jdk8-openjdk maven sdkmanager \
        go npm yarn pnpm bun nodejs eslint typescript rustup \
        cross nsis cargo-xwin lld llvm clang \
        gtk3 webkit2gtk-4.1 appmenu-gtk-module libappindicator-gtk3 alsa-lib \
    && RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup rustup default stable

USER root

RUN mkdir -p /usr/lib/gdk-pixbuf-2.0/2.10.0/loaders &&\
    gdk-pixbuf-query-loaders > /usr/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache

RUN RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup rustup default stable && \
    RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup rustup target add x86_64-pc-windows-msvc && \
    RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup rustup target add aarch64-linux-android

RUN cargo xwin cache xwin --xwin-arch x86_64
RUN ln -sf pathcch.lib ~/.cache/cargo-xwin/xwin/sdk/lib/um/x86_64/PathCch.lib

RUN archlinux-java set java-21-openjdk

ENV ANDROID_HOME=/cache/android-sdk
ENV PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
ENV PATH="$HOME/.cargo/bin:$PATH"
ENV GOPATH=/cache/go
ENV PNPM_CONFIG_STORE_DIR=/cache/pnpm/store \
    PNPM_CONFIG_CACHE_DIR=/cache/pnpm/cache

ENV AGENT_DIST=/opt/buildagent \
    CONFIG_DIR=/data/conf \
    LOG_DIR=/opt/buildagent/logs

RUN wget --no-proxy "https://teamcity.k88936.top/update/buildAgentFull.zip" -O /tmp/buildAgentFull.zip \
    && mkdir -p ${AGENT_DIST} \
    && unzip /tmp/buildAgentFull.zip -d ${AGENT_DIST} \
    && rm -f /tmp/buildAgentFull.zip \
    && rm -f ${AGENT_DIST}/bin/*.bat ${AGENT_DIST}/bin/*.plist ${AGENT_DIST}/bin/*.dist \
    && rm -f ${AGENT_DIST}/bin/mac.launchd.sh \
    && chmod +x ${AGENT_DIST}/bin/*.sh \
    && mkdir -p ${CONFIG_DIR} \
    && mkdir -p ${LOG_DIR}

COPY --chmod=0755 entrypoint.sh cache.sh /
ENTRYPOINT ["/entrypoint.sh"]
