# Hexagonal Architecture OR Ports and Adapters

## Summary

Ports and Adapters/Hexagonal Architecture describes a pattern in which the **domain logic** resides in the center of a hexagon, surrounded by **ports and adaptors** to other parts of the ecosystem.

## Problem

If we’re using domain driven design and microservices that each have their own distinct business logic, how do we solve the problem of connectivity - between our functions and external functions like third party services?

## Solution

With **Ports and Adapters/Hexagonal Architecture,** we allow our microservices to maintain the bounded domains of DDD, but create **adapters** and **handlers**.

We split out logic into **driver** and **driven.** Information that comes into the domain is a **driver;** information that the domain sends to other services is **driven.**

| **Driver (examples)** | **Driven (examples)** |
| --- | --- |
| Events produced from other services | Audit log update |
| Webhooks received from other services | Producing an event |
| API Calls | Sending a notification |

### Ports

The ports are the interfaces and contracts that the service uses to interact with entities that are external to it. Like a port receives ships, a services ports receive information.

### Adaptors

The adaptors translate (or *adapt)* information from the domain and sends them out to entities that are external to it.

## Rationale

- This pattern is technology agnostic, and allows us to keep our modular, microservice based architecture even if we completely change coding languages in future.
- This agnostic approach also means we can adapt to whatever these external entities use; i.e., the domain doesn’t need to know or understand anything about the schema of incoming data, that will be handled by the adapter. We could receive information from the driver in JSON or CSV, or need to send information in Apache Parquet; in each case the adapters will handle the information, allowing the domain model to remain standard.
- With each adapter acting as a separate logic handler, in theory our domains become infinitely **scalable**. At any point that we need to extend our architecture, we can plug in another adapter
- We can also extend our test coverage by creating a test library & adapter which will allow us to run tests on the architecture.


## Trade Offs

- Adapters increase the cyclomatic complexity of the system, unless accounted for.