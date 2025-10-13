{{- define "infra.rdsInstanceName" -}}
    {{- include "infra.resourceName" (dict "override" .Values.aws.rds.instanceNameOverride "commonLabels" .Values.commonLabels "Release" .Release) -}}
{{- end -}}

{{- define "infra.s3BucketName" -}}
    {{- include "infra.resourceName" (dict "override" .Values.aws.s3.bucketNameOverride "commonLabels" .Values.commonLabels "Release" .Release) -}}
{{- end -}}

{{- define "infra.kmsKeyName" -}}
    {{- include "infra.resourceName" (dict "override" .Values.aws.kms.keyNameOverride "commonLabels" .Values.commonLabels "Release" .Release) -}}
{{- end -}}

{{- define "infra.ecrRepoName" -}}
    {{- include "infra.resourceName" (dict "override" .Values.aws.ecr.repoNameOverride "commonLabels" .Values.commonLabels "Release" .Release) -}}
{{- end -}}
