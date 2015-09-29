---
title: OSGi IoT Contest 2015
layout: book
---

You landed on the home page of the OSGi Software Development Kit for the IoT Contest! 

## Why an OSGi IoT Contest?

Every year the OSGi Alliance organizes a contest for developers to demonstrate the power of OSGi in the IoT world. Being able to reliably run the same code in the cloud as on small devices is a very compelling proposition. For the developers it is also fun because it is a way to demonstrate their skills.

## What is the contest about?

This year (2015) the contest is about _trains_. In [Ludwigsburg][ce] we will have a nice LEGO® track with multiple trains, signals, RFIDs, and switches. We provide the whole infrastructure, you provide the brains.  

We have two categories in this domain:

* Track Manager – The track manager is running in the cloud and is responsible for the overall track infrastructure. A track manager can control the switches, the signals, and it receives the RFID. It also dispatches the events so that the other participants know what is going on.
* Train Manager – The train manager is is responsible for navigating the train. A train manager is assigned a position and the software must then navigate through the track to that destination. This requires getting permission to use segments of the track, obeying the signals, and making sure the train does not speed.

## When is this contest?

The OSGi Community Event 2015 is co-located with EclipseCon Europe 2015, in Ludwigsburg, Germany (November 3-5). Registered attendees have access to both conference programs, including the OSGi IoT demo.

## How does it work?

You will have to develop a Track or Train Manager bundle using the _Software Development Kit_ (SDK). The SDK contains an emulator and a GUI that will enable you to write bundles for this environment. 

During the OSGi DevCon we will install a real LEGO® track with a Paremus Service Fabric cloud server and a number of Raspberry Pi's. All connected in a network. We will take the bundles from the participants, upload them in the Prosyst mPRM Device Management System that controls the Raspberry Pi's. We will then mix and match the bundles from different participants and let them run for some time. 

The winner will be selected by a jury consisting of OSGi board members that will judge the bundles on how elegant they perform their task. The prizes are:

* ?????????????

## How do I start!

* First, make sure you subscribe to the messages in the [forum](forum.html). This way we can keep you updated. This is also the place to make suggestions or ask questions. 
* Follow the OSGi enRoute tutorial. You might want to start with the [quick start tutorial][qs] and, when you have a Raspberry Pi, then the [IoT Tutorial][iot]. This will give you a good impression of what OSGi enRoute is all about.
* Clone the https://github.com/osgi/osgi.iot.contest.sdk workspace as a git repository and open it up in Eclipse.
* Read the [description of the architecture](/trains/200-architecture.html)
* Join the [forum](/trains/900-forum.html)
* Run the emulator by starting the `/osgi.enroute.trains.application/debug.bndrun` application (don't forget to resolve).
* Modify/Play with the example Train & Train Managers.
* Create your own project in this workspace and write a Track Manager or Train Manager. (Or both!)
* Test it in the GUI
* Repeat
* At the OSGi Devcon, you can bring your bundle to test it against the real track
* At ????????? we will have a contest where we will several runs of the bundles. During those runs we will introduce a number of variations of the track layout so be prepared.

The winners of the competition will be selected and announced on the final day of the conference.

## More to read

<div>
<ol>

{% for service in site.trains %}<li><a href="{{service.url}}">{{service.title}}</a> – {{service.summary}}</li>
{% endfor %}

</ol>
</div>

[ce]: https://www.eclipsecon.org/europe2015/
[iot]: /book/500-tutorial-iot.html
[qs]: /200-quick-start.html

