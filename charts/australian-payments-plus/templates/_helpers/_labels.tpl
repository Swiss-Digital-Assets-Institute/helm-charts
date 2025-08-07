{{/*
Common labels
*/}}
{{- define "webapp.labels" -}}

{{- $version := .Values.image.tag | toString -}}

{{- $base := dict
    "app" .Values.name
    "version" $version
    "backstage.io/kubernetes-id" .Values.name
    "helm.sh/chart" (include "webapp.chart" .)
    "app.kubernetes.io/managed-by" "argocd"
-}}

{{- if .Chart.AppVersion }}
  {{- $_ := set $base "app.kubernetes.io/version" (.Values.image.tag | toString) }}
{{- end }}

{{- $_ := set $base "app.kubernetes.io/name" .Values.name }}
{{- $_ := set $base "app.kubernetes.io/instance" .Release.Name }}

{{- $commonLabels := .Values.commonLabels | default dict }}
{{- $globalLabels := .Values.global.commonLabels | default dict }}
{{- $selectorLabels := fromYaml (include "webapp.selectorLabels" .) }}

{{- $merged := merge $base $selectorLabels | merge $globalLabels | merge $commonLabels }}

{{- toYaml $merged }}
{{- end }}

{{- /*
Merge webapp.labels and deployment.labels
*/ -}}
{{- define "all-deploy-labels" -}}
{{- $commonLabels := include "webapp.labels" . | fromYaml -}}  
{{- $deploymentLabels := .Values.deployment.labels | default dict -}}  
{{- $mergedLabels := merge $commonLabels $deploymentLabels -}}  
{{- toYaml $mergedLabels -}}  
{{- end }}


{{- /*
Remove istio sidecar injection label
*/ -}}
{{- define "all-labels-removed-istio-sidecar" }}
{{- $labels := fromYaml (include "webapp.labels" .root) }}
{{- $_ := set $labels "istio-injection" "disabled" }}
{{- $_ = set $labels "app.kubernetes.io/name" .name }}
{{- $_ = set $labels "app.kubernetes.io/instance" .name }}
{{- $_ = set $labels "app" .name }}
{{- toYaml $labels -}}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "webapp.selectorLabels" -}}
app.kubernetes.io/name: {{ .Values.name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
