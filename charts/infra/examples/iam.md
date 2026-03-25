# IAM Role Custom Policy Examples

The `iamRoleCustom` feature allows attaching user-defined IAM policy statements
to the IAM role created by this Helm chart. Custom policies are converted from
YAML to JSON and appended alongside any auto-generated service policies
(S3, KMS, SQS, SNS, DynamoDB, Cognito).

The following scenarios are covered below:

- **Scenario A** -- Only AWS services enabled (existing behavior, no custom policies)
- **Scenario B** -- AWS services + custom policies (both merged)
- **Scenario B (complex)** -- S3 + multi-statement custom policy
- **Scenario C** -- Only custom policies (no services enabled)
- **Scenario D** -- Multiple custom policies with multiple statements each
- **Scenario E** -- All services + custom policies (complete example)

---

## Scenario A: Only services enabled (no custom policy)

Existing behavior. S3 and KMS are enabled so their IAM policies are
auto-generated and attached to the role. No custom policy is needed.

```yaml
aws:
  enabled: true
  account: "123456789012"
  region: "eu-central-2"
  eksOidcId: "EXAMPLED539D4633E53DE1B71EXAMPLE"

  s3:
    enabled: true
  kms:
    enabled: true

  iamRoleCustom:
    enabled: false
    policies: []
```

---

## Scenario B: Services + custom policies (merged)

S3 is enabled so the S3 policy is auto-generated. Additionally, a custom
policy granting full access is provided. Both will be merged into the
final IAM policy document.

```yaml
aws:
  enabled: true
  account: "123456789012"
  region: "eu-central-2"
  eksOidcId: "EXAMPLED539D4633E53DE1B71EXAMPLE"

  s3:
    enabled: true

  iamRoleCustom:
    enabled: true
    policies:
      - Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Action: "*"
            Resource: "*"
```

---

## Scenario C: Only custom policies (no services)

No AWS services (S3, KMS, SQS, DynamoDB, etc.) are enabled. Only the
custom policy is attached to the role. This is useful when the application
needs specific AWS permissions that don't map to the chart's managed services.

```yaml
aws:
  enabled: true
  account: "123456789012"
  region: "eu-central-2"
  eksOidcId: "EXAMPLED539D4633E53DE1B71EXAMPLE"

  s3:
    enabled: false
  kms:
    enabled: false
  sqs:
    enabled: false
  dynamodb:
    enabled: false

  iamRoleCustom:
    enabled: true
    policies:
      - Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Action:
              - ec2:CreateNetworkInterface
              - ec2:DeleteNetworkInterface
              - ec2:DetachNetworkInterface
              - ec2:ModifyNetworkInterfaceAttribute
              - ec2:CreateSecurityGroup
              - ec2:CreateNetworkInterfacePermission
            Resource: "*"

          - Effect: Allow
            Action:
              - ec2:DescribeAccountAttributes
              - ec2:DescribeAddresses
              - ec2:DescribeAvailabilityZones
              - ec2:DescribeInstances
              - ec2:DescribeInternetGateways
              - ec2:DescribeNetworkInterfaces
              - ec2:DescribeSecurityGroups
              - ec2:DescribeSubnets
              - ec2:DescribeTags
              - ec2:DescribeVpcs
              - ec2:DescribeRouteTables
              - eks:DescribeCluster
              - elasticloadbalancing:DescribeListeners
              - elasticloadbalancing:DescribeLoadBalancers
              - elasticloadbalancing:DescribeRules
              - elasticloadbalancing:DescribeTargetGroups
              - elasticloadbalancing:DescribeTargetHealth
            Resource: "*"

          - Effect: Allow
            Action:
              - ec2:DeleteSecurityGroup
              - ec2:RevokeSecurityGroupIngress
              - ec2:AuthorizeSecurityGroupIngress
              - ec2:RevokeSecurityGroupEgress
              - ec2:AuthorizeSecurityGroupEgress
            Resource: arn:aws:ec2:*:*:security-group/*
            Condition:
              StringLike:
                ec2:ResourceTag/Name: eks-cluster-sg*

          - Effect: Allow
            Action:
              - ec2:CreateTags
              - ec2:DeleteTags
            Resource:
              - arn:aws:ec2:*:*:vpc/*
              - arn:aws:ec2:*:*:subnet/*
              - arn:aws:ec2:*:*:network-interface/*
              - arn:aws:ec2:*:*:security-group/*
            Condition:
              ForAnyValue:StringLike:
                aws:TagKeys:
                  - kubernetes.io/cluster/*

          - Effect: Allow
            Action: route53:AssociateVPCWithHostedZone
            Resource: arn:aws:route53:::hostedzone/*

          - Effect: Allow
            Action: logs:CreateLogGroup
            Resource: arn:aws:logs:*:*:log-group:/aws/eks/*

          - Effect: Allow
            Action:
              - logs:CreateLogStream
              - logs:DescribeLogStreams
            Resource: arn:aws:logs:*:*:log-group:/aws/eks/*:*

          - Effect: Allow
            Action: logs:PutLogEvents
            Resource: arn:aws:logs:*:*:log-group:/aws/eks/*:*:*

          - Effect: Allow
            Action: cloudwatch:PutMetricData
            Resource: "*"
            Condition:
              StringLike:
                cloudwatch:namespace: AWS/EKS
```

---

## Scenario B (complex): S3 + multi-statement custom policy

S3 is enabled for bucket access. A complex custom policy with multiple
statements covering EC2, EKS, ELB, Route53, CloudWatch, and Logs is also
provided. All statements (S3 auto-generated + custom) are merged.

