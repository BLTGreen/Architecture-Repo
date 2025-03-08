# Build v Buy for Fine-Grained RBAC

## Buy Options

* Okta
* WorkOS
* AuthID

## Build Option

Users can be controlled programmatically using Terraform, which would offer us IaC control (Please see [/solutionsBuildingBlocks\proofOfConcepts\userControlAzure](here) for a quick PoC).

In order to ensure synchronicity in a cross-cloud environment we can use the Federated Identity Pattern [/referenceLibrary/patternLibrary/federatedIdentity.md](here) to delegate authorisation to consolidate cross-cloud user management. In the case of this build option, the idea is to utilise **Azure,** specifically **EntraID** as the user manager.

This would allow us to grant access to the data required by a user's identity while providing a cohesive experience.

### Provisioning Users

### Setting up SSO

**Steps:**
1. Within Azure Portal, create a new Enterprise Application
2. From Enterprise Application Gallery, select AWS IAM Identity Centre
3. On the Single Sign-On page, select SAML
4. 

**Notes**
If ABAC is enabled in AWS IAM Identity Center, the additional attributes may be passed as session tags directly into AWS accounts.

Cost / Time

# Recommendation

