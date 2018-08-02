# ccd-shared-infrastructure

This module sets up the shared infrastructure for CCD.

## Variables

### Configuration

- `env` (required) The environment of the deployment, such as "prod" or "sandbox".
- `tenant_id` (required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault.
- `jenkins_AAD_objectId` (required) The Azure AD object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault.
- `product` (optional) The (short) name of the product. Default is "ccd".
- `location` (optional) The location of the Azure data center. Default is "UK South".

### Output

- `vaultName` The name of the key vault.
