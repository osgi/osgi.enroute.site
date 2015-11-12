---
title: osgi.enroute.easse
layout: service
version: 1.0
summary: Dispatches OSGi Event Admin events that match a given topic to the front-end using Javascript's Server Sent Events
---

![Event Admin Server Sent Events](/img/services/osgi.enroute.easse.overview.png)

## When to Use?

In almost all single-page-web applications it is necessary to synchronize data in the back-end to the front-end. Though the front-end can continuously poll the back-end, in most cases it is better to use events to minimize bandwidth and CPU cycles. This service uses the Event Admin service to estables an event channel between the back-end and the front-end.

This service can also be used to eavesdrop on the OSGi events.

## Example

In the Java code you can use the `RequireEventAdminServerSentEventsWebResource` to include the library Javascript code in your index.html page.

	@RequireEventAdminServerSentEventsWebResource
	@RequireAngularWebResource(resource={"angular.js"}, priority=1000)
	@RequireWebServerExtender
	@Component(name="osgi.enroute.example.eventadminserversentevents")
	public class EventadminserversenteventsApplication{ }

The skeleton of the Javascript looks as follows:

	var events = [];

	var MODULE = angular.module('osgi.enroute.example.easse',
			[ "enEasse"]);

	MODULE.run( function($rootScope, en$easse) {
		$rootScope.events = events;
		
		en$easse.handle("some/topic/*", function(e) {
			$rootScope.$applyAsync(function() {
				events.push(e);
			});
		}, function(error) {
			console.log("EASSE error: " + msg);
		} );
	});

A full working example can be found at [OSGi enRoute Examples][easseexample].
 
## Description

This service uses [OSGi Event Admin][ea] to forward events from the OSGi Framework towards the front-end using Javascript's [Server Sent Events][sse]. Since OSGi eventes are properties, this is quite straightforward.

The service can be used by annotating the application main class  `RequireEventAdminServerSentEventsWebResource`, this will include the `enEasse` angular module (see the WebResource Namespace for more information).

The `enEasse` module will register an `en$easse` service. This service has the following methods:

* `handle(topic, messageCallback, errorCallback, logCallback, scope)` – This will create a watcher on the Event Admin stream connected to this application. 
	* `topic` – The topic can contain the normal wildcard as specified in the Event Admin specification (e.g. `some/topic/*`). 
	* `messageCallback(properties)` – The message callback should be placed in an asynchronous body for Angular:
		
		$rootScope.$applyAsync(function() {
				events.push(properties);
		});
	* `errorCallback(error)` – Indicates any errors
	* `logCallback(message)` – Progress information
	* `scope` – If provided, will be used for the life cycle. If the scope is terminated, the handle will also be closed

Since the connection consumes resources it is important to close the connection when no longer needed. If a scope is provided then the connection is closed when that scope is destroyed. Otherwise, the handle's return object should be closed by calling `close()` on it.
 
[ea]: http://enroute.osgi.org/services/org.osgi.service.event.html
[easseexample]: https://github.com/osgi/osgi.enroute.examples/tree/master/osgi.enroute.examples.easse.application
[sse]: http://www.w3schools.com/html/html5_serversentevents.asp
