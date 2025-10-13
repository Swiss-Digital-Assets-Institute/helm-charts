{{- define "infra.rdsInstanceName" -}}
    {{- default (include "infra.releaseName" .) .Values.aws.rds.instanceNameOverride -}}
{{- end -}}

{{- define "infra.s3BucketName" -}}
    {{- default (include "infra.releaseName" .) .Values.aws.s3.bucketNameOverride -}}
{{- end -}}

{{- define "infra.kmsKeyName" -}}
    {{- default (include "infra.releaseName" .) .Values.aws.kms.keyNameOverride -}}
{{- end -}}

{{- define "infra.ecrRepoName" -}}
    {{- default (include "infra.releaseName" .) .Values.aws.ecr.repoNameOverride -}}
{{- end -}}

{{- define "infra.externalSecretName" -}}
    {{- default (include "infra.releaseName" .) .Values.externalSecrets.nameOverride -}}
{{- end -}}

{{- define "infra.iamRoleName" -}}
    {{- default (include "infra.releaseName" .) .Values.aws.iam.roleNameOverride -}}
{{- end -}}

{{- define "infra.cdnName" -}}
    {{- default (include "infra.releaseName" .) .Values.aws.cdn.distributionNameOverride -}}
{{- end -}}

{{- define "infra.sesIdentityName" -}}
    {{- default (include "infra.releaseName" .) (default "" .Values.aws.ses.identityNameOverride) -}}
{{- end -}}

{{- /* Converts release name to lower case and snake case */ -}}
{{- define "infra.rdsSchemaName" -}}
    {{- $override := .Values.aws.rds.schemaNameOverride | default "" -}}
    {{- if $override -}}
        {{- $override -}}
    {{- else -}}
        {{- $base := include "infra.baseReleaseName" . | lower -}}
        {{- $snake := regexReplaceAll "[^a-z0-9]+" $base "_" -}}
        {{- $clean := regexReplaceAll "^_+|_+$" $snake "" -}}
        {{- $clean -}}
    {{- end -}}
{{- end -}}
