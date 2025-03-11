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

![Target](/solutionsBuildingBlocks/modelsAndDiagrams/solution/LCCC%20Test.png)

*Diagram created/updated in LucidChart*

Link: https://lucid.app/documents/embedded/8fcd57f0-6b8c-4ba3-948d-f5ea80b58c0c

## Rationale 

Using event streaming with Kafka we have access to instant insights and data. Using batch processing, we can pull deeper analysis of our data landscape and complete tasks such as anonymisation and backup for graceful recovery from downtime. 

Furthermore, I made the assumption that the data analytics team are using Power BI or similar. Kafka can use this as a source, which means that if they produce reports or insights that need to be surfaced on the public website (assump. hosting in AWS with the other applications), Kafka can publish these changes to a lambda with permission to update the public website. 

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

As part of the target architecture diagram, we can see that I'm using Kafka for streaming the data. 

- Events are immutable and can be stored using an append-only operation. 
- The append-only storage of events provides an audit trail that can be used to monitor actions taken against a data store.
-  Whatever has occurred to create the current state, event streaming will hold the sequence of events that led to the change as well as the change itself. This, coupled with Kafka's append-only event ledger, means that we have an immutable record of our data sources.
-  A CDC event for the update of a record contains the entire new version of the record, so the current value for a primary key is entirely determined by the most recent event for that primary key, and log compaction can discard previous events for the same key

We'll receive a reflection of the data and events occurring across the landscape, from user events to updates from the RDS WAL.


#### Data Consistency

With ACID consistency, we need certain statements about our data to be invariants, that is to say, always true. In order to assure ourselves of a fault tolerant system, we'd typically want a strong correctness condition, like linearizability. However, Kafka utilises partitions. 

Thus, we can use an end of day batch process to send a copy of the latest data state once per day to preserve that consistency.

### Performance 

For **Streaming Performance**, Kafka has published the following figures:

https://developer.confluent.io/learn/kafka-performance/

| Feature | Speed |
| ------- | ----- |
|Peak Throughput |605 MB/s |
|p99 Latency | 5 ms (200 MB/s load) |

This will enable near real time analytics cross-cloud. 

In order to ensure our Kafka set up is as performative as it possible can be, we must track the following metrics:

* CPU utilization
* Inbound network throughput
* Outbound network throughput
* EventQueueTimeMs
* requests-in-flight

#### Potential issues

* Latency spikes and consumer lags on Kafka could cause massive delays. We'll need to determine effective performance NFRs with our internal stakeholders. Once we have those in place, we'll need to set up effective alarms to alert us when performance drops and latency spikes. 
* Kafka has the ability to throttle client requests in order to prevent one client from overwhelming the entire cluster. However, the Kafka broker does not use error codes in the response to indicate that the client is being throttled. This means we'll need to track kafka.consumer:type=consumer-fetch-manager-metrics, client-id=CLIENTID, attribute fetch-throttle-time-avg to see if a client is being throttled.

### Maintainability

I've used a mix of tools provided by the Cloud Providers and open source.

* Entra ID and AWS IAM can come together to allow resources in Azure to assume roles in AWS. This, plus Entra's in-depth user management tools (i.e., user audit logs), AWS CloudTrail, and Azure Sentinel allows us to build a rigious alternative to a third party SIEM while maintaining a full and secure RBAC approach to our security.
* Kafka is an open source tool with a vibrant open source community. The pre-built connectors from Confluent Cloud will allow us to integrate swiftly and provides an ease of maintainability due to the requirement to maintain those connectors being offloaded to Confluent.
* AWS Batch scales up and down smoothly using Fargate and we can use our pre-existing alerting patterns for EKS.

## Challenges

I've attempted to use technology that minimises time to deployment, but understand that due to the complications of a distributed cloud, we may deal with the following challenges:

* **Upskilling.** We need to ensure that if we do not have sufficient Kafka expertise within the teams, we can enable one to two evangelists within our development teams to help build a good framework for ease of development.
* **Resilience.** Let's ensure we have plenty of playbooks and run gamedays to ensure we understand how to prioritise and bring services up in case of downtime. If Azure and AWS both go down, do we prioritise the data warehouse or the RDS? We need to get consensus from our risk stakeholders.

We have to consider a number of challenges whenever something new is added to the landscape. I've covered some of the metrics we'll need to track above. I'd like to raise an important regulatory point here.

### Environments

