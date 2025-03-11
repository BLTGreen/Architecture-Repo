# Architecture Fitness function
> Any mechanism that provides an objective integrity assessment of some architecture characteristic or combination of architecture characteristics
>> *Evolutionary Architectures* (I think)

Fitness Functions are architectural governance, compliance and verification mechanisms. We can use these to ensure delivery and quality of the target design.

I haven't done a full discovery on how to ensure fitness functions here, but I believe the team is using GitLab. In theory, we can use GitLab CI to run these tests when code is deployed.

I've set up this document to record some suggested Fitness Functions.

## Test coverage
Once we determine a threshold for test coverage - i.e., 90% - we can run a fitness function that fails if the coverage is below that:
'Unit Test Coverage > 0.9;
Execute on each CI Build; Fail when below target coverage'

## Maintain Component Inventory
This is a holistic test that sends an alert on build if any components have been added or removed. This allows the architect to maintain an inventory of services.

## Cyclic Dependency Test
This would allow us to ensure our cyclic dependency level isn't too high. We can write this from scratch, or use modules like this one:
https://github.com/bndr/pycycle

## Chaos Monkey
* https://github.com/netflix/chaosmonkey
Using the Netflix Chaos Monkey libraries, we can test our reliability and ability to respond to crisis.

## Swabbie
* https://github.com/spinnaker/swabbie
Swabbie can help keep costs low by cleaning up unused resources in the cloud.

