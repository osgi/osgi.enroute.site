---
title: Gogo
summary: A short introduction to the Gogo shell
layout: toc-guide-page
lprev: 450-Designing-APIs.html 
lnext: 520-bnd.html 
author: Peter.Kriens@aQute.biz 
sponsor: OSGi™ Alliance 
---

The Gogo shell is a unix `bash` like shell for OSGi frameworks. However unlike `bash` (which coerces all arguments to strings), the Gogo shell manipulates data objects and their public methods as command names. Gogo supports programmatic features like variables and closures. 


## Built-in Commands

When interacting with a running OSGi a framework, as in the [Debug Tutorial](../tutorial/022-tutorial_osgi_runtime), if you see a `q!` prompt then you are using Gogo. 

        g!
{: .shell }

Issue the command `help` to list available commands

     felix:bundlelevel
     felix:cd
     felix:frameworklevel
     felix:headers
     ...
     ...
     gogo:cat
     gogo:each
     gogo:echo
     ...
     ...
     scr:config
     scr:disable
     scr:enable
     scr:info
     scr:list
{: .shell }

Notice that the commands are grouped. In the above we can see three command scopes: i.e. `felix`, `gogo` & `scr`; other command groups may also be created.

The following set of commands are immediate of use: follwoing examples using [Debug Tutorial](../tutorial/022-tutorial_osgi_runtime).

### felix:lb, lb

The `felix:lb` command lists the installed bundles.

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


### felix:bundle, bundle

Detailed information on a select bundle is provided by the `bundle` command

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


### felix:inspect, inspect 

