---
---

Gogo is a surprising powerful shell in a very tiny package. It is used in virtually all OSGi installations that I meet. Newcomers to OSGi often love the shell to explore and navigate the environment. However, when I look at open source Gogo commnands they often look like:

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

Sadly, this is not the way you should write commands for Gogo. Though Gogo feels like a normal shell it actually is a scripting language with real objects. When you write Gogo commands you should accept Java objects and not just strings and for the return value it is the same. Out of the box Gogo supports many useful types and it provides an extension mechanism for custom types.

In the upcoming sections we will take  a tour of how to write Gogo commands and at the end come back and rewrite this example.

## Component

The skeleton of a Gogo command is as follows:

    @Component(
      service = GogoCommand.class,
      property = {
        Debug.COMMAND_SCOPE + "=scope", 
        Debug.COMMAND_FUNCTION + "=function"
    })
    public class GogoCommand
    {
       @Descriptor("Description of the command")
       public double command( 
                @Descriptor("Description of the argument") 
                double times
       )
       {
          return times;
       }
    }

The `COMMAND_SCOPE` defines the scope (surprise!). The `COMMAND_FUNCTION` is the name of the function as it will be used from the command line. If there is no method with that name Gogo will apply the bean patterns to for example a `getFoo()` method will be an implementation for a `foo` command.

The `@Descriptor` annotation can be applied to methods and parameters. It is used by the Gogo `help` command to help the user. If you wisely sprinkle them over your beautiful commands you can get a nice man page for free.

And yes, we are aware that setting properties on a component this way sucks. This is being worked upon.

## Project

The bnd for such a project looks like:

  -buildpath: \
    osgi.enroute.base.api, \
    org.apache.felix.gogo.runtime;version =1.0.2

  -testpath: \
    osgi.enroute.junit.wrapper, \
    osgi.enroute.hamcrest.wrapper

  -runrequires: \
    osgi.identity;filter:='(osgi.identity=osgi.enroute.examples.gogo)',\
    osgi.identity;filter:='(&(osgi.identity=org.apache.felix.gogo.shell)(version>=1.0.0))',\
    osgi.identity;filter:='(&(osgi.identity=org.apache.felix.gogo.command)(version>=0.16.0))'

In OSGi enRoute, just resolve and press the Debug button. This will give you a shell:

    ____________________________
    Welcome to Apache Felix Gogo

    g! command 19
    19.0
    g!
{: .shell }

In the following sections we will add commands that you can add to the skeleton. As always, do not restart the framework, eveyrhting will be updated automatically.

And ... don't forget to add the command to the `@Component` property. This my common mistake. It always takes me 5 minutes to realise that the reason it does not work is my own forgetfullness.

## Arguments

If there is one principle behind Gogo then it is the fact that you should normal plain old type safe java. Despite its tiny size, Gogo takes care of all type conversions and formatting behind the scenes. 

For example, assume you want a command that gives you with the location of a bundle. You could take a `long` for the bundle's id or a `String` for its bundle symbolic name. However, Gogo automatically converts a number to a Bundle when there is a command that takes a bundle.

     @Descriptor("Demonstrate the use of type conversion with a bundle argument")
     public String location( 
              @Descriptor("Bundle conversion") 
              Bundle bundle
     )
     {
        return bundle.getLocation();
     }

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

Obviously! In software, this is close to perfection when you do not write code but still get lots of functionality!

Clearly Gogo knows how to handle a `Bundle` object but 
If this does not work, then you probably forgot to add the command to the `@Component` annotation `property` field?

In general, this works for all applicable types in the VM and the OSGi specification. For example, if you want have a Bundle object then just specify a `Bundle` object. However, any object that has a String constructor can be used. For example, a `URI` works fine in Gogo

     @Descriptor("Demonstrate the use of type conversion with a bundle argument")
     public String scheme( 
              @Descriptor("The URI to get the scheme from") 
              URI uri
     )
     {
        return uri.getScheme();
     }

When we run this:

    g! scheme (location 2)
    reference
    g!
{: .shell }

## Custom Arguments

The simplest way to make your objects interact with Gogo is to implement a String constructor. However, this does not work for interfaces and many extremely useful objects that can only be created through a factory. For example, Java 8 introduced an `Instant` class for the time. This class has no String constructor but it has a static `parse(String)` method. We can tell Gogo how to turn a String into an `Instant` by registering as a _converter_ and converting a String to an `Instant`.

