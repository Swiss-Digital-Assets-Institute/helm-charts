{{/*
Extract the base release name by removing -infra suffix
*/}}
{{- define "infra.baseReleaseName" -}}
{{- if hasSuffix "-infra" .Release.Name -}}
  {{- .Release.Name | trimSuffix "-infra" -}}
{{- else -}}
  {{- .Release.Name -}}
{{- end -}}
{{- end -}}

{{/*
Get the release name with -infra suffix
*/}}
{{- define "infra.releaseName" -}}
{{ printf "%s-infra" (include "infra.baseReleaseName" .) }}
{{- end -}}

{{/*
Compose resource name as org-env-releaseName, unless overridden via resource override
Input:
  override: (string, override value from values file)
*/}}
{{- define "infra.resourceName" -}}
{{- $override := .override -}}
{{- if $override -}}
  {{- $override -}}
{{- else -}}
  {{- $org := required "You must set .commonLabels.org" .commonLabels.org -}}
  {{- $env := required "You must set .commonLabels.env" .commonLabels.env -}}
  {{- $base := include "infra.baseReleaseName" . -}}
  {{- printf "%s-%s-%s" $org $env $base | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Default tags, as required in all resources.
If section.additional_tags exists, merge with these.
*/}}
{{- define "infra.allTags" -}}
{{- $labels := .Values.commonLabels -}}
{{- $section := .section | default dict -}}
{{- $defaults := dict
    "org" (required "You must set .Values.commonLabels.org" $labels.org)
    "env" (required "You must set .Values.commonLabels.env" $labels.env)
    "team" (required "You must set .Values.commonLabels.team" $labels.team)
    "managed_by" "crossplane"
    "project" (required "You must set .Values.commonLabels.project" $labels.project)
  -}}

{{- if $section.additional_tags }}
  {{- $allTags := merge (deepCopy $defaults) $section.additional_tags }}
  {{- /* Ensure managed_by stays hardcoded */ -}}
  {{- $_ := set $allTags "managed_by" "crossplane" -}}
  {{- toYaml $allTags }}
{{- else }}
  {{- toYaml $defaults }}
{{- end -}}
{{- end -}}

{{/* Helm labels with the new convention */}}
{{- define "infra.labels" -}}
app.kubernetes.io/name: {{ include "infra.releaseName" . }}
app.kubernetes.io/instance: {{ include "infra.releaseName" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name (.Chart.Version | replace "+" "_") }}
{{- end -}}

{{/* Required AWS-level keys */}}
{{- define "infra.checkAwsMandates" -}}
{{- if not .Values.aws.account -}}
  {{- fail "You must set .Values.aws.account (AWS account)" -}}
{{- end -}}
{{- if not .Values.aws.eksOidcId -}}
  {{- fail "You must set .Values.aws.eksOidcId (AWS EKS OIDC ID)" -}}
{{- end -}}
{{- end -}}
