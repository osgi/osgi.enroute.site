---
title: OSGi Runtime & Debug  
layout: toc-guide-page
lprev: 020-tutorial_qs.html  
lnext: 030-tutorial_microservice.html 
summary: A peek behind the curtain - the OSGi™ µServices runtime!
author: enRoute@paremus.com
sponsor: OSGi™ Alliance  
---


In the `quickstart` tutorial we created and ran a simple OSGi™ Microservice. Before progressing to more sophisticated examples we'll first take a quick look at the OSGi™ runtime and the software DNA of your Microservices application.

## Creating the debug version of `quickstart` 

To gain access to the OSGi runtime we need to create a **debug** version of `quickstart`.

From the `quickstart` project root directory you previously created, change directory to `./app` edit the `pom.xml`, and changing the first occurance of `<bndrun>app.bndrun</bndrun>` 

      <plugin>
          <groupId>biz.aQute.bnd</groupId>
          <artifactId>bnd-export-maven-plugin</artifactId>
          <configuration>
              <bndruns>
                  <bndrun>app.bndrun</bndrun>
              </bndruns>
          </configuration>
      </plugin>
      <plugin>
          <groupId>biz.aQute.bnd</groupId>
          <artifactId>bnd-resolver-maven-plugin</artifactId>
          <configuration>
              <bndruns>
                  <bndrun>app.bndrun</bndrun>
                  <bndrun>debug.bndrun</bndrun>
              </bndruns>
          </configuration>
      </plugin>


to `<bndrun>debug.bndrun</bndrun>` as shown

      <plugin>
           <groupId>biz.aQute.bnd</groupId>
           <artifactId>bnd-export-maven-plugin</artifactId>
           <configuration>
               <bndruns>
                   <bndrun>debug.bndrun</bndrun>
               </bndruns>
           </configuration>
       </plugin>
       <plugin>
           <groupId>biz.aQute.bnd</groupId>
           <artifactId>bnd-resolver-maven-plugin</artifactId>
           <configuration>
               <bndruns>
                   <bndrun>app.bndrun</bndrun>
                   <bndrun>debug.bndrun</bndrun>
               </bndruns>
           </configuration>
       </plugin>


Now re-build your `quickstart` application

    $ mvn install
    $ mvn bnd-resolver:resolve
    $ mvn package 
{: .shell }

and run the new debug version.

    $ java -jar app/target/debug.jar
{: .shell } 


## Gogo & the OSGi runtime

When interacting with a running OSGi a framework, if you are presented with the prompt `g!` then you are using the [Gogo shell](../FAQ/500-gogo). 

        g!
{: .shell }

### Bundle level diagnostics

The list of installed bundles used to create `quickstart` may be shown with either the `lb` or `bundles` command, 

     g! lb
     START LEVEL 1
         ID|State      |Level|Name
         0|Active     |    0|System Bundle (5.7.0.SNAPSHOT)|5.7.0.SNAPSHOT
         1|Active     |    1|Logback Classic Module (1.2.3)|1.2.3
         2|Active     |    1|Logback Core Module (1.2.3)|1.2.3
         3|Active     |    1|JSR 353 (JSON Processing) API (1.0.0)|1.0.0
         4|Active     |    1|Apache Aries Javax Annotation API (0.0.1.201711291743)|0.0.1.201711291743
         5|Active     |    1|Apache Aries JAX-RS Specification API (0.0.1.201803051642)|0.0.1.201803051642
         6|Active     |    1|Apache Aries JAX-RS Whiteboard (0.0.1.201803051643)|0.0.1.201803051643
         7|Active     |    1|Apache Commons FileUpload (1.3.2)|1.3.2
         8|Active     |    1|Apache Commons IO (2.5.0)|2.5.0
         9|Active     |    1|Apache Felix Configuration Admin Service (1.9.0.SNAPSHOT)|1.9.0.SNAPSHOT
        10|Active     |    1|Apache Felix Gogo Command (1.0.2)|1.0.2
        11|Active     |    1|Apache Felix Gogo Runtime (1.0.10)|1.0.10
        12|Active     |    1|Apache Felix Gogo Shell (1.0.0)|1.0.0
        13|Active     |    1|Apache Felix Http Jetty (3.4.7.R7-SNAPSHOT)|3.4.7.R7-SNAPSHOT
        14|Active     |    1|Apache Felix Servlet API (1.1.2)|1.1.2
        15|Active     |    1|Apache Felix Inventory (1.0.4)|1.0.4
        16|Active     |    1|Apache Felix Declarative Services (2.1.0.SNAPSHOT)|2.1.0.SNAPSHOT
        17|Active     |    1|Apache Felix Web Management Console (4.3.4)|4.3.4
        18|Active     |    1|Apache Felix Web Console Service Component Runtime/Declarative Services Plugin (2.0.8)|2.0.8
        19|Active     |    1|impl (1.0.0.201803052117)|1.0.0.201803052117
        20|Active     |    1|org.osgi:org.osgi.service.jaxrs (1.0.0.201803012137-SNAPSHOT)|1.0.0.201803012137-SNAPSHOT
        21|Active     |    1|org.osgi:org.osgi.util.function (1.1.0.201803012137-SNAPSHOT)|1.1.0.201803012137-SNAPSHOT
        22|Active     |    1|org.osgi:org.osgi.util.promise (1.1.0.201803012137-SNAPSHOT)|1.1.0.201803012137-SNAPSHOT
        23|Active     |    1|osgi.cmpn (4.3.1.201210102024)|4.3.1.201210102024
        24|Active     |    1|slf4j-api (1.7.25)|1.7.25
{: .shell }


