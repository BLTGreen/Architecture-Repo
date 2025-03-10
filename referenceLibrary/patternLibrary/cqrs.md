# CQRS 

## Summary

The command query responsibility segregation (CQRS) pattern separates the data mutation, or the command part of a system, from the query part.

## Problem

In traditional architectures, the same data model is used to query and update a database. That's simple and works well for basic CRUD operations. In more complex applications, however, this approach can become unwieldy. For example, on the read side, the application may perform many different queries, returning data transfer objects (DTOs) with different shapes. Object mapping can become complicated. On the write side, the model may implement complex validation and business logic. As a result, you can end up with an overly complex model that does too much.

Read and write workloads are often asymmetrical, with very different performance and scale requirements.

- There is often a mismatch between the read and write representations of the data, such as additional columns or properties that must be updated correctly even though they aren't required as part of an operation.
- Data contention can occur when operations are performed in parallel on the same set of data.
- The traditional approach can have a negative effect on performance due to load on the data store and data access layer, and the complexity of queries required to retrieve information.
- Managing security and permissions can become complex, because each entity is subject to both read and write operations, which might expose data in the wrong context.

## Solution

You can use the CQRS pattern to separate updates and queries if they have different requirements for throughput, latency, or consistency. The CQRS pattern splits the application into two parts—the command side and the query side—as shown in the below diagram. The command side handles create, update, and delete requests. The query side runs the query part by using the read replicas.

Consider the following process:

1. The business interacts with the application by sending commands through an API. Commands are actions such as creating, updating or deleting data.
2. The application processes the incoming command on the command side. This involves validating, authorizing, and running the operation.
3. The application persists the command’s data in the write (command) database.
4. After the command is stored in the write database, events are triggered to update the data in the read (query) database.
5. The read (query) database processes and persists the data. Read databases are designed to be optimized for specific query requirements.
6. The business interacts with read APIs to send queries to the query side of the application.
7. The application processes the incoming query on the query side and retrieves the data from the read database.

**Further Guidance**

- Commands should be task-based, rather than data centric. ("Book hotel room", not "set ReservationStatus to Reserved"). This may require some corresponding changes to the user interaction style. The other part of that is to look at modifying the business logic processing those commands to be successful more frequently. One technique that supports this is to run some validation rules on the client even before sending the command, possibly disabling buttons, explaining why on the UI ("no rooms left"). In that manner, the cause for server-side command failures can be narrowed to race conditions (two users trying to book the last room), and even those can sometimes be addressed with some more data and logic (putting a guest on a waiting list).
- Commands may be placed on a queue for asynchronous processing, rather than being processed synchronously.
- Queries never modify the database. A query returns a DTO that does not encapsulate any domain knowledge.

## Available Examples

- https://github.com/aws-samples/step-functions-workflows-collection/tree/main/cqrs/ - CQRS using Stepfunctions
- https://github.com/aws-samples/aws-iot-cqrs-example - CQRS with an IoT client

## Implementation on AWS

### Samples from AWS Documentation

- AWS Step by Step guide: https://docs.aws.amazon.com/prescriptive-guidance/latest/patterns/decompose-monoliths-into-microservices-by-using-cqrs-and-event-sourcing.html

## Rationale

- **Independent scaling**. CQRS allows the read and write workloads to scale independently, and may result in fewer lock contentions.
- **Optimized data schemas**. The read side can use a schema that is optimized for queries, while the write side uses a schema that is optimized for updates.
- **Security**. It's easier to ensure that only the right domain entities are performing writes on the data.
- **Separation of concerns**. Segregating the read and write sides can result in models that are more maintainable and flexible. Most of the complex business logic goes into the write model. The read model can be relatively simple.
- **Simpler queries**. By storing a materialized view in the read database, the application can avoid complex joins when querying.

## Trade Offs

- CQRS code can't automatically be generated from a database schema using scaffolding mechanisms such as ORM tools (However, you will be able to build your customization on top of the generated code).
- **Complexity**. The basic idea of CQRS is simple. But it can lead to a more complex application design, especially if they include the Event Sourcing pattern.
- **Messaging**. Although CQRS does not require messaging, it's common to use messaging to process commands and publish update events. In that case, the application must handle message failures or duplicate messages.