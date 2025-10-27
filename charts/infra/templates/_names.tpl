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
Defaults to org-env-releaseName unless overridden.
*/}}
{{- define "infra.ecrRepoName" -}}
    {{- default (include "infra.resourceName" .) .Values.aws.ecr.repoNameOverride -}}
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

