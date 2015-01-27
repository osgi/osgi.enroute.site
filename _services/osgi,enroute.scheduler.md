---
title: osgi.enroute.scheduler.api
layout: service
version: 1.0
summary: A time scheduler with Promise support for one time events and and TimeAjusters for periodic events.
---

![Tracker Overview](/img/services/osgi.enroute.scheduler.overview.png)

## Application Areas

The Scheduler is useful when you need to:

* Delay an activity
* Periodically call a function 
* Fail a promise when it is resolved after a certain time
* Ensure a promise is not successfully resolved before a certain time  
* Delay a promise

## Overview

The Scheduler is a service based around the capabilities of the `org.osgi.util.promise` package. The asynchronous programming model is well suited to delay tasks (before or after resolving), or ensuring cancelation then the resolution of the promise takes too much time.

## Examples

### Delay


