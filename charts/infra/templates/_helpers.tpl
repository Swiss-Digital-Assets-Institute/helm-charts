####################
# MANDATORY CHECKS #
####################
{{/* 
Validate required globals: ..Values.global.env and .Values.global.org
These must be set in values.yaml, else fail the chart rendering.
*/}}
{{- if not .Values.global.env -}}
  {{- fail "You must set .Values.global.env" -}}
{{- end -}}

{{- if not .Values.global.org -}}
  {{- fail "You must set .Values.global.org" -}}
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


#########################################################
# All functions related to names and naming conventions.#
#########################################################

{{/*
infra.releaseName:
Get the canonical release name by stripping "tha-" / "thg-" prefix
and removing any "-infra" suffix.
*/}}
{{- define "infra.releaseName" -}}
  {{- $name := .Release.Name -}}
  # {{- $name = regexReplaceAll "^(tha-|thg-)" $name "" -}}
  {{- if hasSuffix "-infra" $name -}}
    {{- $name | trimSuffix "-infra" -}}
  {{- else -}}
    {{- $name -}}
  {{- end -}}
{{- end -}}


{{/*
infra.rdsSchemaName:
Resolve the database name for RDS.
Precedence:
  1) aws.rds.dbNameOverride (new)
  2) cleaned release name in lower snake_case
Example:
  tha-xyz-abc-123-infra -> xyz_abc_123
*/}}

{{- define "infra.rdsDbSchemaName" -}}
  {{- $override := .Values.aws.rds.dbNameOverride | default "" -}}
  {{- if $override -}}
    {{- printf "%s" $override -}}
  {{- else -}}
    {{- $name := include "infra.releaseName" . | lower | replace "-" "_" -}}
    {{- $name = regexReplaceAll "^(tha_|thg_)" $name "" -}}
    {{- printf "%s" $name -}}
  {{- end -}}
{{- end -}}



{{/*
infra.resourceName:
Builds resource name including org and env.
Example:
  releaseName = tha-xyz-abc-123
  org = example, env = test
  Output = example-test-xyz-abc-123
*/}}
{{- define "infra.resourceName" -}}
  {{- $org := .Values.global.org -}}
  {{- $env := .Values.global.env -}}
  {{- printf "%s-%s-%s" $org $env (include "infra.releaseName" .) -}}
{{- end -}}


####################################################
# All helpers functions related to tags and labels #
####################################################

{{/*
infra.allTags:
Builds default tags from:
  - Globals: $org, $env (always take precedence)
  - .Values.commonLabels (except org/env are ignored)
  - section.additional_tags (optional, except org/env are ignored)
Ensures managed_by is always "crossplane".
*/}}
{{- define "infra.allTags" -}}
  {{- $org := .Values.global.org -}}
  {{- $env := .Values.global.env -}}
  {{- $labels := .Values.commonLabels | default dict -}}
  {{- $section := .section | default dict -}}
  {{- $additional := $section.additional_tags | default dict -}}

  {{- /* Remove org/env from commonLabels if present */ -}}
  {{- $_ := unset $labels "org" -}}
  {{- $_ := unset $labels "env" -}}

  {{- /* Remove org/env from additional_tags if present */ -}}
  {{- $_ := unset $additional "org" -}}
  {{- $_ := unset $additional "env" -}}

  {{- /* Base tags always required */ -}}
  {{- $defaults := dict
      "org" $org
      "env" $env
      "managed_by" "crossplane"
    -}}

  {{- /* Merge in commonLabels */ -}}
  {{- $merged := merge (deepCopy $defaults) $labels -}}

  {{- /* Merge in additional_tags */ -}}
  {{- $allTags := merge (deepCopy $merged) $additional -}}

  {{- /* Ensure managed_by stays hardcoded */ -}}
  {{- $_ := set $allTags "managed_by" "crossplane" -}}

  {{- toYaml $allTags }}
{{- end -}}


{{/*
infra.labels:
Helm labels with the new convention.
Includes org and env from globals (overrides anything else).
*/}}
{{- define "infra.labels" -}}
  {{- $org := .Values.global.org -}}
  {{- $env := .Values.global.env -}}
org: {{ $org }}
env: {{ $env }}
app.kubernetes.io/name: {{ include "infra.releaseName" . }}
app.kubernetes.io/instance: {{ include "infra.releaseName" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name (.Chart.Version | replace "+" "_") }}
{{- end -}}
