---
title: Exploring
layout: tutorial
prev: 100-prerequisites.html
next: 140-develop.html
summary: Exploring the Pi
---

## What Will You Learn

The Raspberry Pi is humming, you're logged into the Raspberry via ssh, java works,and bndtools is showing an empty workspace with only the cnf directory. In this section we will start exploring the Raspberry in the most basic way. We will create an application project that we then use to first just create a little component that plays with the hardware in a component. 

## Create Application Project

In the workspace, create a project. In this tutorial this project is called `osgi.enroute.examples.iot.domotica.application`, but you should obviously give it a name dear to you, just make sure it ends with `.application` since the OSGi enRoute template uses that extension to provide the proper project structure for a web application. It should therefore go without saying, that you should select the OSGi enRoute template when asked.

The following code assumes the `osgi.enroute.examples.iot.domotica.application` name and from this name it derives package names. If you choose your own names, make sure to proper translate these derived names.

## Hello World 

An OSGi enRoute Application project is a full web application with REST but we are first going to ignore those goodies. As always, the easiest app is to say `Hello World` (and on OSGi also `Goodbye World!`). So lets create a component in the `osgi.enroute.examples.iot.domotica.provider` package that performs these highly complex actions:

	package osgi.enroute.examples.iot.domotica.provider;
	
	import ...
	
	@Component
	public class UsePi {	
		@Activate void activate() {
			System.out.println("Hello World");
		}
		@Deactivate void deactivate() {
			System.out.println("Goodbye World");
		}
	}

Make sure you add the package to the private packages of the bundle. You can do this by double clicking on the `provider.bnd` file, select the `Contents` tab and drag the package in the `Private Package` list.

## Remote Debugging

The OSGi enRoute Application template has created a complete runnable project. The `osgi.enroute.examples.iot.domotica.bndrun` file has a specification for running this application on an OSGi server that contains an HTTP server an other necessities in life. However, in this case we will use  the `debug.bndrun` run specification. This run specification inherits its setup from the `osgi.enroute.examples.iot.domotica.bndrun` file, it just adds a number of useful debugging bundles.

So double click this file and go to the `Source` tab. In the editor, add the following instruction:

	-runremote: \
		pi; \
			jdb=1044; \
			host=192.168.2.4

Obviously you have to change the IP number to the one you are using. In the [pre-requisites](100-prerequisites.html) we should have started the bnd remote main program via ssh:

	$ ssh pi@192.168.2.4
	pi@raspberrypi ~ $ sudo bndremote -n 192.168.2.4
	Listening for transport dt_socket at address: 1044
{: .shell}

We now need to _resolve_ the run specification. On the `debug.bndrun`, select the `Run` tab and click the `Resolve` button.

The next step is to run this Run specification. Select the `debug.bndrun` file and call up the context menu, and select `@/Debug As/Bnd Native Launcher`. This will cause bnd to start the debugger and look for a remote agent on the specified host.

 

 The first attempt is to work with the Raspberry Pi's hardware. Some background.








The OSGi enRoute distro contains a bundle `osgi.enroute.iot.pi.provider`. This bundle contains [Pi4j][pi4j], which is a Java library based on [Wiring Pi][wiringpi], a native code library to control the BCM2835 chip in the Raspberry Pi, which will be our gateway to leave the cyberworld and talk to things. This bundle is designed to work with the `osgi.enroute.iot.circuit.provider` bundle, however, we will first descent to the Pi4J level. The  `osgi.enroute.iot.pi.provider` bundle also registers  a Pi4J

  


## Installing the Circuit Application

Among the [OSGi enRoute bundles][bundles] there is a small application that can wire components to the Raspberry Pi hardware. This application is available from jpm, so let's install the latest version (with the @* suffix you get the latest snapshot):

	pi@raspberrypi ~ $ sudo jpm install osgi.enroute.iot.circuit.application.launch@*
	pi@raspberrypi - $ circuit
	[INFO] Started Jetty 8.1.14.v20131031 at port(s) HTTP:8080 on context path /
	....
	[DEBUG] Reusing context with id []
	____________________________
	Welcome to Apache Felix Gogo
	
	Web server
	g! 
{: .shell}

