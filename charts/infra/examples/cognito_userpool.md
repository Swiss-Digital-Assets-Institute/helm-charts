# Cognito User Pool Examples

Examples of Cognito User Pool configurations including sign-in identifiers,
self-registration, required attributes, authentication (email/phone), groups,
password policy, MFA, Lambda triggers, and tags.

---

## Full Cognito User Pool configuration

```yaml
aws:
  enabled: true
  region: eu-central-2

  cognito:
    userpool:
      enabled: true

      # ----------------------------------------------------------------------
      # 1. Sign-In Identifiers
      # Options: email, phoneNumber, username
      # Only identifiers listed here will be enabled; all others are disabled.
      # All options can be found here:
      # https://docs.aws.amazon.com/cognito/latest/developerguide/user-pool-settings-attributes.html
      # ----------------------------------------------------------------------
      signInIdentifiers:
        - email
        - username

      # ----------------------------------------------------------------------
      # 2. Self Registration
      # Whether users can self-register.
      # ----------------------------------------------------------------------
      enableSelfRegistration: false

      # ----------------------------------------------------------------------
      # 3. Required Attributes
      # Define the user attributes that are required.
      # ----------------------------------------------------------------------
      requiredAttributes:
        - email
        - name
        - family_name

      # ----------------------------------------------------------------------
      # 4. Callback URLs
      # List of callback URLs after authentication.
      # ----------------------------------------------------------------------
      callbackUrls: []
      # Example:
      # callbackUrls:
      #   - https://example.com/callback
      #   - https://app.example.com/auth/callback

      # ----------------------------------------------------------------------
      # 5. Logout URLs
      # List of URLs users are redirected to after logout.
      # ----------------------------------------------------------------------
      logoutUrls: []
      # Example:
      # logoutUrls:
      #   - https://example.com/logout
      #   - https://app.example.com/auth/logout

      # ----------------------------------------------------------------------
      # 6. Authentication Configuration
      # ----------------------------------------------------------------------
      authentication:

        # Email authentication block
        email:
          enabled: false  # When false, all below values are ignored
          provider: COGNITO_DEFAULT  # Options: COGNITO_DEFAULT, SES
          sesRegion: eu-central-2
          fromEmailAddress: ""
          fromSenderName: ""
          replyToEmailAddress: ""
          sesConfigurationSet: ""

        # Phone number authentication block
        phoneNumber:
          enabled: false
          snsRegion: eu-central-2
          fromPhoneNumber: "" # Must be in E.164 format (+12345678900)

      # ----------------------------------------------------------------------
      # 7. Groups
      # Define user groups and precedence (lower = higher priority)
      # ----------------------------------------------------------------------
      groups: []
      # Example:
      # groups:
      #   - name: admins
      #     description: Administrator group
      #     precedence: 1
      #   - name: users
      #     description: Regular user group
      #     precedence: 100

      # ----------------------------------------------------------------------
      # 8. Password Policy
      # ----------------------------------------------------------------------
      passwordPolicy:
        minimumLength: 12
        requireLowercase: true
        requireUppercase: true
        requireNumbers: true
        requireSymbols: true
        temporaryPasswordValidityDays: 7

      # ----------------------------------------------------------------------
      # 9. MFA Configuration
      # Acceptable values: "ON", "OFF", or "OPTIONAL"
      # ----------------------------------------------------------------------
      mfaConfiguration: "OFF"

      # ----------------------------------------------------------------------
      # 10. Lambda Trigger Extensions (optional)
      # Configure Lambda triggers for customizing Cognito User Pool behavior
      # ----------------------------------------------------------------------
      # extensions:
      #   enabled: true
      #   triggers:
      #     - type: messaging  # Options: sign_up, authentication, custom_authentication, messaging
      #       events: []  # Optional: specific events for this trigger
      #       eventVersions: []  # Optional: event versions
      #   lambdaFunction:
      #     name: my-cognito-lambda-function  # Required: Lambda function name
      #     arn: arn:aws:lambda:eu-central-2:123456789012:function:my-cognito-lambda-function  # Required: Lambda function ARN

      # ----------------------------------------------------------------------
      # 11. Additional Tags (optional)
      # These are merged into global/common tags via the helper function.
      # ----------------------------------------------------------------------
      tags:
        Application: my-app
        Owner: platform-team@example.com

global:
  org: my-org
  env: production

commonLabels:
  Team: platform
  CostCenter: engineering
```
