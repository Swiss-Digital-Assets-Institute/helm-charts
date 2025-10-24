# IPFS Cluster Bootstrap Mode

Quick reference guide for joining existing IPFS Clusters.

## Overview

Bootstrap mode allows you to deploy new IPFS Cluster nodes that join an existing cluster, enabling:
- Multi-region deployments
- Cluster expansion across namespaces
- Hybrid cloud setups
- Gradual scaling

## Quick Start

### 1. Get Information from Existing Cluster

```bash
# Get bootstrap peer addresses
kubectl exec -n existing-namespace cluster-0-ipfs-cluster-0 -- ipfs-cluster-ctl id

# Example output:
# 12D3KooWPeerID123 | cluster-0 | Sees 2 other peers
#   > Addresses:
#     - /ip4/10.0.1.100/tcp/9096/p2p/12D3KooWPeerID123
#     - /dns4/cluster-0-ipfs-cluster.existing-namespace.svc.cluster.local/tcp/9096/p2p/12D3KooWPeerID123

# Get the shared secret (if stored in Kubernetes secret)
kubectl get secret -n existing-namespace ipfs-cluster -o jsonpath='{.data.secret}' | base64 -d
```

### 2. Configure values.yaml

```yaml
replicaCount: 1
sharedSecret: "paste-the-shared-secret-here"

bootstrap:
  enabled: true
  peers:
    - /ip4/10.0.1.100/tcp/9096/p2p/12D3KooWPeerID123
    - /ip4/10.0.1.101/tcp/9096/p2p/12D3KooWPeerID456
```

### 3. Deploy

```bash
helm install ipfs-new-nodes . -n ipfs-new \
  --create-namespace \
  --set sharedSecret="your-secret" \
  --set bootstrap.enabled=true \
  --set bootstrap.peers[0]="/ip4/10.0.1.100/tcp/9096/p2p/12D3KooWPeerID123"
```

Or with a values file:

```bash
helm install ipfs-new-nodes . -n ipfs-new \
  --create-namespace \
  -f values-join-cluster-example.yaml
```

### 4. Verify

```bash
# Check new cluster sees existing peers
kubectl exec -n ipfs-new cluster-0-ipfs-cluster-0 -- ipfs-cluster-ctl peers ls

# Check from existing cluster
kubectl exec -n existing-namespace cluster-0-ipfs-cluster-0 -- ipfs-cluster-ctl peers ls

# Expected: All peers visible from both sides
```

## Network Requirements

### Same Kubernetes Cluster

If both clusters are in the same Kubernetes cluster but different namespaces:

```yaml
bootstrap:
  enabled: true
  peers:
    # Use DNS names for cross-namespace communication
    - /dns4/cluster-0-ipfs-cluster.existing-namespace.svc.cluster.local/tcp/9096/p2p/12D3KooWPeerID
```

**Requirements:**
- NetworkPolicy allows cross-namespace communication (if using NetworkPolicies)
- Default DNS resolution works

### Different Kubernetes Clusters

If clusters are in different Kubernetes environments:

```yaml
bootstrap:
  enabled: true
  peers:
    # Use LoadBalancer or NodePort IPs
    - /ip4/203.0.113.10/tcp/9096/p2p/12D3KooWPeerID
```

**Requirements:**
1. Expose cluster P2P port (9096) via LoadBalancer or NodePort on existing cluster:
   ```yaml
   cluster:
     service:
       type: LoadBalancer
   ```

2. Network path between clusters (VPN, peering, public internet)
3. Firewall rules allow port 9096

## Common Scenarios

### Scenario 1: Add Nodes to Same Namespace

```bash
# Just increase replicaCount on existing deployment
helm upgrade ipfs-cluster . -n ipfs --set replicaCount=3
```

### Scenario 2: Add Nodes to Different Namespace

```bash
# Deploy with bootstrap to different namespace
helm install ipfs-expansion . -n ipfs-backup \
  --create-namespace \
  --set bootstrap.enabled=true \
  --set bootstrap.peers[0]="/dns4/cluster-0-ipfs-cluster.ipfs.svc.cluster.local/tcp/9096/p2p/12D3KooW..."
```

### Scenario 3: Multi-Region Deployment

**Region 1 (existing):**
```yaml
# us-east cluster
replicaCount: 3
sharedSecret: "global-secret"
cluster:
  service:
    type: LoadBalancer  # Exposes port 9096
```

