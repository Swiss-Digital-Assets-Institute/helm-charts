{{/*
Expand the name of the chart.
*/}}
{{- define "webapp.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "webapp.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "webapp.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "webapp.labels" -}}
app: {{ .Values.name }}
version: {{ ($version := .Values.image.tag  | toString | quote) }}
backstage.io/kubernetes-id: {{ .Values.name }}
helm.sh/chart: {{ include "webapp.chart" . }}
{{ include "webapp.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ $version }}
{{- end }}
app.kubernetes.io/managed-by: argocd
{{- end }}


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

{{/*
Create the name of the service account to use
*/}}
{{- define "webapp.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "webapp.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "namespace" }}
  {{- if eq .Release.Namespace "default" }}
    {{- .Values.name }}
  {{- else }}
    {{- .Release.Namespace }}
  {{- end }}
{{- end }}


{{/*
Return the appropriate apiVersion for Horizontal Pod Autoscaler.
*/}}
{{- define "hpa-version" }}
{{- if $.Capabilities.APIVersions.Has "autoscaling/v2/HorizontalPodAutoscaler" }}
{{- print "autoscaling/v2" }}
{{- else if $.Capabilities.APIVersions.Has "autoscaling/v2beta2/HorizontalPodAutoscaler" }}
{{- print "autoscaling/v2beta2" }}
{{- else }}
{{- print "autoscaling/v2" }}
{{- end }}
{{- end }}

{{/*
Define deployment or argocd rollouts hpa target
*/}}
{{- define "hpa-targets" -}}
name: {{ .Values.name }}
{{- if .Values.argoRollouts.enabled }}
apiVersion: argoproj.io/v1alpha1
kind: Rollout
{{- else }}
apiVersion: apps/v1
kind: Deployment
{{- end }}
{{- end }}

{{/* Generate the default image string to deployment */}}
{{- define "image" -}}
{{- if not .Values.image.repository }}
{{- printf "%s/%s:%s" .Values.image.repository .Values.name .Values.image.tag }}
{{- else }}
{{- printf "%s:%s" .Values.image.repository .Values.image.tag }}
{{- end  }}
{{- end  }}

{{- define "all-volumes" }}
{{- $volumes := .Values.volumes }}
{{- $configName := toString (include "nginx-config-name" . ) }}
{{- if .Values.nginx.enabled }}
  {{- $volumes = append $volumes (dict "name" $configName "configMap" (dict "name" $configName ))}}
  {{- if .Values.nginx.shared.enabled }}
    {{- $volumes = append $volumes (dict "name" "files" "emptyDir" dict )}}
  {{- end }}
{{- end }}
{{- toYaml $volumes }}
{{- end }}