Let's see on what kind of Raspberry we're running:

	g! pi:info
	----------------------------------------------------
	HARDWARE INFO
	----------------------------------------------------
	Serial Number     :  00000000237a3302
	CPU Revision      :  5
	CPU Architecture  :  7
	CPU Part          :  0xc07
	CPU Temperature   :  43.3
	CPU Core Voltage  :  1.2
	CPU Model Name    :  ARMv7 Processor rev 5 (v7l)
	Processor         :  3
	Hardware Revision :  a01041
	Is Hard Float ABI :  true
	Board Type        :  Model2B_Rev1
	----------------------------------------------------
	MEMORY INFO
	----------------------------------------------------
	Total Memory      :  972111872
	Used Memory       :  191946752
	Free Memory       :  780165120
	Shared Memory     :  0
	Memory Buffers    :  22642688
	Cached Memory     :  97341440
	SDRAM_C Voltage   :  1.2
	SDRAM_I Voltage   :  1.2
	SDRAM_P Voltage   :  1.225
	----------------------------------------------------
	OPERATING SYSTEM INFO
	----------------------------------------------------
	OS Name           :  Linux
	OS Version        :  3.18.7-v7+
	OS Architecture   :  arm
	OS Firmware Build :  7789db485409720b0e523a3d6b86b12ed56fd152 (clean) (release)
	OS Firmware Date  :  Feb 14 2015 22:23:03
	----------------------------------------------------
	JAVA ENVIRONMENT INFO
	----------------------------------------------------
	Java Vendor       :  Oracle Corporation
	Java Vendor URL   :  http://java.oracle.com/
	Java Version      :  1.8.0
	Java VM           :  Java HotSpot(TM) Client VM
	Java Runtime      :  Java(TM) SE Runtime Environment
	----------------------------------------------------
	NETWORK INFO
	----------------------------------------------------
	Hostname          :  raspberry
	IP Addresses      :  192.168.2.4
	Nameserver        :  192.168.2.1
	----------------------------------------------------
	CODEC INFO
	----------------------------------------------------
	H264 Codec Enabled:  true
	MPG2 Codec Enabled:  false
	WVC1 Codec Enabled:  false
	----------------------------------------------------
	CLOCK INFO
	----------------------------------------------------
	ARM Frequency     :  600000000
	CORE Frequency    :  250000000
	H264 Frequency    :  0
	ISP Frequency     :  250000000
	V3D Frequency     :  250000000
	UART Frequency    :  3000000
	PWM Frequency     :  0
	EMMC Frequency    :  250000000
	Pixel Frequency   :  25200000
	VEC Frequency     :  0
	HDMI Frequency    :  163683000
	DPI Frequency     :  0
{: .shell}

This is likely more than you ever wanted to know about your Raspberry. What other commands are there?

	g! pi
	refreshed
	pi:* commands. These directly manipulate the GpioController.
	create <name> <pin>           – create a digital pin
	test <name>                   – set a pin low/high 20 times
	pins                          – show the pins
	blink <name> <time>           – use the Pi4J blink function
	high <name>                   – set a pin high
	low <name>                    – set a pin low
	info                          – show all the info of the board
	reset                         – reset the controller
	
	Pin numbers follow Pi4J GPIO numbers, see http://pi4j.com/pins/model-2b-rev1.html
{: .shell}

## The Beef!

It is time to go down to the hardware. It is kind of surprising what kind of sensors you can buy for less cost than a Starbucks' coffee today but we'll start simple. We will start with an LED. Let's take the example from [Gordons Projects][gordon] since this is the author of the library that we're using deep down in native code. We 'reuse' his pictures with his gracious permission but we adapt the text to use our `pi` commands.

### A Single LED

Note: This is a verbatim copy of 
To make sure it all works we first see if we can get an LED to turn on. The Raspberry connector looks like:


![Model 2B pins](http://pi4j.com/images/j8header-2b.png)


Before we even get started with the GPIO, lets make an LED light up by simply wiring it to the +3.3v supply and 0v.

![Simple LED on 3.3V](/img/tutorial_iot/simple-led.jpg)  

We have a yellow wire from the Pi’s +3.3v supply to the breadboard and this connects to an LED then via a 270Ω (ohm) resistor to 0v. The green wire connects back to the Pi.(Note that in general your breadboard might be different than the one shown here. In general breadboard have a strip of holes colored red, which you want to connect to the plus, and colored blue, which is Gnd).

A quick word about the electronics involved. LEDs are Light Emitting Diodes and the diode part is important for us – they only pass electricity one way, so we need to make sure we put them in the right way round. They have a long leg and a slightly shorter leg. The long leg goes to the plus side and the shorter leg to the negative (or 0v) side. If we’re cut the legs short (as I have done here), then another way is to look at the side of the LED – there will be a flat section. Think of the flat as a minus sign and connect that to the 0v side of the circuit.

If we allow too much current through the LED, it will burn very bright for a very short period of time before it burns out, so we need a resistor to limit the current. Calculating the resistor value is not difficult but for now, just use anything from 270Ω to 330Ω. Anything higher will make the LED dimmer.

Refer to the diagram here to work out the pins we’re using. From this view the 3.3v pin on the GPIO connector is to the top-left, or pin number 1 on the connector. The Gnd pin is number 6, or the outer third pin from the top.

We need to move the yellow wire to one of the programmable GPIO pins. We’ll move it to wiringPi pin 0 (GPIO-00 for us) which is notionally the first user GPIO pin. (It’s physical location is pin 11 on the GPIO connector)

![GPIO-00 LED](/img/tutorial_iot/gpio00-led-3d.jpg)

Do check against the wiring diagram to work out which pin on the connector to use. The LED will initially be off because normally the GPIO pins are initialized as inputs at power-on time.

[bundles]: https://github.com/osgi/osgi.enroute.bundles
[gordon]: https://projects.drogon.net/raspberry-pi/gpio-examples/tux-crossing/gpio-examples-1-a-single-led/
[pi4j]: http://pi4j.com/
[wiringpi]: http://wiringpi.com/
