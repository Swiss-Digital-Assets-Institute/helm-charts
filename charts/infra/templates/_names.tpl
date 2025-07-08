{{- define "infra.rdsInstanceName" -}}
{{- include "infra.resourceName" (dict "override" .Values.aws.rds.instanceNameOverride "global" .Values.global "Release" .Release) -}}
{{- end -}}
{{- define "infra.s3BucketName" -}}
{{- include "infra.resourceName" (dict "override" .Values.aws.s3.bucketNameOverride "global" .Values.global "Release" .Release) -}}
{{- end -}}

{{- define "infra.kmsKeyName" -}}
{{- include "infra.resourceName" (dict "override" .Values.aws.kms.keyNameOverride "global" .Values.global "Release" .Release) -}}
{{- end -}}

{{- define "infra.ecrRepoName" -}}
{{- include "infra.resourceName" (dict "override" .Values.aws.ecr.repoNameOverride "global" .Values.global "Release" .Release) -}}
{{- end -}}
