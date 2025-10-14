# webapp

![Version: 0.2.8](https://img.shields.io/badge/Version-0.2.8-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

Helm Charts for default Web Application

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| diegoluisi | <diego.luisi@hashgraph-group.com> | <www.diegoluisi.eti.br> |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| actuator.enabled | bool | `false` | If enabled, create default actuator path and metrics |
| actuator.liveness.failureThreshold | int | `3` | Minimum consecutive failures for the probe to be considered failed after having succeeded |
| actuator.liveness.httpHeaders | list | `[]` | httpHeaders specifies custom headers to set in the request |
| actuator.liveness.initialDelaySeconds | int | `120` | Number of seconds after the container has started before readiness probes are initiated |
| actuator.liveness.path | string | `"/actuator/health/liveness"` | The path to check liveness of the application |
| actuator.liveness.periodSeconds | int | `10` | How often (in seconds) to perform the readiness probe |
| actuator.liveness.scheme | string | `"HTTP"` | The scheme to use for the readiness probe (e.g., HTTP or HTTPS) |
| actuator.liveness.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful after having failed |
| actuator.liveness.timeoutSeconds | int | `3` | Number of seconds after which the readiness probe times out |
| actuator.metrics.path | string | `"/actuator/prometheus"` | The path to expose Prometheus metrics |
| actuator.port.name | string | `"tcp-metrics"` | The name of the port for actuator metrics |
| actuator.port.port | int | `9090` | The port number for actuator metrics |
| actuator.port.protocol | string | `"TCP"` | The protocol used to service |
| actuator.port.targetPort | int | `9090` | The target port in the container for actuator metrics |
| actuator.readiness.failureThreshold | int | `3` | Minimum consecutive failures for the probe to be considered failed after having succeeded |
| actuator.readiness.httpHeaders | list | `[]` | httpHeaders specifies custom headers to set in the request |
| actuator.readiness.initialDelaySeconds | int | `120` | Number of seconds after the container has started before readiness probes are initiated |
| actuator.readiness.path | string | `"/actuator/health/readiness"` | The path to check readiness of the application |
| actuator.readiness.periodSeconds | int | `10` | How often (in seconds) to perform the readiness probe |
| actuator.readiness.scheme | string | `"HTTP"` | The scheme to use for the readiness probe (e.g., HTTP or HTTPS) |
| actuator.readiness.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful after having failed |
| actuator.readiness.timeoutSeconds | int | `3` | Number of seconds after which the readiness probe times out |
| affinity | object | `{}` | affinity allows you to define rules for pod scheduling based on node labels |
| argoRollouts | object | `{"analyses":{"enabled":true,"failureLimit":3,"initialDelay":"30s","interval":"20s","metricName":"success-rate","successCondition":"len(result) == 0 || isNaN(result[0]) || isInf(result[0]) || result[0] >= 0.95"},"dynamicStableScale":true,"enabled":false,"revisionHistoryLimit":3,"strategy":{"steps":[{"setWeight":5},{"pause":{"duration":"10s"}},{"setWeight":20},{"pause":{"duration":"10s"}},{"setWeight":40},{"pause":{"duration":"10s"}},{"setWeight":60},{"pause":{"duration":"10s"}},{"setWeight":80},{"pause":{"duration":"10s"}}]}}` | argoRollouts enable Argo Rollouts Deployment |
| argoRollouts.analyses | object | `{"enabled":true,"failureLimit":3,"initialDelay":"30s","interval":"20s","metricName":"success-rate","successCondition":"len(result) == 0 || isNaN(result[0]) || isInf(result[0]) || result[0] >= 0.95"}` | Specifies whether analysis runs should be created during the rollout |
| argoRollouts.analyses.enabled | bool | `true` | enabled specifies whether analysis runs should be created during the rollout |
| argoRollouts.analyses.failureLimit | int | `3` | Specifies the maximum number of failed analysis runs allowed before the rollout fails |
| argoRollouts.analyses.successCondition | string | `"len(result) == 0 || isNaN(result[0]) || isInf(result[0]) || result[0] >= 0.95"` | Specifies the success condition for the analysis, as a percentage |
| argoRollouts.dynamicStableScale | bool | `true` | Specifies whether the stable ReplicaSet should be dynamically scaled during rollout |
| argoRollouts.enabled | bool | `false` | Specifies whether Argo Rollouts is enabled |
| argoRollouts.revisionHistoryLimit | int | `3` | Specifies the number of old ReplicaSets to retain for rollback purposes |
| argoRollouts.strategy | object | `{"steps":[{"setWeight":5},{"pause":{"duration":"10s"}},{"setWeight":20},{"pause":{"duration":"10s"}},{"setWeight":40},{"pause":{"duration":"10s"}},{"setWeight":60},{"pause":{"duration":"10s"}},{"setWeight":80},{"pause":{"duration":"10s"}}]}` | strategy is the object to configure the rollout strategy |
| argoRollouts.strategy.steps[0] | object | `{"setWeight":5}` | Sets the percentage of traffic to send to the new version |
| argoRollouts.strategy.steps[1] | object | `{"pause":{"duration":"10s"}}` | Pauses the rollout for a specified duration |
| argoRollouts.strategy.steps[2] | object | `{"setWeight":20}` | Sets the percentage of traffic to send to the new version |
| argoRollouts.strategy.steps[3] | object | `{"pause":{"duration":"10s"}}` | Pauses the rollout for a specified duration |
| argoRollouts.strategy.steps[4] | object | `{"setWeight":40}` | Sets the percentage of traffic to send to the new version |
| argoRollouts.strategy.steps[5] | object | `{"pause":{"duration":"10s"}}` | Pauses the rollout for a specified duration |
| argoRollouts.strategy.steps[6] | object | `{"setWeight":60}` | Sets the percentage of traffic to send to the new version |
| argoRollouts.strategy.steps[7] | object | `{"pause":{"duration":"10s"}}` | Pauses the rollout for a specified duration |
| argoRollouts.strategy.steps[8] | object | `{"setWeight":80}` | Sets the percentage of traffic to send to the new version |
| argoRollouts.strategy.steps[9] | object | `{"pause":{"duration":"10s"}}` | Pauses the rollout for a specified duration |
| args | list | `[]` | args is the object to specify the arguments to run in the container |
| autoReloader | bool | `true` | autoReloader enable auto reloader to restart the container when the configMap is updated |
| autoscaling | object | `{"customRules":[],"enabled":true,"maxReplicas":2,"minReplicas":1,"targetCPUUtilizationPercentage":80,"targetMemoryUtilizationPercentage":80}` | autoscaling is the main object of autoscaling |
| autoscaling.customRules | list | `[]` | customRules is a place to customize your application autoscaler using the original API available at: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ |
| autoscaling.enabled | bool | `true` | enabled is the flag to sinalize this funcionality is enabled |
| autoscaling.maxReplicas | int | `2` | maxReplicas is the number of maximum scaling pods |
| autoscaling.minReplicas | int | `1` | minReplicas is the number of mim pods to be running |
| autoscaling.targetCPUUtilizationPercentage | int | `80` | targetCPUUtilizationPercentage is the percentage of cpu when reached to scale new pods |
| autoscaling.targetMemoryUtilizationPercentage | int | `80` | targetMemoryUtilizationPercentage is the percentage of memoty when reached to scale new pods |
| command | list | `[]` | command is the object to specify the command to run in the container |
| commonLabels | object | `{}` | commonLabels sets common labels for all resources |
| configMaps | object | `{"data":{},"enabled":false}` | configMaps is the object to configure an array of configMaps |
| configMaps.data | object | `{}` | data is the object to configure the data of the configMap |
| configMaps.enabled | bool | `false` | enabled is the flag to sinalize this funcionality is enabled |
| consumers | object | `{"annotations":{},"list":[],"terminationGracePeriodSeconds":30}` | consumers is the object to configure an array of consumers |
| consumers.annotations | object | `{}` | annotations to be added to the consumers |
| consumers.list | list | `[]` | list is the array of consumer definition |
| consumers.terminationGracePeriodSeconds | int | `30` | terminationGracePeriodSeconds configures terminationGracePeriodSeconds |
| container | object | `{"port":8080,"readOnlyRootFilesystem":true}` | container is the object to configure the container |
| container.port | int | `8080` | port is the port your application runs under |
| container.readOnlyRootFilesystem | bool | `true` | readOnlyRootFilesystem is the prop to setup the container root filesystem as read-only |
| cronjobs.list | list | `[]` | list is an array of spec for create multiples cronjobs |
| cronjobs.suspend | bool | `false` | suspend used to disable all cronjobs in the list |
| deployment | object | `{"annotations":{},"enabled":true,"labels":{},"strategyType":"RollingUpdate"}` | deployment Disabled Deployment |
| deployment.annotations | object | `{}` | annotations to be added to the deployment |
| deployment.enabled | bool | `true` | enabled is the flag to sinalize this funcionality is enabled |
| deployment.labels | object | `{}` | labels to be added to the deployment |
| deployment.strategyType | string | `"RollingUpdate"` | strategyType is the type of deployment strategy to use |
| envFrom | list | `[]` |  |
| envs | list | `[]` |  |
| externalSecrets.enabled | bool | `false` | If enabled, ExternalSecret resources will be created to sync secrets from external sources (e.g., Vault). |
| externalSecrets.refreshInterval | string | `"30s"` | The time interval at which secrets are refreshed from the external source (e.g., Vault). Default value is "30s", meaning secrets will be refreshed every 30 seconds. |
| externalSecrets.secretStoreRef.kind | string | `"ClusterSecretStore"` | The kind of SecretStore used to fetch secrets. By default, this is set to "ClusterSecretStore" to allow cluster-wide secret management. |
| externalSecrets.secretStoreRef.name | string | `"vault-backend"` | The name of the SecretStore backend. For Vault, this typically refers to the Vault connection (e.g., "vault-backend"). |
| externalSecrets.secrets | list | `[]` | List of secrets to be synced from the external source (e.g., Vault). Add secrets here, where each secretKey in Kubernetes will map to a corresponding key in the external store. |
| externalSecrets.target.creationPolicy | string | `"Owner"` | The creation policy for the target Kubernetes Secret. "Owner" means ExternalSecret manages the lifecycle of the created secret, deleting it when ExternalSecret is deleted. |
| extraContainer | object | `{"enabled":false,"env":[{"name":"ENV_VAR","value":"value"}],"image":"extra-container-image:latest","imagePullPolicy":"Always","name":"extra-container","port":{"containerPort":8081,"name":"http"},"resources":{"limits":{"cpu":"200m","memory":"128Mi"},"requests":{"cpu":"100m","memory":"64Mi"}},"volumeMounts":[{"mountPath":"/etc/config","name":"config-volume"}]}` | extraContainer configuration for an extra container in the pod |
| extraContainer.enabled | bool | `false` | If enabled, create an extra container in the pod |
| fullnameOverride | object | `{}` | fullnameOverride allows full override of the name |
| global.cluster | object | `{"name":""}` | cluster sets the Cluster Name |
| global.env | string | `""` | env sets the Environment Name (dev, mng, prd) |
| global.imageRegistry | string | `""` |  |
| global.network | object | `{"domain":""}` | Network configuration |
| global.network.domain | string | `""` | domain sets the Default Domain |
| global.org | string | `""` |  |
| global.otel | object | `{"argument":"0.25","endpoint":"","port":""}` | otel sets the endpoint for OpenTelemetry collector |
| global.prometheus | object | `{"server":""}` | prometheus sets the Prometheus server URL |
| global.prometheus.server | string | `""` | server sets prometheus endpoint |
| image | object | `{"pullPolicy":"IfNotPresent","repository":"","tag":"latest"}` | image is the object to specify the image to run in the deployment |
| image.pullPolicy | string | `"IfNotPresent"` | pullPolicy is the prop to setup the behavior of pull police. options is: IfNotPresent \| allways |
| image.repository | string | `""` | repository: is the registry of your application ex:556684128444.dkr.ecr.us-east-1.amazonaws.com/YOU-APP-ECR-REPO-NAME if empty this helm will auto generate the image using aws.registry/values.name:values.image.tag |
| image.tag | string | `"latest"` | especify the tag of your image to deploy |
| imagePullSecrets | list | `[]` | imagePullSecrets secret used to download image on private container registry |
| instrumentation | object | `{"enabled":false,"language":""}` | instrumentation set default auto-instrumentation, allowed values dotnet, go, java, nodejs and python |
| instrumentation.enabled | bool | `false` | enabled specifies whether instrumentation is enabled |
| instrumentation.language | string | `""` | allowed values: dotnet, go, java, nodejs and python |
| istio | object | `{"authorizationPolicy":{"action":"ALLOW","enabled":true,"rules":[{"from":[{"source":{"namespaces":["*"]}}]}]},"enabled":true,"gateways":"istio-ingress/istio-ingressgateway","peerAuthentication":{"enabled":true,"mode":"PERMISSIVE"},"virtualServices":{"custom":{"hosts":[]},"enabled":true,"public":false}}` | istio Set default Istio |
| istio.authorizationPolicy | object | `{"action":"ALLOW","enabled":true,"rules":[{"from":[{"source":{"namespaces":["*"]}}]}]}` | authorizationPolicy set default authorization policy |
| istio.authorizationPolicy.enabled | bool | `true` | enable authorizationPolicy |
| istio.gateways | string | `"istio-ingress/istio-ingressgateway"` | gateways set default gateway for virtual-service |
| istio.peerAuthentication | object | `{"enabled":true,"mode":"PERMISSIVE"}` | PeerAuthentication defines how traffic will be tunneled (or not) to the sidecar. |
| istio.peerAuthentication.enabled | bool | `true` | enable peerAuthentication |
| istio.peerAuthentication.mode | string | `"PERMISSIVE"` | set peerAuthentication mode, values (UNSET, DISABLE, PERMISSIVE, STRICT) |
| istio.virtualServices | object | `{"custom":{"hosts":[]},"enabled":true,"public":false}` | istio.virtualServices Set Istio virtualServices parameters |
| istio.virtualServices.enabled | bool | `true` | istio.virtualServices.enable Set Istio virtualServices enabled |
| livenessProbe | object | `{"enabled":false,"exec":{},"failureThreshold":3,"httpHeaders":[],"initialDelaySeconds":10,"path":"/health-check/liveness","periodSeconds":10,"scheme":"HTTP","successThreshold":1,"timeoutSeconds":3}` | livenessProbe indicates whether the application is running and alive |
| livenessProbe.enabled | bool | `false` | Specifies whether the liveness probe is enabled |
| livenessProbe.exec | object | `{}` | Specifies a command to run inside the container to determine liveness |
| livenessProbe.failureThreshold | int | `3` | Minimum consecutive failures for the probe to be considered failed after having succeeded |
| livenessProbe.httpHeaders | list | `[]` | httpHeaders specifies custom headers to set in the request |
| livenessProbe.initialDelaySeconds | int | `10` | Number of seconds after the container has started before liveness probes are initiated |
| livenessProbe.path | string | `"/health-check/liveness"` | The HTTP path to check for liveness |
| livenessProbe.periodSeconds | int | `10` | How often (in seconds) to perform the probe |
| livenessProbe.scheme | string | `"HTTP"` | The scheme to use for the liveness probe (e.g., HTTP or HTTPS) |
| livenessProbe.successThreshold | int | `1` | Minimum consecutive successes for the probe to be considered successful after having failed |
| livenessProbe.timeoutSeconds | int | `3` | Number of seconds after which the probe times out |
| logging | object | `{"podLogs":{"enabled":true,"relabelings":[{"sourceLabels":["__meta_kubernetes_pod_node_name"],"targetLabel":"__host__"},{"action":"labelmap","regex":"__meta_kubernetes_pod_label_(.+)"},{"action":"replace","sourceLabels":["__meta_kubernetes_namespace"],"targetLabel":"namespace"},{"action":"replace","sourceLabels":["__meta_kubernetes_pod_name"],"targetLabel":"pod"},{"action":"replace","sourceLabels":["__meta_kubernetes_container_name"],"targetLabel":"container"},{"replacement":"/var/log/pods/*$1/*.log","separator":"/","sourceLabels":["__meta_kubernetes_pod_uid","__meta_kubernetes_pod_container_name"],"targetLabel":"__path__"}]}}` | logging configuration |
| logging.podLogs | object | `{"enabled":true,"relabelings":[{"sourceLabels":["__meta_kubernetes_pod_node_name"],"targetLabel":"__host__"},{"action":"labelmap","regex":"__meta_kubernetes_pod_label_(.+)"},{"action":"replace","sourceLabels":["__meta_kubernetes_namespace"],"targetLabel":"namespace"},{"action":"replace","sourceLabels":["__meta_kubernetes_pod_name"],"targetLabel":"pod"},{"action":"replace","sourceLabels":["__meta_kubernetes_container_name"],"targetLabel":"container"},{"replacement":"/var/log/pods/*$1/*.log","separator":"/","sourceLabels":["__meta_kubernetes_pod_uid","__meta_kubernetes_pod_container_name"],"targetLabel":"__path__"}]}` | If enabled, create a PodLogs resource for logging |
| migration | object | `{"enabled":false}` | migration Set liquibase migration |
| migration.enabled | bool | `false` | migration.enable liquibase migration |
| monitoring | object | `{"alerts":{"annotations":{},"enabled":false,"labels":{},"namespace":null},"rules":{"additionalGroups":[],"alerting":true,"annotations":{},"enabled":false,"labels":{},"namespace":null},"serviceMonitor":{"annotations":{},"enabled":false,"extraPort":{"enabled":false,"name":"tcp-metrics","number":9090,"protocol":"TCP","targetPort":9090},"interval":"60s","labels":{},"namespace":null,"namespaceSelector":{},"path":"/metrics","relabelings":[],"scheme":"http","scrapeTimeout":"15s"}}` | monitoring Enable Monitoring Features |
| monitoring.alerts.annotations | object | `{}` | Additional annotations for the alerts PrometheusRule resource |
| monitoring.alerts.enabled | bool | `false` | If enabled, create PrometheusRule resource with app alerting rules |
| monitoring.alerts.labels | object | `{}` | Additional labels for the alerts PrometheusRule resource |
| monitoring.alerts.namespace | string | `nil` | Alternative namespace to create alerting rules PrometheusRule resource in |
| monitoring.rules.additionalGroups | list | `[]` | Additional groups to add to the rules file |
| monitoring.rules.alerting | bool | `true` | Include alerting rules |
| monitoring.rules.annotations | object | `{}` | Additional annotations for the rules PrometheusRule resource |
| monitoring.rules.enabled | bool | `false` | If enabled, create PrometheusRule resource with app recording rules |
| monitoring.rules.labels | object | `{}` | Additional labels for the rules PrometheusRule resource |
| monitoring.rules.namespace | string | `nil` | Alternative namespace to create recording rules PrometheusRule resource in |
| monitoring.serviceMonitor.annotations | object | `{}` | ServiceMonitor annotations |
| monitoring.serviceMonitor.enabled | bool | `false` | If enabled, ServiceMonitor resources for Prometheus Operator are created |
| monitoring.serviceMonitor.extraPort | object | `{"enabled":false,"name":"tcp-metrics","number":9090,"protocol":"TCP","targetPort":9090}` | ServiceMonitor will use these tlsConfig settings to make the health check requests |
| monitoring.serviceMonitor.extraPort.enabled | bool | `false` | If enabled, an additional port will be added to the ServiceMonitor |
| monitoring.serviceMonitor.extraPort.name | string | `"tcp-metrics"` | The name of the additional port |
| monitoring.serviceMonitor.extraPort.number | int | `9090` | The port number for the additional port |
| monitoring.serviceMonitor.extraPort.protocol | string | `"TCP"` | The protocol used for the additional port |
| monitoring.serviceMonitor.extraPort.targetPort | int | `9090` | The target port in the container for the additional port |
| monitoring.serviceMonitor.interval | string | `"60s"` | ServiceMonitor scrape interval |
| monitoring.serviceMonitor.labels | object | `{}` | Additional ServiceMonitor labels |
| monitoring.serviceMonitor.namespace | string | `nil` | Alternative namespace for ServiceMonitor resources |
| monitoring.serviceMonitor.namespaceSelector | object | `{}` | Namespace selector for ServiceMonitor resources |
| monitoring.serviceMonitor.path | string | `"/metrics"` | ServiceMonitor path to scrape |
| monitoring.serviceMonitor.relabelings | list | `[]` | ServiceMonitor relabel configs to apply to samples before scraping https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/api.md#relabelconfig |
| monitoring.serviceMonitor.scheme | string | `"http"` | ServiceMonitor will use http by default, but you can pick https as well |
| monitoring.serviceMonitor.scrapeTimeout | string | `"15s"` | ServiceMonitor scrape timeout in Go duration format (e.g. 15s) |
| name | string | `""` | name is the GitHub repository name of this application deployment |
| nameOverride | object | `{}` | nameOverride allows partial override of the name |
| namespace | object | `{"annotations":{},"enabled":false,"labels":{}}` | namespace configuration |
| namespace.annotations | object | `{}` | Annotations to be added to the namespace |
| namespace.enabled | bool | `false` | Specifies whether the namespace is enabled |
| namespace.labels | object | `{}` | Labels to be added to the namespace |
| nginx | object | `{"enabled":false,"image":{"imagePullPolicy":"IfNotPresent","repository":"nginx","tag":"alpine"},"livenessProbe":{"enabled":true,"exec":{},"failureThreshold":3,"initialDelaySeconds":5,"path":"/health-check/liveness","periodSeconds":10,"scheme":"HTTP","successThreshold":1,"timeoutSeconds":3},"resources":{"limits":{"cpu":"50m","memory":"50Mi"},"requests":{"cpu":"10m","memory":"10Mi"}},"shared":{"enabled":false,"path":"/var/www/html/"}}` | nginx configuration for php-fpm the nginx sidecar |
| nginx.enabled | bool | `false` | If enabled, create a sidecar container with nginx |
| nodeSelector | object | `{}` | nodeSelector allows you to constrain a Pod to only be able to run on particular node(s) |
| podAnnotations | object | `{}` | podAnnotations adds custom annotations to the pod |
| podSecurityContext | object | `{}` | podSecurityContext sets the security context for the pod |
| quota | object | `{"enabled":false,"resources":{"hard":{"limits.cpu":"2","limits.memory":"2Gi","requests.cpu":"1","requests.memory":"1Gi"}}}` | ResourceQuota provides constraints that limit aggregate resource consumption per namespace |
| quota.enabled | bool | `false` | Specifies whether a resource quota should be created |
| quota.resources | object | `{"hard":{"limits.cpu":"2","limits.memory":"2Gi","requests.cpu":"1","requests.memory":"1Gi"}}` | resources Specifies the hard resources |
| quota.resources.hard."limits.cpu" | string | `"2"` | limits.cpu Specifies the total CPU limits allowed for all pods in the namespace |
| quota.resources.hard."limits.memory" | string | `"2Gi"` | limits.memory Specifies the total memory limits allowed for all pods in the namespace |
| quota.resources.hard."requests.cpu" | string | `"1"` | requests.cpu Specifies the total CPU requests allowed for all pods in the namespace |
| quota.resources.hard."requests.memory" | string | `"1Gi"` | requests.memory Specifies the total memory requests allowed for all pods in the namespace |
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
| resources | object | `{}` | resources set deployment resources |
| restartPolicy | string | `"Always"` | restartPolicy is the object to specify the restart policy for the container |
| securityContext | object | `{}` | securityContext sets the security context for the container |
| service | object | `{"annotations":{},"enabled":true,"externalDns":{"enabled":false},"labels":{},"nodePort":{},"port":{"name":"tcp-node","port":80,"targetPort":8080},"type":"ClusterIP"}` | service |
| service.annotations | object | `{}` | Annotations to add to the service |
| service.enabled | bool | `true` | service.enabled to enable and disable the creation of service |
| service.externalDns | object | `{"enabled":false}` | service.externalDns to enable and disable the creation of external DNS |
| service.externalDns.enabled | bool | `false` | Enable or disable external DNS for the service |
| service.labels | object | `{}` | Labels to add to the service |
| service.nodePort | object | `{}` | The port to expose on each node in a cluster, only used if type is NodePort or LoadBalancer |
| service.port | object | `{"name":"tcp-node","port":80,"targetPort":8080}` | service.port Define the Service Port |
| service.port.name | string | `"tcp-node"` | Name of the port, used for service discovery |
| service.port.port | int | `80` | Port is the port your application runs under |
| service.port.targetPort | int | `8080` | targetPort is the port your application runs under |
| service.type | string | `"ClusterIP"` | Service An abstract way to expose an application running on a set of Pods as a network service. |
| serviceAccount | object | `{"annotations":{},"automountServiceAccountToken":true,"enabled":true,"irsa":{"enabled":false},"name":""}` | ServiceAccount A service account provides an identity for processes that run in a Pod, about more: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automountServiceAccountToken | bool | `true` | serviceAccount.annotations Automont Service Account Token |
| serviceAccount.enabled | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.irsa | object | `{"enabled":false}` | Specifies whether IRSA (IAM Roles for Service Accounts) is enabled |
| serviceAccount.irsa.enabled | bool | `false` | Specifies whether IRSA (IAM Roles for Service Accounts) is enabled |
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
