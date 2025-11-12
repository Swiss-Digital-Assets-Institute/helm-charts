{{/*
API versions for various AWS providers/resources
*/}}
{{- define "infra.s3ApiVersion" -}}
s3.aws.upbound.io/v1beta2
{{- end -}}

{{- define "infra.ecrApiVersion" -}}
ecr.aws.upbound.io/v1beta2
{{- end -}}

{{- define "infra.ecrLifecyclePolicyApiVersion" -}}
ecr.aws.upbound.io/v1beta1
{{- end -}}

{{- define "infra.ecrRepositoryPolictApiVersion" -}}
ecr.aws.upbound.io/v1beta1
{{- end -}}

{{- define "infra.kmsApiVersion" -}}
kms.aws.upbound.io/v1beta1
{{- end -}}

{{- define "infra.iamApiVersion" -}}
iam.aws.upbound.io/v1beta1
{{- end -}}

{{- define "infra.rdsApiVersion" -}}
database.hashgraphgroup.com/v1alpha2
{{- end -}}

{{- define "infra.cdnApiVersion" -}}
edge.hashgraphgroup.com/v1alpha1
{{- end -}}

{{- define "infra.CognotoUserpoolApiVersion" -}}
identity.hashgraphgroup.com/v1alpha1
{{- end -}}
