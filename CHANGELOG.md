# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.4] - 2025-06-30

- Add `LOWEST_LATENCY_MODEL` environment variable to app container deployments.
- Remove `TLM_DEFAULT_EMBEDDING_MODEL` environment variable from app container deployments.

## [1.0.3] - 2025-06-18

- Add `enable_external_access` variable to `app` module to optionally expose the service with an external IP address.

## [1.0.2] - 2025-06-04

- Use remote Helm chart repo for app module.

## [1.0.1] - 2025-05-30

- Add input to `app` module for ACR repository name.

## [1.0.0] - 2025-05-30

- Initial release of the `infra-modules` repository.

[Unreleased]: https://github.com/cleanlab/infra-modules/compare/v1.0.4...HEAD
[1.0.4]: https://github.com/cleanlab/infra-modules/compare/v1.0.3...v1.0.4
[1.0.3]: https://github.com/cleanlab/infra-modules/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/cleanlab/infra-modules/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/cleanlab/infra-modules/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/cleanlab/infra-modules/compare/025cdabbd3cb3358cbec16595508ec3dc66b42f7...v1.0.0