Additional information for a specified bundle is available via the `bundle $ID` command. 

The ID for our `quickstart` bundle is `19` and `bundle 19` showns 

     g! bundle 19
     Location             jar/impl-1.0-SNAPSHOT.jar
     State                32
     RegisteredServices   [Upper]
     ServicesInUse        [ConfigurationAdmin, ServletContextHelper]
     Bundle                  19|Active     |    1|org.osgi.enroute.examples.quickstart.rest.impl (1.0.0.201803052117)
     Revisions            [org.osgi.enroute.examples.quickstart.rest.impl [19](R 19.0)]
     BundleContext        org.apache.felix.framework.BundleContextImpl@69653e16
     SymbolicName         org.osgi.enroute.examples.quickstart.rest.impl
     BundleId             19
     Version              1.0.0.201803052117
     LastModified         1520685956190
     Headers              [Service-Component=OSGI-INF/org.osgi.enroute.examples.quickstart.rest.Upper.xml, Created-By=1.8.0_162 (Oracle Corporation), Manifest-Version=1.0, Bnd-LastModified=1520284643255, Private-Package=org.osgi.enroute.examples.quickstart.rest, Bundle-Name=impl, Build-Jdk=1.8.0_162, Import-Package=javax.ws.rs, Provide-Capability=osgi.service;objectClass:List<String>="org.osgi.enroute.examples.quickstart.rest.Upper", Bundle-ManifestVersion=2, Bundle-SymbolicName=org.osgi.enroute.examples.quickstart.rest.impl, Bundle-Version=1.0.0.201803052117, Built-By=richardnicholson, Require-Capability=osgi.extender;filter:="(&(osgi.extender=osgi.component)(version>=1.3.0)(!(version>=2.0.0)))",osgi.extender;filter:="(&(osgi.extender=osgi.component)(&(version>=1.4.0)(!(version>=2.0.0))))",osgi.implementation;filter:="(&(osgi.implementation=osgi.http)(&(version>=1.1.0)(!(version>=2.0.0))))",osgi.implementation;filter:="(&(osgi.implementation=osgi.jaxrs)(&(version>=1.0.0)(!(version>=2.0.0))))",osgi.contract;osgi.contract=JavaJAXRS;filter:="(&(osgi.contract=JavaJAXRS)(version=2.1.0))",osgi.ee;filter:="(&(osgi.ee=JavaSE)(version=1.8))", Tool=Bnd-4.0.0.201803042323-SNAPSHOT]
{: .shell }


The `inspect` command can be used to look at the runtime `Requirements` and `Capabilities` of a selected Bundle: see [Namespaces](../FAQ/200-resolving.html#namespaces) for currently supported Req/Cap namespaces. 

Example of usage. 

     g! inspect req osgi.wiring.package 19
     org.osgi.enroute.examples.quickstart.rest.impl [19] requires:
     -------------------------------------------------------------
     osgi.wiring.package; (osgi.wiring.package=javax.ws.rs) resolved by:
        osgi.wiring.package; javax.ws.rs 2.1.0 from org.apache.aries.javax.jax.rs-api [5]
{: .shell }

Indicates that looking at the `osgi.wiring.package` namespacem, `org.osgi.enroute.examples.quickstart.rest.impl` has a runtime Requirement on `javax.ws.rs 2.1.0`, which has been successfully satisfied by `org.apache.aries.javax.jax.rs-api`.


### Component level diagnostics

Your bundles may be correctly installed and running, but your application still not functioning as is it should. 

The Declarative Services `scr` commands provide information on the runtime status and configuration of your Declarative Services Components.

The `scr:list` lists all running DS components.

     g! scr:list
      BundleId Component Name Default State
         Component Id State      PIDs (Factory PID)
      [  19]   org.osgi.enroute.examples.quickstart.rest.Upper  enabled
         [   0] [active      ] 
{: .shell }

With the `quickstart` example, we only have one DS component, which is reported as `active`.

The `scr:info` command can then be used to list detailed information for a named DS component.

     g! scr:info org.osgi.enroute.examples.quickstart.rest.Upper 
     *** Bundle: org.osgi.enroute.examples.quickstart.rest.impl (19)
     Component Description:
       Name: org.osgi.enroute.examples.quickstart.rest.Upper
       Implementation Class: org.osgi.enroute.examples.quickstart.rest.Upper
       Default State: enabled
       Activation: delayed
       Configuration Policy: optional
       Activate Method: activate
       Deactivate Method: deactivate
       Modified Method: -
       Configuration Pid: [org.osgi.enroute.examples.quickstart.rest.Upper]
       Services: 
         org.osgi.enroute.examples.quickstart.rest.Upper
       Service Scope: singleton
       Component Description Properties:
           osgi.http.whiteboard.resource.pattern = [/quickstart/*]
           osgi.http.whiteboard.resource.prefix = static
           osgi.jaxrs.resource = true
       Component Configuration:
         ComponentId: 0
         State: active      
         Component Configuration Properties:
             component.id = 0
             component.name = org.osgi.enroute.examples.quickstart.rest.Upper
             osgi.http.whiteboard.resource.pattern = [/quickstart/*]
             osgi.http.whiteboard.resource.prefix = static
             osgi.jaxrs.resource = true
{: .shell }




