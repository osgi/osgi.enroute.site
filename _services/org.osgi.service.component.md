---
title: org.osgi.service.component
layout: service
version: 1.3
summary: An extender for Declarative Services components 
---

![Declarative Services Collaboration Diagram](/img/services/org.osgi.service.component.overview.png)

## When to Use?

Always! DS is the backbone of OSGi. Whenever you write code in OSGi you write them as DS components. 

## Example Usage

	@Component
	public class MyComponent implements SomeService {
		LogService log;
		
		@Activate
		void activate(ComponentContext cc, BundleContext bc, Map<String,Object> config) {}

		@Deactivate
		void deactivate(ComponentContext cc, BundleContext bc, Map<String,Object> config) {}
		
		@Modified
		void modified(Map<String,Object> config) {}

		@Reference
		void setLogService(LogService log) {
			this.log = log;
		}
	}
	
## Background

Not sure what we were smoking when designing the original OSGi specification, or maybe it was just youthful exuberance, but OSGi did not really become useful for the rest of us until we had Declarative Services (DS) with their annotations. Though some old hardliners still seem to resist DS (see [Real Men Don't Use DS][1]), it is obvious that if you use OSGi and not use DS you're either extremely deep down in middleware or you're masochistic. 

DS (or also called the Service Component Runtime SCR) is an extender that creates components from, shudder, an XML resource in your bundle. In the bad old days you had to write this XML but fortunately there are now some annotations that allow bnd to write the required XML on the fly. This XML file defines your dependencies, properties, and registered services. When the time comes, DS will instantiate the class, inject the dependencies, activate it, and register the services. In short, DS takes the pain out of OSGi, leaving you with all the pleasures.

There are many similarities with injection frameworks that we shall not name here. However, this is like comparing a flat space with a 3D space since DS handles _dynamic_ dependencies. Though for many a developer the dynamics in OSGi are off-putting, the advent of distributed systems makes it more and more clear that the world is dynamic and trying to hide these dynamics from the developer is a really bad idea. Over and over, nature proves to us that trying to give the impression of a perfect world only makes us fall deeper and harder when the perfection inevitably cracks. The beauty of DS is that it allows us to live in a dynamic world with very little effort. If you're a skeptic, realize that those [lustrous points][2] had no clue what that Square was talking about. So bear with us, and one day you might become a beautiful Sphere!

## The Simplest Component

Adding a `@Component` annotation to a public class will turn it into a component. Since the effects are rather pointless on an empty class, let's add a constructor so we can at least see something happening. Make sure to use the right `Component` annotation since some annotation names are clearly more popular than others. 

	package osgi.enroute.examples.component.examples;
	
	import org.osgi.service.component.annotations.Component;
	
	@Component
	public class InfinitelySmallPoint {
		public InfinitelySmallPoint() {
			System.out.println("I am a lustrous point");
		}
	}

Obviously, this component will not win the Turing prize since it does not do anything and is more or less a waste of bits, sacrificed in the goal to elucidate you. But hey, doesn't it do a great job? 

## Registering a Service

The fun parts of OSGi are the services. So how can we register a service? Let's implement an Event Handler service. Such a handler receives events from the [Event Admin service][3]. There are always events emitted by the OSGi framework so that allows us to see something. Registering a service is as simple as implementing its interface. Without an interface a component is an _immediate_ component. Immediate components are immediately started. With one or more implemented interfaces, we automatically register a service.

	@Component
	public class EventHandlerImpl implements EventHandler {
	
		@Override
		public void handleEvent(Event event) {
			System.out.println("Event: " + event.getTopic());
		}
		
	}
	
## Creating Events

Though it is not rocket science to create events (just start/stop some components and/or bundles, in OSGi the Framework is mandated to create these events) it would be nice for our fundamental research in OSGi components to have a steady stream. To create such a stream, we need to create Event Admin events every second. This requires us to get access to the Event Admin service (the honest broker between the event senders and receivers) and it would be nice to have a scheduler. Fortunately, they are part of OSGi enRoute. So let's create an Event source:

	@Component(property=CronJob.CRON+"=* * * * * ?")
	public class EventSource {
		EventAdmin	eventAdmin;
		
		public void run(Object object) {
			Event event = new Event( "osgi/enroute/examples/ping", new HashMap<String,Object>() );
			eventAdmin.postEvent(event);
		}
		
		@Reference
		void setEventAdmin( EventAdmin eventAdmin) {
			this.eventAdmin = eventAdmin;
		}
	}

Since this is an immediate component it will run as long as an Event Admin service is registered. 

When we run this component, we should see the `EventHandlerImpl` component fire out messages.

## Initialization

Initializing in a constructor is awkward and ill advised since the object is only partially ready during construction. Initialization should therefore be done separately from object construction. We can annotate a method with the `@Activate` annotation; this method will be called after the dependencies are set and before a service is registered. 

	@Component
	public class SmallPoint {
		@Activate
		void activate() {
			System.out.println("Hello Lustrous Point!");
		}
	}

## Dependencies

We've already seen some examples of the dependencies. These dependencies were the simplest ones: _static_ and _single_. These defaults are also the most common and match the `@Inject` annotation from dependency injection that are dynamically challenged. When the dependencies are satisfied, your component gets instantiated and when they are no longer matched, your component gets mercilessly killed. Since the component is not alive before and after it never sees the effects that the dynamicity has on it. Always start in this mode since it makes your life significantly easier and is rarely worth to effort to optimize.

However, there are some interesting cases that we can simplify by making things more dynamic. For example the Whiteboard pattern. With this pattern we need to track a number of services. These services can come and go. It would be rather tiring if every arrival of a new member would result in our death and resurrection. This common case is handled by setting to the `cardinality` to `MULTIPLE` and the `policy` to `DYNAMIC`. If DS then finds new members we get informed. This requires us to specify 2 methods: one method for adding members, the other method for removing the members. The _bind_ method is specified with the @Reference annotation. The _unbind_ method is found through the convention of removing the 'add' prefix of the bind method and replacing it with the 'remove' prefix. That is, `addMember` as the bind method requires `removeMember` as the unbind method.

	@Component
	public class WhiteboardExample {
		Map<Member> members = new ConcurrentHashMap<>();
		
		@Reference
		void addMember( Member member ) {
			members.add(member);
		}
		
		void removeMember( Member member ) {
			members.remove(member);
		}
	}
	
Though it is generally not worth the effort, some people can't stop optimizing (and ok, there are a few legitimate cases), and they want also to treat their unary references as being dynamic. This sounds simple but there is a gotcha. The gotcha is the order. DS can first register a new service and then unregister the old service. If you write your code carelessly then it is easy to set your fresh new service to null in your unbind method. If you think about it, it is quite friendly of DS to give you a new service before removing the old, so you're never without one. However, it means you must use an AtomicReference to use those services reliably. We use the `compareAndSet` method; this will only set the reference to `null` if the service to be removed is actually the one we're still using.

This is how it looks:

	@Component
	public class DynamicLogExample {
		final AtomicReference<LogService> log = new AtomicReference<>();

		@Reference(
			cardinality=Cardinality.MULTIPLE, 
			policy=Policy.DYNAMIC
		)
		void setLog( LogService log ) {
			log.set(log);
		}
		
		void unsetLog( LogService log ) {
			log.compareAndSet(log, null);
		}
	}

## Selective References

The dependencies we've used so far were quite promiscuous: they accepted any service with the given service interface. In certain cases you want to be a bit more selective. Maybe you only want the services with a given property. The `target` option in the `@Reference` annotation holds a filter that makes that reference more selective. You only get services injected that are matching that filter. For example, we only want to see the services that have the `foo` property set. 

	@Component
	public class DynamicLogExample {
		Selective selective;
		
		@Reference( target="(foo=*)" )
		void setSelective( Selective selective) {
			this.selective = selective;
		}
	}

## Configuration

Declarative Services is highly integrated with OSGi Configuration Admin. It is therefore possible to get the configuration properties as a map in the `activate` method.

	@Component
	public class SmallPoint {
		@Activate
		void activate(Map<String,Object> map) {
			System.out.println("Configuration " + map);
		}
	}

Since properties are awkward to use, we can use the DTOs service to convert the map to a specific configuration interface, an interface where the methods act as property names:

	@Component
	public class SmallPoint {
	
		interface Config {
			int port();
			String host();
		}
		
		@Activate
		void activate(Map<String,Object> map) {
			Config config = dtos.convert(map).to( Config.class );
			System.out.println("Configuration " + config.host()+":"+config.port());
		}
	}

Configurations can be updated dynamically. Without any extra effort, this will mean your component gets shot down and then recreated with the latest configuration data. Since this is a bit rough, you can also tell DS that you prefer the more subtle approach and would like to get a courteous callback when the change happens. You can tell DS about your preferences by adding the `@Modified` annotation to a method that takes a map. So we can make our code a bit more efficient in the light of change:
 
	@Component
	public class SlightlyBiggerPoint {
	
		interface Config {
			int port();
			String host();
		}
		
		@Activate
		void activate(Map<String,Object> map) {
			modified(map);
		}
		
		@Modified
		void modified(Map<String,Object> map) {
			Config config = dtos.convert(map).to( Config.class );
			System.out.println("Configuration " + config.host()+":"+config.port());
		}
	}

## Configuring References

We've discussed earlier that the `@Reference` annotation can set a target filter on the selected services. However, the annotation is set during development time. It could be quite useful if we could override this filter in a running system. Surprise!

Each reference has a name, this is the name of the method with the prefix `add` or `set` removed. If we configure a component we can set a magic property called `target.<name>` with the filter. DS will use this configuration property as if it was set on the annotation.

## Factories

So far we've not discussed the lifecycle of the component. We've assumed it just gets created when its dependencies are satisfied. However, the integration with Configuration Admin allows us to control the life via this component with Configration Admin's factory configurations. Each factory instance will correspond to a component instance. These factory components are still only created when their dependencies are met.

This is probably one of the coolest features of the components. It allows us to create and delete components on demand. Let's see how we can use this.

First we should disable the creation of a component when there is no configuration whatsoever so that we do not create spurious components. 

	@Component(
		name="borg",
		configuratinoPolicy=ConfigurationPolicy.REQUIRED
	)
	public class FactoryInstance {
		@Activate
		void activate(Map<String,Object> map) {
			System.out.println("Born to be alive: " + map.get("borg");
		}
	}

We can now create a configuration that creates three components.

	@Component
	public class Creator {
		ConfigurationAdmin cm;
		
		@Activate
		void activate() {
			create(1);
			create(2);
			create(3);
		}
		
		void create(int n) {
			Configuration c = cm.createConfiguration("borg", "?");
			Hashtable<String,Object> ht = new Hashtable<>();
			ht.put("borg", n);
			c.update(ht);
		}
		
		@Reference
		void setConfigurationAdmin(ConfigurationAdmin cm) {
			this.cm = cm;
		}
	}	


%%% In the above sentence, you write "It allows us to create and delete components on demand." You show in the example how to create the components, but how can we delete them?

## OSGi API

In general you want to make your components oblivious of any OSGi API. This makes them easier to unit test and in the spirit of modularity less coupling is more. However, if you write middleware for OSGi systems then it is very attractive to access the Bundle Context or Component Context. The `activate` method is designed to provide you with all those objects, in any order:

	@Component
	public class SmallPoint {
		@Activate
		void activate(BundleContext bc, ComponentContext cc, Map<String,Object> map) {
			System.out.println("What is my context?");
		}
	}
 
## Bundle Aware

By default, the components are shared between all bundles. However, sometimes you want to tie the life cycle of a component to the bundle that uses it. This can be set with the `serviceFactory` option. DS will create a unique instance for each bundle that gets that service and that instance will be deactivated when the bundle ungets the service, for example because it is stopped. This may seem a bit esoteric but it allows you to simplify housekeeping you need to do per bundle. It is quite common that you have a service that requires some cleanup, tracking bundles in this service can be cumbersome. A simple solution is then to split the problem in two (where have we heard that before?):

* A `serviceFactory` service that is instantiated for each bundle that uses the service and is responsible for cleaning up after that bundle
* A normal singleton service that is oblivious of bundles.

Lets make an example of a service that allows the creation of Widgets. However, these widgets are tricky, they need to be closed whenever the creating bundle stops using them. Let's first design the Widget interface, they turn out to be really good in doing the `foo` thing.

	public interface Widget {
		void foo();
		void close();
	}

The service we now design must be able to create these suckers:
		
	public interface WidgetFactory {
		Widget create();
	}

We're now ready to create a component that acts as the Bundle facade. This facade depends on the actual Widget Factory Implementation and delegates towards it. However, it closely tracks the widgets created through its bundle.

	@Component(serviceFactory=true)
	public class WidgetFactoryFacade implements WidgetFactory {
		WidgetFactory singleton;
		final Set<Widget>		widgets= new IdentityMap<>().keySet();
		  
		  
		@Dectivate
		void deactivate() {
			synchronized(widgets) {
				widgets.forEach( (w) -> w.close() );
			}
		}
		
		public Widget create() {
			Widget w = singleton.create();
			return new Widget() {
				public void foo() { w.foo(); } 
				public void close() { 
					synchronized(widgets) {
						if ( !widgets.remove(w) )
							return;
					}
					w.close(); 
				} 
			}
		}
		
		@Reference
		void setSingleton( WidgetFactoryImplementation wfi) {
			this.singleton=wfi;
		}
	}

And then all that is left is the singleton implementation. This service should not register the WidgetFactory since it is only the facade that will use it. We therefore force the implementation class to be the actual service. Since this is likely a private class, nobody else can get to it.

	@Component( service=WidgetFactoryImplementation.class )
	public class WidgetFactoryImplementation {
	
		public Widget create() {
			return new Widget() {
				void foo() { System.out.println("I am doing what I'm good at"); }
				void close() { System.out.println("You don't need me anymore?"); }
			}
		}
	}	  

## Gogo Command

Finally, a small example to show you can create a Gogo shell command with DS. Lets make a simple command that allows you to print a word.

	@Component(
		property={
			Debug.COMMAND_SCOPE+"=example", 
			Debug.COMMAND_FUNCTION+"=hello"
		},
		service = HelloCommand.class
	)
	public class HelloCommand {
	
		public String hello(String s) {
			return "Hello " + s;
		}
	}

If you run a Gogo shell in your framework then adding this component will make the hello command available:

	g! hello enRoute
	Hello enRoute
	g!
{: .shell }
	
## Example Application

You can find an example application at [OSGi enRoute Example][2]. 

	
[1]: http://blog.osgi.org/2013/07/real-men-dont-use-ds.html
[2]: https://github.com/Ivesvdf/flatland/blob/master/oneside_a4.pdf?raw=true
[3]: http://enroute.osgi.org/services/org.osgi.service.event.html
