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

* We'd need to track latency
* **Vital to set up alerts around health**

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

**Use Cases**

* Fraud detection
* 

### Measurability
### Maintainability
### Scalability
### Security
### Cost-Effectiveness
### Speed to Develop
### Data availability 
### Consistency

* Although streaming may result in an inconsistency window, if we select a tool like Kafka with an **apend-only** ledger, we can bring a strong consistency model to streaming.

### Auditability

## Strengths

* **Continuous Data Ingestion** Because stream processing is continuously ingesting and analysing data, we can derive up to the minute insights.
* **Detection** 
* **Quick reactions**

## Weaknesses

# Hybrid
A hybrid approach, taking both options into account, would allow us to separate our requirements. We may have some data that requires immediate reporting - for example, the settlements application. But other data publishers/consumers might only need to update once a day. 

In order to approach this from a hybrid perspective, the best plan would be to understand the data requirements. 

**Use Cases**

### Measurability
### Maintainability
### Scalability
### Security
### Cost-Effectiveness
### Speed to Develop
### Data availability 
### Consistency
### Auditability

## Strengths

## Weaknesses

# Security Considerations

# Approach Analysis

For each of these approaches, I'll rate them out of 5 based on the following principles:
1. Measurability
2. Maintainability
3. Scalability
4. Security
5. Cost-Effectiveness
6. Speed to Develop
7. Data availability 
8. Consistency
9. Auditability

| Approach | Measurability | Scalability | Security | Cost | Speed to Dev | Availability | Consistency | Auditability |  Final Score |
| -------- | ------- | ------- | -------- | ------- | ------- | -------- | ------- | ------- | ------- | 
| Batch    |         |         |          |         |         |          |         |         |         |
| Stream   |         |         |          |         |         |          |         |         |         |
| Hybrid   |         |         |          |         |         |          |         |         |         |

# Final recommendation

There is never a perfect solution, but from the final score we can see