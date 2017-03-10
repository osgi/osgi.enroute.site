---
title: Gogo shell in OSGi enRoute
summary: A short introduction to the Gogo shell
---

The Gogo shell is a bash like shell that closely interacts with the OSGi framework. Gogo was designed because there is a need for a service that allows human users as well as well as programs to interact with on OSGi based system with a line based interface: a shell. This shell should allow interactive and string based programmatic access to the core features of the framework as well as provide access to functionality that resides in bundles.

Shells can be used from many different sources it is therefore necessary to have a flexible scheme that allows bundles to provide shells based on telnet, the Java 6 Console class, plain Java console, serial ports, files, etc. Supporting commands from bundles should be made very lightweight and simple as to promote supporting the shell in any bundle. 


## Using the Shell

The Gogo shell feels very bash like but has a number of differences. Primary, the shell uses plain data objects and their public methods as command names. Instead of coercing everything to strings, the shell actually manipulates objects. It has all the necessary features to program in it like variables and closures. 

Let's explore the shell to show what it can do out of the box. The examples in this OSGi enRoute application note are executed in the OSGi enRoute [osgi.enroute.gogo.commands.provider] project on Github. If you check out the workspace then you can go to the [osgi.enroute.gogo.commands.provider] project, double click the bnd.bnd file. You should then resolve it and and then debug it. This should provide you with the following output in the console:

	g! 
{: .shell }

## Commands

The most simple command is `echo` which works as expected.

	g! echo Hello World
	Hello World
{: .shell }

## History/Editing

In the Eclipse console you can unfortunately not edit the commands. However, you can access the history using the bang ('!').

	g! !ech
	Hello World
	g! !1
	Hello World
{: .shell }

In standard terminals, you can use the cursor keys to move back and forth.

## Quoting

Quoting (double or single) is optional if the word does not contain spaces or some special characters like '|', ';',  and some others. So in this case 2 tokens are passed to echo. Notice that we can quote the two words turning it into a single token:

	g! echo Hello                     World
	Hello World
	g! echo 'Hello                     World'
	Hello                     World
{: .shell }

## Multiple Commands

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

## IO Redirection

Two built-in commands `cat` and `tac` ( tac = reversed cat because it stores) are available to provide file data and store file data. Together with the pipe operator they replace the input and output redirection of the bash shell.

	g! echo Hello | tac temp.txt
	Hello
	g! echo World | tac -a temp.txt
	World
	g! cat temp.txt
	Hello
	World
{: .shell }

## Help

