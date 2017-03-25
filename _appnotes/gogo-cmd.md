---
title: Extending Gogo Shell
summary: A primer on how to write commands in the Gogo shell
author: Peter Kriens
---

This application note was written out of my (Peter Kriens) frustration with many Gogo commands I meet in the wild. The way the commands are written often take way more lines than necessary and are not reusable. This application note was written with support from [SMA](http://www.sma.de/)

## Gogo

Gogo is a surprising powerful shell in a very tiny package. It is used in virtually all OSGi installations that I meet. Newcomers to OSGi often love the shell to explore and navigate the environment. However, when I look at open source Gogo commands they often look like:

```java
    /**
     * DO NOT DO THIS AT HOME!
     */
    public String devices( String cmds[] ) {
        int wait = 10;
        boolean localOnly = false;
        
        int i = 0;
        while ( i < cmds.length && cmds[i++].startWith("-")) {
          switch( cmds[i] ) {
          case "--":
             break;
          case "-w":
          case "--wait":
              wait = Integer.parseIn(wait);
              break;
          case "-l":
          case "--localOnly":
              localOnly = true;
              break;
          }
        }
        try (Formatter f = new Formatter();) {
          while( i < cmds.length ) {
              String deviceId = cmds[i++];
              List<Device> ds= driver.findDevices( wait );
              for ( Device d : ds ) {
                f.format("Name           %s\n" +
                         "Address        %s\n" +
                         "Capacity       %s\n", 
                         deviceId, d.getAddress(), d.getCapacity());
              }
          }
          return f.toString();
        }
    }
```

Sadly, this is not the way you should write commands for Gogo. Though Gogo feels like a normal shell it actually is a scripting language with real objects. When you write Gogo commands you should accept Java objects and not just strings and for the return value you should return a plain old Java object. Out of the box, Gogo supports many useful types and it provides an extension mechanism for custom types.

In the upcoming sections we will take a tour of how to write Gogo commands and at the end come back and rewrite this example.

## Component Skeleton

The skeleton of a Gogo command is as follows:

```java
    @Component(
      service = GogoCommand.class,
      property = {
        Debug.COMMAND_SCOPE + "=scope", 
        Debug.COMMAND_FUNCTION + "=function"
    })
    public class GogoCommand {
       @Descriptor("Description of the command")
       public double command( 
                @Descriptor("Description of the argument") 
                double times
       ) {
          return times;
       }
    }
```

The `COMMAND_SCOPE (osgi.command.scope)` defines the scope (surprise!). The `COMMAND_FUNCTION (osgi.command.function)` is the name of the function as it will be used from the command line. If there is no method with that name Gogo will apply the bean patterns to, for example, a `getFoo()` method will be an implementation for a `foo` command.

The `@Descriptor` annotation can be applied to methods and parameters. It is used by the Gogo `help` command to help the user. If you wisely sprinkle them over your beautiful commands you can get a nice man page for free.

And yes, we are aware that setting properties on a component this way sucks. This is being worked upon.

## Project

The `bnd.bnd` file for such a project looks like:

```
      -buildpath: \
        osgi.enroute.base.api, \
        org.apache.felix.gogo.runtime;version =1.0.2

      -runrequires: \
        osgi.identity;filter:='(osgi.identity=osgi.enroute.examples.gogo)',\
        osgi.identity;filter:='(&(osgi.identity=org.apache.felix.gogo.shell)(version>=1.0.0))',\
        osgi.identity;filter:='(&(osgi.identity=org.apache.felix.gogo.command)(version>=0.16.0))'
```

In OSGi enRoute, just resolve and press the Debug button. This will give you a shell:

    ____________________________
    Welcome to Apache Felix Gogo

    g! command 19
    19.0
    g!
{: .shell }

In the following sections we will add commands that you can add to the skeleton. As always, do not restart the framework, everything will be updated automatically.

And ... don't forget to add the command to the `@Component` property. This my common mistake. It always takes me 5 minutes to realise that the reason it does not work is my own forgetfullness.

## Arguments

If there is one principle behind Gogo it is that you should use normal, plain old, type safe java. Despite its tiny size, Gogo takes care of all type conversions and formatting behind the scenes. 

For example, assume you want a command that gives you the location of a bundle. You could take a `long` for the bundle's id or a `String` for its bundle symbolic name. However, Gogo automatically converts a number to a Bundle when there is a command that takes a bundle.

```java
     @Descriptor("Demonstrate the use of type conversion with a bundle argument")
     public String location( 
              @Descriptor("Bundle conversion") 
              Bundle bundle
     ) {
        return bundle.getLocation();
     }
```

So now you can do:

    g! location 15
    reference:file:...felix.gogo.command/0.16.0/org.apache.felix.gogo.command-0.16.0.jar
    g!
{: .shell }

Now the question, does this work with the bundle symbolic name?

    g! location org.apache.felix.gogo.command
    reference:file:...felix.gogo.command/0.16.0/org.apache.felix.gogo.command-0.16.0.jar
    g!
{: .shell }

Obviously! In software, it is close to perfection when you do not write code but still get lots of functionality!

Clearly Gogo knows how to handle a `Bundle` object but... 
If this does not work, then you probably forgot to add the command to the `@Component` annotation `property` field?

In general, this works for all applicable types in the VM and the OSGi specification. For example, if you want a Bundle object then just specify a `Bundle` object. However, any object that has a String constructor can be used. For example, a `URI` works fine in Gogo

```java
     @Descriptor("Demonstrate the use of type conversion with a bundle argument")
     public String scheme( 
              @Descriptor("The URI to get the scheme from") 
              URI uri
     ) {
        return uri.getScheme();
     }
```

When we run this:

    g! scheme (location 2)
    reference
    g!
{: .shell }

## Custom Arguments

The simplest way to make your objects interact with Gogo is to implement a String constructor. However, this does not work for interfaces and many extremely useful objects that can only be created through a factory. For example, Java 8 introduced an `Instant` class for handling time. This class has no String constructor but it has a static `parse(String)` method. We can tell Gogo how to turn a String into an `Instant` by registering as a _converter_ and converting a String to an `Instant`.

You can register a converter by registering a _Converter_ service. The `Converter` interface has a `convert(Class,Object)` method. The class represents the desired type and the object is the input. This can be any type, not just `String`. This supports all types because sometimes an object from another function must be converted. The method can return `null` if the combination of class and object is not recognized. So let's add the `Converter` interface to our `GogoCommand` class.

```java
    @Component(
      property = {
        Debug.COMMAND_SCOPE + "=scope", 
        Debug.COMMAND_FUNCTION + "=function"
    })
    public class GogoCommand implements Converter {
       @Override
       public Object convert(Class<?> desiredType, Object in) throws Exception { 
          return null;
       }
       ...
    }
```

We also need to add a `format` method. This method will be discussed later, just return null. Since we now implement an interface the `service` field in the `Component` annotation is now no longer needed and _must_ be removed. If it is not removed the `Converter` service will not be registered.

For an `Instant` we want to convert from a String with the ISO-8601 representation. This is like `2011-12-03T10:15:30Z`. So we can fill in the convert method:

```java
       @Override
       public Object convert(Class<?> desiredType, Object in) throws Exception { 
          if ( desiredType == Instant.class ) {
             if ( in instanceof CharSequence ) {
                 return Instant.parse( (CharSequence) in);
             }
          }
          return null;
       }
```

To test this we add a command:

```java
     public long epoch( Instant instant) {
        return instant.toEpochMilli();
     }
```

And run it:

    g! epoch 2011-12-03T10:15:30Z
    1322907330000
{: .shell }

## Options and Flags

Shells generally heavily use _options_ and _flags_. An option is an identifier, generally starting with a `-` character, and a subsequent value. For example `-t 67` is an option. A flag is a similar identifier but it has no subsequent value. The presence of the flag gives a value and the absence of the flag gives another value. For example, `-f` might indicate `true` but if the flag is not specified the value is `false`.

Together, options and flags are called _parameters_. Parameters are not treated any differently in the method that executes the function, they are plain old arguments. However, Gogo is provided their extra semantics with the `@Parameter` annotation. This annotation provides the name and optional aliases of the parameter (option or flags), the value when the parameter is not specified (absentValue) and for a flag it specifies a value when the parameter is specified.

For example, in the epoch command we would like to see the results as days, not as milliseconds, when the user specifies the `-d` flag. 

```java
       public long epoch(
            @Parameter(
              names = "-d", 
              presentValue = "true", 
              absentValue = "false") 
            boolean days,
            Instant instant) {
          if (days)
             return instant.toEpochMilli() / (24*60*60*1000);
          else
             return instant.toEpochMilli();
       }
```

And run it:

    g! epoch 2011-12-03T10:15:30Z
    1322907330000
{: .shell }

Since there are only a limited number of characters in the alphabet, shell commands often have long names for parameters. The `@Parameter` annotation can therefore take an array of arguments. For example, instead of having flag for the _units_ of the output we can also specify an enum:

```java
       public enum Unit { 
          years(365*24*60*60*1000L), 
          days(24*60*60*1000), 
          hours(60*60*1000), 
          minutes(60*1000), 
          seconds(1000), 
          millis(1);
          
          public final long divisor;

          Unit(long divisor) {
             this.divisor=divisor;
          }
       };

       public long epoch(
            @Parameter(
                names = {"-u","--unit"}, 
                absentValue = "millis"
            ) 
            Unit unit,
            Instant instant) {
            return instant.toEpochMilli() / unit.divisor;
       }
```

And run it:

    g! epoch -u years 2012-12-03T10:15:30Z
    42
{: .shell }

## Variable Number Of Arguments

Java allows the last argument of a method to hold a variable number of arguments. This is perfectly well supported in Gogo. When the parameters are parsed and the arguments filled, remaining arguments are coerced in the vararg argument if present. This pattern is very useful since it allows the user to specify many variables that the command can operate on. For example, a command to start bundles can be written as follows:

```java
     public void begin( 
              @Parameter( names={"-t","--transient"}, absentValue="0", presentValue="1") 
              int transnt, 
              @Parameter( names={"-p","--policy"}, absentValue="0", presentValue="2") 
              int policy, 
              Bundle ... bundles

              ) throws BundleException {
        int options = transnt+policy;
        for ( Bundle b : bundles ) {
           b.start(options);
        }
     }
```

We call it `begin` because the Gogo shell usually already has a `start` command.

## Getting Direct Input

Sometimes you really want to ask the user. However, the way Gogo is designed means that your user could be in another continent. This clearly will void the use of the Console. So how do you talk to the user?

If the first argument of the  command function is a `CommandSession` then Gogo will automatically insert it. The Command Session is the way Gogo talks to the user. For our purpose it has a `getKeyBoard()` method. This method bypasses any pipes and directly goes to the user. This allows you to wait for input from the user. If the session is attached to a file as input a null is returned.

For example, the following command waits for the user to type a key. It is not guaranteed that each character is returned, some streams are buffered and wait until eof or return to send the content.

```java
    public void anyKey(CommandSession session) throws Exception {
        InputStream keyboard = session.getKeyboard();
        if(keyboard==null)
           return;
        keyboard.read();
     }
```

And in the shell:

    g! anykey
    a
    g!
{: .shell }

## Taking Functions as Argument

Gogo supports _functions_. The user can make a function in the shell and pass it to a command. For example:

    g! each [ 1 2 3 ] { echo --$it-- }
    --1--
    --2--
    --3--
{: .shell }

These functions are represented by the `Function` interface. This is not the Java 8 Function interface, it is an interface that existed in Gogo long before Java 8 was a glimmer in the eyes of its makers. Its only fault was a name that was a tad too common. 

The following code implements a mapping function. It takes an iterable and a function and returns a list of objects that were processed by the function.

```java
     public List<Object> map(CommandSession session, Iterable<?> it, Function f) throws Exception {
        List<Object> list = new ArrayList<>();
        for ( Object o : it) {
           Object r = f.execute(session, Arrays.asList(o));
           list.add(r);
        }
        return list;
     }
```

Such a function can be called with:

    g! map [ "abc" "defghi" "jklmnopq"] { $it length }
    3
    6
    8
{: .shell }

## Formatting of Output

The preferred way in Gogo is to not bother about output. Each method should return normal Plain Old Java Objects. By returning normal objects you automatically get formatted output and you can also use the methods in expressions. By default, the `toString()` method is used to print any objects. However, in Gogo you can use the converter to also _format_. The Gogo Converter interface has another method we ignored earlier. 

```java
    CharSequence format(Object target, int level, Converter escape) throws Exception;
```

If you want to format a specific object, then you can return a formatted string for that object. However. This object takes a _level_ as parameter. This level is a hint to the formatter. In general, the formatting is a recursive process. For example if you return a list of File objects then the first level is the list, the second level is the file object, and the third level consists of the name, access rights, size, etc. In the interface these three levels are identified by 3 constants:

* `INSPECT` – Format the details of the objects. In general the object is the top level object being formatted. For this level you can think of having a table to show your object.
* `LINE` – Used when the object is listed as a member of another object, for example in a list or structure. There is sufficient information to show more than just a unique identifier. You can think of having a row in a table.
* `PART` – Used when the object is used as part of a line. The information should suffice to identify it. You can think of having a cell in a table.

Gogo has a large number of default formatters built in that are used when there is no more specific formatter. One of the defaults is actually following the bean standard. It will get all public methods and display their value recursively. (Using the INSPECT, LINE, PART rule.)

For example, let's implement some commands that show the Java network interfaces. First lets list them:

```java
    public List<NetworkInterface> ifconfig() throws SocketException {
        return Collections.list(NetworkInterface.getNetworkInterfaces());
    }
```

If we try that out:

    g! ifconfig
    name:utun2 (utun2)
    name:utun0 (utun0)
    name:awdl0 (awdl0)
    name:en0 (en0)
    name:lo0 (lo0)
    g!
{: .shell }

This looks awkward. Let's make it close to the output of the real ifconfig.

```java
    NetworkInterface ni = (NetworkInterface) target;
    switch (level) {
    case LINE:
       try (Formatter f = new Formatter();) {
          byte[] ether = ni.getHardwareAddress();
          f.format("%2d %-10s %17s %s", ni.getIndex(), ni.getName(),
                   printHexBinary(ether == null ? new byte[0] : ether).replaceAll("(..e)(?=..)", "$1:"),
                   Collections.list(ni.getInetAddresses()));
          return f.toString();
       }
    case INSPECT:
    case PART:
    }
```

We now get:

    g! ifconfig
    14 utun2                        [/fe80:0:0:0:3aa7:cdc1:3062:a084%utun2]
    10 utun0                        [/fe80:0:0:0:aaa2:3110:55c:67%utun0]
     8 awdl0      DE:F6:1A:E4:21:4E [/fe80:0:0:0:dcf6:1aff:fee4:214e%awdl0]
     4 en0        78:31:C1:CD:81:F8 [/fe80:0:0:0:cc2:307f:93f6:c355%en0, /192.168.67.105]
     1 lo0                          [/fe80:0:0:0:0:0:0:1%lo0, /0:0:0:0:0:0:0:1, /127.0.0.1]
    g!
{: .shell }

So let's now add a method to inspect a single interface.

```java
    public NetworkInterface ifconfig(NetworkInterface networkInterface) {
      return networkInterface;
    }
```

This won't work out of the box so we add the following to the convert method:

```java
      if (desiredType == NetworkInterface.class) {
         if (in instanceof CharSequence) {
            return NetworkInterface.getByName(in.toString());
         }
         if (in instanceof Number) {
            return NetworkInterface.getByIndex(((Number) in).intValue());
         }
      }
```

We can now call this method with:

    g! ifconfig lo0
    Name                 lo0
    Parent               null
    DisplayName          lo0
    Index                1
    NetworkInterfaces    java.net.NetworkInterface$2@73e27ab4
    InterfaceAddresses   [/fe80:0:0:0:0:0:0:1%lo0/64 [null], /0:0:0:0:0:0:0:1/128 [null], /127.0.0.1/8 [null]]
    SubInterfaces        java.net.NetworkInterface$1subIFs@c99d5b9
    HardwareAddress      null
    MTU                  16384
    InetAddresses        java.net.NetworkInterface$1checkedAddresses@277b2440
{:.shell}

This is clearly not looking that good ... So let's add an output that looks like the official Unix `ifconfig` command.

```java
    case INSPECT:
       try (Formatter f = new Formatter();) {
          List<String> l = new ArrayList<>();

          if (ni.isUp())
             l.add("UP");
          if (ni.isLoopback())
             l.add("LOOPBACK");
          if (ni.isPointToPoint())
             l.add("POINTTOPOINT");
          if (ni.isVirtual())
             l.add("VIRTUAL");
          if (ni.supportsMulticast())
             l.add("MULTICAST");

          f.format("%s : <%s> MTU=%s", ni.getName(), l.toString().replaceAll("[\\[\\]]", ""),  ni.getMTU());

          if (ni.getHardwareAddress() != null)
             f.format("\n   ether=%s", printHexBinary(ni.getHardwareAddress()));

          Optional<InetAddress> inet6 = Collections.list(ni.getInetAddresses()).stream()
                   .filter(a -> a instanceof Inet6Address).findFirst();
          if (inet6.isPresent())
             f.format("\n   inet6=%s", inet6.get().getHostAddress());

          Optional<InetAddress> inet4 = Collections.list(ni.getInetAddresses()).stream()
                   .filter(a -> a instanceof Inet4Address).findFirst();
          if (inet4.isPresent())
             f.format("\n   inet4=%s", inet4.get().getHostAddress());

          return f.toString();
       }
```

And in the shell it looks now like:

    g!  ifconfig 4
    en0 : <UP, MULTICAST> MTU=1500
       ether=7831C1CD81F8
       inet6=fe80:0:0:0:cc2:307f:93f6:c355%en0
       inet4=192.168.67.105
    g! 
{: .shell }

Implement the `PART` is left as an exercise for the reader.

## Console Output 

In the enterprise world it is considered a bad habit to write to the `System.out` stream. Though shalt log! I've therefore noticed that few people take advantage of one of Gogo's most simplifying features: `System.out` is the preferable way to create output. The reason `System.out` is considered a bad habit is because the console is a shared resource and if everybody starts to dump their information there it quickly becomes a mess. However, Gogo uses _Threadio_, which is a service that multiplexes `System.out` and `System.err` (and also `System.in`). Each thread is associated with its own triplet of streams. So as long as you print to sysout inside a command then any Gogo user will get the information even if they run the shell remotely. It will therefore also handle piping and other cool features the Gogo shell provides.

So when you need to prepare a real report it makes sense to use System.out instead of using an object and the formatting support.

```java
    public void hello() {
        System.out.println("Hello Gogo");
    }
```

And in the shell:

    g! hello
    Hello Gogo
    g!
{: .shell }
 
## Console

If you need to send information to the current user then you can also directly talk to the console. As discussed before, the best solution is to return plain old Java objects. The second best solution is to use `System.out` since it is redirected in the shell. However, sometimes you want to do something in the background. For example, you want to check that the log is not receiving any errors. In those case you need to directly write to the console. You can access the console via the `CommandSession` method argument. The `getConsole()` method provides you with access to the console.

So let's make an example that tracks the log. We then add a command to do it in the background.

First we need a reference to the LogReader service:

```java
       @Reference
       LogReaderService logr;
```

For convenience, we'd like to input the level symbolically. We can use  an `enum` for this.

```java
       public enum Level {
          ERROR, WARNING, INFO, DEBUG
       }
```

Since we are in a concurrent environment we use an Atomic Reference to manage the Log Listener.

```java
    AtomicReference<LogListener> listener = new AtomicReference<>();
```

We now create a command that takes the Command Session and two options:

* `-q`, `--quit` – Quit an earlier log listener
* `-l`, `--level` – The highest level to log. This is a member of Level

We can declare the following method to have these options:

```java
    public void logt(CommandSession session,
        @Parameter(
            names = {"-q", "--quit"}, 
            absentValue = "false", 
            presentValue = "true") boolean quit,
        @Parameter(
            names = {"-l", "--level"}, 
            absentValue = "DEBUG") 
            Level level
        )
        throws IOException
    {
        LogListener l = e -> {
            if ( e.getLevel() > level.ordinal())
                return;

            session.getConsole().printf("%-6s %s\n", Level.values()[e.getLevel()], e.getMessage());
        };
        
        reset(l);
        if (quit) {
            System.out.println("Disable log trace");
            return;
        }

        logr.addLogListener(l);
            System.out.println("Added log trace");
    }
```

Some utilities to do housekeeping:

```java
    private void reset(LogListener l) {
      LogListener old = listener.getAndSet(l);
      if ( old != null) {
         logr.removeLogListener(old);
      }
    }

    @Deactivate
    void deactivate() {
      reset(null);
    }
```

And in the shell:

    g! logt -l DEBUG
    Added log trace
    g!  (bundle 1) stop
    DEBUG  ServiceEvent UNREGISTERING
    DEBUG  BundleEvent STOPPED
    DEBUG  BundleEvent STOPPED
    g! 
    g! (bundle 1) start
    DEBUG  ServiceEvent REGISTERED
    DEBUG  BundleEvent STARTED
    DEBUG  BundleEvent STARTED
    g!
{: .shell }

## Using Variables

Each session maintains a map of variables. These variables can be read and set from the shell:

    g! foo=12
    12
    g! $foo
    12
    g! 
{:.shell}

These variables are available to you when writing commands. To access them you need to get the Command Session. The Command Session has the following methods:

* `Object get(String)` – Get a variable
* `Object put(String, Object)` – Set a variable, the return is the previous value

## Recap

We started with the following command and promised to rewrite it:

```java
    public String devices( String cmds[] ) {
        int wait = 10;
        boolean localOnly = false;
        
        int i = 0;
        while ( i < cmds.length && cmds[i++].startWith("-")) {
          switch( cmds[i] ) {
          case "--":
             break;
          case "-w":
          case "--wait":
              wait = Integer.parseIn(wait);
              break;
          case "-l":
          case "--localOnly":
              localOnly = true;
              break;
          case "-l":
          case "--limit":
              limit = Integer.parseIn(wait);
              break;
          }
        }
        try (Formatter f = new Formatter();) {
          while( i < cmds.length ) {
              String deviceId = cmds[i++];
              List<Device> ds= driver.findDevices( wait );
              for ( Device d : ds ) {
                f.format("Name           %s\n" +
                         "Address        %s\n" +
                         "Capacity       %s\n", 
                         deviceId, d.getAddress(), d.getCapacity());
              }
          }
          return f.toString();
        }
    }
```

So here is the rewrite:

```java
    @Descriptor("List the devices")
    public List<Device devices( 
        @Descriptor( "Wait seconds for the devices to be discovered" )
        @Parameter( names={"-w", "--wait"}, absentValue="10" )
        int wait,
        
        @Descriptor( "Wait seconds for the devices to be discovered" )
        @Parameter( names={"-l", "--localOnly"}, absentValue="false", presentValue="true" )
        boolean localOnly
    ) {
        return driver.findDevices( wait, localOnly );
    }
```

Since we're using objects now we must provide a format function. 

```java
    public String format( Object target, int level, Converter escape ) {
        if ( target instanceof Device ) {
            Device dev = (Device) target;
            switch( level ) {
                case PART :
                   return device.getId();
                case LINE :
                   return device.toString();
                case INSPECT :
                    try (Formatter f = new Formatter(); ) {
                        f.format("Name           %s\n" +
                             "Address        %s\n" +
                             "Capacity       %s\n", 
                             deviceId, d.getAddress(), d.getCapacity());
                        return f.toString();
                    }
                }
            }
        }
        return null; 
    }
```

## Conclusion

Gogo is a surprisingly powerful shell that makes it very easy to provide commands that can be called from a shell. Since it uses the domain objects natively the commands are often just calling directly to domain code or in many cases the domain is also used to provide the command function. Enjoy it!
