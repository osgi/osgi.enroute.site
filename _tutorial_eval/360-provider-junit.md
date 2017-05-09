---
title: Testing our Provider
layout: tutorial
lprev: 350-provider
lnext: 380-run
summary: Create and run JUnit tests for our provider bundle
---

## What you will learn in this section

In this section we will create a whitebox JUnit test for our simple.provider implementation. 
JUnit tests are very cheap; using them extensively saves tremendous amount of times 
in later phases of the development process. JUnit tests are always run before code 
is released and when they fail, they prohibit the release of the project.

These JUnit tests run outside the OSGi Framework.

Testing is one of those chores a developer has to do, not as much fun as some deep 
algorithmic code. However, it is likely one of the most effective ways to spend your time.

Make sure you are in the top directory:

	$ cd ~/workspaces/osgi.enroute.examples.eval
{: .shell }

## JUnit

A provider should always have *unit* tests. Unit tests are *white* box tests. 
The test knows about the implementation details and it can even see aspects of 
the components that are not part of the public API. 

Since the JUnit tests run outside OSGi it pays off to design the implementation
in such a way that you have OSGi specific parts that then parameterize calls to
plain old java objects (POJO). These POJOs can then be tested independently

In Maven, we have to write our test cases in `src/test/java`. 

	osgi.enroute.examples.eval $ cd simple.provider
	simple.provider $ mkdir -p src/test/java/osgi/enroute/examples/eval/simple/provider
	simple.provider $ vi src/test/java/osgi/enroute/examples/eval/simple/provider/EvalImplTest.java
	// copy the following source
{: .shell }

	package osgi.enroute.examples.eval.simple.provider;

	import junit.framework.TestCase;
	import osgi.enroute.examples.eval.provider.EvalImpl;
	
	public class EvalImplTest extends TestCase {
		public void testSimple() throws Exception {
			EvalImpl t = new EvalImpl();
			assertEquals(3.0, t.eval("1 + 2"));
		}
	}

We can run this test from maven:

	simple.provider $ mvn test
	...
	-------------------------------------------------------
	 T E S T S
	-------------------------------------------------------
	Running com.acme.prime.eval.provider.EvalImplTest
	Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.014 sec
	
	Results :
	
	Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
	...
{: .shell }

	

## What Did We Learn?

In this section we learned how to write a plain JUnit test that tests the 
implementation but does not require an OSGi runtime.