Notice that You can find out about the options of a command by using `-?` (This is not implemented on commands without options and it is not always consistently implemented:

	g! tac -?
	Usage: tac \[-al\] \[FILE\]
		-a --append              append to FILE
		-l --list                return List<String>
		-? --help                show help
{: .shell }

## Built-in Commands

Gogo's commands are methods on objects. By default Gogo adds all public methods on the `java.lang.System` class and the public methods on the session's `BundleContext` as command. This gives us access to some interesting System functions:

	G! currenttimemillis
	1458158111374
	G! property user.dir
	property user.dir
	/Ws/enroute/osgi.enroute.examples/osgi.enroute.gogo.commands.provider
	G! nanotime
	1373044343558515
	G! identityhashcode abc
	828301628
	G! property foo FOO 
	G! property foo
	FOO
	G! env JAVA_HOME
	/Library/Java/JavaVirtualMachines/jdk1.8.0_25.jdk/Contents/Home
	G! gc
	G! 
{: .shell }

More interesting is the fact that the current Bundle Context is also available. This interface has a method `getBundles` so we can now just get the bundles with the `bundles` command.

    g! bundles
    0|Active     |    0|org.eclipse.osgi (3.10.100.v20150529-1857)
    1|Active     |    1|org.apache.felix.configadmin (1.8.6)
    2|Active     |    1|org.apache.felix.gogo.runtime (0.16.2)
    3|Active     |    1|org.apache.felix.log (1.0.1)
    4|Active     |    1|org.apache.felix.scr (2.0.0)
    5|Active     |    1|org.eclipse.equinox.metatype (1.4.100.v20150408-1437)
    6|Active     |    1|org.osgi.service.metatype (1.3.0.201505202024)
    7|Active     |    1|osgi.enroute.gogo.commands.provider (1.0.0.201603161954)
    8|Active     |    1|org.apache.felix.gogo.shell (1.0.0.201603041814)
{: .shell }

We could now also get a specific bundle:

	g! bundle 4
	Location             reference:file:/...
	State                32
	Bundle                   4|Active     |    1|org.apache.felix.scr (2.0.0)
	Module               osgi.identity; ...
	RegisteredServices   [ConfigurationListener, ServiceComponentRuntime, ScrGogoCommand, ManagedService]
	ServicesInUse        [LogService]
	BundleContext        org.eclipse.osgi.internal.framework.BundleContextImpl@3943a2be
	SymbolicName         org.apache.felix.scr
	BundleId             4
	LastModified         1458156749977
	Headers              ...
	Version              2.0.0
{: .shell }

## Objects

Notice that neither command required anything special, they are just the methods defined on Bundle Context. The implementation has no clue about Gogo. All these commands return domain plain unadorned objects. We can test this because Gogo has variables that store these plain objects. We can then use those objects in the shell as commands.

	G! bundle = bundle 4
	...
	G! $bundle tostring
	org.apache.felix.scr_2.0.0 [4]
	G! $bundle bundleid
	4
	G! $bundle headers
	Bundle-License      http://www.apache.org/licenses/LICENSE-2.0.txt
	Manifest-Version    1.0
	Created-By          Apache Maven Bundle Plugin
	Bnd-LastModified    1438861013315
	Bundle-Name         Apache Felix Declarative Services
	...
{: .shell }

## Variables

Variables can be have any name. They are set with `<name>=<expr>`. They are referred to by `$<name>`. Gogo uses variables also itself. For example, the prompt can be changed by setting a new `prompt` variable.

	G! prompt= '$ '
	$   
{: .shell }
	
The following variables are in use by the shell:

* `e` – A function to print the last exception's stack trace
* `exception` – The last exception
* `exception-cmd` – The command that threw the exceptions
* `.context` – The Bundle Context
* `prompt` – The shell prompt

## Scope

The syntax feels very natural but there is something a bit tricky going on. The first token in the command can either identify the _name_ of a command or an object. With an object, the next token is the method on that object. This can cause ambiguity. The scope is further discussed later when we add custom commands. Just be aware that the first token is either an object or a command name.
 
## Literals

We've already use string literals. However, it is also possible to use lists and maps:

	g! [1 2 3] size
	3
	g! [a=1 b=2 c=3] get b
	2
{: .shell }
	
## Expressions

So how do we access a specific header. A command like `$bundle headers get Bundle-Version` cannot work because Gogo will see this as one command and will complain with: `Cannot coerce headers(String, String) to any of [(), (String)]`. The parentheses come to the rescue:

	G! $bundle headers get Bundle-Version
	Cannot coerce headers(String, String) to any of [(), (String)]
	G! ($bundle headers) get Bundle-Version
	2.0.0
{: .shell }

The parentheses first calculate the expression in their inner bowels which then becomes available as the target object for the remaining command. I.e. `($bundle headers)` returns a Dictionary object, which subsequently becomes the target object. The `get` token is the method called on this target object, with the `Bundle-Version` as parameter.

## Back ticks

The bash shell has this wonderful capability of executing commands to get an argument by placing back ticks around a command. We can use the parentheses for the same effect, with the added benefit that the parentheses work recursively.

	G! echo Bundle ($bundle bundleid) has name ((bundle ($bundle bundleid)) symbolicname) 
	Bundle 4 has name org.apache.felix.scr
{: .shell }

## Functions

The Gogo shell can store commands for later execution. The `{` and `}` delimiters are used for that purpose. We can store these functions in objects or pass them as parameters. To execute a function as a command, you should use the name of the variable without the dollar ('$') sign.   

	G! f = { echo Hello }
	echo Hello
	G! f
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

## Repeat and Conditionals 

Gogo provides a number of built in commands that use the functions to provide conditional and repeated execution. For example, the `each` command takes a collection and a function. It then iterates over the collection and calls the function with the element of the iteration.

	G! each [1 2 3] { echo -- $it --  }
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

	G! throw Foo
	Foo
	G! $exception message
	Foo
	G! e
	java.lang.IllegalArgumentException: Foo
	at org.apache.felix.gogo.shell.Procedural._throw(Procedural.java:83)
	...
{: .shell }

You can also catch the exceptions with a `try` command.

	G! exception = null
	G! try { throw Foo }
	G! $exception
	G! 	
{: .shell }

Of course we now silently ignore the exception, not a good idea. So we can provide a catch function that receives the exception as the $it variable.

	G! try { throw Foo } { echo ouch }
	ouch
	G!

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

	G! sysout
	Hello World
	G! hello:sysout
	Hello World
{: .shell }

In the example we use `System.out`. For some surprisingly, this is ok, even if the shell is accessed via SSH or telnet. The Gogo shell redirects `System.out` for the duration of a command. However, the command is currently not usable for other code. It would be nicer if we could return the text:
 
	public String value() {
		return "Hello World";
	}

No running it in the shell makes it look the same:

	G! value
	Hello World
{: .shell }

## Arguments 

We can also provide an argument. Gogo attempts to use a syntax that one expects in a shell but then translate this to method calls. So if we have the command:

	public String parameter(String parameter) {
		return "Hello " + parameter;
	}

So let's try this out:

	G! parameter OSGi
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

	G! option
	Hello World
	G! option -p OSGi
	Hello OSGi
	G! option --parameter OSGi
	Hello OSGi
{: .shell }

	
## Naming

So far we have had a 1:1 relation between the command name and the method. However, it was a primary design goal of Gogo to make it _feel_ like a shell but interact seamlessly with standard Java code. In Java we often use _design patterns_ like prefixing the name of a property with `get`. Gogo will therefore try to match a command to a method removing the prefixes and case sensitivity. So if we add a method `getFoo` then we can stil call it:

	public String getFoo() {
		return "Foo";
	}

We can now call this command in many different ways.
	
	G! foo
	Foo
	G! FOO
	Foo
	G! Foo
	Foo
{: .shell }

[osgi.enroute.gogo.commands.provider]: https://github.com/osgi/osgi.enroute.examples/osgi.enroute.gogo.commands.provider
