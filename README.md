# Dex K8s Authenticator

[![CI](https://github.com/wowsel/dex-k8s-authenticator/actions/workflows/ci.yml/badge.svg)](https://github.com/wowsel/dex-k8s-authenticator/actions/workflows/ci.yml)
[![Go Report Card](https://goreportcard.com/badge/github.com/wowsel/dex-k8s-authenticator)](https://goreportcard.com/report/github.com/wowsel/dex-k8s-authenticator)
[![Docker Pulls](https://img.shields.io/docker/pulls/wowsel/dex-k8s-authenticator)](https://hub.docker.com/r/wowsel/dex-k8s-authenticator)
[![License](https://img.shields.io/github/license/wowsel/dex-k8s-authenticator)](LICENSE)

A web application that integrates with [Dex Identity Provider](https://github.com/dexidp/dex) to generate `kubectl` configuration commands for Kubernetes authentication via OIDC.

## Features

- **Multi-cluster support** - Generate kubeconfig for Dev, Staging, Production environments
- **Cross-platform** - Instructions for Linux, macOS, and Windows
- **Helm Charts included** - Easy deployment to Kubernetes
- **TLS/SSL support** - Secure communication out of the box
- **Security hardened** - Non-root container, security headers, CSRF protection

## Quick Start

### Using Docker

```bash
docker pull wowsel/dex-k8s-authenticator:2.0.0
docker run -p 5555:5555 wowsel/dex-k8s-authenticator:2.0.0 --config /app/config.yaml
```

### Using Helm

```bash
helm repo add dex-k8s-auth https://wowsel.github.io/dex-k8s-authenticator
helm install dex-k8s-authenticator dex-k8s-auth/dex-k8s-authenticator
```

Or install from local charts:

```bash
helm install dex-k8s-authenticator ./charts/dex-k8s-authenticator
```

## Documentation

| Document | Description |
|----------|-------------|
| [Developing and Running](docs/develop.md) | Local development setup |
| [Configuration Options](docs/config.md) | All configuration parameters |
| [Using the Helm Charts](docs/helm.md) | Helm deployment guide |
| [SSL Support](docs/ssl.md) | TLS configuration |
| [AWS EKS Guide](docs/eks.md) | Running on Amazon EKS |

## Screenshots

<details>
<summary>Click to expand</summary>

### Cluster Selection
![Index Page](examples/index-page.png)

### Kubeconfig Generation
![Kubeconfig Page](examples/kubeconfig-page.png)

</details>

## Requirements

- Kubernetes 1.19+
- Helm 3.0+ (for Helm installation)
- [Dex](https://github.com/dexidp/dex) v2.30+

## Architecture

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   Browser   │──────│  dex-k8s-   │──────│     Dex     │
│             │      │authenticator│      │   (OIDC)    │
└─────────────┘      └─────────────┘      └─────────────┘
                            │
                            ▼
                     ┌─────────────┐
                     │ Kubernetes  │
                     │  API Server │
                     └─────────────┘
```

## Alternatives

- [gangway](https://github.com/heptiolabs/gangway)
- [k8s-oidc-helper](https://github.com/micahhausler/k8s-oidc-helper)
- [kuberos](https://github.com/negz/kuberos)
- [loginapp](https://github.com/fydrah/loginapp)

## License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

Originally based on the [example-app](https://github.com/dexidp/dex/tree/master/cmd/example-app) from the Dex repository, originally developed by [Mintel](https://github.com/mintel).
