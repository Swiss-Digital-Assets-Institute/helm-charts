{{/*
IAM ROLE LOGIC HERE.
Trust policy and inline IAM policies dynamically generated.
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

{{/*
ECR cross-account access policy.
*/}}
{{- define "infra.ecrRepositoryPolicy" -}}
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
          "ecr:InitiateLayerUpload",
          "ecr:GetLifecyclePolicy",
          "ecr:GetRepositoryPolicy",
          "ecr:ListImages",
          "ecr:ListTagsForResource",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]{{ if .resourceArn }},
        "Resource": {{ printf "%q" .resourceArn }}{{ end }}
      }
    ]
  }
{{- end -}}

{{/*
ECR lifecycle rules.
*/}}
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

{{/*
Custom IAM inline policy including S3, KMS, SQS, SNS, and SNS-SMS.
*/}}
{{- define "infra.customIamPolicy" -}}
  {{- $region := .Values.aws.region | default "us-east-1" -}}
  {{- $account := required "You must set .Values.aws.account (AWS Account)" .Values.aws.account -}}
  {{- $s3BucketName := include "infra.s3BucketName" . -}}
  {{- $kmsKeyName := include "infra.kmsKeyName" . -}}
  {{- $sqsQueueName := include "infra.sqsQueueName" . -}}
  {{- $snsTopicName := include "infra.snsTopicName" . | default "" -}}
  {{- $cognitoUserPoolName := include "infra.cognitoUserPoolName" . | default "" -}}

  {{- $s3Enabled := .Values.aws.s3.enabled -}}
  {{- $kmsEnabled := .Values.aws.kms.enabled -}}
  {{- $sqsEnabled := .Values.aws.sqs.enabled -}}
  {{- $snsEnabled := .Values.aws.sns.enabled -}}
  {{- $cognitoEnabled := .Values.aws.cognito.userpool.enabled -}}

  {{- /* S3 BLOCK */ -}}
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

  {{- /* KMS BLOCK */ -}}
  {{- $kmsStatement := list -}}
  {{- if $kmsEnabled }}
    {{- $kmsStatement = append $kmsStatement (printf `
    {
      "Effect": "Allow",
      "Action": ["kms:Encrypt", "kms:Decrypt", "kms:DescribeKey", "kms:ListAliases", "kms:ListKeys", "kms:Sign"],
      "Resource": "*"
    },
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

  {{- /* SQS BLOCK */ -}}
  {{- $sqsStatement := list -}}
  {{- if $sqsEnabled }}
    {{- $sqsStatement = append $sqsStatement (printf `
    {
      "Effect": "Allow",
      "Action": "sqs:*",
      "Resource": "arn:aws:sqs:%s:%s:%s"
    }` $region $account $sqsQueueName) }}
  {{- end }}

  {{- /* SNS BLOCK (TOPIC-BASED) */ -}}
  {{- $snsStatement := list -}}
  {{- if $snsEnabled }}
    {{- $snsStatement = append $snsStatement (printf `
    {
      "Effect": "Allow",
      "Action": "sns:*",
      "Resource": "arn:aws:sns:%s:%s:%s"
    }` $region $account $snsTopicName) }}
  {{- end }}

  {{- /* SNS SMS BLOCK (DIRECT PHONE NUMBER SMS) */ -}}
  {{- $snsSmsStatement := list -}}
  {{- if and $snsEnabled .Values.aws.sns.sms.enabled }}
    {{- $snsSmsStatement = append $snsSmsStatement (printf `
    {
      "Effect": "Allow",
      "Action": "sns:Publish",
      "Resource": "*"
    }`) }}
  {{- end }}

  {{- /* COGNITO USER POOL BLOCK */ -}}
  {{- $cognitoStatement := list -}}
  {{- if $cognitoEnabled }}
    {{- $cognitoStatement = append $cognitoStatement (printf `
    {
      "Effect": "Allow",
      "Action": [
        "cognito-identity:*",
        "cognito-idp:*",
        "cognito-sync:*"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:ResourceTag/crossplane-name": "%s-userpool"
        }
      }
    }` $cognitoUserPoolName) }}
  {{- end }}

  {{- /* FINAL POLICY STATEMENT */ -}}
  {{- $allStatements :=
      concat
        (concat
          (concat
            (concat
              (concat $s3Statement $kmsStatement)
              $sqsStatement
            )
            $snsStatement
          )
          $snsSmsStatement
        )
        $cognitoStatement
  -}}
  {
    "Version": "2012-10-17",
    "Statement": [
      {{ $allStatements | join ",\n" }}
    ]
  }
{{- end -}}
