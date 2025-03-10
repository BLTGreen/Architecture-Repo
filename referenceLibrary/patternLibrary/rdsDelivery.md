# Aurora RDS Delivery

## Summary

Aurora DB cluster pushes activities to an Amazon Kinesis data stream in near real time. The Kinesis stream is created automatically. From Kinesis, we can configure AWS services such as Amazon Data Firehose and AWS Lambda to consume the stream and store the data.

## Problem

How do we provide back-up for our Aurora DB records in a way that allows us to ensure no modifications have been made to the data?

How do we transfer the records of our Aurora tables so that we can create a way to pull all of our records into the datalake?

## Solution

The following steps:

1. Data is created in the Aurora cluster
2. Item-level changes are generated in near-real time in Kinesis Data Streams
3. Kinesis Data Streams sends the records to Firehose for transformation and delivery.
4. Data Firehose delivers transformed data into s3. Data can also be sent to partner applications via Kinesis data streams.

## Available Examples

- https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/DBActivityStreams.Monitoring.html

## Rationale

- Useful for data integration and back-up
- Allows for real-time streaming of records

## Trade Offs

- May not be secure or future-forward for our use cases.