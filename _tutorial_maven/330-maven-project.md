---
title: Using bnd Workspace Projects from Maven Projects
layout: tutorial
lprev: 320-local
lnext: 340-application
summary: Demonstrate how you can leverage a bnd project with a Maven (m2e) project.
---

In this section we create a Maven project and consume the API from the previous section of this tutorial.

## Build a Maven Project

You should now create a Maven (**not** a Bndtools) project. Let's call this project `osgi.enroute.examples.eval.provider`. Just use the most simplest Maven project you can find (you can select this at the first wizard page). It provides the implementation of the API we defined in the Bndtools `osgi.enroute.examples.eval.api` project.

The groupId should be `osgi.enroute.examples` and the artifactId to the customary Bundle Symbolic Name: `osgi.enroute.examples.eval.provider`. Let's use a snapshot version: 1.0.0-SNAPSHOT. The prolog of the `pom.xml` file should look like:

	<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
		<modelVersion>4.0.0</modelVersion>
		<groupId>osgi.enroute.examples</groupId>
		<artifactId>osgi.enroute.examples.eval.provider</artifactId>
		<version>1.0.0-SNAPSHOT</version>

We are going to implement the Eval API with [parsii](https://github.com/scireum/parsii) external dependency. We also need the OSGi component annotations and of course our API. So our `dependencies` section in the POM should look like:

	<dependencies>
		<dependency>
			<groupId>osgi.enroute.examples</groupId>
			<artifactId>osgi.enroute.examples.eval.api</artifactId>
			<version>1.0.0-SNAPSHOT</version>
		</dependency>
		<dependency>
			<groupId>com.scireum</groupId>
			<artifactId>parsii</artifactId>
			<version>2.3</version>
		</dependency>
		<dependency>
			<groupId>org.osgi</groupId>
			<artifactId>org.osgi.service.component.annotations</artifactId>
			<version>1.3.0</version>
		</dependency>
	</dependencies>

We want to build this project with the bnd Maven plugin, so we need to add the following build section:

	<build>
		<plugins>
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-compiler-plugin</artifactId>
				<configuration>
					<source>1.8</source>
					<target>1.8</target>
				</configuration>
			</plugin>
			<plugin>
				<groupId>biz.aQute.bnd</groupId>
				<artifactId>bnd-maven-plugin</artifactId>
				<version>3.1.0</version>
				<executions>
					<execution>
						<id>default-bnd-process</id>
						<goals>
							<goal>bnd-process</goal>
						</goals>
					</execution>
				</executions>
			</plugin>
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-jar-plugin</artifactId>
				<configuration>
					<useDefaultManifestFile>
						true
					</useDefaultManifestFile>
				</configuration>
			</plugin>
		</plugins>
	</build>

## Instructions for bnd

Last, but not least, we need to provide an adjacent `bnd.bnd` file, we need to export the API package and we want to include the [parsii](https://github.com/scireum/parsii) JAR because it happens to be not a bundle. We do not have to wrap the Guava library because it is a proper bundle. We assume this will be linked in through the application we develop later.

	Export-Package: 	osgi.enroute.examples.eval.api
	Private-Package: 	parsii.*
	-sources: 			true

Note that the Maven plugin by default includes all the classes in the project.

## Source Code

The source code in `src/main/java/` is:

	package osgi.enroute.examples.eval.provider;

	import java.util.List;

	import org.osgi.service.component.annotations.Activate;
	import org.osgi.service.component.annotations.Component;

	import osgi.enroute.examples.eval.api.Eval;
	import parsii.eval.Expression;
	import parsii.eval.Function;
	import parsii.eval.Parser;
	import parsii.eval.Scope;

	@Component
	public class EvalImpl implements Eval {
		Scope scope = new Scope();

		public double eval(String expression) throws Exception {
			Expression expr = Parser.parse(expression);
			return expr.evaluate();
		}
	}

## Installing

If you've done everything well (and we as well) then your project should be buildable from the command line:

	mvn install
	....
	------------------------------------------------------------------------
	[INFO] BUILD SUCCESS
	[INFO] ------------------------------------------------------------------------
	[INFO] Total time: 1.247 s
	[INFO] Finished at: 2016-04-08T19:17:48+02:00
	[INFO] Final Memory: 13M/309M
	[INFO] ------------------------------------------------------------------------
{:.shell}

## Updates

We've now a relatively unmanaged situation. In the current setup, Bndtools will install every JAR it builds immediately in the local Maven repository. However, Maven will not pick this up automatically. You will have to update the classpath manually. However, this is in general what Maven users are used to?

## What We've Done

We now build a standard Maven project that has a dependency on a Bndtools project. The Bndtools project will be updated ('installed') every time when there is a change.

In the next section we take a look at how we can depend on this Maven project.
