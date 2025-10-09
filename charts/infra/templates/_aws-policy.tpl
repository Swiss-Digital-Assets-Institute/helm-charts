{{/*
IAM ROLE LOGIC HERE. Trust policy and the inline policy gets dynamically generated.
*/}}

{{- define "infra.trustRelationship" -}}
  {{- $region := .Values.aws.region | default "eu-central-2" -}}
  {{- $account := required "You must set .Values.aws.account (AWS Account)" .Values.aws.account -}}
  {{- $eksOidcId := required "You must set .Values.aws.eksOidcId (AWS EKS OIDC ID)" .Values.aws.eksOidcId -}}
  {{- $releaseName := .Release.Name -}}
  {{- $serviceAccountName := ( .Values.aws.irsa.serviceAccountNameOverride | default $releaseName ) -}}
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
            "oidc.eks.{{ $region }}.amazonaws.com/id/{{ $eksOidcId }}:sub": "system:serviceaccount:{{ $.Release.Namespace }}:{{ $serviceAccountName }}",
            "oidc.eks.{{ $region }}.amazonaws.com/id/{{ $eksOidcId }}:aud": "sts.amazonaws.com"
          }
        }
      }
    ]
  }
{{- end -}}

# ECR ACCOUNT SHARING POLICY
{{- define "infra.ecrRegistryPolicy" -}}
  {{- $accounts := .Values.aws.ecr.accountAccessList | default list -}}
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "CrossAccountECRAccess",
        "Effect": "Allow",
        "Principal": {
          "AWS": [
{{- range $i, $account := $accounts }}
            "arn:aws:iam::{{ $account }}:root"{{ if ne (add1 $i) (len $accounts) }},{{ end }}
{{- end }}
          ]
        },
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:GetRepositoryPolicy",
          "ecr:InitiateLayerUpload",
          "ecr:ListImages",
          "ecr:ListTagsForResource",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ],
        "Resource": "*"
      }
    ]
  }
{{- end -}}

{{- define "infra.ecrLifecyclePolicyRules" -}}
  {{- $rules := .Values.aws.ecr.lifecyclePolicy.rules | default list -}}
  {{- range $i, $r := $rules }}
    {
      "rulePriority": {{ $r.rulePriority }},
      "description": {{ $r.description | quote }},
      "selection": {{ toJson $r.selection }},
      "action": {{ toJson $r.action }}
    }{{ if ne (add1 $i) (len $rules) }},{{ end }}
  {{- end }}
{{- end -}}

{{- define "infra.customIamPolicy" -}}
  {{- $region := .Values.aws.region | default "us-east-1" -}}
  {{- $account := required "You must set .Values.aws.account (AWS Account)" .Values.aws.account -}}
  {{- $s3BucketName := include "infra.s3BucketName" . -}}
  {{- $kmsKeyName := include "infra.kmsKeyName" . -}}
  {{- $s3Enabled := .Values.aws.s3.enabled -}}
  {{- $kmsEnabled := .Values.aws.kms.enabled -}}

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

  {{- $kmsStatement := list -}}
  {{- if $kmsEnabled }}
    {{- $kmsStatement = append $kmsStatement (printf `
    {
      "Effect": "Allow",
      "Action": "kms:*",
      "Resource": "arn:aws:kms:%s:%s:key/*",
      "Condition": {
        "StringEquals": {
          "kms:RequestAlias": "alias/%s"
        }
      }
    }` $region $account $kmsKeyName) }}
  {{- end }}

  {{- $allStatements := concat $s3Statement $kmsStatement | join ",\n" -}}
  {
    "Version": "2012-10-17",
    "Statement": [
      {{ $allStatements }}
    ]
  }
{{- end -}}
