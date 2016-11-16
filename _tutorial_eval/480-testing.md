---
title: Integration Testing
layout: tutorial
lprev: 450-web
lnext: 490-modules
summary: Run integration tests
---

## What you will learn in this section

In this section we will create an OSGi integration test. We will use
the bnd-testing-maven-plugin to setup a runtime environment and then
run our JUnit tests inside OSGi.

Make sure you are in the top directory:

	$ cd ~/workspaces/osgi.enroute.examples.eval
{: .shell }


## Create a Test Bundle

We will first create a test bundle. A test bundle is one one or more classes
with JUnit tests. Each bundle will list its test classes in the Test-Cases
manifest header. The bnd runtime support has a tester that will look for bundles
with this header and then automatically runs these test.

In this instance, we want to define a test to verify the Eval service.

## Create the pom

Let's create the pom.

	osgi.enroute.examples.eval $ mkdir test
	osgi.enroute.examples.eval $ cd test
	test $ vi pom.xml
	// get the content
{: .shell }

	<project 
		xmlns="http://maven.apache.org/POM/4.0.0" 
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
		
		<modelVersion>4.0.0</modelVersion>
	
		<parent>
			<groupId>org.osgi</groupId>
			<artifactId>osgi.enroute.examples.eval</artifactId>
			<version>1.0.0-SNAPSHOT</version>
		</parent>
	
		<artifactId>osgi.enroute.examples.eval.test</artifactId>

We need the API bundle and JUnit as dependencies. We use the OSGi enRoute wrapped
version of JUnit because JUnit normally does not contain OSGi metadata and many
wrappers have problems.
	
		<dependencies>
			<dependency>
				<groupId>org.osgi</groupId>
				<artifactId>osgi.enroute.examples.eval.api</artifactId>
				<version>1.0.0-SNAPSHOT</version>
			</dependency>
			<dependency>
				<groupId>org.osgi</groupId>
				<artifactId>osgi.enroute.junit.wrapper</artifactId>
				<version>4.12.0</version>
			</dependency>
		</dependencies>
	
	</project>

## The Source Code

It is a tad confusing but the source code for an integration test bundle *must* be
in the `src/main/java` directory, *not* in the `test` directory. This makes sense
if you realize that we're making a bundle and the sole purpose of a test branch
in the src directory is to make sure that code does not end up in a bundle.

	test $ mkdir -p src/main/java/osgi/enroute/examples/eval/test
	test $ vi src/main/java/osgi/enroute/examples/eval/test/EvalTest.java
	// get the content from the next section
{: .shell }

	package osgi.enroute.examples.eval.test;

	import org.osgi.framework.BundleContext;
	import org.osgi.framework.FrameworkUtil;
	import org.osgi.framework.ServiceReference;
	
	import junit.framework.TestCase;
	import osgi.enroute.examples.eval.api.Eval;
	
	public class EvalTest  extends TestCase {
		BundleContext context = FrameworkUtil.getBundle(EvalTest.class).getBundleContext();
		
		public void testEval() throws Exception {
			ServiceReference<Eval> ref = context.getServiceReference(Eval.class);
			assertNotNull("No such service", ref);
			Eval eval = context.getService(ref);
			assertNotNull("Service object init error", eval);
			assertEquals( 7.0D, eval.eval("1+6"));
		}
	}

Remember that the bnd runtime support for testing expects the Test-Cases manifest
header to be set. We therefore need a bnd.bnd file.

	test $ vi bnd.bnd
	// get the content from the next section
{: .shell }

	Bundle-Description: 				\
		Integration Test bundle for the Eval service

	Test-Cases: ${classes;NAMED;*Test}

The magic in this case is the macro `classes`. It will list all classes that
end with `Test`.

## Install

That's all, we created a test bundle. So we need to install it.

	test $ mvn install
	...
{: .shell }

You should also add this project to our parent pom.

## The Integration Test Project

Integration testing requires a runtime environment. We have been using the 
bndrun file to create a runtime environment for our application. We can use a
similar bndrun file, or more than one, to perform our integration tests.

Multiple environments can be useful if you want to test on different platforms.

## Create the Integration Project and Pom

	test $ cd ..
	osgi.enroute.examples.eval $ mkdir integration-test
	osgi.enroute.examples.eval $ cd integration-test
	integration-test $ vi pom.xml
	// get content from next section
{: .shell }

The content of our pom is:

	<project 
		xmlns="http://maven.apache.org/POM/4.0.0" 
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
		<modelVersion>4.0.0</modelVersion>
	
		<parent>
			<groupId>org.osgi</groupId>
			<artifactId>osgi.enroute.examples.eval</artifactId>
			<version>1.0.0-SNAPSHOT</version>
			<relativePath>..</relativePath>
		</parent>
	
		<artifactId>osgi.enroute.examples.eval.integration-test</artifactId>
	
		<packaging>pom</packaging>
	
		<build>
			<plugins>

