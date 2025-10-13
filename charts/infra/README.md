# infra

![Version: 1.7.23](https://img.shields.io/badge/Version-1.7.23-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

Managing and maintaining cloud resources using crossplane

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| aws.account | string | `""` |  |
| aws.cdn.additional_tags | object | `{}` |  |
| aws.cdn.bucketName | string | `""` |  |
| aws.cdn.bucketPolicy.version | string | `"2012-10-17"` |  |
| aws.cdn.cloudFront.comment | string | `""` |  |
| aws.cdn.cloudFront.defaultCacheBehavior.allowedMethods[0] | string | `"GET"` |  |
| aws.cdn.cloudFront.defaultCacheBehavior.allowedMethods[1] | string | `"HEAD"` |  |
| aws.cdn.cloudFront.defaultCacheBehavior.cachedMethods[0] | string | `"GET"` |  |
| aws.cdn.cloudFront.defaultCacheBehavior.cachedMethods[1] | string | `"HEAD"` |  |
| aws.cdn.cloudFront.defaultCacheBehavior.compress | bool | `true` |  |
| aws.cdn.cloudFront.defaultCacheBehavior.defaultTtl | int | `86400` |  |
| aws.cdn.cloudFront.defaultCacheBehavior.maxTtl | int | `31536000` |  |
| aws.cdn.cloudFront.defaultCacheBehavior.minTtl | int | `0` |  |
| aws.cdn.cloudFront.defaultCacheBehavior.targetOriginId | string | `"S3Origin"` |  |
| aws.cdn.cloudFront.defaultCacheBehavior.viewerProtocolPolicy | string | `"redirect-to-https"` |  |
| aws.cdn.cloudFront.defaultRootObject | string | `""` |  |
| aws.cdn.cloudFront.enabled | bool | `false` |  |
| aws.cdn.cloudFront.httpVersion | string | `"http2"` |  |
| aws.cdn.cloudFront.isIPV6Enabled | bool | `true` |  |
| aws.cdn.cloudFront.originAccessIdentity | bool | `false` |  |
| aws.cdn.cloudFront.priceClass | string | `"PriceClass_All"` |  |
| aws.cdn.cloudFront.viewerProtocolPolicy | string | `"redirect-to-https"` |  |
| aws.cdn.distributionNameOverride | string | `""` |  |
| aws.cdn.domainName | string | `""` |  |
| aws.cdn.enabled | bool | `false` |  |
| aws.cdn.s3.corsPolicy.allowedHeaders[0] | string | `"*"` |  |
| aws.cdn.s3.corsPolicy.allowedMethods[0] | string | `"GET"` |  |
| aws.cdn.s3.corsPolicy.allowedMethods[1] | string | `"HEAD"` |  |
| aws.cdn.s3.corsPolicy.allowedOrigins[0] | string | `"*"` |  |
| aws.cdn.s3.corsPolicy.maxAgeSeconds | int | `3600` |  |
| aws.ecr.accountAccessList[0] | string | `"107282186755"` |  |
| aws.ecr.accountAccessList[1] | string | `"009160051835"` |  |
| aws.ecr.accountAccessList[2] | string | `"009160051778"` |  |
| aws.ecr.accountAccessList[3] | string | `"458845629758"` |  |
| aws.ecr.additional_tags | object | `{}` |  |
| aws.ecr.enabled | bool | `false` |  |
| aws.ecr.imageTagMutability | string | `"MUTABLE"` |  |
| aws.ecr.lifecyclePolicy.rules[0].action.type | string | `"expire"` |  |
| aws.ecr.lifecyclePolicy.rules[0].description | string | `"Expire images older than 14 days"` |  |
| aws.ecr.lifecyclePolicy.rules[0].rulePriority | int | `1` |  |
| aws.ecr.lifecyclePolicy.rules[0].selection.countNumber | int | `14` |  |
| aws.ecr.lifecyclePolicy.rules[0].selection.countType | string | `"sinceImagePushed"` |  |
| aws.ecr.lifecyclePolicy.rules[0].selection.countUnit | string | `"days"` |  |
| aws.ecr.lifecyclePolicy.rules[0].selection.tagStatus | string | `"untagged"` |  |
| aws.ecr.lifecyclePolicy.rules[1].action.type | string | `"expire"` |  |
| aws.ecr.lifecyclePolicy.rules[1].description | string | `"Expire dev* images older than 365 days"` |  |
| aws.ecr.lifecyclePolicy.rules[1].rulePriority | int | `2` |  |
| aws.ecr.lifecyclePolicy.rules[1].selection.countNumber | int | `365` |  |
| aws.ecr.lifecyclePolicy.rules[1].selection.countType | string | `"sinceImagePushed"` |  |
| aws.ecr.lifecyclePolicy.rules[1].selection.countUnit | string | `"days"` |  |
| aws.ecr.lifecyclePolicy.rules[1].selection.tagPatternList[0] | string | `"dev*"` |  |
| aws.ecr.lifecyclePolicy.rules[1].selection.tagStatus | string | `"tagged"` |  |
| aws.ecr.repoNameOverride | string | `""` |  |
| aws.ecr.scanOnPush | bool | `true` |  |
| aws.eksOidcId | string | `""` |  |
| aws.enabled | bool | `true` |  |
| aws.iam.roleNameOverride | string | `""` |  |
| aws.irsa.serviceAccountNameOverride | string | `""` |  |
| aws.kms.additional_tags | object | `{}` |  |
| aws.kms.deletionWindowInDays | int | `365` |  |
| aws.kms.enabled | bool | `false` |  |
| aws.kms.keyNameOverride | string | `""` |  |
| aws.kms.rotateKey | bool | `false` |  |
| aws.rds.additional_tags | object | `{}` |  |
| aws.rds.allocatedStorage | int | `20` |  |
| aws.rds.backup.backupRetentionPeriod | int | `30` |  |
| aws.rds.backup.copyTagsToSnapshot | bool | `true` |  |
| aws.rds.backup.enabled | bool | `false` |  |
| aws.rds.backup.replication.destinationRegion | string | `""` |  |
| aws.rds.backup.replication.enabled | bool | `false` |  |
| aws.rds.backup.replication.kmsKeyId | string | `""` |  |
| aws.rds.dbName | string | `""` |  |
| aws.rds.dbSubnetGroupName | string | `""` |  |
| aws.rds.enabled | bool | `false` |  |
| aws.rds.engine | string | `"postgres"` |  |
| aws.rds.engineVersion | string | `"15.12"` |  |
| aws.rds.ha.enabled | bool | `false` |  |
| aws.rds.instanceClass | string | `"db.t3.micro"` |  |
| aws.rds.instanceNameOverride | string | `""` |  |
| aws.rds.masterUserName | string | `"postgres"` |  |
| aws.rds.monitoring.enableInsights | bool | `false` |  |
| aws.rds.monitoring.enablePerformanceInsights | bool | `false` |  |
| aws.rds.monitoring.insightsMode | string | `"standard"` |  |
| aws.rds.monitoring.performanceInsightsKmsKeyId | string | `""` |  |
| aws.rds.monitoring.performanceInsightsRetentionPeriod | int | `30` |  |
| aws.rds.multiAz | bool | `false` |  |
| aws.rds.namespace | string | `""` |  |
| aws.rds.passwordSecretRef.key | string | `"password"` |  |
| aws.rds.passwordSecretRef.name | string | `""` |  |
| aws.rds.passwordSecretRef.namespace | string | `""` |  |
| aws.rds.preferredBackupWindow | string | `"03:00-05:00"` |  |
| aws.rds.schemaNameOverride | string | `""` |  |
| aws.rds.security.enableDeletionProtection | bool | `true` |  |
| aws.rds.storage.enableAutoscaling | bool | `false` |  |
| aws.rds.storage.enableDedicatedLogVolume | bool | `false` |  |
| aws.rds.storage.maxAllocatedStorage | int | `500` |  |
| aws.rds.storage.provisionedIops | int | `3000` |  |
| aws.rds.storage.type | string | `"gp3"` |  |
| aws.rds.storageEncrypted | bool | `true` |  |
| aws.region | string | `"eu-central-2"` |  |
| aws.s3.additional_tags | object | `{}` |  |
| aws.s3.bucketNameOverride | string | `""` |  |
| aws.s3.corsPolicy.allowedHeaders[0] | string | `"*"` |  |
| aws.s3.corsPolicy.allowedMethods[0] | string | `"GET"` |  |
| aws.s3.corsPolicy.allowedMethods[1] | string | `"HEAD"` |  |
| aws.s3.corsPolicy.allowedOrigins[0] | string | `"*"` |  |
| aws.s3.corsPolicy.maxAgeSeconds | int | `3600` |  |
| aws.s3.enabled | bool | `false` |  |
| aws.s3.lifeCycleConfiguration.enabled | bool | `false` |  |
| aws.s3.lifeCycleConfiguration.rule | list | `[]` |  |
| aws.s3.objectOwnership | string | `"BucketOwnerEnforced"` |  |
| aws.s3.versioning.enabled | bool | `false` |  |
| aws.ses.additional_tags | object | `{}` |  |
| aws.ses.dkim.enabled | bool | `true` |  |
| aws.ses.dkim.keyLength | string | `"RSA_1024_BIT"` |  |
| aws.ses.domainNameOverride | string | `""` |  |
| aws.ses.enabled | bool | `false` |  |
| aws.ses.identityNameOverride | string | `""` |  |
| aws.ses.mailFromBehavior | string | `"UseDefaultMailFrom"` |  |
| commonLabels.env | string | `""` |  |
| commonLabels.org | string | `""` |  |
| commonLabels.project | string | `""` |  |
| commonLabels.team | string | `""` |  |
| externalSecrets.enabled | bool | `false` |  |
| externalSecrets.nameOverride | string | `""` |  |
| externalSecrets.refreshInterval | string | `"30s"` |  |
| externalSecrets.secretStoreRef.kind | string | `"ClusterSecretStore"` |  |
| externalSecrets.secretStoreRef.name | string | `"vault-backend"` |  |
| externalSecrets.target.creationPolicy | string | `"Owner"` |  |
| fullnameOverride | object | `{}` | fullnameOverride allows full override of the name |
| global.cluster.name | string | `""` |  |
| global.env | string | `""` |  |
| global.network.domain | string | `""` |  |
| nameOverride | object | `{}` | nameOverride allows partial override of the name |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
