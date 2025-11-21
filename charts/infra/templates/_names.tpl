{{/*
infra.rdsInstanceName:
Defaults to org-env-releaseName unless overridden.
*/}}
{{- define "infra.rdsInstanceName" -}}
    {{- default (include "infra.resourceName" .) .Values.aws.rds.instanceNameOverride -}}
{{- end -}}

{{/*
infra.s3BucketName:
Defaults to org-env-releaseName unless overridden.
*/}}
{{- define "infra.s3BucketName" -}}
    {{- default (include "infra.resourceName" .) .Values.aws.s3.bucketNameOverride -}}
{{- end -}}

{{/*
infra.kmsKeyName:
Defaults to org-env-releaseName unless overridden.
*/}}
{{- define "infra.kmsKeyName" -}}
    {{- default (include "infra.resourceName" .) .Values.aws.kms.keyNameOverride -}}
{{- end -}}

{{/*
infra.ecrRepoName:
Returns the external ECR repo name <namespace>/<releaseName>.
*/}}
{{- define "infra.ecrRepoName" -}}
{{ printf "%s/%s" .Release.Namespace .Release.Name | replace " " "-" | lower }}
{{- end -}}

{{/*
infra.ecrK8sName:
Kubernetes-safe name for ECR resources.
Defaults to org-env-<releaseName>, or org-env-<repo> when a repo override is supplied.
*/}}
{{- define "infra.ecrK8sName" -}}
  {{- $root := .root -}}
  {{- $repo := .repo | default "" -}}
  {{- if $repo -}}
    {{- printf "%s-%s-%s" $root.Values.global.org $root.Values.global.env $repo | replace " " "-" | lower -}}
  {{- else -}}
    {{- include "infra.resourceName" $root -}}
  {{- end -}}
{{- end -}}


{{/*
infra.externalSecretName:
Defaults to org-env-releaseName unless overridden.
*/}}
{{- define "infra.externalSecretName" -}}
    {{- default (include "infra.resourceName" .) .Values.externalSecrets.nameOverride -}}
{{- end -}}

{{/*
infra.iamRoleName:
Defaults to org-env-releaseName unless overridden.
*/}}
{{- define "infra.iamRoleName" -}}
    {{- default (include "infra.resourceName" .) .Values.aws.iam.roleNameOverride -}}
{{- end -}}

{{/*
infra.cdnName:
Defaults to org-env-releaseName unless overridden.
*/}}
{{- define "infra.cdnName" -}}
    {{- default (include "infra.resourceName" .) .Values.aws.cdn.distributionNameOverride -}}
{{- end -}}

{{/*
infra.sesIdentityName:
Defaults to org-env-releaseName unless overridden.
*/}}
{{- define "infra.sesIdentityName" -}}
    {{- default (include "infra.resourceName" .) (default "" .Values.aws.ses.identityNameOverride) -}}
{{- end -}}

{{/*
infra.sqsQueueName:
Defaults to org-env-releaseName unless overridden.
Appends ".fifo" automatically if FIFO is enabled.
*/}}
{{- define "infra.sqsQueueName" -}}
{{- $baseName := (default (include "infra.resourceName" .) (default "" .Values.aws.sqs.queueNameOverride)) -}}
{{- if .Values.aws.sqs.fifo -}}
{{ printf "%s.fifo" $baseName }}
{{- else -}}
{{ $baseName }}
{{- end -}}
{{- end -}}

{{/*
Return the SNS Topic name
*/}}
{{- define "infra.snsTopicName" -}}
{{- printf "%s-sns-topic" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
infra.cognitoUserPoolName:
Defaults to org-env-releaseName unless overridden.
*/}}
{{- define "infra.cognitoUserPoolName" -}}
    {{- default (include "infra.resourceName" .) .Values.aws.cognito.userpool.nameOverride | default "" -}}
{{- end -}}