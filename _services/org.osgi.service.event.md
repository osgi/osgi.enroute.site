---
title: org.osgi.service.event
layout: service
version: 1.0
summary: A simple publish and subscribe mechanism for generic events 
---

![Event Admin Collaboration Diagram](/img/services/org.osgi.service.event.overview.png)

Nearly all the bundles in an OSGi framework must deal with events, either as an event publisher or as an event handler. So far, the preferred mechanism to disperse those events have been the service interface mechanism.

Dispatching events for a design related to X, usually involves a service of type XListener. Howev- er, this model does not scale well for fine grained events that must be dispatched to many different handlers. Additionally, the dynamic nature of the OSGi environment introduces several complexi- ties because both event publishers and event handlers can appear and disappear at any time.

The Event Admin service provides an inter-bundle communication mechanism. It is based on a event publish and subscribe model, popular in many message based systems.
This specification defines the details for the participants in this event model.