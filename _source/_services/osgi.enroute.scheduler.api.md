---
title: osgi.enroute.scheduler.api
layout: service
version: 1.0
summary: Provides time based functions like delays, (cron and period based) schedules, and timeouts on Promises. 
---

![Scheduler Service](/img/services/osgi.enroute.scheduler.overview.png)

## Problem

You use the Scheduler API in the following cases:

* Delays – `scheduler.after( ()-> foo(), 100 )`
* Running at a certain time – `scheduler.at( Instant.from( dateTime ) )`
* Periodic Schedules – `scheduler.schedule( ()-> foo(), 10, 20 , 40, 100 )`
* Cron Schedules – `scheduler.schedule( () -> foo(), "10 10 10 FRI#3 JAN-JUN ?" )`
* Timeout on Promises – `CancelablePromise<Integer> cp = scheduler.before( p, 100 )`
* Execute some work on another thread – `scheduler.after( C::work, 0)`

## Background 

Basically the API replaces the Java Timer and ScheduledExecutor while providing quite a bit more bang for the buck. It is bundle aware so that any schedules or delays are properly canceled when the bundle is stopped.  

## 
 



## Configuration

Implementations must follow the PID `osgi.enroute.rest` which must support at least the following fields:

* `alias` – The primary end-point

