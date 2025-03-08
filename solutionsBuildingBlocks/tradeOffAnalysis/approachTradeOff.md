# Approach Trade-Off Analysis

# Batch Processing
Batch processing is best used when we don't need immediate data. For example, the CHAPS window is 6-6; batch processing would be best used there, to run a large reconciliation report after 6pm. 

# Real-Time Streaming
Real time streaming is absolutely necessary for anything that requires real-time insights to be surfaced. Anomoly detection, up-to-the-second reporting, continuous monitoring, etc.

# Hybrid
A hybrid approach, taking both options into account, would allow us to separate our requirements. We may have some data that requires immediate reporting - for example, the settlements application. But other data publishers/consumers might only need to update once a day. 

In order to approach this from a hybrid perspective, the best plan would be to understand the data requirements. 

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
