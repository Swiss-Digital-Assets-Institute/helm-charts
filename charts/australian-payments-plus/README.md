# australian-payments-plus

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

# AP+ API - Helm Chart

This package contains the Helm Chart for deploying the **AP+ API** service in a Kubernetes environment.

## ⚙️ Prerequisites

- Kubernetes ≥ 1.21
- Helm ≥ 3.0
- Istio installed in the cluster (required if `istio.virtualServices.enabled: true`)
- External Secrets Operator installed and configured with Vault

## 🚀 Installation

```bash
# 1. Navigate to the Helm chart directory
cd applus-api-helm/

# 2. (Optional) Review and adjust values.yaml if needed

# 3. Install the application
helm upgrade --install applus-api . -f values.yaml

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| hashgraph-group | <hashgraph-group@hashgraph-group.com> | <www.hashgraph-group.com> |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | affinity allows you to define rules for pod scheduling based on node labels |
| args | list | `[]` | args is the object to specify the arguments to run in the container |
| autoReloader | bool | `true` | autoReloader enable auto reloader to restart the container when the configMap is updated |
| autoscaling | object | `{"customRules":[],"enabled":false,"maxReplicas":2,"minReplicas":1,"targetCPUUtilizationPercentage":80,"targetMemoryUtilizationPercentage":80}` | autoscaling is the main object of autoscaling |
| autoscaling.customRules | list | `[]` | customRules is a place to customize your application autoscaler using the original API available at: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ |
| autoscaling.enabled | bool | `false` | enabled is the flag to sinalize this funcionality is enabled |
| autoscaling.maxReplicas | int | `2` | maxReplicas is the number of maximum scaling pods |
| autoscaling.minReplicas | int | `1` | minReplicas is the number of mim pods to be running |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | targetCPUUtilizationPercentage is the percentage of cpu when reached to scale new pods |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` | targetMemoryUtilizationPercentage is the percentage of memoty when reached to scale new pods |
| command | list | `[]` | command is the object to specify the command to run in the container |
| commonLabels | object | `{}` | commonLabels sets common labels for all resources |
| container.port | int | `3000` | port is the port your application runs under |
| container.readOnlyRootFilesystem | bool | `true` | readOnlyRootFilesystem is the prop to setup the container root filesystem as read-only |
| deployment | object | `{"annotations":{},"enabled":true,"labels":{},"strategyType":"RollingUpdate"}` | deployment Disabled Deployment |
| deployment.annotations | object | `{}` | annotations to be added to the deployment |
| deployment.enabled | bool | `true` | enabled is the flag to sinalize this funcionality is enabled |
| deployment.labels | object | `{}` | labels to be added to the deployment |
| deployment.strategyType | string | `"RollingUpdate"` | strategyType is the type of deployment strategy to use |
| envFrom[0].secretRef.name | string | `"kvv-applus"` |  |
| envs[0].name | string | `"API_PORT"` |  |
| envs[0].value | string | `"3000"` |  |
| envs[1].name | string | `"NODE_ENV"` |  |
| envs[1].value | string | `"development"` |  |
| envs[2].name | string | `"POSTGRES_HOST"` |  |
| envs[2].value | string | `"postgresql.australian-payments-plus.svc.cluster.local"` |  |
| envs[3].name | string | `"POSTGRES_PORT"` |  |
| envs[3].value | string | `"5432"` |  |
| envs[4].name | string | `"POSTGRES_USER"` |  |
| envs[4].value | string | `"applus"` |  |
| envs[5].name | string | `"POSTGRES_DATABASE"` |  |
| envs[5].value | string | `"applus"` |  |
| externalSecrets.enabled | bool | `true` | If enabled, ExternalSecret resources will be created to sync secrets from external sources (e.g., Vault). |
| externalSecrets.refreshInterval | string | `"30s"` | The time interval at which secrets are refreshed from the external source (e.g., Vault). Default value is "30s", meaning secrets will be refreshed every 30 seconds. |
| externalSecrets.secretStoreRef.kind | string | `"ClusterSecretStore"` | The kind of SecretStore used to fetch secrets. By default, this is set to "ClusterSecretStore" to allow cluster-wide secret management. |
| externalSecrets.secretStoreRef.name | string | `"vault-backend"` | The name of the SecretStore backend. For Vault, this typically refers to the Vault connection (e.g., "vault-backend"). |
| externalSecrets.secrets | list | `[{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"API_PORT"},"secretKey":"API_PORT"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"NODE_ENV"},"secretKey":"NODE_ENV"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"DATABASE_URL"},"secretKey":"DATABASE_URL"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"ACCOUNT_CONFIG"},"secretKey":"ACCOUNT_CONFIG"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"PROVIDER_CONFIG"},"secretKey":"PROVIDER_CONFIG"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"CHAIN_CONFIG"},"secretKey":"CHAIN_CONFIG"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"JSON_RPC_PROVIDER_CONFIG"},"secretKey":"JSON_RPC_PROVIDER_CONFIG"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"HASHGRAPH_ACCOUNT_ID"},"secretKey":"HASHGRAPH_ACCOUNT_ID"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"HASHGRAPH_PUBLIC_KEY"},"secretKey":"HASHGRAPH_PUBLIC_KEY"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"HASHGRAPH_PRIVATE_KEY"},"secretKey":"HASHGRAPH_PRIVATE_KEY"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"HASHGRAPH_NETWORK"},"secretKey":"HASHGRAPH_NETWORK"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"HASHGRAPH_MIRROR_NODE_URL"},"secretKey":"HASHGRAPH_MIRROR_NODE_URL"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"HASHICORP_VAULT_URL"},"secretKey":"HASHICORP_VAULT_URL"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"HASHICORP_VAULT_TOKEN"},"secretKey":"HASHICORP_VAULT_TOKEN"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"RETRY_MAX_RETRIES"},"secretKey":"RETRY_MAX_RETRIES"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"RETRY_DELAY_MS"},"secretKey":"RETRY_DELAY_MS"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"ORCHESTRATION_SCHEDULER_ENABLED"},"secretKey":"ORCHESTRATION_SCHEDULER_ENABLED"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"ESCROW_ADDRESS"},"secretKey":"ESCROW_ADDRESS"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"CHAIN_TYPE_TEMP"},"secretKey":"CHAIN_TYPE_TEMP"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"CHAIN_TEMP"},"secretKey":"CHAIN_TEMP"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"NETWORK_TEMP"},"secretKey":"NETWORK_TEMP"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"INTERCHANGE_ADDRESS"},"secretKey":"INTERCHANGE_ADDRESS"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"REDBANK_MEMBER_FX_ADDRESS"},"secretKey":"REDBANK_MEMBER_FX_ADDRESS"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"BLUEBANK_MEMBER_FX_ADDRESS"},"secretKey":"BLUEBANK_MEMBER_FX_ADDRESS"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"REDCOIN_ADDRESS"},"secretKey":"REDCOIN_ADDRESS"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"BLUECOIN_ADDRESS"},"secretKey":"BLUECOIN_ADDRESS"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"NOTIFICATION_API_KEY"},"secretKey":"NOTIFICATION_API_KEY"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"NOTIFICATION_BASE_URL"},"secretKey":"NOTIFICATION_BASE_URL"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"ORCHESTRATION_PROCESS_TIMEOUT_SECONDS"},"secretKey":"ORCHESTRATION_PROCESS_TIMEOUT_SECONDS"},{"remoteRef":{"key":"secrets/dev/tha-dev-elca-k8s/australian-payments-plus","property":"POSTGRES_PASSWORD"},"secretKey":"POSTGRES_PASSWORD"}]` | List of secrets to be synced from the external source (e.g., Vault). Add secrets here, where each secretKey in Kubernetes will map to a corresponding key in the external store. |
| externalSecrets.target.creationPolicy | string | `"Owner"` | The creation policy for the target Kubernetes Secret. "Owner" means ExternalSecret manages the lifecycle of the created secret, deleting it when ExternalSecret is deleted. |
| global.cluster | string | `"cluster.local"` | cluster sets the Cluster Name |
| global.env | string | `"dev"` | env sets the Environment Name (dev, mng, prd) |
| global.network | object | `{"domain":"<your-domain>"}` | Network configuration |
| global.network.domain | string | `"<your-domain>"` | domain sets the Default Domain |
| image.pullPolicy | string | `"IfNotPresent"` | pullPolicy is the prop to setup the behavior of pull police. options is: IfNotPresent \| allways |
| image.repository | string | `"<your-registry>/<your-repo>/<your-image>"` | repository: is the registry of your application ex:556684128444.dkr.ecr.us-east-1.amazonaws.com/YOU-APP-ECR-REPO-NAME if empty this helm will auto generate the image using aws.registry/values.name:values.image.tag |
| image.tag | string | `"latest"` | especify the tag of your image to deploy |
| imagePullSecrets | list | `[]` | imagePullSecrets secret used to download image on private container registry |
| istio | object | `{"authorizationPolicy":{"action":"ALLOW","enabled":true,"rules":[{"from":[{"source":{"namespaces":["*"]}}]}]},"enabled":true,"gateways":"istio-ingress/istio-ingressgateway","peerAuthentication":{"enabled":true,"mode":"PERMISSIVE"},"virtualServices":{"custom":{"hosts":[]},"enabled":true,"public":false}}` | istio Set default Istio |
| istio.authorizationPolicy | object | `{"action":"ALLOW","enabled":true,"rules":[{"from":[{"source":{"namespaces":["*"]}}]}]}` | authorizationPolicy set default authorization policy |
| istio.authorizationPolicy.enabled | bool | `true` | enable authorizationPolicy |
| istio.gateways | string | `"istio-ingress/istio-ingressgateway"` | gateways set default gateway for virtual-service |
| istio.peerAuthentication | object | `{"enabled":true,"mode":"PERMISSIVE"}` | PeerAuthentication defines how traffic will be tunneled (or not) to the sidecar. |
| istio.peerAuthentication.enabled | bool | `true` | enable peerAuthentication |
| istio.peerAuthentication.mode | string | `"PERMISSIVE"` | set peerAuthentication mode, values (UNSET, DISABLE, PERMISSIVE, STRICT) |
| istio.virtualServices | object | `{"custom":{"hosts":[]},"enabled":true,"public":false}` | istio.virtualServices Set Istio virtualServices parameters |
| istio.virtualServices.enabled | bool | `true` | istio.virtualServices.enable Set Istio virtualServices enabled |
| livenessProbe | object | `{"enabled":false,"exec":{},"failureThreshold":3,"httpHeaders":[],"initialDelaySeconds":10,"periodSeconds":10,"scheme":"HTTP","successThreshold":1,"timeoutSeconds":3}` | livenessProbe indicates whether the application is running and alive |
| livenessProbe.enabled | bool | `false` | Specifies whether the liveness probe is enabled |
| livenessProbe.exec | object | `{}` | Specifies a command to run inside the container to determine liveness |
| livenessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the probe to be considered failed after having succeeded |
| livenessProbe.httpHeaders | list | `[]` | httpHeaders specifies custom headers to set in the request |
| livenessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before liveness probes are initiated |
| livenessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the liveness probe |
| livenessProbe.scheme | string | `"HTTP"` | The scheme to use for the liveness probe (e.g., HTTP or HTTPS) |
| livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful after having failed |
| livenessProbe.timeoutSeconds | int | `3` | Number of seconds after which the liveness probe times out |
| name | string | `"applus"` | name is the GitHub repository name of this application deployment |
| namespace | object | `{"annotations":{},"enabled":false,"labels":{}}` | namespace configuration |
| namespace.annotations | object | `{}` | Annotations to be added to the namespace |
| namespace.enabled | bool | `false` | Specifies whether the namespace is enabled |
| namespace.labels | object | `{}` | Labels to be added to the namespace |
| nodeSelector | object | `{}` | nodeSelector allows you to constrain a Pod to only be able to run on particular node(s) |
| podAnnotations | object | `{}` | podAnnotations adds custom annotations to the pod |
| podSecurityContext | object | `{}` | A security context defines privilege and access control settings for a Pod or Container. About more: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/ |
| readinessProbe | object | `{"enabled":false,"exec":{},"failureThreshold":3,"httpHeaders":[],"initialDelaySeconds":10,"path":"/health-check/readiness","periodSeconds":10,"scheme":"HTTP","successThreshold":1,"timeoutSeconds":3}` | readinessProbe indicates whether the application is ready to serve requests |
| readinessProbe.enabled | bool | `false` | Specifies whether the readiness probe is enabled |
| readinessProbe.exec | object | `{}` | Specifies a command to run inside the container to determine readiness |
| readinessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the probe to be considered failed after having succeeded |
| readinessProbe.httpHeaders | list | `[]` | httpHeaders specifies custom headers to set in the request |
| readinessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before readiness probes are initiated |
| readinessProbe.path | string | `"/health-check/readiness"` | The HTTP path to check for readiness |
| readinessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the readiness probe |
| readinessProbe.scheme | string | `"HTTP"` | The scheme to use for the readiness probe (e.g., HTTP or HTTPS) |
| readinessProbe.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful after having failed |
| readinessProbe.timeoutSeconds | int | `3` | Number of seconds after which the readiness probe times out |
| replicaCount | int | `1` | replicaCount is used when autoscaling.enabled is false to set a manually number of pods |
| resources | object | `{"limits":{"cpu":"100m","memory":"1024Mi"},"requests":{"cpu":"50m","memory":"512Mi"}}` | resources set deployment resources |
| resources.limits | object | `{"cpu":"100m","memory":"1024Mi"}` | Resource limits are the maximum amount of CPU and memory that the container is allowed to use |
| resources.limits.cpu | string | `"100m"` | The maximum amount of CPU the container can use |
| resources.limits.memory | string | `"1024Mi"` | The maximum amount of memory the container can use |
| resources.requests.cpu | string | `"50m"` | The amount of CPU requested for the container |
| resources.requests.memory | string | `"512Mi"` | The amount of memory requested for the container |
| restartPolicy | string | `"Always"` | restartPolicy is the object to specify the restart policy for the container |
| service | object | `{"annotations":{},"enabled":true,"externalDns":{"enabled":false},"labels":{},"nodePort":{},"port":{"name":"tcp-node","port":80,"targetPort":3000},"type":"ClusterIP"}` | service |
| service.annotations | object | `{}` | Annotations to add to the service |
| service.enabled | bool | `true` | service.enabled to enable and disable the creation of service |
| service.externalDns | object | `{"enabled":false}` | service.externalDns to enable and disable the creation of external DNS |
| service.externalDns.enabled | bool | `false` | Enable or disable external DNS for the service |
| service.labels | object | `{}` | Labels to add to the service |
| service.nodePort | object | `{}` | The port to expose on each node in a cluster, only used if type is NodePort or LoadBalancer |
| service.port | object | `{"name":"tcp-node","port":80,"targetPort":3000}` | service.port Define the Service Port |
| service.port.name | string | `"tcp-node"` | Name of the port, used for service discovery |
| service.port.port | int | `80` | Port is the port your application runs under |
| service.port.targetPort | int | `3000` | targetPort is the port your application runs under |
| service.type | string | `"ClusterIP"` | Service An abstract way to expose an application running on a set of Pods as a network service. |
| serviceAccount | object | `{"annotations":{},"automountServiceAccountToken":true,"enabled":true,"name":{}}` | ServiceAccount A service account provides an identity for processes that run in a Pod, about more: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automountServiceAccountToken | bool | `true` | serviceAccount.annotations Automont Service Account Token |
| serviceAccount.enabled | bool | `true` | Specifies whether a service account should be created |
| terminationGracePeriodSeconds | int | `30` | terminationGracePeriodSeconds is the number of seconds to wait before terminating a pod |
| tolerations | list | `[]` | tolerations allows the pods to schedule onto nodes with taints |
| topologySpreadConstraints | object | `{"enabled":true,"maxSkew":1,"topologyKey":"topology.kubernetes.io/zone","whenUnsatisfiable":"ScheduleAnyway"}` | topologySpreadConstraints allows you to constrain the pods to run on nodes with a certain topology |
| topologySpreadConstraints.enabled | bool | `true` | topologySpreadConstraints.enabled specifies whether topology spread constraints should be applied |
| topologySpreadConstraints.maxSkew | int | `1` | topologySpreadConstraints.maxSkew specifies the maximum skew allowed among the topologies |
| topologySpreadConstraints.topologyKey | string | `"topology.kubernetes.io/zone"` | topologySpreadConstraints.topologyKey specifies the key of the topology |
| topologySpreadConstraints.whenUnsatisfiable | string | `"ScheduleAnyway"` | topologySpreadConstraints.whenUnsatisfiable specifies the action to take when a constraint is not satisfied |
| volumeMounts | list | `[]` | volumeMounts specifies where Kubernetes will mount Pod volumes |
| volumes | list | `[]` | volumes specifies pod volumes |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
