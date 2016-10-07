---
title: Prerequisites
layout: tutorial
lprev: /book/500-tutorial_iot.html
lnext: 120-exploring.html
summary: The prerequisites for the use of OSGi enRoute (Important!)
---

{% include prerequisites.md %}

## Raspberry Pi Setup

Ok, now about that Raspberry Pi. This tutorial assumes a Raspberry Pi 2 model B. This model is compatible with the Raspberry [Pi 1 Model B+][pimodel2b]. See the [Raspberry Pi][pi] and [Pi4j][pi4j]  sites for compatibility details. Note that the Raspberry 2 is surprisingly much faster, faster than you would expect from the technical specifications.

## Booting the Pi

There are lots of resources with pictures and videos if you want that get you start with the Raspberry Pi, see [the Raspberry Pi quick start guide][piqs] or just search Google. 

The state you want to reach before you continue is that you can log in with SSH into the Raspberry Pi. In this tutorial we will [use the address 192.168.2.4][pinetw] as the address of our raspberry. For example:

	$ ssh pi@192.168.2.4
	Linux raspberrypi 3.12.22+ #691 PREEMPT Wed Jun 18 18:29:58 BST 2014 armv6l

	The programs included with the Debian GNU/Linux system are free software;
	the exact distribution terms for each program are described in the
	individual files in /usr/share/doc/*/copyright.

	Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
	permitted by applicable law.
	Last login: Thu Jun 18 07:42:02 2015 from 192.168.67.102
	pi@raspberrypi ~ $ 
{: .shell}

## Java

Java 8 is now included in the [NOOBS distribution][noobs]. So in the shell, you should be able to do:

	pi@raspberrypi ~ $ java -version
	java version "1.8.0"
	Java(TM) SE Runtime Environment (build 1.8.0-b132)
	Java HotSpot(TM) Client VM (build 25.0-b70, mixed mode)
{: .shell}

The build numbers should be regarded as minimum. Java is installed on the latest Raspian OS but if Java is not installed on your machine, then you can download it from [Oracle's Java Embedded site][java] and install it locally. You might want to search for [java + Raspberry Pi on Google][javapi]. 

## Goodies

To experiment with the Raspberry Pi we will need some sensors and actuators. It also helps to have a little breadboard and wires. It is amazing what you can get at amazon nowadays. If you can afford it, the [SunFounder][sunfounder] kit is like a boy's dream but for this tutorial you just need:

* An couple of LEDs with ± 220 Ω resistors
* A few button/switches that you can plug into a breadboard
* A breadboard
* Some wires female-male to connect the Raspberry to the breadboard.

Any local electronics store has this material. If you need a reference, these parts are included in the [SunFounder Sidekick Starter Kit](http://www.amazon.com/SunFounder-Sidekick-Breadboard-Resistors-Mega2560/dp/B00DGNZ9G8/ref=sr_1_4?s=electronics&ie=UTF8&qid=1434719207&sr=1-4&keywords=breadboard).

![Alt text](http://ecx.images-amazon.com/images/I/71lHGMCOODL._SL1000_.jpg)

## Remote bnd Debugging

Almost there, we only need one more install! The OSGi enRoute tool chain has a remote debugging facility. 
Remote debugging from bnd(tools) requires an _agent_ to be running inside an OSGi framework. 
However, in this case we would also like to define the actual framework in bnd(tools), we just need a 
program that installs a framework with an agent defined in a bnd(tools) bndrun file. This is the 
`biz.aQute.remote.main` program. Let's install it


	pi@raspberrypi ~ $ curl -o bndremote.jar curl http://repo1.maven.org/maven2/biz/aQute/bnd/biz.aQute.remote.main/3.3.0/biz.aQute.remote.main-3.3.0.jar 
	pi@raspberrypi ~ $ sudo java -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=1044 -jar bndremote.jar -n 192.168.2.4
	Listening for transport dt_socket at address: 1044
{: .shell}
	
This will start the bnd remote main program in the Java debug mode and will listen to port 1044. This will allow us to debug OSGi enRoute applications in bndtools on another machine.

As you can see, we start the command with `sudo`, this is required to use the general purpose IO on the device. The `-n` option indicates the network we are running on, if you don't specify this you can only use the agent from the same machine (i.e. localhost). 

## Setting Up bndtools

The next setup is the Eclipse works. Please follow the [quick start tutorial][qs] or if you're ambitious the [base tutorial][base]. For this tutorial, you should create a new workspace as described in the tutorials. Make sure you get the latest version workspace from github.

[java]: http://www.oracle.com/technetwork/java/javase/downloads/jdk8-arm-downloads-2187472.html
[pi]: https://www.raspberrypi.org/
[pimodel2b]: http://pi4j.com/pins/model-2b-rev1.html
[pi4j]: http://pi4j.com/
[piqs]: https://www.raspberrypi.org/help/quick-start-guide/
[pinetw]: https://www.raspberrypi.org/documentation/troubleshooting/hardware/networking/ip-address.md
[noobs]: https://www.raspberrypi.org/new-raspbian-and-noobs-releases/
[javapi]: https://www.google.fr/search?q=raspberry+pi+java
[qs]: http://enroute.osgi.org/book/200-quick-start.html
[base]: http://enroute.osgi.org/book/220-tutorial-base.html
[sunfounder]: http://www.amazon.com/SunFounder-modules-Raspberry-Sensor-Extension/dp/B00HU0G9TO/ref=sr_1_1?ie=UTF8&qid=1434718754&sr=8-1&keywords=raspberry+pi+sensors&pebp=1434718756184&perid=1EEX5GD8E2YX258S7SQ0