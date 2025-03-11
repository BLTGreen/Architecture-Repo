# RBAC vs ABAC

RBAC sets access at role level, whereas ABAC sets access at attribute level - i.e., resource-type, user characteristic (job title), or document sensitivity.

## **Group-Based RBAC with Fine-Grained Permissions**

- Permissions can be included in more than one role. So if there’s a can-view-this-item permission, it’s probably included in the “viewer,” “editor,” and “admin” roles.
- We’ll define larger roles (Financial Ops, Customer Ops), and then fine grained permissions that can be included within those roles.
- Authorization systems define permissions as first-class concepts. Instead of checking whether a user is a member of a group, the policy first checks whether a user has permission.

## **Fine-Grained Authorization for Domain-Specific Objects**

- Many applications want to grant permissions on a set of objects that they manage. For example, a file-sharing application such as Google Drive defines “folders” and “files” as object types. Folders and files can both have a parent folder. Each of these objects has a set of relations (“owner,” “editor,” “commenter” and “viewer”) and the “owner” can grant these roles to users and groups. So rather than a global “editor” role which has edit access to every file and folder, these permissions can be assigned to discrete folders and files.
- A great example of this is the permissions system within Google Drive, Zanzibar: [Zanzibar: Google’s Consistent, Global Authorization System](https://research.google/pubs/zanzibar-googles-consistent-global-authorization-system/)

My suggestion:

## **Combining both Group-Based RBAC and FGA**

- Often, authorization includes checking a global role (e.g., “financial ops”) and then checking whether the user has access to a particular resource (e.g., a billing report). The user needs to satisfy both conditions to be able to edit items on that list.

This'll be useful when used in conjunction with a cross-cloud user management system as it means we can create a cross-cloud ACL and assign global roles.

# Appendix

## Zanzibar
https://research.google/pubs/zanzibar-googles-consistent-global-authorization-system/ 

Google's Zanzibar is a global system for storing and evaluating access control lists across Google's services (Google Drive, Google Photos, etc). When I think about consistency and fine grained user permissions, I often return to this paper to re-read how Google implemented a scalable, globally used system.