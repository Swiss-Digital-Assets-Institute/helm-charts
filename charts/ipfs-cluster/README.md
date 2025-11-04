# ipfs-cluster

![Version: 1.1.0](https://img.shields.io/badge/Version-1.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

Managing and maintaining IPFS clusters in kubernetes.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| bootstrap.enabled | bool | `true` |  |
| bootstrap.peers | list | `[]` |  |
| cluster.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].key | string | `"nodeType"` |  |
| cluster.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].operator | string | `"In"` |  |
| cluster.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].values[0] | string | `"cluster"` |  |
| cluster.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.topologyKey | string | `"kubernetes.io/hostname"` |  |
| cluster.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight | int | `100` |  |
| cluster.image.pullPolicy | string | `"IfNotPresent"` |  |
| cluster.image.repository | string | `"ipfs/ipfs-cluster"` |  |
| cluster.image.tag | string | `"v1.0.8"` |  |
| cluster.imagePullSecrets | list | `[]` |  |
| cluster.livenessProbe.enabled | bool | `true` |  |
| cluster.livenessProbe.failureThreshold | int | `3` |  |
| cluster.livenessProbe.initialDelaySeconds | int | `30` |  |
| cluster.livenessProbe.periodSeconds | int | `10` |  |
| cluster.livenessProbe.timeoutSeconds | int | `5` |  |
| cluster.nodeSelector | object | `{}` |  |
| cluster.podSecurityContext | object | `{}` |  |
| cluster.readinessProbe.enabled | bool | `true` |  |
| cluster.readinessProbe.failureThreshold | int | `3` |  |
| cluster.readinessProbe.initialDelaySeconds | int | `15` |  |
| cluster.readinessProbe.periodSeconds | int | `10` |  |
| cluster.readinessProbe.timeoutSeconds | int | `5` |  |
| cluster.resources | object | `{}` |  |
| cluster.securityContext | object | `{}` |  |
| cluster.service.annotations | object | `{}` |  |
| cluster.service.type | string | `"ClusterIP"` |  |
| cluster.storage.storageClassName | string | `""` |  |
| cluster.storage.volumeSize | string | `"1Gi"` |  |
| cluster.tolerations | list | `[]` |  |
| fullnameOverride | string | `""` |  |
| ipfs.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].key | string | `"nodeType"` |  |
| ipfs.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].operator | string | `"In"` |  |
| ipfs.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.labelSelector.matchExpressions[0].values[0] | string | `"ipfs"` |  |
| ipfs.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].podAffinityTerm.topologyKey | string | `"kubernetes.io/hostname"` |  |
| ipfs.affinity.podAntiAffinity.preferredDuringSchedulingIgnoredDuringExecution[0].weight | int | `100` |  |
| ipfs.image.pullPolicy | string | `"IfNotPresent"` |  |
| ipfs.image.repository | string | `"ipfs/go-ipfs"` |  |
| ipfs.image.tag | string | `"latest"` |  |
| ipfs.imagePullSecrets | list | `[]` |  |
| ipfs.livenessProbe.enabled | bool | `true` |  |
| ipfs.livenessProbe.failureThreshold | int | `3` |  |
| ipfs.livenessProbe.initialDelaySeconds | int | `30` |  |
| ipfs.livenessProbe.periodSeconds | int | `10` |  |
| ipfs.livenessProbe.timeoutSeconds | int | `5` |  |
| ipfs.nodeSelector | object | `{}` |  |
| ipfs.podSecurityContext | object | `{}` |  |
| ipfs.readinessProbe.enabled | bool | `true` |  |
| ipfs.readinessProbe.failureThreshold | int | `3` |  |
| ipfs.readinessProbe.initialDelaySeconds | int | `15` |  |
| ipfs.readinessProbe.periodSeconds | int | `10` |  |
| ipfs.readinessProbe.timeoutSeconds | int | `5` |  |
| ipfs.resources.limits.cpu | string | `"1000m"` |  |
| ipfs.resources.limits.memory | string | `"2Gi"` |  |
| ipfs.resources.requests.cpu | string | `"500m"` |  |
| ipfs.resources.requests.memory | string | `"1Gi"` |  |
| ipfs.securityContext | object | `{}` |  |
| ipfs.service.annotations | object | `{}` |  |
| ipfs.service.type | string | `"ClusterIP"` |  |
| ipfs.storage.storageClassName | string | `""` |  |
| ipfs.storage.volumeSize | string | `"50Gi"` |  |
| ipfs.tolerations | list | `[]` |  |
| istio.adminEnabled | bool | `false` |  |
| istio.adminGateways | list | `[]` |  |
| istio.adminHosts | list | `[]` |  |
| istio.enabled | bool | `false` |  |
| istio.exposeClusterApiPublicly | bool | `false` |  |
| istio.gateways | list | `[]` |  |
| istio.hosts | list | `[]` |  |
| metrics.enabled | bool | `false` |  |
| nameOverride | string | `""` |  |
| replicaCount | int | `3` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| sharedSecret | string | `""` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