* It's very challenging to hold a Dev-UAT-Prod mindset with data warehouses. Due to how expensive it is to stream and process data, having extra environments may feel like wasted money. With this design, I've tried to aim for the following strategy:
  * **Production Only Data Warehouse** - with only privileged users having access to the data warehouse in production. 
  * To mitigate any resiliency risk, we **must ensure** the Data Warehouse is IaC. 
* The aim is to keep the rest of the infrastructure through the other environments (dev/UAT) to ensure unit tests and integration tests can be carried out.

### GDPR 

Using fine grained Roles Based Access Controls via Entra (please see suggested roles below), we can ensure that only privileged users have access to necessary information. 

**Anonymisation** - We can use Batch Processing for this, setting up an ETL pipeline using tools such as **Amazon Macie** to discover and redact sensitive data.

* As a note, we may wish to perform anonymisation on all PII before it leaves our AWS environment. In this case, we can use Single Message Transforms: https://docs.confluent.io/kafka-connectors/transforms/current/overview.html Using the **Mask Field** Transform (https://docs.confluent.io/kafka-connectors/transforms/current/maskfield.html#maskfield) we can mask details such as name, age, financial records, etc, before they reach Azure Warehouse.

**Right to be Forgotten** - Under Article 17 of the UK GDPR individuals have the right to have personal data erased. The right only applies to data held at the time the request is received. It does not apply to data that may be created in the future. The right is not absolute and only applies in certain circumstances.

Individuals have the right to have their personal data erased if:

* the personal data is no longer necessary for the purpose which you originally collected or processed it for;
* you are relying on consent as your lawful basis for holding the data, and the individual withdraws their consent;
* you are relying on legitimate interests as your basis for processing, the individual objects to the processing of their data, and there is no overriding legitimate interest to continue this processing;
* you are processing the personal data for direct marketing purposes and the individual objects to that processing;
* you have processed the personal data unlawfully (ie in breach of the lawfulness requirement of the 1st principle);
* you have to do it to comply with a legal obligation; or
* you have processed the personal data to offer information society services to a child.

We can utilise a chain of tools as follows:

* AWS Macie to redact information within AWS RDS
* Azure Language Service to redact information within the Data Warehouse
* Mark necessary records for deletion in Kafka and run log compaction https://www.confluent.io/blog/handling-gdpr-log-forget/


# Solution Building Blocks

Solution Building Blocks are the research, reusable patterns, analysis and trade-offs that go into a solution architecture. You can find all research in the folder solutionsBuildingBlocks.

## Architecture Models

I've selected some architectural models from the TOGAF ADM to illustrate parts of my discovery into this ADD. Given more time, I would add the following to mitigate any unknowns:

* Application Interaction Diagram
* Application/Technology Matrix
* Conceptual data model
* Data Entity/Data Component Catalog
* Data Lifecycle Diagram
* Data Dissemination Diagram
* Data Security Diagram
* Enterprise Manageability Diagram
* Application Communication Diagram
* Technology Standards Catalog
* Environments and Locations Diagram

I've included the suggested tailored ADM [/metamodel/architectureFramework/tailoredTOGAFADM.md](here).

## User Access

I placed a list of suggested roles [/solutionsBuildingBlocks/security/suggestedRoles.md](here).

We can begin to surface their needs through a user access matrix, as suggested below:

| Role | Requirements |  Create |  Read  | Update | Delete | Add Users  | Security Level |
| ---- | ------------ | ------- | ------ | ------ | ------ | ---------- | -------------- |
| Data Analytics Team | Access to non-PII data | n/a | X | n/a | n/a | n/a | Medium |
| Security | Access to logs & audit trail | n/a | X | n/a | n/a | X | High |
| Ext Readers | Ability to view legal data | n/a | X | n/a | n/a | n/a | Low |

#### Cost

I've worked on the following cost analysis:

| | Feature | (USD) Cost per Month |
|-| ------- | ------------- |
| | Kafka   |  1,150 (enterprise)  |
| | AWS Batch |     1.73    |
| | Entra |   6 per user    |
| | Sentinel |        2      |
| | CloudTrail Logs |  $2.00 per 100,000 management events |
| | Step Functions |   0 (for the first 4k transactions)     |
| | Lambda |        0.20     |
| | AWS Backup | 0.10 per GB |
| | S3 |            0.0053  |
| | S3 Glacier |  0.01 |
| Total Cost | |     1162.0453 for one user and 1Gb of data (stored / transferred)       |

