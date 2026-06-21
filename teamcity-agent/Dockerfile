FROM archlinux:base-devel
ENV IMAGE_VERSION=1

RUN sed -i '1i Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' /etc/pacman.d/mirrorlist \
    && pacman -Syyu --noconfirm \
    && pacman -S --noconfirm --needed sudo git gnupg

RUN useradd -m -G wheel -s /bin/bash yay \
    && echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/99-wheel \
    && chmod 0440 /etc/sudoers.d/99-wheel

USER yay
RUN git clone https://aur.archlinux.org/yay-bin.git /home/yay/yay-bin \
    && cd /home/yay/yay-bin \
    && makepkg -si --noconfirm --needed \
    && cd /home/yay \
    && rm -rf /home/yay/yay-bin

RUN yay -Syy --noconfirm --needed git git-lfs jq zip unzip xz 7zip tar wget curl openssh

RUN yay -S --noconfirm --needed uv python

RUN yay -S --noconfirm --needed inetutils net-tools 

RUN yay -S --noconfirm --needed podman podman-compose

RUN yay -S --noconfirm --needed github-cli aws-cli

RUN yay -S --noconfirm --needed jdk21-openjdk jdk8-openjdk maven

RUN yay -S --noconfirm --needed sdkmanager

RUN yay -S --noconfirm --needed go

RUN yay -S --noconfirm --needed npm yarn pnpm bun nodejs eslint typescript

RUN yay -S --noconfirm --needed rustup && RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup rustup default stable && yay -S --noconfirm --needed cross nsis cargo-xwin lld llvm clang

RUN yay -Scc --noconfirm && rm /home/yay/* -rf

USER root

RUN RURUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup rustup default stable && \
    RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup rustup target add x86_64-pc-windows-msvc && \
    RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup rustup target add aarch64-linux-android

RUN cargo xwin cache xwin --xwin-arch x86_64

RUN archlinux-java set java-21-openjdk

ENV ANDROID_HOME=/cache/android-sdk
ENV PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
ENV PATH="$HOME/.cargo/bin:$PATH"
ENV GOPATH=/cache/go

ENV AGENT_VERSION=2026.1
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

COPY entrypoint.sh cache.sh /
RUN chmod +x /entrypoint.sh /cache.sh
ENTRYPOINT ["/entrypoint.sh"]
