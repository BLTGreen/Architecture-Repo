# Approach Trade-Off Analysis

# Batch Processing
Batch processing is best used when we don't need immediate data. For example, the CHAPS window is 6-6; batch processing would be best used in a system reliant on data from CHAPS transactions to run a reconciliation report covering all transactions after 6pm. 

Processing takes place on a set schedule, with large sets of data processed in batches. It's low complexity, dealing with usually a predictable load in a predictable time window. With smart auto-scaling approaches, we can take performance efficiency and cost optimisation into account and use horizontal scaling to offset the load across small compute instances to increase our flexibility and cost effectiveness further.

**Use Cases**

* End of Day Reconciliation
* Timeboxed (Annual/Monthly/Weekly) billing
* Marketing campaigns
* Recurring reports

### Measurability

* The primary metric to track against batch processing is throughput. This'll help us understand the performance efficiency of our batch process.
* It'll also be vital to set up alerts to let us know immediately when a batch job fails.

### Maintainability

* Batch jobs are easy to maintain and are often seen as "set it and forget it"
* Static, no changes, little upkeep
* Observability/measurability a vital part of this to ensure immediate alerting should batch job fail to run

### Scalability

* Leader elections
* Horizontal scaling (could wipe out the leader)
* Because there's little upkeep, optimisation to ensure flexibility is easier

### Security