* The steepest cost here is Kafka. Realistically, the price will depend on how we've set it up/how much data we're sending/consuming. In this case, I borrowed the figure from Confluent Cloud's estimate for enterprises.
* I worked out one user and 1Gb (and 1 vCPU) because I don't know the exact amounts of data in each transaction. This figure will help me scale it based on data / users.


# Observability

While we can use (and I would usually recommend) Grafana for cross-cloud observability integrating with CloudWatch, Grafana is more of a visualisation dashboard. I looked briefly into Sentry and Datadog for the purposes of integrating with a SIEM, but after looking into Azure Sentinel I realised that with an IAM role, it could pull CloudWatch and CloudTrail logs.

With user access audit trails in Entra ID already pulled into Sentinel, adding AWS CloudTrail gives us a full audit of all actions, and CloudWatch allows us to visualise our performance. This means we can build a lightweight SIEM that covers our existing requirements.

## Risks with Sentinel

The problem with Grafana, Sentinel, and other tools is simply: alert fatigue. If we do not configure these tools appropriately, we risk burning ourselves out with false positives. 

I.E., A user accesses Power BI from a different network than usual (perhaps at a coffee shop?). Sentinel may then alert the security team. Too many of these eager alerts and we risk missing a larger issue. 

### Risk Mitigation

We can mitigate the risk of alert fatigue through things like:
* **Conditional Access** - we can handle this via Entra to ensure much lower chances of suspicious activity alerts. 
* **In-Depth NFR Work Shops** - If we work out with our stakeholders the exact NFR thresholds and when to throw up alarms (i.e., if our throughput NFR is 500k m/s, we might be fine with a drop of 50m/s, but less fine with 5000m/s). This'll stop any alerting channels getting crowded with false negatives.
* **Clear and Actionable Logs** - if our teams know how to respond to alerts, they're easier to solve.

## Metrics

I've added a list of potential metrics to solutionsBuildingBlocks\observability\trackedMetrics.md. In short, here's what I'd suggest:

* **Maintainability Level**
* **Technical Debt**
* **DORA**
* **Response Time**
* **Cost**
* **Throughput**
* **Mean time between failures (MTBF)**
* **Mean time to recover (MTTR)**
* **CPU Utilisation**
* **Availability**
  

## Audit Logs

We'll need to lean on the following sources for our auditing:
* Entra ID - if we can use the user audit log, we'll have a good view on security across both clouds.
* Kafka's logs - if we're keeping Kafka as part of our persistance layer, we'll be able to derive significant audit data from the logs.
* CloudTrail - because we can pull its data into Sentinel, we can use CloudTrail to track all of our auditable activity in AWS and surface insights in Azure.

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

### Mitigating Known Impacts

* To prevent high impacts, I'd recommend beginning with the back-up process, as this is fairly lightweight and can be done via click-ops. 
* We can build batch processing in the background, beginning by using AWS Batch to schedule a regular dump of the RDS Db to Azure (which means that if AWS fails over, we can spin the RDS Database up in Azure). 
* From there, with Domain Driven Design, we can add streaming per topic with Kafka. 

This gradual approach will allow us to create value immediately without impacting existing processes exponentially. 

## Unknown Impacts

I've listed below impacts that are unknown to me. If I were to begin this project, I would investigate them to discover our capacity for change and any known stakeholder requirements not yet surfaced.

* Existing ETL processes
* Existing user management processes
* Existing data team actions to gather insights
* Existing roadmaps for the external website
* Developmental roadmaps
* Budget

### Mitigating Unknown Impacts

* **Event Storming** - In order to understand a full view of the user journeys, I'd like to run an Event Storming workshop. As I've included event-driven elements in this architecture and have suggested Domain Driven Design as a framework, this'll help me verify my approach. I'll need stakeholders from across the business for this, specifically: product, engineering, data, security, compliance, customer operations, IT ops.
* **Enterprise Data Models** - If I can get access to an EDM, this'll allow me to understand our universal data model and any gaps.
* **Documenting As-Is Processes** - If I can get these documented, I can build an appropriate gap analysis between as-is state and target architecture. I can utilise the deliverables I called out under Architecture Models to verify as-is processes and validate the target.

With the above, I can move the *unknown impacts* to *known impacts*, or mitigate them entirely.

## Transition Architecture

I would usually suggest a transition architecture to ensure we can move step-by-step towards a new landscape - e.g., switch once service to Kafka, then another. 

