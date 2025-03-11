# Metrics to Track

I'd suggest tracking these metrics alongside our quantitative NFRs. 

## Maintainability Level

Alexander von Zitzewitz's Maintainability Level metric objectively defines the maintainability level of an application. It's complex, but if we run it over the architecture as it's delivered, we can keep an eye on any potential factors affecting our maintainability.

## Technical Debt

This is more of a delivery metric. However, by raising technical debt tickets and applying them against an "overdraft" (like a WIP limit), we can report on how much refactoring we may need to do. That'll prevent roadmap impacts later down the road.

## DORA

Another delivery/DevOps metric, by measuring how quickly we can deliver a ticket versus our change fail rate we can identify cultural clashes or problems up stream (such as churn or confusion around the architecture).

## Response Times

We'll need to set NFRs to ensure practical response time thresholds across the architecture, from API endpoint to Kafka ack. 

## Cost

With tools like AWS Budgets we can set up alerts for if our budget goes over a certain level. We ought to ensure we're regularly evaluating this metric to avoid a frog in hot water style situation in which we realise we're spending far much more than should be expected for our organisation's size and utilisation. 

## Throughput

We need to ensure the throughput of our Kafka messages matches the NFRs that will be set. 

## Mean time to recover (MTTR)

A metric related to DORA. By measuring how long it takes to recover from downtime and change fails, we can identify if there's any obstacles in the way of our ability to maintain and recover from issues.

## CPU Utilisation

Tracking CPU Utilisation will help us determine performance for the RDS, AWS Batch, and Kafka.

## Availability

Azure and AWS guarantee a certain level of availability. We'll need to ensure our own availability does not affect any SLAs or SLOs we have. 

## Inbound network throughput

We can use JMX to surface this in Kafka. This is the rate at which data is received by a Kafka broker from producers, essentially measuring how many bytes of messages are coming into the Kafka cluster per second.

## Outbound network throughput

We can use JMX to surface this in Kafka. This is the rate at which data is sent out from a Kafka broker to other brokers or consumers on the network, essentially measuring how much data is leaving the Kafka cluster per unit time, usually measured in bytes per second.

## EventQueueTimeMs

We can use JMX to surface this in Kafka. Time that an event (except the Idle event) waits, in milliseconds, in the controller event queue before being processed.

## requests-in-flight

We can use JMX to surface this in Kafka. The current number of in-flight requests awaiting a response.