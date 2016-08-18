---
title: org.osgi.service.cm
layout: service
version: 1.5
summary: Provides a push and pull model to configure components. 
---

![Configuration Admin Collaboration Diagram](/img/services/org.osgi.service.cm.overview.png)

## When to Use?

Configuration Admin is, obviously, about configuration. It is probably one of the most fundamental specifications in the compendium. You should use Configuration Admin any time you need configuration, but you should rarely use it directly. 

Declarative Services, the rock solid foundation of OSGi enRoute, has a very close integration with Configuration Admin. In almost all cases you will receive your configuration in the `activate` method. So if you just want to get configuration data, then consult the [Declarative Services][1] service catalog entry. 

Hmm, you're still reading so be prepared to dive a bit deeper. There are a few advanced cases where directly using Configuration Admin comes in handy. 

* You're writing middleware and need to work closely with Configuration Admin.
* You want to receive multiple configurations
* You want to set configuration for other components

## Example Usage

The following snippet shows a small example how you can use Configuration Admin to create a singleton configuration:

	Configuration configuration = cm.getConfiguration("singleton", "?");
	Hashtable<String, Object> map = new Hashtable<String,Object>();
	map.put("msg", "Hello Singleton");
	configuration.update(map);

The following creates a factory configuration:

	Configuration a = cm.createFactoryConfiguration("factory", "?");
	Hashtable<String, Object> map = new Hashtable<String,Object>();
	map.put("msg", "Hello Factory");
	a.update(map);

You can list all configurations with the following snippet:

	public Collection<Map<String, Object>> findConfigurations(String filter)
			throws IOException, InvalidSyntaxException {
		return getConfigurations0(filter).map(
				(c) -> ca.toMap(c.getProperties()))
				.collect(Collectors.toList());
	}

	private Stream<Configuration> getConfigurations0(String filter)
			throws IOException, InvalidSyntaxException {

		Configuration[] configurations = cm.listConfigurations(filter);
		if (configurations == null)
			configurations = EMPTY;

		return Arrays.stream(configurations);
	}

## Background

Most people that first see the OSGi Configuration Admin find it a rather odd API. Most developers want to get their configuration somewhere and process it. Not in this API. The basic model is push (or in more trendy terms: async!). To get configuration, you register a Managed Service or a Managed Service Factory and then ... do nothing. One day, when the Configuration Admin feels like it, it will call you with the configuration properties. Only then you should start doing whatever you were supposed to be doing with those properties. Whenever there are new configuration properties, Configuration Admin will call you again. So Configuration Admin collapses the case of starting and getting your configuration and updating your configuration. It only knows how to update you with new properties.

Lots of developers are upset about this model because they worry that Configuration Admin is not around and they have to "wait" forever (they're not waiting, they're just being ignored). Good designers are humble and just wait until it is their turn; they understand that certain aspects of the overall system should not be managed in each component. Bad designers have no clue what this means. In a proper OSGi enRoute design the component reacts to its configuration updates.

OSGi provides a standardized model to provide bundles with _confgurations_ in the Configuration Admin specification. Every configuration is identified by a persistent identity (PID). A PID is a unique token that follows the symbolic name syntax. A configuration consists of a set of _properties_, where a property consists of a string key and a corresponding value. The type of the value is limited to the primitive types and their wrappers as well as arrays or Java Vector or List classes. 

### Singletons and Factories

Configurations can be grouped with a factory PID, these are called _factory_ configurations, this leaves us with naming the configurations that are not factories (we'd like to remain positive) so let's call them singletons.

Now here we need a tad of history. Originally the model was that if you wanted a singleton configuration you registered a Managed Service (service) and if you want to be notified when factory instances were created or deleted you registered a Managed Service Factory service. Since a singleton can have at most one value for a PID, the `ManagedService` interface only supports a simple `updated()` method that receives the properties. A factory represents 0 or more instances, the `ManagedServiceFactory` interface therefore has an `updated()` method that takes an instance PID and properties as well as a `deleted()` method that that takes the factory PID.

So why do we have 2 managed service types? Singletons (`ManagedServce`) and factories (`ManagedServiceFactory`). 

A singleton gives you one set of properties, no less and no more. For example, you have a bundle that provides a simple HTTP server. If the server can only run on one port you would use the singleton configuration to parameterize it. 

The magic is in the factories, they allow you to define multiple sets of properties. In [Declarative Services][1] factories allow you to instantiate a component multiple times. For example, if you have a more advanced HTTP server that can run on different ports with different configurations then you would use the factory for each configuration.

### PIDs

PID stands for _Persistent IDentity_. It is an identifier with a dotted name (like a Java fully qualified name) that links a bundle to a set of properties. A.k.a. a primary key. When a bundle wants to get its configuration it registers a Managed Service with the PID as the service property. PIDs are so fundamental that this is the only non-framework entity with its own OSGi Framework constant: `Constants.SERVICE_PID` (`service.pid`).

Configuration Admin detects the PID and will look in its database of configuration records. If it has a set of properties, it will call the service with those properties, otherwise it will call it with a `null`. That is, the Managed Service is _always_ called.

Managed Service Factory work similar but their PID is treated as a _factory pid_. The Configuration Admin will look in its database for records and finds any records that are marked with that factory PID. Each entry is then turned into properties and sent to the Managed Service Factory `update` method. This `update` method takes two parameters: a PID and  a set of properties. The PID is not the factory PID, it is the _instance PID_, the primary key of the record.

If a configuration is deleted through Configuration Admin then the Managed Service will be called on its `update` method with a `null`. A Managed Service Factory has a special delete method that takes the instance PID. 

### Locations

Locations were a mistake in the Configuration Admin API. Ok, I've said it. They were a failed attempt to provide security at an unsuitable place. Mea culpa ... The intention was that we could restrict configurations to specific bundles, this restriction was actually automatic when the location was set to `null` and a bundle used it. Countless hours have been lost figuring out why Configuration Admin did not call `update` only to discover that the location was wrong. Alas, the sins we commit when we try to specify.

So what should you do with the location? Well, just set it always to "?". This is a recent addition to the specification that basically removes the awkward location check. 

## Example Application

You can find an example application at [OSGi enRoute Example][2]. This application is a simple web application that provides an implementation for all actors in the Configuration Admin service specification except for Configuration Admin itself. The application has a number of buttons to execute simple scenarios. Run it in debug mode, set breakpoints, and enjoy.

## Discussion

### How do I take an arbitrary object and ask OSGi for its configuration?

In most non-OSGi environments the configuration model assumes that a component asks for configuration when it needs it, a so called pull model. In contrast, OSGi uses a _push model_. The component gets the initial configuration pushed to it. In DS, it gets the configuration in the `activate` method. If the component wants to be notified when changes occur to it's configuration it can use the `modified` method using the `@Modified` annotation. So in general a component never has to request its configuration.

Maintain this precious invariant because it keeps the components as simple as possible while always synchronized with their persistent configuration. Realize that the moment that you start to go to [Configuration Admin] to fetch properties you have the really hard responsibility to also pick up changes to that configuration.

After this caveat, if you really want to get the configuration of an object then you need to know the PID (Persistent IDentity). If you have a PID, you can fetch the configuration from the [Configuration Admin] service.


[1]: /services/org.osgi.service.component.html
[2]: https://github.com/osgi/osgi.enroute.examples/tree/master/osgi.enroute.examples.cm.application
[Configuration Admin]: /services/org.osgi.service.cm
