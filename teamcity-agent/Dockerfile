FROM docker.io/kvtodev/ci-containers:base

USER yay
RUN yay -Syy --noconfirm

RUN yay -S --noconfirm --needed inetutils net-tools 

RUN yay -S --noconfirm --needed podman podman-compose

RUN yay -S --noconfirm --needed github-cli aws-cli

RUN yay -S --noconfirm --needed jdk21-openjdk jdk8-openjdk maven

RUN yay -S --noconfirm --needed sdkmanager

RUN yay -S --noconfirm --needed go

RUN yay -S --noconfirm --needed npm yarn pnpm bun nodejs eslint typescript

RUN yay -S --noconfirm --needed rustup && rustup default stable

RUN yay -S --noconfirm --needed cross nsis cargo-xwin lld llvm clang

RUN yay -Scc --noconfirm

USER root
RUN rustup default stable
RUN rustup target add x86_64-pc-windows-msvc
RUN rustup target add aarch64-linux-android 

RUN  archlinux-java set java-21-openjdk

RUN echo "mkdir -p /cache/m2 && ln -s /cache/m2 /root/.m2" >> /cache.sh
RUN echo "mkdir -p /cache/gradle && ln -s /cache/gradle /root/.gradle" >> /cache.sh
RUN echo "mkdir -p /cache/npm && ln -s /cache/npm /root/.npm" >> /cache.sh
RUN echo "mkdir -p /cache/bun && ln -s /cache/npm /root/.bun" >> /cache.sh
RUN echo "mkdir -p /cache/pnpm /root/.local/share/ && ln -s /cache/pnpm /root/.local/share/pnpm" >> /cache.sh
RUN echo "mkdir -p /cache/yarn /usr/local/share/.cache/ && ln -s /usr/local/share/.cache/yarn" >> /cache.sh
RUN echo "mkdir -p /cache/rust && ln -s /cache/rust /root/.cargo" >> /cache.sh

ENV ANDROID_HOME=/cache/android-sdk
ENV PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
ENV PATH="$HOME/.cargo/bin:$PATH"
ENV GOPATH=/cache/go

ENV AGENT_VERSION=2025.11.4
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

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
