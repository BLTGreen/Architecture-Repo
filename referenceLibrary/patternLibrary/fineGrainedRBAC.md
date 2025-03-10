# RBAC

## Summary
Often, authorization includes checking a global role (e.g., “Data Team”) and then checking whether the user has access to a particular resource (e.g., a report). The user needs to satisfy both conditions to be able to edit items on that list.

## Problem

How do we construct an access control policy that gives us the control we need in a complex environment where different roles will require different levels of access management?

## Solution

Role-based access control (RBAC) determines access to resources based on a role that usually aligns with business logic. Permissions are associated with the role as appropriate. For instance, a *marketing* role would authorize a user to perform *marketing* activities within a restricted system. This is a relatively simple access control model to implement because it aligns well to easily recognizable business logic.

Fine-grained control, or attribute-based access control *(ABAC)* determines access to resources based on attributes. Attributes can be associated with a user, resource, environment, or even application state. Your policies or rules reference attributes and can use basic Boolean logic to determine whether a user is permitted to perform an action.

Combining RBAC and ABAC can provide some of the advantages of both models. RBAC, being aligned so closely to business logic, is simpler to implement than ABAC. To provide an additional layer of granularity when making authorization decisions, you can combine ABAC with RBAC. This hybrid approach determines access by combining a user's role (and its assigned permissions) with additional attributes to make access decisions. Using both models enables simple administration and assignment of permissions while also permitting increased flexibility and granularity pertaining to authorization decisions.


## Rationale

- Permissions can be included in more than one role. So if there’s a can-view-this-item permission, it’s probably included in the “viewer,” “editor,” and “admin” roles.
- We’ll define larger roles (Data Team, IT Ops, Security, External User), and then fine grained permissions that can be included within those roles.
- Authorization systems define permissions as first-class concepts. Instead of checking whether a user is a member of a group, the policy first checks whether a user has permission.
- Many applications want to grant permissions on a set of objects that they manage. For example, a file-sharing application such as Google Drive defines “folders” and “files” as object types. Folders and files can both have a parent folder. Each of these objects has a set of relations (“owner,” “editor,” “commenter” and “viewer”) and the “owner” can grant these roles to users and groups. So rather than a global “editor” role which has edit access to every file and folder, these permissions can be assigned to discrete folders and files.
- This will be extremely useful for delineating secure roles (i.e., 'data team admin' vs 'data team member', 'security user' vs 'IT ops'), ensuring a fine-grained division of what can be accessed by who.

## Trade Offs

- True ABAC can be difficult to maintain in larger organisations; as the complexity grows, so too do the number of attributes that must be assigned.