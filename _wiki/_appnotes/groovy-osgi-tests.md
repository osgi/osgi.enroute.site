---
title: Groovy, Tycho, and OSGi Testing
summary: Groovy and testing on Tycho 
---

This page describes how to add Groovy language support for writing OSGi
tests. It is assumed that you already have a running [Maven/Tycho
toolchain](MavenTychoEclipsePDEToolchain "wikilink").

Purpose
-------

Groovy is a great JVM language, especially for writing tests. The
[Groovy OSGi Testing](https://github.com/groovyosgi/testing/) github
project describes how to implement Groovy OSGi tests in a more
expressive and more efficient way. Build automation is only a small part
of the whole approach. At the github project and within the [EclicpseCon
session slides](http://groovyosgi.github.io/testing) of the talk
"Testing OSGi the 'groovy' way" you find more information how to
implement Unit and OSGi-In-Container tests with Groovy.

To include Groovy support in a Maven/Tycho toolchain you must enhance
your Maven test project:

-   Configure maven-compiler-plugin to use Groovy Eclipse compiler
-   Add Groovy p2 repository
-   Instruct surefire to include Groovy class files

Compile Groovy with Maven
-------------------------

To compile Groovy with Maven you need to configure the
'maven-compiler-plugin' to use the [Groovy Eclipse
Compiler](http://groovy.codehaus.org/Groovy-Eclipse+compiler+plugin+for+Maven)
in your Maven POM of your test project:

``  
`<build>`  
`    <plugins>`  
`        <plugin>`  
`            <artifactId>maven-compiler-plugin</artifactId>`  
`            <version>3.1</version>`  
`            <configuration>`  
`                <compilerId>groovy-eclipse-compiler</compilerId>`  
`            </configuration>`  
`            <dependencies>`  
`                <dependency>`  
`                    <groupId>org.codehaus.groovy</groupId>`  
`                    <artifactId>groovy-eclipse-compiler</artifactId>`  
`                    <version>2.8.0-01</version>`  
`                </dependency>`  
`                <dependency>`  
`                    <groupId>org.codehaus.groovy</groupId>`  
`                    <artifactId>groovy-eclipse-batch</artifactId>`  
`                    <version>2.1.8-01</version>`  
`                </dependency>`  
`            </dependencies>`  
`        </plugin>`  
`    </plugins>`  
`</build>`

Add Groovy p2 repository
------------------------

You need to add the [Groovy
Eclipse](http://groovy.codehaus.org/Eclipse+Plugin) p2 repository inside
the repositories section. The repository contains Groovy as OSGi bundke.

`<repositories>`  
`    <repository>`  
`        <id>groovy-eclipse</id>`  
`        <layout>p2</layout>`  
`        <url>http://dist.springsource.org/release/GRECLIPSE/e4.3/</url>`  
`    </repository>`  
`</repositories>`

Now you can use all classes of Groovy inside your test classes.

Tycho Surefire Groovy configuration
-----------------------------------

Tycho surefire plugin needs to include Groovy test files, too:

`<build>`  
`    <plugins>`  
`        <plugin>`  
`            <groupId>org.eclipse.tycho</groupId>`  
`            <artifactId>tycho-surefire-plugin</artifactId>`  
`            <version>0.18.1</version>`  
`            <configuration>`  
`            <includes>`  
`                <include>**/*</include>`  
`            </includes>`  
`        </plugin>`  
`    </plugins>`  
`</build>`

Groovy Sample Test
------------------

Subsequent a sample JUnit test is shown which is written in Groovy and
uses the [hamcrest](https://code.google.com/p/hamcrest/) matcher
library.

MANIFEST.MF includes imports for "org.codehaus.groovy.\*" and
"org.junit.\*" packages:

`Manifest-Version: 1.0`  
`Bundle-ManifestVersion: 2`  
`Bundle-Name: Pizza Service Groovy Test Fragment`  
`Bundle-SymbolicName: com.github.groovyosgi.testing.pizzaservice.test`  
`Bundle-Version: 1.0.0.qualifier`  
`Bundle-Vendor: Luigis Pizza`  
`Fragment-Host: com.github.groovyosgi.testing.pizzaservice.impl`  
`Bundle-RequiredExecutionEnvironment: JavaSE-1.7`  
`Require-Bundle: org.junit`  
`Import-Package: groovy.lang,`  
` org.codehaus.groovy.reflection,`  
` org.codehaus.groovy.runtime,`  
` org.codehaus.groovy.runtime.callsite,`  
` org.codehaus.groovy.runtime.typehandling,`  
` org.hamcrest.core,`  
` org.junit;version="4.0.0",`  
` org.junit.matchers;version="4.0.0",`  
` org.junit.runner;version="4.0.0"`

A simple JUnit tests might look like this:

`class PizzaBuilderTest {`  
`   @Test`  
`   void 'build Pizza With Bacon Cheese And TomateSauce'() {`  
`       def pizza = PizzaBuilder.newPizza()`  
`           .withBacon()`  
`           .withCheese()`  
`           .withSauce(TOMATO)`  
`           .build()`  
`       assertThat pizza.cheese, is(true)`  
`       assertThat pizza.bacon, is(true)`  
`       assertThat pizza.sauce, is(TOMATO)`  
`   }`  
`}`

For a complete example and more information how to write integrative
tests with groovy please look at
[1](https://github.com/groovyosgi/testing/).

