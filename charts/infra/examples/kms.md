# KMS Key Examples

Examples of KMS key configurations including symmetric encryption keys,
asymmetric signing keys, key rotation, deletion windows, and alias settings.

---

## Full KMS configuration

```yaml
aws:
  enabled: true

  # AWS region where the KMS key will be created
  region: "eu-central-2"

  # Crossplane ProviderConfig reference
  providerConfigRef:
    name: "aws-provider"

  kms:
    enabled: true

    # ---------------------------------------------------------
    # Toggle between SIGNING vs ENCRYPTION modes
    # ---------------------------------------------------------
    # true  = Asymmetric SIGN_VERIFY key (ECC/RSA)
    # false = Symmetric ENCRYPT_DECRYPT key (AES-256)
    signingEnabled: false

    # ---------------------------------------------------------
    # keyUsage (optional override)
    # If not provided:
    #   signingEnabled=true  -> SIGN_VERIFY
    #   signingEnabled=false -> ENCRYPT_DECRYPT
    #
    # Valid values:
    #   ENCRYPT_DECRYPT
    #   SIGN_VERIFY
    #   GENERATE_VERIFY_MAC
    # ---------------------------------------------------------
    keyUsage: ""

    # ---------------------------------------------------------
    # customerMasterKeySpec (optional override)
    # If not provided:
    #   signingEnabled=true  -> ECC_NIST_P256
    #   signingEnabled=false -> SYMMETRIC_DEFAULT
    #
    # Symmetric:
    #   SYMMETRIC_DEFAULT
    #
    # RSA (asymmetric signing):
    #   RSA_2048
    #   RSA_3072
    #   RSA_4096
    #
    # ECC (asymmetric signing):
    #   ECC_NIST_P256
    #   ECC_NIST_P384
    #   ECC_NIST_P521
    #   ECC_SECG_P256K1   # blockchain curve
    #
    # HMAC (MAC keys):
    #   HMAC_256
    # ---------------------------------------------------------
    keySpec: ""

    # ---------------------------------------------------------
    # Key rotation
    # Asymmetric keys -> rotation MUST be false
    # Symmetric keys  -> can be true or false
    #
    # Default: false
    # ---------------------------------------------------------
    enableKeyRotation: ""

    # ---------------------------------------------------------
    # Deletion window (7-30 days)
    # ---------------------------------------------------------
    deletionWindowInDays: 30

    # ---------------------------------------------------------
    # Tags applied to the KMS key
    # ---------------------------------------------------------
    tags:
      environment: "dev"
      owner: "platform-team"
      project: "funding-platform"

    # ---------------------------------------------------------
    # Alias configuration
    # ---------------------------------------------------------
    alias:
      enabled: true
      # If empty, template will use KMS key name automatically
      name: ""
```
