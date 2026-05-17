# Hermes Agent Custom Wrapper

This repository provides a customized Docker image build environment for the [Nous Research Hermes Agent](https://github.com/NousResearch/Hermes-Agent).

## Project Overview

The goal of this project is to create a robust, automated pipeline for building and maintaining a customized version of the Hermes Agent image, tailored with specific dependencies and configurations.

### Key Features

- **Base Image:** Starts from the official Nous Research Hermes Agent Docker images.
- **Custom Dependencies:** Extends the base image with a curated set of additional tools and libraries.
- **Multi-Architecture Builds:** Supports both `amd64` and `arm64` architectures.
- **Automated CI/CD:** Utilizes GitHub Actions for building and pushing images.
- **Container Registry:** Images are hosted on the GitHub Container Registry (`ghcr.io`).
- **Dependency Management:** Integrated with Renovate for automated package and base image updates.

## Infrastructure

- **Build System:** GitHub Actions.
- **Deployment:** Handled via external GitOps infrastructure (Kubernetes). Deployment logic is out of scope for this repository.

## Maintenance

Renovate is configured to monitor dependencies and base image updates, ensuring the customized image remains up-to-date with security patches and upstream improvements.