* The technology we select needs to be secure, i.e., Azure Batch can be locked down with [https://learn.microsoft.com/en-us/azure/virtual-machines/trusted-launch](Trusted Launch). 
* Robust logging must be implemented

### Cost-Effectiveness

* The cost will depend on the underlying technology, but as this is a task that happens once a day, we have options to reduce impact on budget.
* Batch jobs are a known quantity. Therefore, using tools like AWS Budgets will help alert us if things are outside of our expectations.

### Speed to Develop

* Because of how simple most batch processes are, a simple batch process can be spun up quickly using a cron job, a step function, Azure Batch or AWS Batch.

### Data availability 

* Due to the gaps in time between data being gathered and data being processed, this approach scores low on availability. 
* We can improve usability for stakeholders by automating a 'weekly insights' email, but there will be no real time analysis available with this method. This is **not suitable** for our stakeholders in the data team.

### Consistency

* Our consistency level here would be **high**. It's a **strong consistency pattern**. We're at a far lower risk of inconsistency with all of our data being processed in one large batch once a day.
* For **Data Quality** Batch Processing is useful. If we architect in reliable ETL processes, we can build a comprehensive data-driven portrait of our enterprise.

### Auditability

* Cloudtrail for monitoring 
* Microsoft Entra activity logs

## Strengths

* **Data Consistency** 
* **Compute Efficiency** 
* **Cost Effective**
* **Sustainability** - This is one of the AWS Well Architected guidelines. Batch Processing can rise to meet this through its performance efficiency.

## Weaknesses

* **Real-time insights**
* **Data Accessibility** - there'd be no way to run real-time decision making as required by the data analytics team.
* **Latency**

# Real-Time Streaming
Real time streaming is absolutely necessary for anything that requires real-time insights to be surfaced. Anomoly detection, instant reporting, continuous monitoring, etc.

While batch processing takes place once a day, stream processing is more event driven. As it consumes inputs (data and events) it produces outputs (data and events). This allows us to quickly get information from the system of record to the derived data system in a manner that allows for constantly up-to-date information.

**Use Cases**

* Fraud detection
* Search indexes
* Recommendation systems
* Real time analytics 

### Measurability

* Along with throughput, we'd need to measure latency
* Observability would need to be constant with alerting to ensure no data streams drop
* Many streaming technologies have their own observability patterns to support deployment

### Maintainability

* Batch processing certainly wins in the stream v batch battle of maintainability. 
* Streaming technologies like Kafka have higher levels of maintainability thanks to a long history of use and extensive documentation.

### Scalability

* We can utilise scaling patterns such as **Fan-Out** or **Load Balancing** to ensure scale in our streams.

### Security
### Cost-Effectiveness

* Streaming can become quite expensive based on the data being collected. 

### Speed to Develop



### Data availability 

* Streaming would create the highest levels of availability for our data.

### Consistency

* In streaming, producers send messages by appending them to a file that's partitioned by topic. Consumers read these messages sequentially.
* Although streaming may result in an inconsistency window, if we select a tool like Kafka with an **apend-only** ledger, we can bring a strong consistency model to streaming.
* To prevent data from being streamed more than once (i.e., a message queue repeating events), we can ensure the technology we select allows us to delete messages from the publisher queue once we have confirmation the subscriber has received them.
* If an event has not been delivered, events can be replayed, minimising data loss.

### Auditability

* To ensure data isn't lost in case of a crash or stream drop, event streaming message brokers use acknowledgements; the consumer of the event must explicitly acknowledge an event has been received before a broker removes it from their queue. This means we can store a record of transactions as an audit trail of events.

## Strengths

* **Continuous Data Ingestion** Because stream processing is continuously ingesting and analysing data, we can derive up to the minute insights.
* **Detection** 
* **Quick reactions**

## Weaknesses

* A subscriber continuously polling a publisher may become expensive
* We need to ensure producers never send messages faster than a subscriber can process them - do we want to set up a queue? Or allow the subscriber to scale?

# Hybrid
A hybrid approach, taking both options into account, would allow us to separate our requirements. We may have some data that requires immediate reporting - for example, the settlements application. But other data publishers/consumers might only need to update once a day. 

In order to approach this from a hybrid perspective, the best plan would be to understand the data requirements. Do we have different data use patterns that would call for more flexibility in our approach?

In this case, the Systems of Record (aka Data Producers) are two different applications. We can assume the associate business journeys may require different derived data system design and we can furthermore confirm this with the requirements:

*3. Data Consumers:*
*Public Website (publishes legally required data)*
*Data Analytics Team (uses data for insights and decision-making)*

* Our internal stakeholders, the Data Analytics Team, will require **Real Time Streaming** for up to date insights and decisions.
* The external stakeholders consuming updates via the public facing website likely will not.

**Use Cases**

* 

### Measurability



### Maintainability



### Scalability



### Security



### Cost-Effectiveness

* 

### Speed to Develop

* Due to multiple methods, this will take longer to develop.
* However, if developed in tandem, neither approach should take overly long

### Data availability 

* Where we **require** highly available data we will have highly available data.

### Consistency

* If the same data, or data relating to the same topic, appears in multiple places, it must be kept in synch. If Item A is updated in one data source, we must ensure it's updated across any other data sources.

### Auditability

* **Change Data Capture** - Having a mixture of streaming and batch processing would allow us to keep an eye on all changes occurring not just within the applications but the *systems of record themselves*. This would be useful from a security standpoint (identifying malicious actors/incorrectly assigned authentication) but also for data consistency.
  *  We can use Bottled Water or Debezium to keep track of CDC by pointing them at our Postgres WAL.

## Strengths

* Absolute flexibility, allowing for adjustment across all levels of data capture and processing.
* Consistency for enterprise data
* Cost-effective, meaning things that do not need to be streamed are not streamed
* High reliability in place with each approach able to act as a redundancy for the other

## Weaknesses

* A single approach allows for low cognitive load. Switching to multiple approaches creates more complexity.

# Security Considerations

# Approach Analysis

For each of these approaches, I'll rate them out of 5 based on the following principles (Please look to Design Principles for a further breakdown):

| Approach | Measurability | Scalability | Security | Cost | Speed to Dev | Availability | Consistency | Auditability |  Final Score |
| -------- | ------- | ------- | -------- | ------- | ------- | -------- | ------- | ------- | ------- | 
| Batch    |   3     |   2     |     3    |   5     |   5     |    1     |    5    |   3     |  27     |
| Stream   |   3     |   5     |    3     |   4     |   3     |    5     |    4    |   5     |  32     |
| Hybrid   |   4     |   5     |    3     |   5     |   3     |    5     |    5    |   5     |  35     |

# Final recommendation

There is never a perfect solution, but from the final score and the above overview of strengths v weaknesses we can see that for our use case. **Hybrid** is the right approach. It'll enable the real time streaming required for the data team's use cases, logging, change data capture and alerting (i.e., detect and respond security) while allowing for batch processing where necessary.