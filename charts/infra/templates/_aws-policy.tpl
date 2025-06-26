{{/*
IAM ROLE LOGIC HERE. Trust policy and the inline policy gets dynamically generated.
*/}}

{{- define "infra.trustRelationship" -}}
  {{- $env := required "You must set .Values.infra.aws.environment to one of: staging, prod, or development" .Values.infra.aws.environment -}}
  {{- $region := .Values.infra.aws.region | default "eu-central-2" -}}
  {{- $account := include "infra.account" . -}}
  {{- $eksOidcId := include "infra.eksOidcId" . -}}
  {{- $appName := required "You must set .Values.appName" .Values.appName -}}
  
  {{- /* Generate the trust relationship JSON */ -}}
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "pods.eks.amazonaws.com"
        },
        "Action": [
          "sts:TagSession",
          "sts:AssumeRole"
        ]
      },
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "arn:aws:iam::{{ $account }}:oidc-provider/oidc.eks.{{ $region }}.amazonaws.com/id/{{ $eksOidcId }}"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "oidc.eks.{{ $region }}.amazonaws.com/id/{{ $eksOidcId }}:sub": "system:serviceaccount:kube-system:{{ $appName }}",
            "oidc.eks.{{ $region }}.amazonaws.com/id/{{ $eksOidcId }}:aud": "sts.amazonaws.com"
          }
        }
      }
    ]
  }
{{- end -}}

{{- define "infra.customIamPolicy" -}}
  {{- $region := .Values.infra.aws.region | default "eu-central-2" -}}
  {{- $env := required "You must set .Values.infra.aws.environment to one of: staging, prod, or development" .Values.infra.aws.environment -}}
  {{- $account := include "infra.account" . -}}
  {{- $s3BucketName := include "infra.s3BucketName" . -}}
  {{- $kmsKeyName := include "infra.kmsKeyName" . -}}
  {{- $s3Enabled := .Values.infra.aws.s3.enabled -}}
  {{- $kmsEnabled := .Values.infra.aws.kms.enabled -}}

  {{- /* S3 Policy Statement */ -}}
  {{- $s3Statement := list -}}
  {{- if $s3Enabled }}
    {{- $s3Statement = append $s3Statement (printf `
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::%s",
        "arn:aws:s3:::%s/*"
      ]
    }` $s3BucketName $s3BucketName) }}
  {{- end }}

  {{- /* KMS Policy Statement */ -}}
  {{- $kmsStatement := list -}}
  {{- if $kmsEnabled }}
    {{- $kmsStatement = append $kmsStatement (printf `
    {
      "Effect": "Allow",
      "Action": "kms:*",
      "Resource": "arn:aws:kms:%s:%s:key/%s"
    }` $region $account $kmsKeyName) }}
  {{- end }}

  {{- /* Combine statements */ -}}
  {{- $allStatements := concat $s3Statement $kmsStatement | join ",\n" -}}

  {{- /* Final policy document */ -}}
  {
    "Version": "2012-10-17",
    "Statement": [
      {{ $allStatements }}
    ]
  }
{{- end -}}

{{/* Helper functions for account and EKS OIDC ID */}}
{{- define "infra.account" -}}
  {{- $env := required "You must set .Values.infra.aws.environment to one of: staging, prod, or development" .Values.infra.aws.environment -}}
  {{- if eq $env "staging" -}}
    107282186755
  {{- else if or (eq $env "prod") (eq $env "production") (eq $env "development") -}}
    009160051835
  {{- else -}}
    {{- fail (printf "Unknown environment '%s' for account" $env) -}}
  {{- end -}}
{{- end -}}

{{- define "infra.eksOidcId" -}}
  {{- $env := required "You must set .Values.infra.aws.environment to one of: staging, prod, or development" .Values.infra.aws.environment -}}
  {{- if eq $env "staging" -}}
    107916C22F83AAC08CFF8E8C93E433C1
  {{- else if or (eq $env "prod") (eq $env "production") (eq $env "development") -}}
    C14B75483334CD720225B731A2F3DF25
  {{- else -}}
    {{- fail (printf "Unknown environment '%s' for eksOidcId" $env) -}}
  {{- end -}}
{{- end -}}