# Internal Principles

I usually break architectural principles down under the following guidelines, listing them under any departmental or enterprise goals they contribute to. For example:

* Maintainability
* Modularity
* Scalability
* Performance
* Cost
* Usability
* Security

As I've been given some specific principles to cover, I'll work on ensuring I've got full coverage in this doc.

## Secure by Design Principles
The UK Government has a set of principles to ensure architects keep security top of mind. Here's the high level items:

1. Create responsibility for Cybersecurity Risk
2. Source secure technology products
3. Adopt a risk-driven approach
4. Design usable security controls
5. Build in 'detect and respond' security
6. Design flexible architecture
7. Minimise the attack surface
8. Defend in depth
9. Embed continuous assurance
10. Make changes securely


## Well Architected Principles (Azure / AWS)
Azure and AWS have a lot of overlap in their principles, making them natural partners. Here's what I'll be keeping in mind:

| AWS                    | Azure                   |
| ---------------------- | ----------------------  |
| Operational Excellence | Operational Excellence  |
| Security               | Security                |
| Reliability            | Reliability             |
| Performance Efficiency | Performance Efficiency  |
|   Cost Optimisation    | Cost Optimisation       |
|   Sustainability       | n/a                     |


## NFRs

From the brief, I also have the following guidelines to prioritise:

* Performance, scalability, maintainability, and fault tolerance.
* Data availability, consistency, and audit-ability.
* Cost considerations for AWS-Azure data transfer

# Bringing all of these together

Because these frameworks are pretty harmonious in bringing together a best practises view, I'll define the headers I'll be using as a short-hand in my trade-off analyses and any discoveries here. 

### Measurability

The ability to measure and observe the architecture.

Following the above guidelines:
- Secure by Design Principle 9: Embed Continuous Assurance
- Secure by Design Principle 5: Detect and Respond Security
- Performance / AWS/Azure Well Architected principle: Performance Efficiency
- AWS Well Architected principle: Sustainability
- AWS/Azure Well Architected principle: Operational Excellence 

### Scalability

Scalability is how we respond to a changing landscape. It concerns manual/automated change management and flexibility. How easily do we adjust to unexpected loads, or gracefully scale up/down to meet demands? 

Following the above guidelines:
- Secure by Design Principle 6: Design flexible architecture
- Secure by Design Principle 5: Detect and Respond Security
- Secure by Design Principle 10: Make changes securely
- AWS/Azure Well Architected principle: Reliability
- AWS/Azure Well Architected principle: Performance Efficiency

### Security

Ensuring the ongoing security of the architectural solution. Anything from integration of a SIEM to ensuring a minimal attack surface at the beginning of the design process. 

Following the above guidelines:
- Secure by Design Principle 1: responsibility for cyber security
- Secure by Design Principle 2: Source secure technology products
- Secure by Design Principle 7: Minimise the attack surface
- Secure by Design Principle 8: Defend in Depth
- AWS/Azure Well Architected principle: Security
- AWS/Azure Well Architected principle: Operational Excellence

### Cost

We need to ensure we understand the long-term costs of our architecture, in both effort and currency. Different enterprises may have different budgets; one enterprise may have roadmap capacity but no financial budget, meaning a lower-cost build solution may be a better option than the quick win of the buy option.

Following the above guidelines:
- Secure by Design Principle 2: Source secure technology products
- Secure by Design Principle 3: Adopt a Risk Driven Approach
- AWS/Azure Well Architected principle: Operational Excellence
- AWS/Azure Well Architected principle: Cost Optimisation
- AWS/Azure Well Architected principle: Performance Efficiency

### Availability

What's our plans for disaster recovery and business continuity? How do we ensure the data is accessible when needed? How do we ensure our systems are working as intended?

Following the above guidelines:
- Secure by Design Principle 9: Embed continuous assurance
- AWS/Azure Well Architected principle: Reliability
- AWS/Azure Well Architected principle: Operational Excellence

### Consistency

Per Redis.io, 'Any transaction of data written to the database must only change affected data as defined by the specific constraints, triggers, variables, cascades, etc., established by the rules set by the database’s developer.' This quality guideline is to ensure our data holds its integrity. 

Following the above guidelines:
- Secure by Design Principle 9: Embed continuous assurance
- AWS/Azure Well Architected principle: Operational Excellence
- AWS/Azure Well Architected principle: Reliability

### Auditability

We need to ensure that we hold audit records to ensure:
1. Access has been assigned appropriately to data, no malicious actors have been able to get access.
2. Data is flowing without any problems or gaps
3. Our architecture is performative and tests are running appropriately.

Following the above guidelines:
- Secure by Design Principle 4: Design usable security controls
- Secure by Design Principle 9: Embed continuous assurance
- AWS/Azure Well Architected principle: Operational Excellence
- AWS/Azure Well Architected principle: Security
- AWS/Azure Well Architected principle: Reliability

#### Why split them up like this?

A lot of these principles could work under multiple headlines. I could have thrown all of the secure by design principles under 'security'. 

Each principle directly reflects and integrates with other principles. I like to embed security under all headers to ensure it's always a high priority in every part of the design.

# How I plan to work from these

I'll be using this table to break down any discoveries and approach trade-offs to ensure I'm covering the necessary NFRs/principles in my comparisons.

I will score each approach under these headers out of 5, 5 being the best and 1 the worst, depending on how well I see it meeting the requirements (briefly referenced above). I will go in depth where they fail to meet/exceeds expectations. I have also added an extra column called 'speed to dev' in which I will estimate briefly how quickly it might take to build under a standard Secure Software Delivery Lifecycle (assump: design -> threat modelling -> ticket refinement -> build -> unit testing -> integration testing -> acceptance testing -> release) and the TOGAF ADM [/metamodel/architectureFramework/tailoredTOGAFADM.md](here). 

The final score column will show which item scores best across the board. **This is excellent evidence but does not in all cases identify the best solution.** It could be, for example, a buy solution scores 5/5 on all headers, but 1/5 on cost. Similarly, a build solution may score 5/5 on everything but speed to dev, at which point it may well be worth discussing a less well rated buy option for a transition architecture approach.

| Approach | Measurability | Scalability | Security | Cost | Speed to Dev | Availability | Consistency | Auditability |  Final Score |
| -------- | ------- | ------- | -------- | ------- | ------- | -------- | ------- | ------- | ------- | 
|          |         |         |          |         |         |          |         |         |         |
|          |         |         |          |         |         |          |         |         |         |
|          |         |         |          |         |         |          |         |         |         |