You can register a converter by registering a _Converter_ service. The `Converter` interface has a `convert(Class,Object)` method. The class represents the desired type and the object is the input. This can be any type, not just `String`. This supports all types because sometimes an object from another function must be converted. The method can return `null` if the combination of class and object is not recognized. So let's add the `Converter` interface to our `GogoCommand` class.

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

We also need to add a `format` method. This method will be discussed later, just return null. Since we now implement an interface the `service` field in the `Component` annotation is now no longer needed and _must_ be. If it is not removed the Converter service will not be registered.

For an `Instant` we want to convert from a String with the ISO-8601 representation. This is like `2011-12-03T10:15:30Z`. So we can fill in the convert method:

       @Override
       public Object convert(Class<?> desiredType, Object in) throws Exception { 
          if ( desiredType == Instant.class ) {
             if ( in instanceof CharSequence ) {
                 return Instant.parse( (CharSequence) in);
             }
          }
          return null;
       }
     
To test this we add a command:

     public long epoch( Instant instant) {
        return instant.toEpochMilli();
     }

And run it:

    g! epoch 2011-12-03T10:15:30Z
    1322907330000
{: .shell }

## Options and Flags

Shells generally heavily use _options_ and _flags_. An option is an identifier, general starting with a `-` character, and a subsequent value. For example `-t 67` is an option. A flag is a a similar identifier but it has no subsequent value. The presence of the flag gives a value and the absence of the flag gives another value. For example, `-f` might indicate `true` but if the flag is not specified the value is `false`.

Together, options and flags are called _parameters_. Parameters are not treated any differently in the method that executes the function, they are plain old arguments. However, Gogo is provided their extra semantics with the `@Parameter` annotation. This annotation provides the name and optional aliases of the parameter (option or flags), the value when the parameter is not specified (absentValue) and for a flag it specifies a value when the parameter is specified.

For example, in the epoch command we would like to see the results as days, not as milliseconds, when the user specifies the `-d` flag. 

   public long epoch(
        @Parameter(
          names = "-d", 
          presentValue = "true", 
          absentValue = "false") 
        boolean days,
        Instant instant)
   {
      if (days)
         return instant.toEpochMilli() / (24*60*60*1000);
      else
         return instant.toEpochMilli();

   }

And run it:

    g! epoch 2011-12-03T10:15:30Z
    1322907330000
{: .shell }

Since there are only a limited number of characters in the alphabet, shell commands often have long names for parameters. The `@Parameter` annotation can therefore take an array of arguments. For example, instead of having flag for the _units_ of the output we can also specify an enum:

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
            Instant instant)
       {
            return instant.toEpochMilli() / unit.divisor;
       }

And run it:

    g! epoch -u years 2012-12-03T10:15:30Z
    42
{: .shell }

## Variable Number Of Arguments

Java allows the last argument of a method to hold a variable number of arguments. This is perfectly well supported in Gogo. When the parameter are parsed and the arguments filled and remaining arguments are coerced in the vararg argument if present. This pattern is very useful since it allows the user to specify many variables that the command can operate on. For example, a command to start bundles can be written as follows:

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

We call it `begin` because the Gogo shell usually already has a `start` command.

## Getting Direct Input

Sometimes you really want to ask the user. However, the way Gogo is designed means that your user could be in another continent. This clearly will void the use of the Console. So how do you talk to the user?

If the first argument of the  command function is a `CommandSession` then Gogo will automatically insert it. The Command Session is the way to to talk to the user and Gogo. For our purpose it has a `getKeyBoard()` method. This method bypasses any pipes and directoy goes to the user. This allows you to wait for input from the user. If the session is attached to a file as input a null is returned.

For example, the following command waits for the user to type a key. It is not guaranteed that each character is returned, some streams are buffered and wait until eof or return to send the content.

    public void anyKey(CommandSession session) throws Exception {
        InputStream keyboard = session.getKeyboard();
        if(keyboard==null)
           return;
        keyboard.read();
     }


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

These functions are represented by the `Function` interface. This is not the Java 8 Function interface, it is an interface that long before Java 8 was a glimmer in the eyes of its makers existed in Gogo. Its only fault was a name that was a tad too common. 

The following code implements a mapping function. It takes an iterable and a function and returns a list of objects that were processed by the function.

     public List<Object> map(CommandSession session, Iterable<?> it, Function f) throws Exception {
        List<Object> list = new ArrayList<>();
        for ( Object o : it) {
           Object r = f.execute(session, Arrays.asList(o));
           list.add(r);
        }
        return list;
     }

Such a function can be called with:

    g! map [ "abc" "defghi" "jklmnopq"] { $it length }
    3
    6
    8
{: .shell }

## Formatting the Return Value

