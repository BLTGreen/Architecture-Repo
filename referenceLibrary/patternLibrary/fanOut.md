# Fan Out

## **Summary**

Messaging patterns can encourage loosely coupled communication between highly cohesive components to manage complexity in serverless architectures.

## **Simple Diagram**

Open image-20240607-132357.png

## **Problem**

When using Lambda in a serverless architecture, the goal should be to design tightly focused functions that do one thing and do it well. When these functions are composed to accomplish larger goals in microservice architectures, the complexity shifts from the internal components to the external communication between components. It’s all too easy to accidentally back into an architecture that's rigid because components are too knowledgeable of each other via the communication paths between them.

## **Solution**

SNS allows applications to send time-critical messages to multiple subscribers through a “push” mechanism, eliminating the need to periodically check or “poll” for updates. Additionally, the message filter functionality of Amazon SNS can autonomously and individually discard irrelevant messages. The services can specify the threshold values for the messages they wish to receive.

An SQS queue in front of each subscriber service also acts as a buffering load balancer.

Since every message is delivered to one of potentially many consumer processes, you can scale out the subscriber services, and the message load is distributed over the available consumer processes.

As messages are buffered in the queue, they are preserved during a scaling event, such as when you must wait until an additional consumer process becomes operational.

Lastly, these queue characteristics help flatten peak loads for your consumer processes, buffering messages until consumers are available. This allows you to process messages at a pace decoupled from the message source.

## **Rationale**

- Amazon SNS allows applications to send time-critical messages to multiple subscribers through a “push” mechanism, eliminating the need to periodically check or “poll” for updates. Amazon SQS is a message queue service used by distributed applications to exchange messages through a polling model, and can be used to decouple sending and receiving components—without requiring each component to be concurrently available. Using Amazon SNS and Amazon SQS together, messages can be delivered to applications that require immediate notification of an event, and also persisted in an Amazon SQS queue for other applications to process at a later time.
  
## **Trade Offs**

- This is a controversial pattern, with arguments over if it might be considered an anti-pattern due to introducing complexity into an asynchronous process. The argument here is that parallelism creates complexity, especially in cases where FIFO might be necessary.