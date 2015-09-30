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

* €200 Gift certificate for the First prize.
* 2x €50 Gift certificate for two runner ups!

## How do I start!

* First, make sure you subscribe to the messages in the [forum](forum.html). This way we can keep you updated. This is also the place to make suggestions or ask questions. 
* Follow the OSGi enRoute tutorial. You might want to start with the [quick start tutorial][qs] and, when you have a Raspberry Pi, then the [IoT Tutorial][iot]. This will give you a good impression of what OSGi enRoute is all about.
* Clone the https://github.com/osgi/osgi.iot.contest.sdk workspace as a git repository and open it up in Eclipse.
* Read the [description of the architecture](/trains/200-architecture.html)
* Join the [forum](/trains/900-forum.html)
* Run the emulator by starting the `/osgi.enroute.trains.application/debug.bndrun` application (don't forget to resolve). If you don't know how to run a bndrun file you missed out a lot in your life and you did not follow the previous instruction to do the [quick start tutorial][qs] :-)
* Play with the example Train & Train Managers. 
* Create your own project in this workspace and write a Track Manager or Train Manager implementation. (Or both!) Make sure you name your project with a project name in your name space.
* Test it in the GUI with the emulator. You can easily control the bundles you want to try this out with in the `/osgi.enroute.trains.application/debug.bndrun` file.
* You are perfectly free to copy the existing code, it is all Apache Software License 2.0. However, this code does not handle some of the harder parts as menacing trains and missed RFID events. So feel free to use better planning software but realize we can change the track layout. Expect at least one other train to be there. If at any time you have questions, don't hesitate to ask on the [forum](/trains/900-forum.html). We really like to hear from you and some of us are more than willing to help out.
* Repeat ...
* If you're really ambitious then you can bring your own hardware like a camera, gas sensors, or geiger counter. In that case please contact us on [iot2015@osgi.org](mailto:iot2015@osgi.org) so we can discuss the details.
* At the OSGi Community Event, you can bring your bundle(s) to test them against the real life track. For this you need to make an appointment so we can properly schedule it. Send a mail to [iot2015@osgi.org](mailto:iot2015@osgi.org) and we give you a time.
* If you are unable to come to the conference because you think it is too much fun to handle then you can also submit your bundles via a Github repository. Just clone the [OSGi IoT 2015 Contest][repo] repository and send us the Github URL by mail at least before October 31 midnight UTC. Don't forget the instructions and make sure it is buildable without errors and warnings in Gradle & Eclipse. 
* Wednesday Evening Nov. 4 at the exhibit place around 17.45 before the Exhibitor's reception in the exhibitor area. There we will have several runs of your and other bundles in any mix we see fit. During those runs we will introduce a number of variations of the track layout so be prepared. A jury will judge the bundles by how they perform. For a Track Manager we will judge it on how it manages the signals, switches, and train management. For a Train Manager we will look at how it handles planning with unexpected events like missing RFIDs detections and blockages.
* The winners of the competition will be selected and announced on the final day of the conference during the wrap up.

## Dates

* October 1 – Start, SDK Available
* November 3 & 4 – Real track time available by appointment: [iot2015@osgi.org](mailto:iot2015@osgi.org)
* November 4 at 17.45 – Running the different combinations of bundles
* November 5 at 3pm (wrap up) – Announcement of the winner 

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
[repo]: https://github.com/osgi/osgi.iot.contest.sdk
