{{/*
Common labels
*/}}
{{- define "webapp.labels" -}}
app: {{ .Values.name }}
version: {{ printf "%s" .Values.image.tag | quote }}
backstage.io/kubernetes-id: {{ .Values.name }}
helm.sh/chart: {{ include "webapp.chart" . }}
{{ include "webapp.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ printf "%s" .Values.image.tag | quote }}
{{- end }}
app.kubernetes.io/managed-by: argocd
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
