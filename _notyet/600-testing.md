---
title: Project
layout: tutorial
next: 700-release.html
prev: 500-dependencies.html
summary: How to test OSGi bundles
---

## What You Will Learn in This Section

In this section we will create an OSGi _test project_, a test project will contain a bundle that is dedicated to testing. It defines a framework setup with the run bundles. A special setup is used to then run test cases in the test bundle. This testing is completely compatible with the JUnit GUI in the IDE.

## Creating a Test Project

Create a new test project with `File/New/New Bndtools OSGi Project`. The project name *must* have the `.test` extension, so let's call it `com.acme.prime.hello.test`. Make sure you use the OSGi enRoute template, and the rest are defaults.

The source code for the test is in the `src` folder, not in the `test` folder because we are making a bundle with the test cases and the `test` folder is for JUnit only; any code in that folder is never put in the bundle.

The code looks as follows:

	package com.acme.prime.hello.test;
	
	import org.junit.Assert;
	import org.junit.Test;
	import org.osgi.framework.BundleContext;
	import org.osgi.framework.FrameworkUtil;
	
	public class HelloTest {
	
	    private final BundleContext context = FrameworkUtil.getBundle(this.getClass()).getBundleContext();
	    
	    @Test
	    public void testHello() throws Exception {
	    	Assert.assertNotNull(context);
	    }
	}

This is a rather trivial test, but it makes sure it is actually running inside an OSGi framework, ensure by the real Bundle Context.

## Running the Test

The test as is will run, just select the `bnd.bnd` file and do `@/Debug As/Bndtools OSGi Test Launcher (JUnit)`. You can also select a project, the `src` folder, a package, a class, or a method and then do `@/Debug As/Bndtools OSGi Test Launcher (JUnit)`. This will run all the tests found under that level; this is identical to how JUnit works normally.

## More Realism

This test was of course completely stand alone, we did not depend on any other bundles. Let's add a bundle and then test it's registered service. An common bundle is Event Admin and we could check if we can send and receive an event.

So let's first change the test code. We will first register an Event Handler which will receive the events. The handler will set a boolean if it was called with the right topic. Then we get the Event Admin service and send an event, sending is synchronous, so after the call the boolean should be set. A tad trivial, but hey, this is a quick start. A bit annoying is how to get the service object, we hide that in a method that does very bad things and will not work reliable in runtime. We get away with it here because the test environment guarantees that the other bundles are resolved and started before the test runs.

So this is the code:

	public class HelloTest {
	
		private final BundleContext context = FrameworkUtil.getBundle(
				this.getClass()).getBundleContext();
	
		@Test
		public void testHello() throws Exception {
			AtomicBoolean called = new AtomicBoolean();
			Hashtable<String, Object> map = new Hashtable<>();
			map.put(EventConstants.EVENT_TOPIC, "*");
			context.registerService(EventHandler.class,
					(Event event) -> called.set(event.getTopic().equals("topic")),
					map);
	
			EventAdmin ea = getService(EventAdmin.class);
			assertNotNull("No Event Admin registered", ea);
			ea.sendEvent(new Event("topic", Collections.emptyMap()));
	
			assertTrue("Event handler not called ", called.get());
		}
	
		private EventAdmin getService(Class<EventAdmin> clazz) {
			ServiceReference<EventAdmin> ref = context.getServiceReference(clazz);
			if (ref == null)
				return null;
	
			return context.getService(ref);
		}
	}

## Adding Event Admin

If we now try to run the test with `@/Debug As/Bndtools OSGi Test Launcher (JUnit)` we find that the bundle no longer resolves, quite cleverly detected by the launcher, although reported sometimes in a rather loud way (the yellow window). Obviously we need to add an Event Admin bundle! 

So select the `Run` tab of the `bnd.bnd` file and drag the Apache Felix Event Admin bundle to the right on the `Run Requirements` list. Resolve, save, select the `HelloTest` class or the `testHello` method, and then `@/Debug As/Bndtools OSGi Test Launcher (JUnit)`.

Observant people would have noticed that we did not add our own bundle to the requirements nor to the run bundles while it is still deployed. This is a bnd default that is actually under active discussion.
{: class=bug }

## Advanced

Under the hood there is quite a lot of things happening to make this all work so smoothly. The JUnit OSGi testing is based on the launcher. When you test code, it uses the run bundles to launch a framework but will add a special bundle that understands JUnit. It also adds some parameters to the launcher properties file. When the framework starts it will also start the JUnit runner. The JUnit runner looks at the properties. It can either be started from a src folder, package class or method, or it is started from a bnd file. In the former case it will have a list of the selected test methods. In the latter case it actually looks in the test bundle for a magic property: `Test-Cases`. This property lists the classes that contain test methods. 

It will then run the tests one by one. If this was started from Eclipse, it reports it through a socket to Eclipse. It also reports the result in standard XML files in the `generated/test-reports/` directory. 

## Next

In the next section we take a look at releasing a bundle.

 