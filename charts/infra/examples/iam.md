# IAM Role Custom Policy Examples

The `iamRoleCustom` feature allows attaching user-defined IAM policy statements
to the IAM role created by this Helm chart. Custom policies are converted from
YAML to JSON and appended alongside any auto-generated service policies
(S3, KMS, SQS, SNS, DynamoDB, Cognito).

Three scenarios are covered below:

- **Scenario A** -- Only AWS services enabled (existing behavior, no custom policies)
- **Scenario B** -- AWS services + custom policies (both merged)
- **Scenario C** -- Only custom policies (no services enabled)

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
