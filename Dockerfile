# Use the specific pinned version of Hermes Agent as the base
FROM nousresearch/hermes-agent:v2026.8.18

LABEL org.opencontainers.image.description="Customized Hermes Agent image with additional deployment tools (gh, docker, go) and optimized for non-root execution in Kubernetes."
LABEL org.opencontainers.image.source="https://github.com/jhart99/jhart99-hermes-agent"
LABEL org.opencontainers.image.base.name="docker.io/nousresearch/hermes-agent:v2026.8.18"

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
    libolm-dev \
    && rm -rf /var/lib/apt/lists/*

# Install additional Python dependencies in the existing venv
COPY requirements.txt .
RUN /usr/local/bin/uv pip install --no-cache-dir -r requirements.txt && \
    rm requirements.txt

# Set up environment variables
ENV PATH="/usr/local/go/bin:${PATH}"

# Install GitHub CLI
# renovate: datasource=github-releases depName=cli/cli
RUN GH_VERSION="2.97.0" && \
    case "${TARGETARCH}" in \
        "amd64") GH_ARCH="amd64" ;; \
        "arm64") GH_ARCH="arm64" ;; \
    esac && \
    curl -fsSL "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_${GH_ARCH}.tar.gz" -o gh.tar.gz && \
    tar xzf gh.tar.gz && \
    cp "gh_${GH_VERSION}_linux_${GH_ARCH}/bin/gh" /usr/local/bin/ && \
    chmod +x /usr/local/bin/gh && \
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
    chmod +x /usr/local/bin/docker && \
    rm -f docker.tgz

# Install Go
# renovate: datasource=golang-version depName=go
RUN GO_VERSION="1.26.6" && \
    case "${TARGETARCH}" in \
        "amd64") GO_ARCH="amd64" ;; \
        "arm64") GO_ARCH="arm64" ;; \
    esac && \
    curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" -o go.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm -f go.tar.gz

# Symlink hermes to a standard location
RUN ln -sf /opt/hermes/.venv/bin/hermes /usr/local/bin/hermes

# Create /opt/data and ensure it's writable by any user for Kubernetes non-root compatibility
RUN mkdir -p /opt/data && chmod 777 /opt/data

# Switch back to the default user
USER hermes

WORKDIR /opt/hermes