```yaml
aws:
  enabled: true
  account: "123456789012"
  region: "eu-central-2"
  eksOidcId: "EXAMPLED539D4633E53DE1B71EXAMPLE"

  s3:
    enabled: true

  iamRoleCustom:
    enabled: true
    policies:
      - Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Action:
              - ec2:DescribeInstances
              - ec2:DescribeSecurityGroups
              - ec2:DescribeSubnets
              - ec2:DescribeVpcs
              - eks:DescribeCluster
            Resource: "*"

          - Effect: Allow
            Action: logs:CreateLogGroup
            Resource: arn:aws:logs:*:*:log-group:/aws/eks/*

          - Effect: Allow
            Action: cloudwatch:PutMetricData
            Resource: "*"
            Condition:
              StringLike:
                cloudwatch:namespace: AWS/EKS
```

---

## Scenario D: Multiple custom policies with multiple statements

You can define multiple policy documents in the `policies` list. Each policy
can contain multiple statements. All statements from all policies are merged
into the final inline policy. This is useful for organizing related permissions
into logical groups.

```yaml
aws:
  enabled: true
  account: "123456789012"
  region: "eu-central-2"
  eksOidcId: "EXAMPLED539D4633E53DE1B71EXAMPLE"

  s3:
    enabled: false
  kms:
    enabled: false
  sqs:
    enabled: false
  dynamodb:
    enabled: false

  iamRoleCustom:
    enabled: true
    policies:
      # First policy: KMS and AIOps permissions
      - Version: "2012-10-17"
        Statement:
          - Sid: CustomKMSAccess
            Effect: Allow
            Action:
              - kms:CreateKey
              - kms:Decrypt
              - kms:CreateGrant
              - kms:CreateCustomKeyStore
            Resource: "*"
          - Sid: CustomAIOpsAccess
            Effect: Allow
            Action:
              - aiops:CreateInvestigation
              - aiops:CreateInvestigationEvent
              - aiops:CreateInvestigationGroup
            Resource: "*"
            Condition:
              ArnEquals:
                "aws:SourceArn": "arn:aws:aiops:eu-central-2:123456789012:investigation/*"

      # Second policy: EC2 and CloudWatch Logs permissions
      - Version: "2012-10-17"
        Statement:
          - Sid: CustomEC2Access
            Effect: Allow
            Action:
              - ec2:DescribeInstances
              - ec2:DescribeSecurityGroups
              - ec2:DescribeSubnets
              - ec2:DescribeVpcs
            Resource: "*"
          - Sid: CustomLogsAccess
            Effect: Allow
            Action:
              - logs:CreateLogGroup
              - logs:CreateLogStream
              - logs:PutLogEvents
            Resource: "arn:aws:logs:*:*:log-group:/aws/eks/*"
```

---

## Scenario E: All services + custom policies (complete example)

This example enables all supported AWS services (S3, KMS, SQS, SNS with SMS,
and DynamoDB) alongside custom policies. All auto-generated service policies
and custom policy statements are merged into a single inline policy document.

```yaml
aws:
  enabled: true
  account: "123456789012"
  region: "eu-central-2"
  eksOidcId: "EXAMPLED539D4633E53DE1B71EXAMPLE"

  # S3 bucket
  s3:
    enabled: true
    bucketNameOverride: "my-app-bucket"

  # KMS key
  kms:
    enabled: true
    keyNameOverride: "my-app-key"

  # SQS queue
  sqs:
    enabled: true
    queueNameOverride: "my-app-queue"

  # SNS topic with SMS
  sns:
    enabled: true
    sms:
      enabled: true

  # DynamoDB table
  dynamodb:
    enabled: true
    tables:
      - name: users-table
        attribute:
          - name: UserId
            type: S
        hashKey: UserId
        billingMode: PAY_PER_REQUEST

  # Custom policies merged with all service policies
  iamRoleCustom:
    enabled: true
    policies:
      - Version: "2012-10-17"
        Statement:
          - Sid: CustomKMSAccess
            Effect: Allow
            Action:
              - kms:CreateKey
              - kms:Decrypt
              - kms:CreateGrant
              - kms:CreateCustomKeyStore
            Resource: "*"
          - Sid: CustomAIOpsAccess
            Effect: Allow
            Action:
              - aiops:CreateInvestigation
              - aiops:CreateInvestigationEvent
              - aiops:CreateInvestigationGroup
            Resource: "*"
            Condition:
              ArnEquals:
                "aws:SourceArn": "arn:aws:aiops:eu-central-2:123456789012:investigation/*"
      - Version: "2012-10-17"
        Statement:
          - Sid: CustomEC2Access
            Effect: Allow
            Action:
              - ec2:DescribeInstances
              - ec2:DescribeSecurityGroups
              - ec2:DescribeSubnets
              - ec2:DescribeVpcs
            Resource: "*"
          - Sid: CustomLogsAccess
            Effect: Allow
            Action:
              - logs:CreateLogGroup
              - logs:CreateLogStream
              - logs:PutLogEvents
            Resource: "arn:aws:logs:*:*:log-group:/aws/eks/*"
```

The resulting IAM inline policy will contain statements for:
- S3 bucket access (`s3:*` on the bucket ARN)
- KMS key operations (encrypt, decrypt, describe, sign)
- SQS queue operations (`sqs:*` on the queue ARN)
- SNS topic operations (`sns:*` on the topic ARN)
- SNS SMS publishing (`sns:Publish` on `*`)
- DynamoDB table operations (CRUD on the table ARN)
- Custom KMS access (CreateKey, Decrypt, CreateGrant, CreateCustomKeyStore)
- Custom AIOps access with ARN condition
- Custom EC2 describe operations
- Custom CloudWatch Logs access
