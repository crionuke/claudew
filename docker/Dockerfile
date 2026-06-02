FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        gnupg \
        git \
        unzip \
        zip \
        bash \
        bash-completion \
        locales \
        tzdata \
        sudo \
        openssh-client \
        openssh-server \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Create `claudew` user (beforehand, so subsequent setup can target $HOME)
ARG USERNAME=claudew
ARG USER_UID=1000
ARG USER_GID=1000
RUN if getent passwd "$USER_UID" >/dev/null; then userdel -r "$(getent passwd "$USER_UID" | cut -d: -f1)" 2>/dev/null || true; fi \
    && if getent group "$USER_GID" >/dev/null; then groupdel "$(getent group "$USER_GID" | cut -d: -f1)" 2>/dev/null || true; fi \
    && groupadd --gid "$USER_GID" "$USERNAME" \
    && useradd --uid "$USER_UID" --gid "$USER_GID" -m -s /bin/bash "$USERNAME" \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | tee /usr/share/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y --no-install-recommends gh \
    && rm -rf /var/lib/apt/lists/*

# Docker CLI (to control host Docker via mounted socket)
RUN install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
        | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && chmod a+r /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" \
        > /etc/apt/sources.list.d/docker.list \
    && apt-get update && apt-get install -y --no-install-recommends \
        docker-ce-cli \
        docker-compose-plugin \
        docker-buildx-plugin \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -f docker \
    && usermod -aG docker "$USERNAME"

# Node.js (for Claude Code)
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# Claude Code
RUN npm install -g @anthropic-ai/claude-code

# `claudew` wrapper — runs `claude --dangerously-skip-permissions`
RUN printf '#!/usr/bin/env bash\nexec claude --dangerously-skip-permissions "$@"\n' > /usr/local/bin/claudew \
    && chmod +x /usr/local/bin/claudew

# SDKMAN + Java 25 (Temurin) + Quarkus CLI — installed under /opt so a bind-mount over $HOME doesn't shadow it
ENV SDKMAN_DIR=/opt/sdkman
RUN curl -s "https://get.sdkman.io?rcupdate=false" | bash \
    && source "$SDKMAN_DIR/bin/sdkman-init.sh" \
    && sdk install java 25-tem \
    && sdk install quarkus \
    && sdk flush \
    && chmod -R a+rX /opt/sdkman

ENV JAVA_HOME=/opt/sdkman/candidates/java/current \
    QUARKUS_HOME=/opt/sdkman/candidates/quarkus/current
ENV PATH=$JAVA_HOME/bin:$QUARKUS_HOME/bin:$PATH

# Project skills — symlinked into ~/.claude/skills by the entrypoint
COPY --chown=claudew:claudew skills /opt/claudew/skills

# Git identity — consumed by entrypoint to seed ~/.gitconfig and the SSH key on first run
ARG GIT_USER_NAME="Kirill Byvshev"
ARG GIT_USER_EMAIL="crionuke@gmail.com"
ENV GIT_USER_NAME=$GIT_USER_NAME \
    GIT_USER_EMAIL=$GIT_USER_EMAIL

COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER claudew
WORKDIR /home/claudew

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]