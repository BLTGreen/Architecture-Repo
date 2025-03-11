# Architecture Definition Document

**Date:** March 08 2025
**Author:** Bonnie Green

## Scope

An architecture that facilitates seamless and secure data sharing across all stakeholders while adhering to regulatory requirements. 


## Architecture Principles and Frameworks

A full list of principles can be found [/metamodel/designPrinciples.md](here). These were pulled from the brief and informed by the Frameworks I selected.

### Frameworks

I selected the following Frameworks to help determine this architecture. For more information, please check metamodel -> architectureFramework in the associated repository.

**AWS Well Architected** - AWS Well Architected is the backbone of a good AWS architecture. Its guiding principles helped me determine the best patterns and technologies to use.
**Azure Well Architected** - Much as above, with the benefit that AWS Well Architected and Azure Well Architected (and, beyond these two, Google Cloud Well-Architected Framework) largely align!
**TOGAF** - I used mostly principles from TOGAF 10 in selecting processes and diagrams. However, there is little difference between TOGAF 9.x and TOGAF 10. I selected TOGAF for its flexibility and in-depth focus on delivery

### Potential Future Frameworks

Given the differences in data needs between the data analytics team and external stakeholders, if I were to take this further, I'd suggest **Domain Driven Design** as a framework. The emphasis on event-driven, domain-bounded architecture and tools like Ubiquitous Language would enable a flexible, responsive architecture.

# Target Architecture 

[Target](/solutionsBuildingBlocks/modelsAndDiagrams/solution/LCCC%20Test.png)

*Diagram created/updated in LucidChart*

Link: https://lucid.app/documents/embedded/8fcd57f0-6b8c-4ba3-948d-f5ea80b58c0c

## Rationale 

Using event streaming with Kafka we have access to instant insights and data. Using batch processing, we can pull deeper analysis of our data landscape. 

A fuller look at the approaches and patterns I've researched and selected can be found described in depth in the folder solutionsBuildingBlocks. My aim here is to design an architecture that fulfills the requirements of the stakeholders named in the brief while remaining cost-effective, secure, and maintainable. 

### Integration Strategy

I considered two approaches: event sourcing and batch processing. 

After completing a full trade-off analysis, considering design principles, pricing, time to build, etc, I opted for a **Hybrid Approach**. We have some use cases where real time streaming is a necessisty, specifically around our data analytics team. We'll also need real time insights to follow the UK Government's **Secure by Design** principles. 

Utilising Kafka we can build a modular, maintainable system that'll allow us to create a full landscape of data:
* Change Data Capture by streaming the WAL
* Event streams
* Security Insights
* Audit records

And by utilising Batch Processing, we can make sure our data is up to the rigoruous standards set by the UK government:
* Anonymising personal data
* Enabling Right to be Forgotten through redaction
* Processing deeper insights
* Back-up and Disaster Recovery

### Data Quality

As part of the above diagram, we can see that I'm using Kafka for streaming the data. After that, it enters an ETL process.


#### Data Consistency

* Detecting Concurrent Writes
* Atomic Commit
* **Change Data Capture**
* ETL

### Performance across different business cases

* Throughput is high for streaming.

### Maintainability



## Challenges

We have to consider a number of challenges. 

### GDPR and the Right to be Forgotten

### Data consistency

### Risks



# Solution Building Blocks

Solution Building Blocks are the research, reusable patterns, analysis and trade-offs that go into a solution architecture. You can find all diagrams in the folder solutionsBuildingBlocks->modelsAndDiagrams. I've also placed them below, aligned to the architectural area they cover.

## Architecture Models

### Business Architecture

#### Gap analysis

#### Cost

### Data Architecture

* Right to be Forgotten
* GDPR

### Application Architecture

### Technology Architecture


# Observability

## Metrics

## Audit Logs

# Impact Assessment

Based on the known current data landscape:

1. Data Sources: Two core applications generate data:
Settlements application (AWS-hosted)
Contracts application (AWS-hosted)
2. Data Warehouse: Stores only the necessary data from data sources and third-party external sources.
Hosted in Azure
3. Data Consumers:
Public Website (publishes legally required data)
Data Analytics Team (uses data for insights and decision-making)

We have the following potential impacts:

## Known Impacts

Here are some of the items that will be impacted from this build that I can surmise from the data landscape supplied in the brief:

* Adding a new streaming service into the landscape
* Adjusting back-up process 
* New batch processing and ETL 

## Unknown Impacts

I've listed below impacts that are unknown to me. If I were to begin this project, I would investigate them to discover our capacity for change and any known stakeholder requirements not yet surfaced.

* Existing ETL processes
* Existing user management processes
* Existing data team actions to gather insights
* Existing roadmaps for the external website
* Developmental roadmaps
* Budget

## Transition Architecture

I would usually suggest a transition architecture to ensure we can move step-by-step towards a new landscape - e.g., switch once service to Kafka, then another. 

However, given the importance of data and the relative simplicity of the ask (two data producers), I would suggest that instead we implement the target state immediately. 

# Security 



## Threat Model

# Disaster Recovery

Disaster recovery is going to be super vital here. This is what I would suggest:

## Backup

Using **AWS Backup** we can take snapshots of the RDS Database once a day. These are hosted in S3 to ensure total coverage of our data, in case we need to back-up from disaster. We can use lifecycle rules to automate S3 moving/deleting old back-ups, to ensure we don't end up with a serious pricing surge - e.g., keeping new back-ups for a week, moving a back-up to Glacier after 7 days, and deleting after a month.

**Pricing in eu-west-2**
Amazon RDS Database Snapshot	$0.10 per GB-Month
S3 First 50 TB / Month	        $0.024 per GB
S3 Glacier Flexible Retrieval   $0.00405 per GB

## Failover

### Runbooks and Playbooks

* We need to make sure there's a testable runbook in place for our streaming service so that in the case of business continuity interruptions, any engineer has the knowledge to swiftly bring the service back online.
* We should also ensure we have a library of playbooks for specific incidents, i.e., **Broker not Available**, **Leader not Available**

# Suggested Roadmap

| NOW | NEXT | LATER |
|-----|------|-------|
| Verify ETL process with Data Analytics Team | Allow external stakeholders to subscribe to timeboxed reporting | Integrate a data dashboard |