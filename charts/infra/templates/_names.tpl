{{- define "infra.rdsInstanceName" -}}
    {{- include "infra.releaseName" . -}}
{{- end -}}

{{- define "infra.s3BucketName" -}}
    {{- include "infra.releaseName" . -}}
{{- end -}}

{{- define "infra.kmsKeyName" -}}
    {{- include "infra.releaseName" . -}}
{{- end -}}

{{- define "infra.ecrRepoName" -}}
    {{- include "infra.releaseName" . -}}
{{- end -}}

{{- define "infra.externalSecretName" -}}
    {{- include "infra.releaseName" . -}}
{{- end -}}

{{- define "infra.iamRoleName" -}}
    {{- include "infra.releaseName" . -}}
{{- end -}}

{{- define "infra.cdnName" -}}
    {{- include "infra.releaseName" . -}}
{{- end -}}

{{- define "infra.sesIdentityName" -}}
    {{- include "infra.releaseName" . -}}
{{- end -}}
