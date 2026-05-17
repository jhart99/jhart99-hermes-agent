# Hermes Agent Custom Wrapper

This repository provides a customized Docker image build environment for the [Nous Research Hermes Agent](https://github.com/NousResearch/Hermes-Agent).

## Project Overview

The goal of this project is to create a robust, automated pipeline for building and maintaining a customized version of the Hermes Agent image, tailored with specific dependencies and configurations.

### Key Features

- **Base Image:** Starts from the official Nous Research Hermes Agent Docker images.
- **Custom Dependencies:** Includes pre-installed tools for deployment and development:
  - **GitHub CLI (gh)**: For interacting with GitHub from within the agent.
  - **Docker CLI**: For managing containers (requires `/var/run/docker.sock` mount).
  - **Go**: Full Go toolchain for building and running Go-based tools.
- **Non-Root Execution:** Optimized for Kubernetes with a default non-root user (`hermes`) and a world-writable `/opt/data` directory for persistence.
- **Multi-Architecture Builds:** Supports both `amd64` and `arm64` architectures.
- **Automated CI/CD:** Utilizes GitHub Actions for building and pushing images with OCI-compliant metadata and annotations.
- **Container Registry:** Images are hosted on the GitHub Container Registry (`ghcr.io`).
- **Dependency Management:** Integrated with Renovate for automated package and base image updates.

## Infrastructure

- **Build System:** GitHub Actions.
- **Deployment:** Handled via external GitOps infrastructure (Kubernetes). Deployment logic is out of scope for this repository.

## Maintenance

Renovate is configured to monitor dependencies and base image updates, ensuring the customized image remains up-to-date with security patches and upstream improvements.