**Region 2 (new):**
```yaml
# us-west cluster
replicaCount: 2
sharedSecret: "global-secret"  # Same!
bootstrap:
  enabled: true
  peers:
    - /ip4/203.0.113.10/tcp/9096/p2p/12D3KooWEastPeer1
```

### Scenario 4: Development + Production

**Production cluster:**
```yaml
replicaCount: 5
sharedSecret: "prod-secret"
```

**Dev cluster joins prod for testing:**
```yaml
replicaCount: 1
sharedSecret: "prod-secret"  # Same as prod
bootstrap:
  enabled: true
  peers:
    - /dns4/cluster-0-prod.production.svc.cluster.local/tcp/9096/p2p/12D3KooWProd
```

## Troubleshooting

### Peers Not Connecting

**Check 1: Network connectivity**
```bash
kubectl exec -n ipfs-new cluster-0-ipfs-cluster-0 -- \
  nc -zv 10.0.1.100 9096
```

**Check 2: Shared secret matches**
```bash
# From new cluster
kubectl exec -n ipfs-new cluster-0-ipfs-cluster-0 -- env | grep CLUSTER_SECRET

# From existing cluster
kubectl exec -n existing-namespace cluster-0-ipfs-cluster-0 -- env | grep CLUSTER_SECRET
```

**Check 3: Bootstrap env var is set**
```bash
kubectl exec -n ipfs-new cluster-0-ipfs-cluster-0 -- env | grep CLUSTER_BOOTSTRAP
# Should output: CLUSTER_BOOTSTRAP=/ip4/...
```

**Check 4: Logs**
```bash
kubectl logs -n ipfs-new cluster-0-ipfs-cluster-0 | grep -i "bootstrap\|peer"
```

### Common Errors

**Error: "connection refused"**
- Port 9096 not accessible
- Check firewall rules
- Verify service type (LoadBalancer/NodePort for external access)

**Error: "failed to decrypt message"**
- Shared secrets don't match
- Verify both clusters use same secret

**Error: "no bootstrap peers"**
- `bootstrap.enabled=true` but `bootstrap.peers=[]`
- Add at least one bootstrap peer address

### Validation Checklist

- [ ] Same `sharedSecret` on both clusters
- [ ] Port 9096 accessible from new cluster to bootstrap peers
- [ ] Bootstrap peer addresses are correct (run `ipfs-cluster-ctl id` to verify)
- [ ] Network path exists between clusters
- [ ] New cluster logs show "successfully connected to bootstrap peer"
- [ ] `ipfs-cluster-ctl peers ls` shows all peers

## Best Practices

1. **Use DNS addresses when possible** - More resilient to IP changes
2. **Specify multiple bootstrap peers** - Redundancy if one is down
3. **Test connectivity first** - Use `nc -zv <ip> 9096` before deploying
4. **Monitor cluster health** - Check `ipfs-cluster-ctl health graph`
5. **Document your topology** - Keep track of which clusters are connected
6. **Use same IPFS/Cluster versions** - Avoid compatibility issues

## Environment Variables Reference

When `bootstrap.enabled=true`, the chart sets:

```bash
CLUSTER_BOOTSTRAP=/ip4/10.0.1.100/tcp/9096/p2p/PeerID1,/ip4/10.0.1.101/tcp/9096/p2p/PeerID2
```

This tells the cluster daemon to connect to these peers on startup.

## Performance Considerations

- **Latency**: Cross-region clusters have higher latency for replication
- **Bandwidth**: Consider data transfer costs for multi-cloud
- **Replication Factor**: Adjust based on geographic distribution
- **Pin Allocation**: IPFS Cluster CRDT handles distributed pinning automatically

## Security

- **Shared Secret**: Treat as a sensitive credential
- **Network Exposure**: Only expose port 9096 to trusted networks
- **TLS**: IPFS Cluster encrypts communication using the shared secret
- **Firewall**: Restrict port 9096 to known peer IPs when possible

## Further Reading

- [IPFS Cluster Documentation](https://cluster.ipfs.io/)
- [IPFS Cluster Configuration](https://cluster.ipfs.io/documentation/reference/configuration/)
- [CRDT Consensus](https://cluster.ipfs.io/documentation/guides/consensus/)
