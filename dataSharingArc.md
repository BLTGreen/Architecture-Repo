# Architecture Definition Document

**Date:** March 08 2025
**Author:** Bonnie Green

## Scope

An architecture that facilitates seamless and secure data sharing across all stakeholders while adhering to regulatory requirements. 


## Architecture Principles

A full list of principles can be found [/metamodel/designPrinciples.md](here).

# Target Architecture 

*Diagram created/updated in LucidChart*

<div style="width: 640px; height: 480px; margin: 10px; position: relative;"><iframe allowfullscreen frameborder="0" style="width:640px; height:480px" src="https://lucid.app/documents/embedded/8fcd57f0-6b8c-4ba3-948d-f5ea80b58c0c" id="hdyZRUXqxy~g"></iframe></div>

## Rationale 

### Integration Strategy

I considered two approaches: event sourcing and batch processing. 

After completing a full trade-off analysis, considering design principles, pricing, time to build, etc, I opted for x. 

### Data Quality

As part of the above diagram, we can see that I'm using 

### Performance across different business cases

### Maintainability



## Challenges

### GDPR and the Right to be Forgotten

### Data consistency

### Risks



# Solution Building Blocks


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

## Unknown Impacts

## Transition Architecture

My suggested transition architecture is to 

# Security 

## Threat Model

# Disaster Recovery

## Failover

## Backup

# Suggested Roadmap

| NOW | NEXT | LATER |
|-----|------|-------|