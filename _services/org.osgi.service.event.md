---
title: org.osgi.service.event
layout: service
version: 1.0
summary: A simple publish and subscribe mechanism for generic events 
---

![Event Admin Collaboration Diagram](/img/services/org.osgi.service.event.overview.png)

# When to Use?

The archetypical use case for Event Admin is the case where you have useful information but you're not sure who might be interested. That is, you feel like talking and don't care if someone is actually listening. For example, a web based user interface shows the internal state of a wiring circuit. Though the user interface obviously knows about the circuit component, a good design goes out of its way to keep the circuit component unaware of the user interface. One approach is to create circuit specific listeners. However, these listeners tend to follow an almost identical pattern between different components, causing ugly looking boiler plate code.

The Event Admin service captures this commonality.



Nearly all the bundles in an OSGi framework must deal with events, either as an event publisher or as an event handler. So far, the preferred mechanism to disperse those events have been the service interface mechanism.

Dispatching events for a design related to X, usually involves a service of type XListener. Howev- er, this model does not scale well for fine grained events that must be dispatched to many different handlers. Additionally, the dynamic nature of the OSGi environment introduces several complexi- ties because both event publishers and event handlers can appear and disappear at any time.

The Event Admin service provides an inter-bundle communication mechanism. It is based on a event publish and subscribe model, popular in many message based systems.
This specification defines the details for the participants in this event model.
