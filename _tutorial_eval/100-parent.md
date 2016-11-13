---
title: Parent Pom
layout: tutorial
summary: Create a Maven parent pom project
lprev: 050-start
lnext: 300-api
---

## What you will learn in this section

Maven supports the concept of a _parent_ pom. This pom collects the information
that is shared between a number of projects.

Make sure you are in the top directory:

	$ cd ~/workspaces/osgi.enroute.examples.eval
{: .shell }

## Directory Layout

The directory layout for our complete project will be:

	./
		osgi.enroute.examples.eval/
			api/
			application/
			bndrun/
			command/
			integration-test/
			parsii.provider/
			simple.provider/
			test/

We will create this layout along the way step by step.
			
## Creating the Parent Pom

In the default directory (`~/osgi.enroute.examples.eval/`) we create a `pom.xml`
file. It has the following content.

	osgi.enroute.examples.eval $ vi pom.xml
	// fill the content from the next sections
{: .shell } 
	

First the mandatory prolog:

	<project xmlns="http://maven.apache.org/POM/4.0.0" 
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
		xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">

		<modelVersion>4.0.0</modelVersion>
		
In this section we define the default group name for any modules falling under this
module project. The `groupId` for the projects will be `org.osgi` and the `artifactId`, which
will also be the Bundle Symbolic Name for OSGi, will follow the pattern 
`osgi.enroute.examples.eval.*`.


		<groupId>org.osgi</groupId>
		<artifactId>osgi.enroute.examples.eval</artifactId>
		<version>1.0.0-SNAPSHOT</version>
		
Module POMs have no output and should have packaging set to POM.

		<packaging>pom</packaging>

Pretty standard Maven setup for our defaults.
	
		<properties>
			<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
		</properties>
	  
		<build>
			<plugins>
			
Compiler setup:

				<plugin>
					<groupId>org.apache.maven.plugins</groupId>
					<artifactId>maven-compiler-plugin</artifactId>
					<version>3.1</version>
					<configuration>
						<source>1.8</source>
						<target>1.8</target>
					</configuration>
				</plugin>

Standard plugin to jar-up the artifact:
				
				<plugin>
					<groupId>org.apache.maven.plugins</groupId>
					<artifactId>maven-jar-plugin</artifactId>
					<version>3.0.1</version>
					<configuration>
			          <archive>
			            <manifestFile>${project.build.outputDirectory}/META-INF/MANIFEST.MF</manifestFile>
			          </archive>
					</configuration>
				</plugin>
		
The bnd plugin that will calculate our manifest and other files in the bundle. This 
plugin will automatically run in m2e to do a lot of magic for you.

				<plugin>
					<groupId>biz.aQute.bnd</groupId>
					<artifactId>bnd-maven-plugin</artifactId>
					<version>3.3.0</version>
					<executions>
						<execution>
							<goals>
								<goal>bnd-process</goal>
							</goals>
						</execution>
					</executions>
				</plugin>
				
			</plugins>
		</build>

The important part, the dependencies:
		
		<dependencies>

This is a compile dependency providing us with the standardized set of functions
in OSGi enRoute. This dependency contains no runtime dependencies; it is specification
only. 

			<dependency>
				<groupId>org.osgi</groupId>
				<artifactId>osgi.enroute.base.api</artifactId>
				<version>2.0.0</version>
			</dependency>

We are adding JUnit because we will use this to test our code:
			
			<dependency>
				<groupId>junit</groupId>
				<artifactId>junit</artifactId>
				<version>4.12</version>
			</dependency>
			
		</dependencies>

The following repositories are defined if you want to use the OSGi enRoute and bnd
snapshot bundles and/or plugins.
		
		<repositories>
			<repository>
				<id>osgi-snapshots</id>
				<url>https://oss.sonatype.org/content/groups/osgi/</url>
				<layout>default</layout>
			</repository>
			<repository>
				<id>bnd-snapshots</id>
				<url>https://bndtools.ci.cloudbees.com/job/bnd.master/lastSuccessfulBuild/artifact/dist/bundles/</url>
				<layout>default</layout>
			</repository>
		</repositories>
		
		<pluginRepositories>
        	<pluginRepository>
	            <id>bnd-snapshots</id>
	            <url>https://bndtools.ci.cloudbees.com/job/bnd.master/lastSuccessfulBuild/artifact/dist/bundles/</url>
	            <layout>default</layout>
	            <snapshots>
	                <enabled>true</enabled>
	            </snapshots>
	        </pluginRepository>
    	</pluginRepositories>		

	</project>

## Verify

After you created the pom.xml file you should verify that it all is ok.

	osgi.enroute.examples.eval $ mvn verify
	[INFO] Scanning for projects...
	[INFO]                                                                         
	[INFO] ------------------------------------------------------------------------
	[INFO] Building osgi.enroute.examples.eval 1.0.0-SNAPSHOT
	[INFO] ------------------------------------------------------------------------
	[INFO] 
	[INFO] --- bnd-maven-plugin:3.3.0:bnd-process (default) @ osgi.enroute.examples.eval ---
	[INFO] skip project with packaging=pom
	[INFO] 
	[INFO] --- maven-install-plugin:2.4:install (default-install) @ osgi.enroute.examples.eval ---
	[INFO] Installing /Ws/enroute/osgi.enroute.examples.eval/pom.xml to /Users/aqute/.m2/repository/org/osgi/osgi.enroute.examples.eval/1.0.0-SNAPSHOT/osgi.enroute.examples.eval-1.0.0-SNAPSHOT.pom
	[INFO] ------------------------------------------------------------------------
	[INFO] BUILD SUCCESS
	[INFO] ------------------------------------------------------------------------
	[INFO] Total time: 0.327 s
	[INFO] Finished at: 2016-10-04T16:39:25+02:00
	[INFO] Final Memory: 9M/309M
	[INFO] ------------------------------------------------------------------------
{: .shell }

Since the output of mvn is quite, lets say, verbose, we will only show relevant parts in the
following sections. Any skipped parts will be indicated with `...`.

