{{/*
Set org to "tha" (default)
*/}}
{{- define "infra.org" -}}
tha
{{- end -}}

{{/*
Infer environment and environment short name from .Values.infra.aws.environment
Returns env, envShort as map
*/}}
{{- define "infra.envs" -}}
{{- $env := required "You must set .Values.infra.aws.environment to one of: staging, production, or development" .Values.infra.aws.environment -}}
{{- if eq $env "staging" }}
  {{- dict "env" "stage" "envShort" "stg" -}}
{{- else if eq $env "production" }}
  {{- dict "env" "prod" "envShort" "prd" -}}
{{- else if eq $env "development" }}
  {{- dict "env" "prod" "envShort" "prd" -}}
{{- else }}
  {{- fail (printf "Environment must be one of: staging, production, development. Got '%s'" $env) -}}
{{- end -}}
{{- end -}}

{{- define "infra.name" -}}
{{- required "You must set .Values.appName (application name)" .Values.appName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "infra.fullname" -}}
{{- $org := include "infra.org" . -}}
{{- $envmap := include "infra.envs" . | fromYaml -}}
{{- $envShort := index $envmap "envShort" -}}
{{- $appName := include "infra.name" . -}}
{{- printf "%s-%s-%s" $org $envShort $appName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "infra.releaseName" -}}
{{- include "infra.name" . -}}
{{- end -}}

{{- define "infra.version" -}}
{{- .Chart.AppVersion -}}
{{- end -}}

{{- define "infra.labels" -}}
app.kubernetes.io/name: {{ include "infra.name" . }}
app.kubernetes.io/instance: {{ include "infra.fullname" . }}
app.kubernetes.io/version: {{ include "infra.version" . }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name (.Chart.Version | replace "+" "_") }}
{{- end -}}

{{- define "infra.s3BucketName" -}}
{{- .Values.bucketNameOverride | default (include "infra.fullname" .) -}}
{{- end -}}
{{- define "infra.kmsKeyName" -}}
{{- .Values.infra.aws.kms.keyNameOverride | default (include "infra.fullname" .) -}}
{{- end -}}

{{/*
Combine default tags and additional user-defined tags in .Values.tags
Produces a YAML map for use in resources. Output should be referenced as $allTags.
Default tags example: org, environment, managed-by=helm, etc.
*/}}
{{- define "infra.allTags" -}}
{{- $defaultTags := dict "org" (include "infra.org" .) "environment" .Values.infra.aws.environment "managed-by" "helm" -}}
{{- if .Values.tags }}
{{- $allTags := merge (deepCopy $defaultTags) .Values.tags }}
{{- toYaml $allTags }}
{{- else }}
{{- toYaml $defaultTags }}
{{- end -}}
{{- end -}}

{{/* Helper functions for account and EKS OIDC ID */}}
{{- define "infra.account" -}}
  {{- $env := required "You must set .Values.infra.aws.environment to one of: staging, production, or development" .Values.infra.aws.environment -}}
  {{- if eq $env "staging" -}}
    107282186755
  {{- else if or (eq $env "prod") (eq $env "production") (eq $env "development") -}}
    009160051835
  {{- else -}}
    {{- fail (printf "Unknown environment '%s' for account" $env) -}}
  {{- end -}}
{{- end -}}

{{- define "infra.eksOidcId" -}}
  {{- $env := required "You must set .Values.infra.aws.environment to one of: staging, production, or development" .Values.infra.aws.environment -}}
  {{- if eq $env "staging" -}}
    107916C22F83AAC08CFF8E8C93E433C1
  {{- else if or (eq $env "prod") (eq $env "production") (eq $env "development") -}}
    C14B75483334CD720225B731A2F3DF25
  {{- else -}}
    {{- fail (printf "Unknown environment '%s' for eksOidcId" $env) -}}
  {{- end -}}
{{- end -}}