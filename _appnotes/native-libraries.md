---
title: Using Native Libraries in a Bundle
summary: Discusses the issues with native libraries and OSGi
---

Sometimes a bundle may contain several native libraries. One may be JNI
code and it may have dependencies on the other libraries. This article
discusses issues with dependencies between the native libraries. It is
based upon an
[email](http://www.mail-archive.com/users@felix.apache.org/msg10172.html)
from Holger Hoffstätte.

`> We are accessing native libraries from Java. This works outside of`  
`> OSGi and in OSGi on Windows but not on Linux probably because the dll`  
`> and so linking behave differently.`

Yes and no. They work differently, but you must understand why. Instead
of randomly "successful" expriments here is what happens & why, and what
you can do to load native code from bundles regardless of platform.

First off: the Bundle-NativeCode capabilitiy/idea is absolutely
fantastic and one of the most underrated & unknown features of OSGi. It
works well, but is naturally affected by the capabilities of the
underlying OS and Java's behaviour. Naturally this area is harder since
"write once, run anywhere" does not apply any longer when you venture
outside the JVM. Nobody just walks into native land.

I'll skip the case where you only have a single library, since that is
easy and not a problem on either platform. Just link all your JNI stubs
and whatever they call into one big dll/so and bingo; works everywhere.

As you have learned this is not so easy any more when you have two or
more libraries with dependencies between them. Since loading of
dependencies between native libraries works differently on different
OSes, there is nothing OSGi itself can do here; but understanding what
exactly happens will allow us to handle the differences in a transparent
manner.

First off let's understand what happens when Java loads a dll/so.

Regardless of the platform-specific call the library is loaded, and -
before the call returns - the OS will notice missing symbols (e.g.
functions defined in a dependent library) and start the
platform-dependent search for dependencies to satisfies the missing
bits. Windows will look in the current working directory of the process
(usually useless for OSGi) and then %PATH%, Linux will inspect
LD\_LIBRARY\_PATH
(https://blogs.oracle.com/rie/entry/tt\_ld\_library\_path\_tt) and then
consult the ld.so cache, usually located in /etc/ld.so.cache. This cache
contains a cached representation of the system-wide search paths usually
declared in /etc/ld.so.conf. This can be updated by e.g. an installer or
system management tool; see man ldconfig.

All of these mechanisms are unfortunately not too useful for OSGi, since
two or more libraries contained in & unpacked from a bundle are sitting
somewhere in a bundle cache - a private directory normally not visible
to the OS. So what can you do to trick the native platform loading into
doing the right thing?

Let's start with Windows since that is ironically the easiest case. As
some other posters have indicated you can indeed pre-load dependencies
in their correct order and then load your JNI library. The preloading
makes sure that the last loaded dependency has no missing symbols, and
the native search machinery does not kick in - problem averted.

Then you try this on Linux or OSX and realize that it Simply Does Not
Work (sorry Richard :). Why?

The POSIX/Unix/Linux system calls used for loading, accessing and
closing shared objects are called dlopen(), dlsym() and dlclose(). If
you look at dlopen(), it takes a filename (the library to load) and a
magic flag. The way the JVM calls dlopen() is the reason why preloading
does not work: the flag is by platform-default set to RTLD\_LOCAL, which
does NOT expose loaded symbols to subsequently loaded libraries
(contrary to Windows, where loaded symbols become visible). In other
words: manual preloading of dependencies on Linux fixes exactly nothing!
Whether this is just an unfortunate default, a bug or deliberate is a
different, complicated discussion about isolation, security, stability
etc. but ultimately does not matter since we cannot influence it.

Bummer. So what now, give up? Bah!

If preloading does not work then maybe we can make the OS do the right
thing instead. ld.so - the dynamic loader used for resolving library
dependencies - looks at a loaded object and obviously also needs to know
what else to load in case there are any declared dependencies. As it
turns out shared libraries can have a search path embedded and \*this
path can be manipulated\*. Quote from the ld.so man page:

`  $ORIGIN and rpath`  
`      ld.so  understands  the  string  $ORIGIN  (or  equivalently`  
`      ${ORIGIN}) in an rpath specification (DT_RPATH or DT_RUNPATH) to`  
`      mean the directory containing the application executable.`  
`      Thus, an application located in somedir/app could be compiled`  
`      with gcc -Wl,-rpath,'$ORIGIN/../lib' so that it finds an`  
`      associated shared library in somedir/lib no matter where`  
`      somedir is located in the directory hierarchy. [..]`

Awesomesauce! This means that you can build your native libraries with
e.g. -rpath,'\$ORIGIN' and loading one dependency (for example your JNI
stubs) will now correctly find any dependencies from the same directory.
Win!

But what if you don't have the source to the dependencies? Or even worse
you never learned how to compile C code?

Well, old people\^h\^h\^h\^h\^h\^h\^h enterprising individuals like me
would probably just bring out the old hex editor, but there is a more
civilized way: meet [patchelf](http://nixos.org/patchelf.html). For
anyone who wants to dive deeper you can also look at
<https://blogs.oracle.com/ali/entry/changing_elf_runpaths>; I managed to
make the author's "rpath" tool build & work on Linux with just a few
modifications.

patchelf is easy to build and allows you to inspect & modify the runpath
of any library. For an example let's find a library that has
dependencies:

(readelf is part of binutils, which you should have installed already)

`$readelf -d /usr/lib/libpcrecpp.so.0.0.0`  
  
`Dynamic section at offset 0x8dd4 contains 28 entries:`  
` Tag        Type                  Name/Value`  
`0x00000001 (NEEDED)              Shared library: [libpcre.so.0]`  
`0x00000001 (NEEDED)              Shared library:[libstdc++.so.6]`  
`0x00000001 (NEEDED)              Shared library: [libm.so.6]`  
`0x00000001 (NEEDED)              Shared library: [libc.so.6]`  
`0x00000001 (NEEDED)              Shared library: [libgcc_s.so.1]`  
`0x0000000e (SONAME)              Library soname: [libpcrecpp.so.0]`  
`0x0000000c (INIT)                0x2af8`

That should do: the C++ wrapper for pcre needs the core C pcre library
as dependency. Let's modify it!

`$cp /usr/lib/libpcrecpp.so.0.0.0 .`  
`$patchelf --set-rpath '.:$ORIGIN' libpcrecpp.so.0.0.0`  
`$patchelf --print-rpath libpcrecpp.so.0.0.0`  
`.:$ORIGIN`

And indeed:

`$readelf -d libpcrecpp.so.0.0.0`  
  
`Dynamic section at offset 0xa100 contains 29 entries:`  
` Tag        Type                  Name/Value`  
`0x0000001d (RUNPATH)             Library runpath: [.:$ORIGIN]`  
`0x00000001 (NEEDED)              Shared library: [libpcre.so.0]`  
`[..]`

This means that loading this library would make the ld.so loader look
for dependencies first in the current directory of the process (which
btw is a questionable practice, mostly for security reasons), and then
in the directory where the originating library is located..which could
be the completely unknown and anonymous bundle cache of the OSGi
runtime. Win!

So you modify all your .so libraries, package them into the bundle
and..OH NOES! It STILL does not work! Depending on the OSGi runtime you
still get errors about the native dependency not being found, despite
\$ORIGIN.

"You didn't think it would be that easy, did you? Silly Rabbit."

You see, what happens is that the OSGi runtime is at liberty to unpack
resources from a bundle lazily. This means that simply loading a
toplevel dependency is not enough, as any other bundle-included
dependencies may not yet have been unpacked, causing the native loader
to fail. The fix is easy: simply \*pretend\* to preload all libraries
(just like on Windows), but ignore any UnsatisfiedLinkErrors - and then
load the JNI stubs.

Et voilà: angels will sing, and your bundle will work.

To make this robust don't just sprinkle the System.loadLibrary() calls
throughout your classes; make a central Initializer class (bound to the
bundle's Activator or not..your choice) and refer to it. Then in that
activator you can have differetn loading strategies for Windows
(preloading nicely in-order), Linux (fake preloading) OSX (same as
Linux) or any other platform. It's also a good idea not to refer to the
classes in this bundle as "library" (i.e. passive code); make the native
code a service and properly track it from client bundles.

I hope this answers all your questions and gives you more rope to hang
yourself than you asked for.