This plugin will iterate over a set of bndrun files and execute any tests in them.

				<plugin>
					<groupId>biz.aQute.bnd</groupId>
					<artifactId>bnd-testing-maven-plugin</artifactId>
					<version>3.4.0-SNAPSHOT</version>
					<configuration>
						<resolve>true</resolve>
						<bndruns>

The relative file path of the bndrun file. We will create a runtime that has
the parsii provider for testing.

							<bndrun>parsii.bndrun</bndrun>
							
						</bndruns>
						<targetDir>.</targetDir>
					</configuration>
					<executions>
						<execution>
							<goals>
								<goal>testing</goal>
							</goals>
						</execution>
					</executions>
				</plugin>
			</plugins>
		</build>
	
To be able to resolve our own projects we need to list the dependencies we are
allowed to resolve against.

		<dependencies>
			<dependency>
				<groupId>org.osgi</groupId>
				<artifactId>osgi.enroute.examples.eval.parsii.provider</artifactId>
				<version>1.0.0-SNAPSHOT</version>
			</dependency>
			<dependency>
				<groupId>org.osgi</groupId>
				<artifactId>osgi.enroute.examples.eval.test</artifactId>
				<version>1.0.0-SNAPSHOT</version>
			</dependency>
			<dependency>
				<groupId>org.osgi</groupId>
				<artifactId>osgi.enroute.pom.distro</artifactId>
				<version>2.0.0</version>
			</dependency>
			
		</dependencies>
	</project>
	
## The parsii.bndrun File

In the `bndruns` section of the bnd-testing-maven-plugin we listed the `parsii.bndrun` file.
We therefore need to create it:

	integration-test $ vi parsii.bndrun
	// get the content of the next section
{: .shell }

The content is quite similar to the bndrun file we created in the bndrun project.

	-standalone: 
	
	-plugin.examples.eval = \
		aQute.bnd.repository.maven.pom.provider.BndPomRepository; \
			snapshotUrls=https://oss.sonatype.org/content/repositories/osgi/; \
			releaseUrls=https://repo1.maven.org/maven2/; \
			pom=${.}/pom.xml; \
			name=examples.eval; \
			location=${.}/target/cached.xml
	

We want to test the parsii provider.
	
	-runrequires: \
		osgi.identity;filter:='(osgi.identity=osgi.enroute.examples.eval.parsii.provider)',\
		osgi.identity;filter:='(osgi.identity=osgi.enroute.examples.eval.test)'
	
	-runfw: 		org.eclipse.osgi;version='[3.10.100.v20150529-1857,3.10.100.v20150529-1857]'
	-runtrace: 		true
	
	
	-runee: 						JavaSE-1.8
	-resolve.effective:				resolve, active
		
	-runsystempackages.eqnx:		javax.script
	-runsystemcapabilities.dflt: 	${native_capability}
	

Just like the bndrun file before, we need to resolve the file to find the bundles.

	integration-test $ mvn install
	...
{: .shell }
	
	-runbundles: \
		org.apache.felix.configadmin; version='[1.8.8,1.8.9)',\
		org.apache.felix.scr; version='[2.0.2,2.0.3)',\
		org.eclipse.equinox.metatype; version='[1.4.100,1.4.101)',\
		org.osgi.service.metatype; version='[1.3.0,1.3.1)',\
		osgi.enroute.examples.eval.parsii.provider; version='[1.0.0,1.0.1)',\
		osgi.enroute.examples.eval.test; version='[1.0.0,1.0.1)',\
		osgi.enroute.hamcrest.wrapper; version='[1.3.0,1.3.1)',\
		osgi.enroute.junit.wrapper; version='[4.12.0,4.12.1)'

	integration-test $ vi parsii.bndrun
	// update the -runbundles	
	integration-test $ mvn install
	...
	Test parsii.bndrun
	Tests run  : 1
	Passed     : 1
	Errors     : 0
	Failures   : 0
	...
	[INFO] ------------------------------------------------------------------------
	[INFO] BUILD SUCCESS
	[INFO] ------------------------------------------------------------------------
	...
{: .shell }

## What Did We Learn?

In this section we created an OSGi integration test. This required a test bundle
that had the Test-Cases manifest header set. It also required an integration-test
project that ran the test. This project can run multiple integration tests by
defining multiple bndrun files and listing them in the configuration section
of the bnd-testing-maven-plugin.


