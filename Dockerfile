# Use the specific pinned version of Hermes Agent as the base
FROM nousresearch/hermes-agent:v2026.5.16@sha256:b6e41c155d6bfce5ad83c5d0fec670086db8a43250e4511c9474134be5482d33

ARG TARGETARCH

USER root

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    git \
    tar \
    build-essential \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Set up environment variables
ENV PATH="/usr/local/go/bin:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"
ENV HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"

# Install GitHub CLI
# renovate: datasource=github-releases depName=cli/cli
RUN GH_VERSION="2.61.0" && \
    case "${TARGETARCH}" in \
        "amd64") GH_ARCH="amd64" ;; \
        "arm64") GH_ARCH="arm64" ;; \
    esac && \
    curl -fsSL "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_${GH_ARCH}.tar.gz" -o gh.tar.gz && \
    tar xzf gh.tar.gz && \
    cp "gh_${GH_VERSION}_linux_${GH_ARCH}/bin/gh" /usr/local/bin/ && \
    rm -rf gh.tar.gz "gh_${GH_VERSION}_linux_${GH_ARCH}"

# Install Docker CLI
# renovate: datasource=github-releases depName=moby/moby
RUN DOCKER_VERSION="29.4.0" && \
    case "${TARGETARCH}" in \
        "amd64") DOCKER_ARCH="x86_64" ;; \
        "arm64") DOCKER_ARCH="aarch64" ;; \
    esac && \
    curl -fsSL "https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/docker-${DOCKER_VERSION}.tgz" -o docker.tgz && \
    tar xzf docker.tgz --strip-components=1 -C /usr/local/bin docker/docker && \
    rm -f docker.tgz

# Install Go
# renovate: datasource=golang-version depName=go
RUN GO_VERSION="1.23.5" && \
    case "${TARGETARCH}" in \
        "amd64") GO_ARCH="amd64" ;; \
        "arm64") GO_ARCH="arm64" ;; \
    esac && \
    curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" -o go.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm -f go.tar.gz

# Install Homebrew
RUN mkdir -p ${HOMEBREW_PREFIX} && \
    git clone --depth 1 https://github.com/Homebrew/brew ${HOMEBREW_PREFIX} && \
    chown -R hermes:hermes ${HOMEBREW_PREFIX} && \
    # Initialize brew as the hermes user
    su - hermes -c "${HOMEBREW_PREFIX}/bin/brew update --force --quiet" && \
    chmod -R g+rwx ${HOMEBREW_PREFIX}

# Symlink hermes to a standard location
RUN ln -sf /opt/hermes/.venv/bin/hermes /usr/local/bin/hermes

# Switch back to the default user
USER hermes

# Ensure brew is available in the shell environment
RUN echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc

WORKDIR /opt/hermes
