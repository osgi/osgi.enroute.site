---
title: Example Projects
layout: book
---

This section is an entry to the hopefully growing collection of examples that OSGi enRoute provides. If you want to develop an additional example, please submit a PR.

The examples are all in a workspace that you can clone from Github. Some examples are combined together, others have their own workspace. It is highly suggested to clone the workspace and play with the example.

## Trains

This example is quite large since it was used in the 2015 IoT Contest. The OSGi IoT Trains SDK is a way to write software for a Lego® train track used in the OSGi IoT Contest. The SDK is an OSGi enRoute workspace with a number of projects. The SDK is a self contained environment that contains everything to run an emulator with custom or example bundles.

[Go to the Trains example](/trains/200-architecture.html)

## Components

Sometimes one could wonder what the initial designers of OSGi were smoking when designing the core APIs. Though the APIs were top from a point of view of specification, consistency, clarity, and power, they sucked quite badly because they required lots of boiler plate. Fortunately, Declarative Services changed all that. DS combines the awesome power of OSGi and type safe Java with the friendliness of a script language. 

This project shows lots of examples of what you can do with OSGi Declarative Services.

[Go to the Component examples](https://github.com/osgi/osgi.enroute.examples/tree/master/osgi.enroute.examples.component.application)

## Led over MQTT

This example has been donated by Amit Kumar Mondal. It shows how to use OSGi enRoute to turn on a LED over MQTT using the Eclipse server and a Raspberry Pi. It requires the [IoT Tutorial as a base][12]. Very interesting if you are into IoT. (Realize that looking at the predictions IoT is soon into you.)

[Go to the web LED over MQTT example application](https://github.com/osgi/osgi.enroute.examples.ledovermqtt/tree/master/osgi.enroute.examples.led.controller.application)

## CRUD Example with Mongodb

This example is currently work in progress. It shows the progress on a project to make a full blown CRUD example with OSGi enRoute. Though OSGi enRoute contains a lot of excellent parts to do this, it shamefully lacks a database abstraction. (The reason is the highly sensitive nature of databases in Java.) [Chuck Boecking][13], whois an expert in ERP is using an [open source Mongo db bundle][14] to build the example.

Chuck also delivered an [excellent video about the subject][15]. Highly recommended.   

[Go to the CRUD example workspace](https://github.com/cboecking/com.chuboe.moeboe)

## Configuration Admin

The OSGi Configuration Admin is a a significant part of the reason why OSGi is so powerful. Its primary trick is to reverse the normal flow where an app looks for configuration to a model where the app is called with the configuration. (Another don't call us, we'll call you!) However,  this novel approach is often not well understood. Add to that the subtle difference between _factories_ and _singletons_ and you've got a lot of confused people. This example shows lots of examples on an OSGi enRoute GUI.

[Go to the Configuration Admin examples](https://github.com/osgi/osgi.enroute.examples/tree/master/osgi.enroute.examples.cm.application)

## Event Admin & Javascript's Server Sent Events

How often did you write a browser application and wished you could easily get the events from the server? Your sorrows are over! OSGi enRoute contains a helper bundle ([osgi.enroute.easse.simple.adapter][1]) that makes it trivial to receive the events from Event Admin the browser as [Server Sent Events][2]. The [OGSi enRoute perspective][3] has an example project to demonstrate how awesome this support is.

[Go to the Event Admin/Server Sent Events example application](https://github.com/osgi/osgi.enroute.examples/blob/master/osgi.enroute.examples.easse.application)


## JSON RPC

REST APIs are fantastic until they are not. Though they definitely have a role to play in modern distributed system they do suck when two closely tied parties have to interact on the details. At that level, a significant time is lost on designing URLs, parameters, and payload formats and making sure [Roy Fielding][4] does not get upset. This is especially true when you have a Javascript front-end that needs to collaborate with a Java/OSGi back-end. This is very chatty and mapping it to a RESTful API is about as pleasant as doing tax returns.

The OSGi enRoute JSON RPC is therefore a relief. It is based on the simple idea that the public methods on an OSGi service should be available on a Javascript object. So adding a method to the service makes it immediately available in Javascript without having to worry for three days if the arguments should be passed in the URL, the parameter, or the payload. Quite productive!

Though the beaming up of the methods is extremely pleasant, it does cause a bit of a problem in initialization before those methods have arrived. This example shows you in detail how to setup the Angular initialization code to make it work.

[Go to the JSON RPC example application](https://github.com/osgi/osgi.enroute.examples/tree/master/osgi.enroute.examples.jsonrpc.application)

## REST Application Skeleton

This project demonstrates the use of the [OSGi enRoute REST API][5]. This API allows you to write POJO code that is mapped to REST with JSON as payload. The project shows in the [RestApplication][6] class a number of examples that manipulate a history. All the examples are turned into a web page that allows you to execute them easily with a mouse click.

If you intend to use REST as the transport between your back-end and front-end then you might want to checkout JSON RPC.

[Go to the REST example application](https://github.com/osgi/osgi.enroute.examples/tree/master/osgi.enroute.examples.rest.application)


## Scheduler

The [OSGi enRoute Scheduler API][7] is quite awe inspiring. It heavily uses the Promises and lambdas to make async programming simple in OSGi. It supports all the important features like deadlines, delays, and Cron like scheduling. This example is a GUI that calls lots of examples in the back end. It is a really nice way to explore the Scheduler API.

[Go to the Scheduler examples application](https://github.com/osgi/osgi.enroute.examples/tree/master/osgi.enroute.examples.scheduler.application)

## Web Server

A large part of a web site usually consists of static resources like images, scripts, html, etc. These resources must be mapped to a proper path on the local webserver. The webserver can provide this feature by mapping a folder in the bundle to a path (i.e. the URL) on the webserver.

In a large webserver it is likely that the same web resources must be present in multiple versions. This is especially opportune for Javascript. Such web resources also have dependencies that are managed by a myriad of dependency systems that also interact like amd, commonjs, bower, npm, and ES6. Even with these solutions it requires a lot of manual care to support multiple versions of the same web resources.

The webserver therefore provides the possibility to wrap the web resources in bundles and use the OSGi dependency model to create a coherent set. This set can then be included as a single file in the web application’s HTML.This is called [web resources][9].

This example shows a project with a Javascript part and it demonstrates the web resource concepts. Look at [web resources][9] for a description of how to use this. It basically consists of a [simple application][10] and a w[eb resource][11].

[Go to the web resource example application][10] [or the web resource][11].


## Backend Application

This example helped a person that wanted to solve a problem in an elegant way but did not find appropriate pieces yet. He described the problem as follows:

	I want to create some abstraction for a little 
	data management system which should be connected 
	to different data backends at the same time 
	(e.g. S3, Dropbox, local/network filesystem, ...).

	Now let's consider a simple example of the 
	logic involving the following standard CRUD 
	operations (because I want to publish that 
	in a single ReST endpoint):

The example shows a solution to the classic _dispatch problem_. In this case we need to dispatch the operations on a BLOB (Binary Large Object). 

[Go to the Backend example](https://github.com/osgi/osgi.enroute.examples/tree/master/osgi.enroute.examples.backend.application)

## Framework Properties

A quite simplistic example GUI application that reads the properties from framework and shows them on the UI. The properties are accessed using a REST API. Small and maybe not that useful but it is a skeleton of a REST application so that might be interesting.

[Go to the Properties example application](https://github.com/osgi/osgi.enroute.examples/tree/master/osgi.enroute.examples.properties.application)

## Web Console

A simple skeleton of a [Apache Felix Web Console][8] plugin. Since this webconsole is heavily used in debugging OSGi applications it is sometimes an alternative to Gogo commands if you do not hate Javascript too much.

[Go to the Web Console Plugin example](https://github.com/osgi/osgi.enroute.examples/tree/master/osgi.enroute.examples.webconsole.provider)

## Maven Bnd Repository Plugin

A bnd workspace that shows the different possibilities of the Maven Bnd Repository plugin.

[Go to the Maven Bnd Repository Plugin example](https://github.com/osgi/osgi.enroute.examples.maven)

 
[1]: https://github.com/osgi/osgi.enroute.bundles/tree/master/osgi.enroute.easse.simple.adapter 
[2]: https://www.w3.org/TR/2011/WD-eventsource-20110208/
[3]: http://enroute.osgi.org/services/osgi.enroute.easse.html
[4]: https://www.ics.uci.edu/~fielding/pubs/dissertation/top.htm
[5]: http://enroute.osgi.org/services/osgi.enroute.rest.api.html
[6]: https://github.com/osgi/osgi.enroute.examples/blob/master/osgi.enroute.examples.rest.application/src/osgi/enroute/examples/rest/application/RestApplication.java
[7]: http://enroute.osgi.org/services/osgi.enroute.scheduler.api.html
[8]: http://felix.apache.org/documentation/subprojects/apache-felix-web-console.html
[9]: http://enroute.osgi.org/services/osgi.enroute.webserver.capabilities.html
[10]: https://github.com/osgi/osgi.enroute.examples/tree/master/osgi.enroute.examples.webserver.application
[11]: https://github.com/osgi/osgi.enroute.examples/tree/master/osgi.enroute.examples.webserver.webresource
[12]: /tutorial_iot/050-start.html
[13]: http://erp-academy.chuckboecking.com/
[14]: https://github.com/pkriens/aQute.open/tree/master/aQute.open.store.mongo.provider
[15]: http://erp-academy.chuckboecking.com/?page_id=3789