However, given the importance of data and the relative simplicity of the ask, I would suggest that instead we work towards implement the target state immediately. 

# Security 

## User Provisioning

Entra allows for Cross-Tenant Synchronisation, meaning we can automatically replicate users across connected clouds, allowing for automated lifecycle management and smooth user management. Furthermore, with SCIM we can automatically provision users and permissions across both AWS and Azure.

Furthermore, we can use OpenID Connect to manage application access to the AWS cloud from Azure. On the Entra ID side, this involves the registration of an application and includes setup of a service principal. On the AWS side, it requires the establishment of a trust relationship with the registered application and creation of a web identity role.

[Entra to IAM](solutionsBuildingBlocks\modelsAndDiagrams\idDiagrams\entraToIAM.png)

## Threat Model

| Threat | Likelihood | Impact | Rating | Action |
| ------ | ---------- | ------ | ------ | ------ |
| Miscongifigured authentication | Unlikely | Significant | Amber | Always enable SSL and mTLS where possible |
| Misconfigured ACLs | Unlikely | Significant | Amber | Follow least privilege principles to reduce any attack vectors |
| Inadequate logging | Medium | Medium | Amber | Perform regular security and logging audits to ensure logging is adequate for security/compliance/engineering/DevOps stakeholders. |
| Man in the Middle Attack | Unlikely | Significant | Amber | Always connect to API over HTTPS using HMAC |

# Disaster Recovery

Disaster recovery is going to be super vital here due to a single production Data Warehouse. This is what I would suggest:

## Backup

Using **AWS Backup** we can take snapshots of the RDS Database once a day. These are hosted in S3 to ensure total coverage of our data, in case we need to back-up from disaster. We can use lifecycle rules to automate S3 moving/deleting old back-ups, to ensure we don't end up with a serious pricing surge - e.g., keeping new back-ups for a week, moving a back-up to Glacier after 7 days, and deleting after a month.

**Pricing in eu-west-2**
Amazon RDS Database Snapshot	$0.10 per GB-Month
S3 First 50 TB / Month	        $0.024 per GB
S3 Glacier Flexible Retrieval   $0.00405 per GB

We can utilise Azure tools to back up the Data Warehouse. https://learn.microsoft.com/en-us/troubleshoot/azure/synapse-analytics/dedicated-sql/backup-restore/dsql-maint-backup-restore-guidance We'll need to ensure this is captured in any BCP or DR plan. 

### Runbooks and Playbooks

* We need to make sure there's a testable runbook in place for our streaming service so that in the case of business continuity interruptions, any engineer has the knowledge to swiftly bring the service back online.
* We should also ensure we have a library of playbooks for specific incidents, i.e., **Broker not Available**, **Leader not Available**

# Design Principles

I have mapped out the standards required in the brief under headers here: /metamodel/designPrinciples.md. Here's a quick description of how this architecture meets them:

| Measurability | Scalability | Security | Cost | Availability | Consistency | Auditability |  
| ------------- | ----------- | -------- | ---- | ------------ | ----------- | ------------ | 
| High levels of cross-cloud measurability available through pushing CloudTrail/CloudWatch logs to Azure Sentinel |  Event Streaming a highly scalable solution, placing batch processing within Fargate also allowing us to scale up/down as need be   |  Using least privilege principles and RBAC/ABAC keeps us super secure   |  Cost tracked with tools like AWS Budgets  | Streaming allows for immediately available data |  High levels of data consistency  |  Audit logs provided by CloudTrail and Entra ID   | 
|  Azure Sentinel helps us to define a Detect and Respond architecture    | Using step functions and STS to auto-provision users on AWS allows for programmatic provision, opening up scale  |  mTLS, SSO and SSL as standard   |          | Shared responsibility model in the cloud means availability of our resources is high  |    Disaster recovery and threat model taken into account at point of design     |  Designing security controls that ensure users are managed cross-platform   |  
| Metrics defined to track performance efficiency    |   Flexible architecture responsive to scale  |  Minimising attack surfaces by aiming to use cloud provider-managed security services   |          |         |         |          |  

# Suggested Roadmap

| NOW | NEXT | LATER |
|-----|------|-------|
| Verify as-is processes with stakeholders | Allow external stakeholders to subscribe to timeboxed reporting | Integrate a data dashboard |
| Event storming session | Track metrics | |
| Provision users with Entra | | |
| Verify s3 lifecycle rules | | |
| Begin work on Kafka | | |