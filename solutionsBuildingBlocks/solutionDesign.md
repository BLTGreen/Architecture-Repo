# Solution Design

My initial concept was to simply use Azure Event Hub or Kafka Concluent Cloud to subscribe to events created in AWS. A cronjob could run every day to push any data that requires batch processing to the Data Lake.

[solution concept](/solutionsBuildingBlocks/solutionConcept.png)

After examining the options [solutionsBuildingBlocks\integrationApproaches\streamingOptions.md](here), I've opted for a mixture of Kafka and Event Hub. I can have AWS lambdas send events to Kafka, which can be sent on to Azure Data Warehouse. I believe the resilience and security of Kafka will create an easier solution to build and maintain. 

Furthermore, I'd like to suggest utilising the WAL in the RDS schemas in order to stream all changes to the database for audit purposes.

I also think that with this architecture, given that access needs appear relatively simple from the requirements given to me in the brief, we can rely on EntraID. Entra can work as an SSO provider for AWS Cognito, and we can utilise it to provision users and permissions. Not only that, but it also provides audit and activity logs, [https://learn.microsoft.com/en-us/entra/identity/monitoring-health/concept-audit-logs](here) and fine-grained roles-based access [https://learn.microsoft.com/en-us/entra/permissions-management/product-roles-permissions](here). Given the brief, it would be faster, cheaper, more secure, and we'd have more control if we used Entra for user management.

Furthermore, we can utilise AWS connectors to link our CloudWatch and CloudTrail events to Azure Sentinel for greater overview of our performance and security. See [https://learn.microsoft.com/en-us/azure/sentinel/cloudwatch-lambda-function](here).

After considering all of the above, here is my target solution diagram:

[!Target diagram](/solutionsBuildingBlocks/modelsAndDiagrams/solution/LCCC%20Test.png)

[https://lucid.app/lucidchart/8fcd57f0-6b8c-4ba3-948d-f5ea80b58c0c/edit?viewport_loc=212%2C421%2C1471%2C716%2C0_0&invitationId=inv_97c169a4-f578-448d-aacf-933f8c354c70](link) to LucidChart.