The `inspect` command can be used to look at the runtime `Requirements` and `Capabilities` of a selected Bundle: see [Namespaces](../FAQ/200-resolving.html#namespaces) for currently supported Req/Cap namespaces. 

Example of usage. 

     g! inspect req osgi.wiring.package 19
     org.osgi.enroute.examples.quickstart.rest.impl [19] requires:
     -------------------------------------------------------------
     osgi.wiring.package; (osgi.wiring.package=javax.ws.rs) resolved by:
        osgi.wiring.package; javax.ws.rs 2.1.0 from org.apache.aries.javax.jax.rs-api [5]
{: .shell }

Indicates that looking at the `osgi.wiring.package` namespacem, `org.osgi.enroute.examples.quickstart.rest.impl` has a runtime Requirement on `javax.ws.rs 2.1.0`, which has been successfully satisfied by `org.apache.aries.javax.jax.rs-api`.


### scr:list, list

The `scr` scope concerns the Declarative Services layer of the runtime: `scr:list` lists all running DS components.

     g! scr:list
      BundleId Component Name Default State
         Component Id State      PIDs (Factory PID)
      [  19]   org.osgi.enroute.examples.quickstart.rest.Upper  enabled
         [   0] [active      ] 
{: .shell }


### scr:info, info

The `scr:info` command can then be used to list detailed information for a selected DS component.

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

### System Functions

By default Gogo adds all public methods on the `java.lang.System` class and the public methods on the session's `BundleContext` as command. This gives us access to some interesting System functions:

        g! currenttimemillis
        1458158111374
        g! property user.dir
        property user.dir
        /opt/enRoute/enRoutetest/quickstart/app/target
        g! nanotime
        1373044343558515
        g! identityhashcode abc
        828301628
        g! property foo FOO
        g! property foo
        FOO
        g! env JAVA_HOME
        /Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk/Contents/Home
        g! gc
        g!
{: .shell }


## The Command Shell

The most simple command is `echo` which works as expected.

	g! echo Hello World
	Hello World
{: .shell }

### History/Editing

In the Eclipse console you can unfortunately not edit the commands. However, you can access the history using the bang ('!').

	g! !ech
	Hello World
	g! !1
	Hello World
{: .shell }

In standard terminals, you can use the cursor keys to move back and forth.

### Quoting

Quoting (double or single) is optional if the word does not contain spaces or some special characters like '|', ';',  and some others. So in this case 2 tokens are passed to echo. Notice that we can quote the two words turning it into a single token:

	g! echo Hello                     World
	Hello World
	g! echo 'Hello                     World'
	Hello                     World
{: .shell }

### Multiple Commands

You can execute multiple commands on a line by separating the commands with a semicolon (`';'`).

	g! echo Hello; echo World
	Hello 
	World
{: .shell }

Multiple commands can also be separated by a _pipe_ character. In that case the output is the input of the next command. Gogo has a built-in `grep` command so we can use `echo` to create output and `grep` to check the output.

	g! echo Hello | grep Hello
	Hello
	true
	g! echo Hello | grep World
	Hello
	false
{: .shell }

### IO Redirection

Two built-in commands `cat` and `tac` ( tac = reversed cat because it stores) are available to provide file data and store file data. Together with the pipe operator they replace the input and output redirection of the bash shell.

	g! echo Hello | tac temp.txt
	Hello
	g! echo World | tac -a temp.txt
	World
	g! cat temp.txt
	Hello
	World
{: .shell }

### Help

Notice that you can find out about the options of a command by using `-?` (This is not implemented on commands without options and it is not always consistently implemented:

	g! tac -?
	Usage: tac \[-al\] \[FILE\]
		-a --append              append to FILE
		-l --list                return List<String>
		-? --help                show help
{: .shell }


## Objects, Variables, Function ...

### Objects

Notice that neither command required anything special, they are just the methods defined on Bundle Context. The implementation has no clue about Gogo. All these commands return domain plain unadorned objects. We can test this because Gogo has variables that store these plain objects. We can then use those objects in the shell as commands.

	g! bundle = bundle 4
	...
	g! $bundle tostring
	org.apache.felix.scr_2.0.0 [4]
	g! $bundle bundleid
	4
	g! $bundle headers
	Bundle-License      http://www.apache.org/licenses/LICENSE-2.0.txt
	Manifest-Version    1.0
	Created-By          Apache Maven Bundle Plugin
	Bnd-LastModified    1438861013315
	Bundle-Name         Apache Felix Declarative Services
	...
{: .shell }

### Variables

Variables can be have any name. They are set with `<name>=<expr>`. They are referred to by `$<name>`. Gogo uses variables also itself. For example, the prompt can be changed by setting a new `prompt` variable.

	g! prompt= '$ '
	$   
{: .shell }
	
The following variables are in use by the shell:

* `e` – A function to print the last exception's stack trace
* `exception` – The last exception
* `exception-cmd` – The command that threw the exceptions
* `.context` – The Bundle Context
* `prompt` – The shell prompt

### Scope

The syntax feels very natural but there is something a bit tricky going on. The first token in the command can either identify the _name_ of a command or an object. With an object, the next token is the method on that object. This can cause ambiguity. The scope is further discussed later when we add custom commands. Just be aware that the first token is either an object or a command name.
 
### Literals

We've already use string literals. However, it is also possible to use lists and maps:

	g! [1 2 3] size
	3
	g! [a=1 b=2 c=3] get b
	2
{: .shell }
	
### Expressions

So how do we access a specific header. A command like `$bundle headers get Bundle-Version` cannot work because Gogo will see this as one command and will complain with: `Cannot coerce headers(String, String) to any of [(), (String)]`. The parentheses come to the rescue:

	g! $bundle headers get Bundle-Version
	Cannot coerce headers(String, String) to any of [(), (String)]
	g! ($bundle headers) get Bundle-Version
	2.0.0
{: .shell }

The parentheses first calculate the expression in their inner bowels which then becomes available as the target object for the remaining command. I.e. `($bundle headers)` returns a Dictionary object, which subsequently becomes the target object. The `get` token is the method called on this target object, with the `Bundle-Version` as parameter.

### Back ticks

The bash shell has this wonderful capability of executing commands to get an argument by placing back ticks around a command. We can use the parentheses for the same effect, with the added benefit that the parentheses work recursively.

	g! echo Bundle ($bundle bundleid) has name ((bundle ($bundle bundleid)) symbolicname) 
	Bundle 4 has name org.apache.felix.scr
{: .shell }

### Functions

The Gogo shell can store commands for later execution. The `{` and `}` delimiters are used for that purpose. We can store these functions in objects or pass them as parameters. To execute a function as a command, you should use the name of the variable without the dollar ('$') sign.   

	g! f = { echo Hello }
	echo Hello
	g! f
	Hello
{: .shell }

You can pass arguments to the function. They are named $1..$9. $0 is the command name if available. The $it macro refers to $1.

	g! f = { echo $it }
	echo $1
	g! f Hello World
	Hello
{: .shell }

Obviously it is not very nice that we miss the `World` because we only used $1. There is a magic variable called `$args`. This variable is list that gets expanded into separate arguments. So we can change our function to use all the arguments when the function is invoked:
 
	g! f = { echo $args }
	echo $args
	g! f Hello         World
	Hello World
{: .shell }

The `$args` list of arguments cannot be manipulated as a normal object, it gets expanded into its members wherever you use it.  

### Repeat and Conditionals 

Gogo provides a number of built in commands that use the functions to provide conditional and repeated execution. For example, the `each` command takes a collection and a function. It then iterates over the collection and calls the function with the element of the iteration.

	g! each [1 2 3] { echo -- $it --  }
	-- 1 --
	-- 2 --
	-- 3 --
	null
	null
	null
{: .shell }

We can now also use the `if` command:

	g! l = []
	g! if {$l isempty} { echo empty } { echo not empty }
	empty
	g! $l add foo
	g! if {$l isempty} { echo empty } { echo not empty }
	not empty
{: .shell }

You can negate with the `not` command, which takes a function:
	
	g! if { not {$l isempty}} { echo not empty } { echo empty }
	not empty
{: .shell }

TODO while, until

## Adding Commands

You can add any object as a command. If you add an instance then the methods of that instance will be available as commands. However, make sure that you can only add one instance of a given type. The commands would overshadow eachother. For example, we could add a list as a command. Since this is an Array List, all its methods become available. 

	g! addcommand silly-scope [1 2 3 4] 
	g! size
	4
	g! isempty
	false
	g! get 3
	4
	g!
{: .shell }

Clearly this is not that useful. However, it is also possible to add all static methods of a class. This is done automatically for you at startup with the System class. If you ask for the properties then this is actually calling the static method `getProperties()`. For example, we can add all the Math functions to be in the math scope.

	g! addcommand math ((bundle 0) loadclass java.lang.Math) 
	g! sin 2
	0.9092974268256817
	g!
{: .shell }

The `((bundle 0) loadclass java.lang.Math)` is caused by a bug in Gogo. It overloads the `addCommand()` methods in such a way that Gogo cannot coerce the string `java.lang.Math` to a class. Ah well.

## Prompt 

The `g!` prompt is not hard coded. You can override the prompt by setting the variable `prompt` (Surprise!). The value can be a simple string:

	g! prompt = "$ "
	$ sin 2
	0.9092974268256817
	$ 
{: .shell }

However, Gogo would not be Gogo if we could not do this a little more exciting. Lets be original and add the name of the local host. For that, we need to add the InetAddress static methods to our command set.

	g! addcommand inet ((bundle 0) loadclass java.net.InetAddress)
	g!  prompt = { echo ((localhost) hostname) "$ " }
	zeno.local $
{: .shell }

## Formatting
Gogo was designed to format an object to a string in two places. 

* Send to a pipe – This is controlled by `.Format.Pipe`
* Send to the user – This is controlled by `.Gogo.format`

## Exceptions

You (and any code you call) can throw exceptions. The last exception is stored in the `$exception` variable and there is a built in function `e` that shows the stack trace.

	g! throw Foo
	Foo
	g! $exception message
	Foo
	g! e
	java.lang.IllegalArgumentException: Foo
	at org.apache.felix.gogo.shell.Procedural._throw(Procedural.java:83)
	...
{: .shell }

You can also catch the exceptions with a `try` command.

	g! exception = null
	g! try { throw Foo }
	g! $exception
	g! 	
{: .shell }

Of course we now silently ignore the exception, not a good idea. So we can provide a catch function that receives the exception as the $it variable.

	g! try { throw Foo } { echo ouch }
	ouch
	g!
{: .shell }

## Providing a Command

Bundles that can add commands to the shell by registering any service with the `osgi.command.scope` property and `osgi.command.function` service properties. The Gogo shell then call any method name listed in the `osgi.command.function` property. To disambiguate, the `osgi.command.scope` can be used by prefixing the command with the scope and a ':'. The constants for these properties can be found in `osgi.enroute.debug.api.Debug`.

For example, assume the following component is registered:

	@Component(
		property = {
			Debug.COMMAND_SCOPE + "=hello", //
			Debug.COMMAND_FUNCTION + "=world" //
		}
	)
	public class FooImpl implements Foo {
		
		public void sysout() {
			System.out.println("Hello World");
		}
	}

A primary goal of the design was to make it possible to add commands to existing service implementation objects.

## Using the Shell

In the shell, we can now call the function:

	g! sysout
	Hello World
	g! hello:sysout
	Hello World
{: .shell }

In the example we use `System.out`. For some surprisingly, this is ok, even if the shell is accessed via SSH or telnet. The Gogo shell redirects `System.out` for the duration of a command. However, the command is currently not usable for other code. It would be nicer if we could return the text:
 
	public String value() {
		return "Hello World";
	}

No running it in the shell makes it look the same:

	g! value
	Hello World
{: .shell }

### Arguments 

We can also provide an argument. Gogo attempts to use a syntax that one expects in a shell but then translate this to method calls. So if we have the command:

	public String parameter(String parameter) {
		return "Hello " + parameter;
	}

So let's try this out:

	g! parameter OSGi
	Hello OSGi
{: .shell }

It is also quite easy to make the parameter an option:

	public String option(
		@Parameter(
			absentValue="World", 
			names={"-p","--parameter"}) 
			String parameter
		) {
		return "Hello " + parameter;
	}

Since we have an absent value, we do not need the value to be specified. So we can call the command with and without a parameter.

	g! option
	Hello World
	g! option -p OSGi
	Hello OSGi
	g! option --parameter OSGi
	Hello OSGi
{: .shell }

	
### Naming

So far we have had a 1:1 relation between the command name and the method. However, it was a primary design goal of Gogo to make it _feel_ like a shell but interact seamlessly with standard Java code. In Java we often use _design patterns_ like prefixing the name of a property with `get`. Gogo will therefore try to match a command to a method removing the prefixes and case sensitivity. So if we add a method `getFoo` then we can stil call it:

	public String getFoo() {
		return "Foo";
	}

We can now call this command in many different ways.
	
	g! foo
	Foo
	g! FOO
	Foo
	g! Foo
	Foo
{: .shell }

