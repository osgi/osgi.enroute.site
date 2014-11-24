---
title: org.osgi.service.coordinator
layout: service
version: 1.0
summary: A coordinator for thread based requests with the possibility to get a callback at the end of a request. 
---

![Coordinator Collaboration Diagram](/img/services/org.osgi.service.coordinator.overview.png)

The OSGi programming model is based on the collaboration of standard and custom components. In such a model there is no central authority that has global knowledge of the complete application. Though this lack of authority can significantly increase reusability (and robustness) there are times when the activities of the collaborators must be coordinated. For example, a service that is repeated- ly called in a task could optimize performance by caching intermediate results until it knew the task was ended.
To know when a task involving multiple collaborators has ended is the primary purpose of the Co- ordinator service specification. The Coordinator service provides a rendezvous for an initiator to create a Coordination where collaborators can decide to participate. When the Coordination has ended, all participants are informed.
This Coordinator service provides an explicit Coordination model, the Coordination is explicitly passed as a parameter, and an implicit model where the Coordination is associated with the current thread. Implicit Coordinations can be nested.
Coordinators share the coordination aspects of the resource model of transactions. However, the model is much lighter-weight because it does not support any of the ACID properties.
