# Changelog

All notable changes to this IPFS Cluster Helm chart will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2025-10-24

### Added

- **Bootstrap Mode**: New feature to join existing IPFS Clusters
  - Added `bootstrap.enabled` parameter to enable/disable bootstrap mode
  - Added `bootstrap.peers` parameter to specify bootstrap peer multiaddresses
  - Cluster nodes can now join existing clusters by providing bootstrap peer information
  - Support for multi-region, multi-namespace, and multi-cluster deployments

### Changed

- Updated `Chart.yaml` description to reflect bootstrap support
- Chart version bumped from 0.1.0 to 0.2.0

### Documentation

- Comprehensive bootstrap documentation added to README.md
  - Step-by-step guide for joining existing clusters
  - Prerequisites and network requirements
  - Multiple deployment scenarios (same namespace, different namespace, multi-region)
  - Troubleshooting section for bootstrap issues
- New `BOOTSTRAP.md` quick reference guide
- New `values-join-cluster-example.yaml` example configuration file
- Updated FAQ to reflect bootstrap capability
- Added bootstrap configuration parameters to Configuration section

### Technical Details

- Modified `templates/cluster.statefulset.yaml` to conditionally set `CLUSTER_BOOTSTRAP` environment variable
- Bootstrap peers are joined with comma separator as expected by IPFS Cluster
- Backwards compatible: existing deployments work without any changes (bootstrap disabled by default)

## [0.1.0] - Initial Release

### Added

- Initial IPFS Cluster Helm chart
- IPFS node (go-ipfs) deployment via StatefulSet
- IPFS Cluster node (ipfs-cluster) deployment via StatefulSet
- Shared secret support for cluster encryption
- Configurable storage classes and volume sizes
- Service accounts and RBAC
- Ingress support for HTTP/HTTPS gateway access
- LoadBalancer and NodePort service types
- Resource limits and requests configuration
- Node selectors, tolerations, and affinity rules
- Comprehensive README with deployment guides

### Features

- CRDT-based consensus (no leader election)
- Automatic data replication across nodes
- Persistent storage with PVCs
- StatefulSet-based deployment for stable network identities
- Kubernetes-native service discovery
