# ccd-shared-infrastructure

This module sets up the shared infrastructure for CCD.
**Note:** The environment specific branches demo, ithc and perftest will be automatically synced with master branch. Changes commited to master are reflected in other branches - with a subsequent branch build per environment. If per branch specific changes are required this sync can be overridden in Jenkinsfile_CNP.

## Variables

### Configuration

- `env` (required) The environment of the deployment, such as "prod" or "sandbox".
- `tenant_id` (required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault.
- `jenkins_AAD_objectId` (required) The Azure AD object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault.
- `product` (optional) The (short) name of the product. Default is "ccd".
- `location` (optional) The location of the Azure data center. Default is "UK South".

### Output

- `vaultName` The name of the key vault.
