# Hub and Spoke

## Summary

Hub and Spoke is the industry standard for virtual network topology. I'd also use it when describing data landscapes. When there are multiple data producers and applications that require data across the enterprise, having a central hub to store and analyse it is key.

## Problem

In a distributed system, how do we best ensure data integrity and resilience?

## Solution

By having each data producer push their events to a central hub, we can create a central store of truth and single-stop shop for data across the enterprise.

## Rationale

* With a single hub, discovery of data is much easier.
* Logically defining the data landscape is simpler.
* We have minimised the attack vectors to a single, well guarded and audited, datalake.

## Trade Offs

* We would need to build a unified data model
* Backing up the datalake becomes key; although all other data stores in the landscape have resilience, if they use lifecycle rules to delete their data, relying on the datalake to store for the regulatory 7y, it'll be vital to get that backed up and audited too.
* Security processes must be prioritised. 
