# Upgrade Guide

## Upgrading from v0.1.0 to v0.2.0

### Overview

Version 0.2.0 introduces **Bootstrap Mode** for joining existing IPFS Clusters. This is a **backwards-compatible** update - existing deployments will continue to work without any changes.

### What's New

- Ability to join existing IPFS Clusters
- Support for multi-region, multi-namespace, and multi-cluster deployments
- New `bootstrap.enabled` and `bootstrap.peers` configuration options

### Breaking Changes

**None** - This is a fully backwards-compatible release.

### Upgrade Steps

#### For Existing Standalone Clusters

If you have an existing standalone cluster and want to keep it as-is:

```bash
# Simply upgrade the chart
helm upgrade ipfs-cluster . -n ipfs

# No configuration changes needed
# bootstrap.enabled defaults to false
```

Your cluster will continue to operate normally.

#### For Adding New Nodes to Existing Clusters

If you want to add new nodes to your existing cluster:

**Option 1: Scale within same namespace**
```bash
# Just increase replicaCount
helm upgrade ipfs-cluster . -n ipfs --set replicaCount=5
```

**Option 2: Deploy to different namespace/cluster with bootstrap**
```bash
# Get bootstrap info from existing cluster
kubectl exec -n ipfs cluster-0-ipfs-cluster-0 -- ipfs-cluster-ctl id

# Deploy new nodes
helm install ipfs-expansion . -n ipfs-backup \
  --set bootstrap.enabled=true \
  --set bootstrap.peers[0]="/ip4/10.0.1.100/tcp/9096/p2p/12D3KooW..." \
  --set sharedSecret="same-secret-as-existing"
```

### Configuration Changes

New parameters added to `values.yaml`:

```yaml
# Bootstrap configuration (NEW in v0.2.0)
bootstrap:
  enabled: false  # Default: disabled for backwards compatibility
  peers: []       # List of bootstrap peer multiaddresses
```

### Validation After Upgrade

```bash
# Check chart version
helm list -n ipfs

# Verify pods are running
kubectl get pods -n ipfs

# Check cluster peer status
kubectl exec -n ipfs cluster-0-ipfs-cluster-0 -- ipfs-cluster-ctl peers ls

# Verify bootstrap configuration (if enabled)
kubectl exec -n ipfs cluster-0-ipfs-cluster-0 -- env | grep CLUSTER_BOOTSTRAP
```

### Rollback

If you need to rollback to v0.1.0:

```bash
helm rollback ipfs-cluster -n ipfs
```

**Note**: Since v0.2.0 doesn't change any existing behavior (when bootstrap is disabled), rollback should be seamless.

### Migration Scenarios

#### Scenario 1: Keep Existing Standalone Cluster

**Before (v0.1.0):**
```yaml
replicaCount: 3
sharedSecret: "your-secret"
```

**After (v0.2.0):**
```yaml
replicaCount: 3
sharedSecret: "your-secret"
# bootstrap section not needed - defaults to disabled
```

**Action**: Just upgrade, no config changes needed.

#### Scenario 2: Convert to Multi-Cluster Setup

**Existing Cluster:**
```yaml
# values-main-cluster.yaml (unchanged)
replicaCount: 3
sharedSecret: "shared-secret"
```

**New Secondary Cluster:**
```yaml
# values-secondary-cluster.yaml (NEW)
replicaCount: 2
sharedSecret: "shared-secret"  # Same!
bootstrap:
  enabled: true
  peers:
    - /ip4/main-cluster-ip/tcp/9096/p2p/12D3KooW...
```

**Actions:**
1. Upgrade main cluster to v0.2.0 (no config changes)
2. Deploy secondary cluster with bootstrap enabled

### Troubleshooting Upgrades

#### Issue: Helm upgrade fails

```bash
# Check current values
helm get values ipfs-cluster -n ipfs

# Do a dry-run first
helm upgrade ipfs-cluster . -n ipfs --dry-run --debug

# Check template rendering
helm template ipfs-cluster . -n ipfs
```

#### Issue: Bootstrap not working after upgrade

```bash
# Verify bootstrap configuration
kubectl get statefulset -n ipfs cluster-0-ipfs-cluster -o yaml | grep -A 3 CLUSTER_BOOTSTRAP

# Check if env var is set
kubectl exec -n ipfs cluster-0-ipfs-cluster-0 -- env | grep CLUSTER_BOOTSTRAP

# Verify it's actually set in values
helm get values ipfs-cluster -n ipfs | grep -A 5 bootstrap
```

#### Issue: Pods restart during upgrade

This is expected for StatefulSets. Kubernetes will perform a rolling update:

```bash
# Monitor rollout
kubectl rollout status statefulset -n ipfs cluster-0-ipfs-cluster

# Check pod events
kubectl get events -n ipfs --sort-by='.lastTimestamp'
```

### Best Practices

1. **Test in non-production first**: Always test upgrades in a dev/staging environment
2. **Backup data**: Before upgrading, backup your IPFS data and pin list
3. **Check compatibility**: Ensure your IPFS and IPFS Cluster versions are compatible
4. **Monitor during upgrade**: Watch pod status and logs during the upgrade
5. **Verify functionality**: Test file add/retrieve after upgrade

### Getting Help

- Check [README.md](README.md) for complete documentation
- See [BOOTSTRAP.md](BOOTSTRAP.md) for bootstrap-specific guidance
- Review [CHANGELOG.md](CHANGELOG.md) for detailed changes
- Open an issue on GitHub for problems

### Version Compatibility Matrix

| Chart Version | IPFS Cluster | IPFS (go-ipfs) | Kubernetes | Helm |
|---------------|--------------|----------------|------------|------|
| 0.2.0         | v0.14.2      | latest         | 1.14+      | 3.x  |
| 0.1.0         | v0.14.2      | latest         | 1.14+      | 3.x  |

### Next Steps After Upgrade

1. Review the new bootstrap documentation in README.md
2. Consider if bootstrap mode would benefit your deployment
3. Test bootstrap functionality in a dev environment
4. Plan multi-region or multi-cluster expansion if needed

## Questions?

Refer to the comprehensive [README.md](README.md) or open an issue if you encounter any problems during the upgrade process.
