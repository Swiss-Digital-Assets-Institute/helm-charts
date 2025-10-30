# IPFS

## Table of Contents

- [What is IPFS?](#what-is-ipfs)
- [What is IPFS Cluster?](#what-is-ipfs-cluster)
- [Architecture Overview](#architecture-overview)
- [Components](#components)
- [Port Reference](#port-reference)
- [API Endpoints](#api-endpoints)
- [Installation](#installation)
- [Configuration](#configuration)
- [Exposing Services](#exposing-services)
- [Monitoring](#monitoring)
- [Troubleshooting](#troubleshooting)
- [Production Considerations](#production-considerations)

## What is IPFS?

**IPFS (InterPlanetary File System)** is a peer-to-peer hypermedia protocol designed to make the web faster, safer, and more open. Unlike traditional HTTP, which fetches content from specific servers, IPFS retrieves content based on what it is, not where it is.

### Use Cases:

- Decentralized file storage and distribution
- Website hosting with resilience
- Large dataset distribution (scientific data, media files)
- Blockchain and NFT storage
- Content delivery networks (CDN alternatives)

## What is IPFS Cluster?

**IPFS Cluster** provides data orchestration across a swarm of IPFS nodes by allocating, replicating, and tracking a global pinset distributed among multiple peers.

### Key Features

- **Coordinated pinning**: Ensures content is replicated across multiple IPFS nodes
- **High availability**: Content remains available even if some nodes go down
- **Load balancing**: Distributes storage and retrieval load across nodes
- **Automatic replication**: Monitors and maintains replication factors
- **RESTful API**: Easy integration with applications

### How It Works

1. You submit content to the cluster via the Cluster API
2. The cluster decides which IPFS nodes should store the content
3. Content is pinned on the selected IPFS nodes
4. The cluster continuously monitors replication status
5. If a node goes down, the cluster automatically re-replicates content

### Additional Cluster Features

- Automatic data replication across nodes
- CRDT-based consensus (no leader election required)
- Persistent storage using StatefulSets
- Support for LoadBalancer, NodePort, and Ingress
- Configurable resource limits

### System Requirements

| Component                | Minimum | Recommended |
| ------------------------ | ------- | ----------- |
| Kubernetes Nodes         | 1       | 3+          |
| CPU per IPFS pod         | 500m    | 2000m       |
| Memory per IPFS pod      | 512Mi   | 4Gi         |
| CPU per Cluster pod      | 100m    | 500m        |
| Memory per Cluster pod   | 128Mi   | 512Mi       |
| Storage per IPFS node    | 1Gi     | 50Gi+       |
| Storage per Cluster node | 500Mi   | 2Gi         |

## Architecture Overview

This Helm chart deploys a paired architecture where each IPFS Cluster node manages a corresponding IPFS node:

```
┌─────────────────────────────────────────────────────────────┐
│                      Kubernetes Cluster                       │
│                                                               │
│  ┌──────────────────┐  ┌──────────────────┐  ┌─────────────┐│
│  │  Cluster Node 0  │  │  Cluster Node 1  │  │ Cluster N.. ││
│  │  ┌────────────┐  │  │  ┌────────────┐  │  │ ┌─────────┐ ││
│  │  │  Cluster   │←─┼──┼─→│  Cluster   │←─┼──┼→│ Cluster │ ││
│  │  │  (9094/96) │  │  │  │  (9094/96) │  │  │ │(9094/96)│ ││
│  │  └─────┬──────┘  │  │  └─────┬──────┘  │  │ └────┬────┘ ││
│  │        │         │  │        │         │  │      │      ││
│  │  ┌─────▼──────┐  │  │  ┌─────▼──────┐  │  │ ┌────▼────┐ ││
│  │  │    IPFS    │  │  │  │    IPFS    │  │  │ │  IPFS   │ ││
│  │  │ (4001/5001)│  │  │  │ (4001/5001)│  │  │ │(4001/   │ ││
│  │  │   /8080    │  │  │  │   /8080    │  │  │ │5001/8080│ ││
│  │  └────────────┘  │  │  └────────────┘  │  │ └─────────┘ ││
│  └──────────────────┘  └──────────────────┘  └─────────────┘│
│                                                               │
│  ┌───────────────────────────────────────────────────────┐   │
│  │              Istio VirtualServices                    │   │
│  │  ┌─────────────────┐    ┌──────────────────────┐     │   │
│  │  │ Public Gateway  │    │   Admin Gateway      │     │   │
│  │  │ (8080: Content) │    │ (9094: Cluster API)  │     │   │
│  │  │ (5001: IPFS API)│    │ (8888: Metrics)      │     │   │
│  │  └─────────────────┘    └──────────────────────┘     │   │
│  └───────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## Components

This chart deploys two main StatefulSets:

### 1. IPFS StatefulSet (`ipfs.statefulset.yaml`)

**Purpose**: Runs the core IPFS nodes that store and serve content.

**Key Characteristics**:

- Deployed as a StatefulSet for stable network identities and persistent storage
- Each pod gets its own PersistentVolumeClaim for data storage
- Uses headless service for stable DNS names per pod
- Manages the actual content storage and P2P networking

**Pod Components**:

- **Container**: `ipfs` - The go-ipfs daemon
- **Data**: Stored in `/data/ipfs`
- **Initialization**: Automatic on first start

### 2. IPFS Cluster StatefulSet (`cluster.statefulset.yaml`)

**Purpose**: Orchestrates and coordinates the IPFS nodes for high availability.

**Key Characteristics**:

- Deployed as a StatefulSet with the same replica count as IPFS
- Each cluster node pairs with a corresponding IPFS node
- Bootstrap mechanism for peer discovery
- Manages cluster consensus and replication

**Pod Components**:

- **Init Container 1**: `init-cluster` - Initializes cluster configuration
- **Init Container 2**: `configure-bootstrap` - Sets up peer discovery (for non-zero pods)
- **Main Container**: `cluster` - The ipfs-cluster-service daemon
- **Data**: Stored in `/data/ipfs-cluster`

## Port Reference

### IPFS Node Ports

````markdown
| Port | Name     | Protocol | Purpose                                   | Access Level |
| ---- | -------- | -------- | ----------------------------------------- | ------------ |
| 4001 | swarm    | TCP      | P2P communication between IPFS nodes      | Internal/P2P |
| 5001 | api      | TCP      | IPFS HTTP API (full control)              | Restricted   |
| 8080 | gateway  | TCP      | HTTP Gateway (read-only content delivery) | Public-safe  |
| 5353 | zeroconf | UDP      | mDNS peer discovery                       | Internal     |

#### Port 4001 - Swarm

- **Purpose**: Peer-to-peer communication with other IPFS nodes
- **Protocol**: libp2p over TCP
- **Use**: Content exchange, DHT queries, bitswap protocol
- **Exposure**: Should be accessible to other IPFS nodes in the network

#### Port 5001 - IPFS HTTP API

- **Purpose**: Full control API for the IPFS node

- **Capabilities**:

  - ✅ Upload/add files (`/api/v0/add`)
  - ✅ Pin/unpin content (`/api/v0/pin/*`)
  - ✅ Retrieve content (`/api/v0/cat`, `/api/v0/get`)
  - ✅ Manage configuration (`/api/v0/config/*`)
  - ✅ Query node information (`/api/v0/id`, `/api/v0/version`)
  - ✅ Manage peers (`/api/v0/swarm/*`)

- **Security**: ⚠️ **MUST BE PROTECTED** - Allows full node control

- **Exposure**: Should only be accessible to authenticated users/services

#### Port 8080 - Gateway

- **Purpose**: HTTP gateway for read-only content retrieval

- **Capabilities**:

  - ✅ Retrieve content via `/ipfs/{CID}/path`
  - ✅ Resolve IPNS names via `/ipns/{name}/path`
  - ✅ Browser-friendly content serving
  - ❌ Cannot upload or modify content
  - ❌ No administrative capabilities

- **Security**: ✅ Safe for public exposure

- **Exposure**: Can be publicly accessible for content delivery

### IPFS Cluster Ports

```markdown
| Port | Name    | Protocol | Purpose                            | Access Level |
| ---- | ------- | -------- | ---------------------------------- | ------------ | -------------------------------------------------------------------------- |
| 9094 | api     | TCP      | Cluster REST API                   | Restricted   |
| 9096 | p2p     | TCP      | Cluster peer-to-peer communication | Internal     |
| 8888 | metrics | TCP      | Prometheus metrics (optional)      | Monitoring   | Name Protocol Purpose Access Level9094 api TCP Cluster REST API Restricted |
```
````

#### Port 9094 - Cluster REST API

- **Purpose**: Cluster management and orchestration API

- **Capabilities**:

  - ✅ Add content to cluster (`POST /pins/{cid}`)
  - ✅ Remove content from cluster (`DELETE /pins/{cid}`)
  - ✅ List cluster peers (`GET /peers`)
  - ✅ Query pin status (`GET /pins`, `GET /pins/{cid}`)
  - ✅ Cluster health (`GET /health/graph`)
  - ✅ Node information (`GET /id`)

- **Security**: ⚠️ **MUST BE PROTECTED** - Allows cluster-wide operations

- **Exposure**: Should only be accessible to authenticated administrators

#### Port 9096 - Cluster P2P

- **Purpose**: Internal cluster consensus and communication
- **Protocol**: libp2p
- **Use**: CRDT consensus, cluster state synchronization
- **Exposure**: Only needs to be accessible between cluster nodes

#### Port 8888 - Metrics (Optional)

- **Purpose**: Prometheus-formatted metrics

- **Metrics Include**:

  - Cluster peer count
  - Pin counts and status
  - IPFS repo size
  - System resources (memory, goroutines)

- **Exposure**: Should be accessible to your monitoring stack

---

## API Endpoints

### IPFS HTTP API (Port 5001)

Base URL: `http://ipfs-node:5001/api/v0/`

#### File Operations

```markdown
Endpoint Method Purpose Example/add POST Upload file(s) to IPFS curl -F file=@photo.jpg http://localhost:5001/api/v0/add
/cat POST Retrieve file content curl "http://localhost:5001/api/v0/cat?arg=QmHash..."
/get POST Download file(s) curl "http://localhost:5001/api/v0/get?arg=QmHash..."
/ls POST List directory contents curl "http://localhost:5001/api/v0/ls?arg=QmHash..."
```

#### Pin Management

```markdown
Endpoint Method Purpose Example/pin/add POST Pin content locally curl -X POST "http://localhost:5001/api/v0/pin/add?arg=QmHash..."
/pin/rm POST Unpin content curl -X POST "http://localhost:5001/api/v0/pin/rm?arg=QmHash..."
/pin/ls POST List pinned content curl "http://localhost:5001/api/v0/pin/ls"
```

#### Node Information

```markdown
Endpoint Method Purpose Example/id POST Get node identity curl "http://localhost:5001/api/v0/id"
/version POST Get IPFS version curl "http://localhost:5001/api/v0/version"
/repo/stat POST Get repository statistics curl "http://localhost:5001/api/v0/repo/stat"
```

### IPFS Gateway (Port 8080)

Base URL: `http://ipfs-node:8080/`

#### Content Retrieval

```markdown
Path Pattern Purpose Example/ipfs/{CID} Retrieve content by CID http://localhost:8080/ipfs/QmHash.../file.txt
/ipfs/{CID}/{path} Retrieve file from directory http://localhost:8080/ipfs/QmHash.../folder/file.jpg
/ipns/{name} Resolve and retrieve IPNS content http://localhost:8080/ipns/example.com/
```

**Note**: Gateway is read-only. Use the API (port 5001) for uploads.

### IPFS Cluster API (Port 9094)

Base URL: `http://cluster-node:9094/`

#### Cluster Management

```markdown
Endpoint Method Purpose Example/id GET Get cluster node info curl http://localhost:9094/id
/peers GET List all cluster peers curl http://localhost:9094/peers
/health/graph GET Get cluster health status curl http://localhost:9094/health/graph
```

#### Pin Operations

```markdown
Endpoint Method Purpose Example/pins GET List all pins in cluster curl http://localhost:9094/pins
/pins/{cid} GET Get pin status curl http://localhost:9094/pins/QmHash...
/pins/{cid} POST Add pin to cluster curl -X POST http://localhost:9094/pins/QmHash...
/pins/{cid} DELETE Remove pin from cluster curl -X DELETE http://localhost:9094/pins/QmHash...
/allocations GET Show pin allocations curl http://localhost:9094/allocations
```

#### Advanced Operations

```markdown
Endpoint Method Purpose Example/pins/{cid}/recover POST Recover failed pin curl -X POST http://localhost:9094/pins/QmHash.../recover
/add POST Add and pin file curl -X POST -F file=@data.txt http://localhost:9094/add
```

### Prometheus Metrics (Port 8888)

Base URL: `http://cluster-node:8888/`

```markdown
Endpoint Method Purpose/metrics GET Prometheus metrics in text format
```

**Key Metrics**:

- `cluster_peers_total` - Number of cluster peers
- `cluster_pins_total` - Total pins in cluster
- `cluster_pins_pinned` - Successfully pinned items
- `cluster_pins_pin_error` - Failed pins
- `ipfs_repo_size_bytes` - IPFS repository size
- `go_memstats_alloc_bytes` - Memory usage

### Bootstrap Configuration (`bootstrap.*`)

Configures bootstrap mode for joining an existing IPFS Cluster.
| Parameter | Description | Default |
| ------------------- | ---------------------------------------------- | ------- |
| `bootstrap.enabled` | Enable bootstrap mode to join existing cluster | `false` |
| `bootstrap.peers` | List of bootstrap peer multiaddresses | `[ ]` |

**Example**:

```yaml
bootstrap:
  enabled: true
  peers:
    - /ip4/10.0.1.100/tcp/9096/p2p/12D3KooWPeer1ABC
    - /dns4/cluster.example.com/tcp/9096/p2p/12D3KooWPeer2DEF
```

## Installation

### Prerequisites

- Kubernetes cluster 1.19+
- Helm 3.0+
- kubectl configured to access your cluster
- (Optional) Istio for ingress management
- (Optional) Prometheus Operator for metrics

### Quick Start

1. **Clone or download the chart**:

bash

```bash
git clone <repository-url>
cd helm-ipfs-cluster
```

2. **Generate a cluster secret**

```bash
od -vN 32 -An -tx1 /dev/urandom | tr -d ' \n'
```

1. **Create a values file** (`my-values.yaml`)

```yaml
replicaCount: 3

sharedSecret: "YOUR_GENERATED_SECRET_HERE"

bootstrap:
  enabled: true

metrics:
  enabled: true

cluster:
  image:
    tag: "v1.0.8"
  resources:
    limits:
      cpu: 1000m
      memory: 2Gi
    requests:
      cpu: 500m
      memory: 1Gi
  storage:
    volumeSize: "5Gi"

ipfs:
  resources:
    limits:
      cpu: 1000m
      memory: 2Gi
    requests:
      cpu: 500m
      memory: 1Gi
  storage:
    volumeSize: "100Gi"
```

1. **Install the chart**:

```bash
helm install my-ipfs-cluster . -f my-values.yaml --namespace ipfs --create-namespace
```

1. **Verify the installation**:

```bash
# Check pods
kubectl get pods -n ipfs

# Check cluster status
kubectl exec -it ipfs-cluster-cluster-0 -n ipfs -c cluster -- ipfs-cluster-ctl peers ls
```

### Upgrading

```bash
helm upgrade my-ipfs-cluster . -f my-values.yaml --namespace ipfs
```

### Uninstalling

```bash
helm uninstall my-ipfs-cluster --namespace ipfs

# Optionally delete PVCs
kubectl delete pvc -n ipfs -l app.kubernetes.io/instance=my-ipfs-cluster
```

---

## Configuration

### Generate Cluster Secret

The cluster secret is a 32-byte hexadecimal string that encrypts communication between cluster nodes. All nodes must share the same secret.

```bash

# Method 1: Using openssl (recommended)
export CLUSTER_SECRET=$(openssl rand -hex 32)

# Method 2: Using od
export CLUSTER_SECRET=$(od -vN 32 -An -tx1 /dev/urandom | tr -d ' \n')

# Method 3: Using xxd
export CLUSTER_SECRET=$(xxd -l 32 -p /dev/urandom | tr -d '\n')

# Example output:
e7f3a4b2c8d1e9f6a3b5c7d2e8f1a4b6c9d3e7f2a5b8c1d4e6f9a2b7c3d5e8f1

```

Parameter Description DefaultreplicaCount Number of IPFS and Cluster nodes 3
sharedSecret Cluster authentication secret ""
bootstrap.enabled Enable automatic peer discovery true
bootstrap.peers External bootstrap peers []
metrics.enabled Enable Prometheus metrics false
cluster.image.tag IPFS Cluster version "" (uses appVersion)
cluster.storage.volumeSize Cluster data volume size "1Gi"
ipfs.storage.volumeSize IPFS data volume size "10Gi"
istio.enabled Enable Istio VirtualServices false

````markdown
### Storage Configuration

Configure persistent storage for production:

```yaml
cluster:
  storage:
    storageClassName: "fast-ssd"
    volumeSize: "10Gi"

ipfs:
  storage:
    storageClassName: "fast-ssd"
    volumeSize: "500Gi"
```
````

### Resource Limits

Set appropriate resource limits:

```yaml
cluster:
  resources:
    limits:
      cpu: 2000m
      memory: 4Gi
    requests:
      cpu: 1000m
      memory: 2Gi

ipfs:
  resources:
    limits:
      cpu: 2000m
      memory: 4Gi
    requests:
      cpu: 1000m
      memory: 2Gi
```

### High Availability

Enable pod anti-affinity for HA:

```yaml
cluster:
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchExpressions:
              - key: nodeType
                operator: In
                values:
                  - cluster
          topologyKey: kubernetes.io/hostname

ipfs:
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchExpressions:
              - key: nodeType
                operator: In
                values:
                  - ipfs
          topologyKey: kubernetes.io/hostname
```

---

## Exposing Services

### Option 1: Istio VirtualService (Recommended)

Enable Istio integration in your values:

```yaml
istio:
  enabled: true

  # Public gateway for content retrieval
  gateways:
    - istio-ingress/ingressgateway-public
  hosts:
    - ipfs.example.com

  # Admin gateway for management
  adminEnabled: true
  adminGateways:
    - istio-ingress/ingressgateway-admin
  adminHosts:
    - ipfs-admin.example.com
```

**Public URLs**:

- Content retrieval: `https://ipfs.example.com/ipfs/{CID}`
- IPFS API: `https://ipfs.example.com/api/v0/*`

**Admin URLs**:

- Cluster API: `https://ipfs-admin.example.com/*`
- Metrics: `https://ipfs-admin.example.com/metrics`

### Option 2: Kubernetes Ingress

Create an Ingress resource:

yaml

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ipfs-ingress
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  tls:
    - hosts:
        - ipfs.example.com
      secretName: ipfs-tls
  rules:
    - host: ipfs.example.com
      http:
        paths:
          - path: /ipfs
            pathType: Prefix
            backend:
              service:
                name: ipfs-test
                port:
                  number: 8080
          - path: /api/v0
```

```yaml
pathType: Prefix
backend:
  service:
    name: ipfs-test
    port:
      number: 5001
```

### Option 3: NodePort Service

Expose services via NodePort:

```yaml
service:
  type: NodePort

ipfs:
  service:
    type: NodePort

cluster:
  service:
    type: NodePort
```

Access services at `<node-ip>:<node-port>`.

### Option 4: LoadBalancer

For cloud environments:

```yaml
service:
  type: LoadBalancer

ipfs:
  service:
    type: LoadBalancer
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-type: "nlb"

cluster:
  service:
    type: LoadBalancer
```

### Security Recommendations

#### Protect Administrative Endpoints

**Always protect these endpoints**:

- IPFS API (port 5001) - Full node control
- Cluster API (port 9094) - Cluster-wide operations

**Protection methods**:

1. **Network Policies**:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ipfs-admin-policy
spec:
  podSelector:
    matchLabels:
      nodeType: ipfs
  policyTypes:
    - Ingress
  ingress:
    # Allow only from specific namespaces
    - from:
        - namespaceSelector:
            matchLabels:
              name: admin-namespace
      ports:
        - protocol: TCP
          port: 5001
```

1. **Istio Authorization**:

```yaml
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: ipfs-admin-auth
spec:
  selector:
    matchLabels:
      app: ipfs-test
  action: ALLOW
  rules:
    - from:
        - source:
            requestPrincipals: ["cluster-local/ns/admin/sa/admin-user"]
      to:
        - operation:
            ports: ["5001", "9094"]
```

1. **API Keys/JWT** (application level)

#### Public Gateway Configuration

The IPFS Gateway (port 8080) is safe for public exposure:

```yaml
istio:
  enabled: true
  gateways:
    - istio-ingress/ingressgateway-public
  hosts:
    - ipfs.example.com
```

Users can retrieve content at:

- `https://ipfs.example.com/ipfs/QmHash.../file.jpg`
- `https://ipfs.example.com/ipns/example.com/`

---

## Monitoring

### Prometheus Metrics

Enable metrics in your values:

yaml

```yaml
metrics:
  enabled: true
```

This exposes metrics on port 8888 at `/metrics`.

### ServiceMonitor (Prometheus Operator)

The chart includes an optional ServiceMonitor resource. Deploy Prometheus Operator and it will automatically discover and scrape metrics:

bash

```bash
helm install my-ipfs-cluster . -f my-values.yaml \
  --set metrics.enabled=true
```

### Key Metrics to Monitor

#### Cluster Health

- `cluster_peers_total` - Should equal your replica count
- `cluster_pins_pinned` - Successfully replicated content
- `cluster_pins_pin_error` - Failed replications (should be 0)
- `cluster_pins_queued` - Pending operations

#### Storage

- `ipfs_repo_size_bytes` - IPFS storage usage
- `ipfs_repo_objects_total` - Number of objects stored

#### Performance

- `go_goroutines` - Concurrent operations
- `go_memstats_alloc_bytes` - Memory usage
- `process_cpu_seconds_total` - CPU usage

### Grafana Dashboard

Create a Grafana dashboard with these queries:

promql

```promql
# Cluster peer count
cluster_peers_total

# Total pins across cluster
sum(cluster_pins_total)

# Pin success rate
sum(cluster_pins_pinned) / sum(cluster_pins_total) * 100

# Storage usage per node
ipfs_repo_size_bytes

# Pin operation latency
rate(cluster_pins_pin_duration_seconds_sum[5m]) /
rate(cluster_pins_pin_duration_seconds_count[5m])
```

### Alerting Rules

Example Prometheus alerting rules:

yaml

```yaml
groups:
  - name: ipfs-cluster
    interval: 30s
    rules:
      - alert: ClusterPeerDown
        expr: cluster_peers_total < 3
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "IPFS Cluster peer count low"
          description: "Cluster has {{ $value }} peers, expected 3"

      - alert: PinReplicationFailed
        expr: cluster_pins_pin_error > 0
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "Pin replication failures detected"
          description: "{{ $value }} pins failed to replicate"

      - alert: IPFSStorageHigh
        expr: ipfs_repo_size_bytes > 450e9 # 450GB
        for: 1h
        labels:
          severity: warning
        annotations:
          summary: "IPFS storage usage high"
          description: "Node {{ $labels.pod }} using {{ $value | humanize }}B"
```

### Health Checks

Check cluster health:

bash

```bash
# Via kubectl exec
kubectl exec -it ipfs-cluster-cluster-0 -n ipfs -c cluster -- \
  ipfs-cluster-ctl health graph

# Via API (if exposed)
curl https://ipfs-admin.example.com/health/graph

# Check individual peer
kubectl exec -it ipfs-cluster-cluster-0 -n ipfs -c cluster -- \
  ipfs-cluster-ctl peers ls
```

### Logs

View logs for troubleshooting:

bash

```bash
# Cluster logs
kubectl logs -n ipfs ipfs-cluster-cluster-0 -c cluster --tail=100 -f

# IPFS logs
kubectl logs -n ipfs ipfs-test-0 -c ipfs --tail=100 -f

# Init container logs
kubectl logs -n ipfs ipfs-cluster-cluster-0 -c init-cluster
kubectl logs -n ipfs ipfs-cluster-cluster-0 -c configure-bootstrap
```

---

## Troubleshooting

### Common Issues

#### 1. Cluster Peers Not Connecting

**Symptoms**: `ipfs-cluster-ctl peers ls` shows "Sees 0 other peers"

**Solutions**:

bash

```bash
# Check if bootstrap is enabled
kubectl get pods -n ipfs -o yaml | grep BOOTSTRAP

# Check cluster secret is set
kubectl get secret -n ipfs

# Verify network connectivity
kubectl exec -it ipfs-cluster-cluster-0 -n ipfs -c cluster -- \
  wget -O- http://ipfs-cluster-cluster-1.ipfs-cluster-cluster.ipfs.svc.cluster.local:9094/id

# Check firewall rules for port 9096
```

#### 2. IPFS Nodes Not Accessible

**Symptoms**: Cluster shows IPFS connection errors

**Solutions**:

bash

```bash
# Check IPFS is running
kubectl get pods -n ipfs -l nodeType=ipfs

# Verify IPFS API endpoint
kubectl exec -it ipfs-cluster-cluster-0 -n ipfs -c cluster -- \
  env | grep CLUSTER_IPFSHTTP_NODEMULTIADDRESS

# Test IPFS connectivity
kubectl exec -it ipfs-test-0 -n ipfs -c ipfs -- \
  ipfs id

# Check DNS resolution
kubectl exec -it ipfs-cluster-cluster-0 -n ipfs -c cluster -- \
  nslookup ipfs-test-0.ipfs-test-headless.ipfs.svc.cluster.local
```

#### 3. Content Not Replicating

**Symptoms**: Pins stuck in "pinning" state

**Solutions**:

bash

```bash
# Check pin status
kubectl exec -it ipfs-cluster-cluster-0 -n ipfs -c cluster -- \
  ipfs-cluster-ctl status QmHash...

# Recover failed pin
kubectl exec -it ipfs-cluster-cluster-0 -n ipfs -c cluster -- \
  ipfs-cluster-ctl pin recover QmHash...

# Check IPFS has the content
kubectl exec -it ipfs-test-0 -n ipfs -c ipfs -- \
  ipfs pin ls QmHash...

# Check storage space
kubectl exec -it ipfs-test-0 -n ipfs -c ipfs -- \
  ipfs repo stat
```

#### 4. Metrics Not Available

**Symptoms**: `/metrics` endpoint returns 404

**Solutions**:

bash

```bash
# Verify metrics are enabled
kubectl get pods -n ipfs -o yaml | grep CLUSTER_METRICS_ENABLESTATS

# Check metrics port
kubectl exec -it ipfs-cluster-cluster-0 -n ipfs -c cluster -- \
  wget -O- http://localhost:8888/metrics

# Port forward to access locally
kubectl port-forward -n ipfs ipfs-cluster-cluster-0 8888:8888
curl http://localhost:8888/metrics
```

#### 5. Pod Crashes or OOMKilled

**Symptoms**: Pods restarting, OOMKilled status

**Solutions**:

bash

```bash
# Check resource usage
kubectl top pods -n ipfs

# Increase memory limits
helm upgrade my-ipfs-cluster . -f my-values.yaml \
  --set cluster.resources.limits.memory=4Gi \
  --set ipfs.resources.limits.memory=4Gi

# Check storage usage
kubectl exec -it ipfs-test-0 -n ipfs -c ipfs -- \
  df -h /data/ipfs
```

#### 6. Istio VirtualService Not Working

**Symptoms**: 404 or connection refused errors

**Solutions**:

bash

```bash
# Verify VirtualService created
kubectl get virtualservice -n ipfs

# Check Istio gateway
kubectl get gateway -n istio-ingress

# Test service directly
kubectl port-forward -n ipfs svc/ipfs-test 8080:8080
curl http://localhost:8080/ipfs/QmHash...

# Check Istio sidecar injection
kubectl get pods -n ipfs -o jsonpath='{.items[*].spec.containers[*].name}'
```

### Debug Commands

bash

```bash
# Get all resources
kubectl get all -n ipfs

# Describe pod for events
kubectl describe pod ipfs-cluster-cluster-0 -n ipfs

# Check persistent volumes
kubectl get pvc -n ipfs
kubectl describe pvc data-ipfs-cluster-cluster-0 -n ipfs

# View all logs since deployment
kubectl logs -n ipfs ipfs-cluster-cluster-0 -c cluster --since=1h

# Execute interactive shell
kubectl exec -it ipfs-cluster-cluster-0 -n ipfs -c cluster -- /bin/sh

# Check service endpoints
kubectl get endpoints -n ipfs

# Validate helm chart
helm lint .
helm template my-ipfs-cluster . -f my-values.yaml --debug
```

---

## Production Considerations

### Scaling

#### Horizontal Scaling

To scale the cluster:

bash

```bash
# Scale up
helm upgrade my-ipfs-cluster . -f my-values.yaml \
  --set replicaCount=5

# Scale down (with caution)
helm upgrade my-ipfs-cluster . -f my-values.yaml \
  --set replicaCount=3
```

**Notes**:

- Scaling up adds more storage and availability
- Scaling down requires careful consideration of replication factor
- Content may need to be re-replicated after scaling

#### Vertical Scaling

Increase resources for existing pods:

```yaml
cluster:
  resources:
    limits:
      cpu: 4000m
      memory: 8Gi
    requests:
      cpu: 2000m
      memory: 4Gi

ipfs:
  resources:
    limits:
      cpu: 4000m
      memory: 8Gi
    requests:
      cpu: 2000m
      memory: 4Gi
```

### Backup and Recovery

#### Backing Up Cluster State

```bash
# Backup cluster configuration
kubectl exec -it ipfs-cluster-cluster-0 -n ipfs -c cluster -- \
  tar -czf /tmp/cluster-backup.tar.gz /data/ipfs-cluster

kubectl cp ipfs/ipfs-cluster-cluster-0:/tmp/cluster-backup.tar.gz \
  ./cluster-backup-$(date +%Y%m%d).tar.gz -c cluster

# Backup IPFS data
kubectl exec -it ipfs-test-0 -n ipfs -c ipfs -- \
  tar -czf /tmp/ipfs-backup.tar.gz /data/ipfs

kubectl cp ipfs/ipfs-test-0:/tmp/ipfs-backup.tar.gz \
  ./ipfs-backup-$(date +%Y%m%d).tar.gz -c ipfs
```

#### Automated Backups with Velero

```bash
# Install Velero
velero install --provider aws --bucket my-backups

# Backup entire namespace
velero backup create ipfs-backup --include-namespaces ipfs

# Schedule daily backups
velero schedule create ipfs-daily \
  --schedule="0 2 * * *" \
  --include-namespaces ipfs
```

#### Disaster Recovery

```bash
# Restore from Velero backup
velero restore create --from-backup ipfs-backup

# Manual restore
kubectl cp ./cluster-backup.tar.gz \
  ipfs/ipfs-cluster-cluster-0:/tmp/cluster-backup.tar.gz -c cluster

kubectl exec -it ipfs-cluster-cluster-0 -n ipfs -c cluster -- \
  tar -xzf /tmp/cluster-backup.tar.gz -C /
```

### Security Hardening

#### Pod Security

yaml

```yaml
cluster:
  podSecurityContext:
    runAsNonRoot: true
    runAsUser: 1000
    fsGroup: 1000
    seccompProfile:
      type: RuntimeDefault

  securityContext:
    allowPrivilegeEscalation: false
    readOnlyRootFilesystem: true
    capabilities:
      drop:
        - ALL

ipfs:
  podSecurityContext:
    runAsNonRoot: true
    runAsUser: 1000
    fsGroup: 1000

  securityContext:
    allowPrivilegeEscalation: false
    capabilities:
      drop:
        - ALL
```

#### Network Policies

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ipfs-cluster-netpol
  namespace: ipfs
spec:
  podSelector:
    matchLabels:
      app.kubernetes.io/name: ipfs-cluster
  policyTypes:
    - Ingress
    - Egress
  ingress:
    # Allow cluster communication
    - from:
        - podSelector:
            matchLabels:
              nodeType: cluster
      ports:
        - protocol: TCP
          port: 9096
    # Allow monitoring
    - from:
        - namespaceSelector:
            matchLabels:
              name: monitoring
      ports:
        - protocol: TCP
          port: 8888
  egress:
    # Allow DNS
    - to:
        - namespaceSelector:
            matchLabels:
              name: kube-system
      ports:
        - protocol: UDP
          port: 53
    # Allow cluster communication
    - to:
        - podSelector:
            matchLabels:
              nodeType: cluster
    # Allow IPFS communication
    - to:
        - podSelector:
            matchLabels:
              nodeType: ipfs
```

#### Secret Management

Use sealed secrets or external secret management:

```bash
# Using Sealed Secrets
kubectl create secret generic ipfs-cluster-secret \
  --from-literal=secret=$(od -vN 32 -An -tx1 /dev/urandom | tr -d ' \n') \
  --dry-run=client -o yaml | \
  kubeseal -o yaml > sealed-secret.yaml

# Using External Secrets Operator
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: ipfs-cluster-secret
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: vault-backend
    kind: SecretStore
  target:
    name: ipfs-cluster-secret
  data:
    - secretKey: secret
      remoteRef:
        key: ipfs/cluster-secret
```

### Performance Tuning

#### IPFS Configuration

Tune IPFS for performance:

yaml

```yaml
ipfs:
  env:
    # Increase connection limits
    - name: IPFS_SWARM_CONNMGR_HIGHWATER
      value: "900"
    - name: IPFS_SWARM_CONNMGR_LOWWATER
      value: "600"
    # Enable experimental features
    - name: IPFS_ENABLE_EXPERIMENTAL_FEATURES
      value: "true"
```

#### Cluster Configuration

```yaml
cluster:
  env:
    # Faster monitoring
    - name: CLUSTER_MONITORPINGINTERVAL
      value: "2s"
    # Larger connection pool
    - name: CLUSTER_IPFSHTTP_POOLSIZE
      value: "100"
```

#### Storage Performance

Use high-performance storage classes:

```yaml
cluster:
  storage:
    storageClassName: "fast-ssd"
    volumeSize: "20Gi"

ipfs:
  storage:
    storageClassName: "fast-ssd"
    volumeSize: "1Ti"
```

### Multi-Region Deployment

Deploy across regions for geo-distribution:

```yaml
# Region 1
cluster:
  nodeSelector:
    topology.kubernetes.io/region: us-east-1

ipfs:
  nodeSelector:
    topology.kubernetes.io/region: us-east-1

# Region 2 (separate cluster)
bootstrap:
  peers:
    - "/dns4/cluster-0.us-east-1.example.com/tcp/9096/p2p/12D3..."
```

### Monitoring and Observability

#### Distributed Tracing

Enable OpenTelemetry:

```yaml
cluster:
  env:
    - name: OTEL_EXPORTER_OTLP_ENDPOINT
      value: "http://jaeger-collector:4318"
    - name: OTEL_SERVICE_NAME
      value: "ipfs-cluster"
```

#### Log Aggregation

Configure centralized logging:

```yaml
# Fluentd/Fluent Bit configuration
apiVersion: v1
kind: ConfigMap
metadata:
  name: fluentd-config
data:
  fluent.conf: |
    <match kubernetes.var.log.containers.ipfs-cluster-**>
      @type elasticsearch
      host elasticsearch
      port 9200
      index_name ipfs-cluster
    </match>
```

### Cost Optimization

#### Storage Tiering

Use different storage classes:

```yaml
# Hot data - SSD
cluster:
  storage:
    storageClassName: "fast-ssd"

# Cold data - HDD
ipfs:
  storage:
    storageClassName: "standard-hdd"
```

#### Resource Requests

Set appropriate requests to avoid over-provisioning:

```yaml
cluster:
  resources:
    requests:
      cpu: 500m # Actual average usage
      memory: 1Gi
    limits:
      cpu: 2000m # Peak usage
      memory: 4Gi
```

#### Autoscaling (Future Enhancement)

Consider implementing HPA for dynamic scaling:

````yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: ipfs-cluster-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: StatefulSet
    name: ipfs-cluster-cluster
  minReplicas: 3
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```

---

## Architecture Diagrams

### Component Interaction
```
┌─────────────────────────────────────────────────────────────────┐
│                         User/Application                          │
└────────────┬────────────────────────┬───────────────────────────┘
             │                        │
             │ Upload/Pin             │ Retrieve Content
             │ (Cluster API)          │ (Gateway)
             │                        │
┌────────────▼────────────┐  ┌────────▼───────────────────────────┐
│   IPFS Cluster API      │  │     IPFS Gateway                   │
│   (Port 9094)           │  │     (Port 8080)                    │
└────────────┬────────────┘  └────────┬───────────────────────────┘
             │                        │
             │ Orchestrate            │ Serve Content
             │ Replication            │
             │                        │
┌────────────▼────────────────────────▼───────────────────────────┐
│                   IPFS Cluster Layer                             │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐                  │
│  │Cluster-0 │◄──►│Cluster-1 │◄──►│Cluster-2 │                  │
│  │(Leader)  │    │(Follower)│    │(Follower)│                  │
│  └────┬─────┘    └────┬─────┘    └────┬─────┘                  │
│       │ CRDT          │ CRDT          │ CRDT                    │
│       │ Consensus     │ Consensus     │ Consensus               │
└───────┼───────────────┼───────────────┼─────────────────────────┘
        │               │               │
        │ Manage        │ Manage        │ Manage
        │ (Port 5001)   │ (Port 5001)   │ (Port 5001)
        │               │               │
┌───────▼───────────────▼───────────────▼─────────────────────────┐
│                      IPFS Storage Layer                          │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐                  │
│  │ IPFS-0   │◄──►│ IPFS-1   │◄──►│ IPFS-2   │                  │
│  │ (Store)  │    │ (Store)  │    │ (Store)  │                  │
│  └────┬─────┘    └────┬─────┘    └────┬─────┘                  │
│       │ P2P           │ P2P           │ P2P                     │
│       │ (Port 4001)   │ (Port 4001)   │ (Port 4001)            │
└───────┼───────────────┼───────────────┼─────────────────────────┘
        │               │               │
        ▼               ▼               ▼
   [Storage PVC]   [Storage PVC]   [Storage PVC]
```

### Data Flow: Adding Content
```
1. User uploads file
        │
        ▼
2. Cluster API receives request (any node)
        │
        ▼
3. Cluster determines allocation
   (which IPFS nodes should store it)
        │
        ▼
4. Cluster tells allocated IPFS nodes to pin
        │
        ├──────────┬──────────┐
        ▼          ▼          ▼
5. IPFS nodes fetch and pin content
   (Node-0)   (Node-1)   (Node-2)
        │          │          │
        └──────────┴──────────┘
                   │
                   ▼
6. Cluster tracks replication status
                   │
                   ▼
7. Returns success when replicated
````

---

## Additional Resources

- **IPFS DEPLOYMENT STRATEGY**: <https://hashgraph.atlassian.net/wiki/spaces/~712020edf5cdba061e4a81b741d486c2525a37/pages/470024205/IPFS+Cluster+Deployment+Strategy+Based+on+Kubo>
- **IPFS AS SERVICE PLATFORM**: <https://hashgraph.atlassian.net/wiki/spaces/~712020706bc044f8f0489a86f1ceda97595a3a/pages/409534465/IAAS+-+IPFS+as+a+Service+Platform>

### Official Documentation

- **IPFS**: <https://docs.ipfs.tech/>
- **IPFS Cluster**: <https://cluster.ipfs.io/documentation/>
- **go-ipfs GitHub**: <https://github.com/ipfs/go-ipfs>
- **ipfs-cluster GitHub**: <https://github.com/ipfs-cluster/ipfs-cluster>

### API References

- **IPFS HTTP API**: <https://docs.ipfs.tech/reference/kubo/rpc/>
- **IPFS Cluster API**: <https://cluster.ipfs.io/documentation/reference/api/>

### Community

- **IPFS Forums**: <https://discuss.ipfs.tech/>
- **IPFS Discord**: <https://discord.gg/ipfs>
- **GitHub Discussions**: <https://github.com/ipfs/ipfs-cluster/discussions>

### Tools

- **IPFS Desktop**: <https://github.com/ipfs/ipfs-desktop>
- **IPFS Companion**: <https://github.com/ipfs/ipfs-companion>
- **ipfs-cluster-ctl**: Command-line tool (included in cluster pods)
