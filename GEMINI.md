# Project Instructions: Hermes Agent Custom Wrapper

This file contains foundational mandates for the `jhart99-hermes-agent` project.

## Core Mandates

- **Target Architectures:** Always build and support both `amd64` and `arm64`.
- **Registry:** All production images must be pushed to `ghcr.io`.
- **Automation:** Use GitHub Actions for all build and release workflows.
- **Dependency Management:** Use Renovate for keeping base images and system packages updated.
- **Deployment Scope:** This repository is strictly for image building and maintenance. Deployment manifests (Kubernetes/GitOps) are managed in a separate repository.

## Development Workflow

- **Dockerfiles:** Ensure multi-arch compatibility in all Dockerfile instructions.
- **CI/CD:** GitHub Action workflows should trigger on pushes to the main branch and for pull requests.
