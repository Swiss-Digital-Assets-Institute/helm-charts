{{- define "infra.rdsInstanceName" -}}
    {{- default (include "infra.resourceName" .) .Values.aws.rds.instanceNameOverride -}}
{{- end -}}

{{- define "infra.s3BucketName" -}}
    {{- default (include "infra.resourceName" .) .Values.aws.s3.bucketNameOverride -}}
{{- end -}}

{{- define "infra.kmsKeyName" -}}
    {{- default (include "infra.resourceName" .) .Values.aws.kms.keyNameOverride -}}
{{- end -}}

{{- define "infra.ecrRepoName" -}}
    {{- default (include "infra.resourceName" .) .Values.aws.ecr.repoNameOverride -}}
{{- end -}}

{{- define "infra.externalSecretName" -}}
    {{- default (include "infra.resourceName" .) .Values.externalSecrets.nameOverride -}}
{{- end -}}

{{- define "infra.iamRoleName" -}}
    {{- default (include "infra.resourceName" .) .Values.aws.iam.roleNameOverride -}}
{{- end -}}

{{- define "infra.cdnName" -}}
    {{- default (include "infra.resourceName" .) .Values.aws.cdn.distributionNameOverride -}}
{{- end -}}

{{- define "infra.sesIdentityName" -}}
    {{- default (include "infra.resourceName" .) (default "" .Values.aws.ses.identityNameOverride) -}}
{{- end -}}
