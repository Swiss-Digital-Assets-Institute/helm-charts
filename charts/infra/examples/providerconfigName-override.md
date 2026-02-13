# ProviderConfig Name Override Examples

Examples demonstrating how to override the Crossplane `providerConfigRef` name
on a per-resource basis. This is useful when different AWS resources need to
use different Crossplane provider configurations.

---

## Full configuration with per-resource provider overrides

```yaml
global:
  env: "qa"
  org: "thg"
  cluster:
    name: "thg-qa-che-eks"
  network:
    domain: hashgraph-group.com

aws:
  enabled: true
  account: "388744578936"
  region: "eu-central-2"
  eksOidcId: "8C7BEA8CD72F646DD6DA84B4AE4A1305"
  providerConfigRef:
    name: "crossplane-service-user"

  # Test with section-specific overrides
  sqs:
    enabled: true
    fifo: true
    contentBasedDeduplication: true
    delaySeconds: 0
    visibilityTimeoutSeconds: 60
    messageRetentionSeconds: 1209600
    providerConfigRef:
      name: "custom-sqs-provider"
    additional_tags: {}

  sns:
    enabled: true
    sms:
      enabled: false
    providerConfigRef:
      name: "custom-sns-provider"
    additional_tags: {}

  kms:
    enabled: true
    keyNameOverride: ""
    signingEnabled: false
    deletionWindowInDays: 365
    rotateKey: false
    providerConfigRef:
      name: "custom-kms-provider"
    additional_tags: {}
    alias:
      enabled: false

  s3:
    enabled: true
    bucketNameOverride: ""
    objectOwnership: "BucketOwnerEnforced"
    providerConfigRef:
      name: "custom-s3-provider"
    lifeCycleConfiguration:
      enabled: false
      rules: []
    versioning:
      enabled: false
    corsConfiguration:
      enabled: false
      corsRules: []
    bucketWebsiteConfiguration:
      enabled: false
    bucketPublicAccessBlock:
      enabled: false
    additional_tags: {}

  ecr:
    enabled: true
    repoNames: []
    imageTagMutability: "MUTABLE"
    additionalAnnotations: {}
    scanOnPush: true
    accountAccessList: []
    providerConfigRef:
      name: "custom-ecr-provider"
    additional_tags: {}
    lifecyclePolicy:
      rules: []

  rds:
    enabled: false

  iam:
    roleNameOverride: ""
    providerConfigRef:
      name: "custom-iam-provider"

  dynamodb:
    enabled: true
    providerConfigRef:
      name: "custom-dynamodb-provider"
    additional_tags: {}
    tables: []

commonLabels:
  team: "mtg"
  project: "mtg"

externalSecrets:
  enabled: false
```
