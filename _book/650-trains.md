---
title: OSGi IoT Contest 2015
layout: book
---

Welcome to the home page of the [OSGi Software Development Kit (SDK)](https://github.com/osgi/osgi.iot.contest.sdk) for the OSGi IoT Contest 2015! 

The contest will be judged on November 3 at the [OSGi Community Event 2015](http://www.osgi.org/CommunityEvent2015) which is being co-located with [EclipseCon Europe 2015](ce) (November 3 to 5) in Ludwigsburg, Germany.  

The prizes for the winner and two runners up are:

* €200 Amazon Gift certificate for the winner
* €50 Amazon Gift certificate each for two runners up

The competition is open to all, whether you will be able to join us at the OSGi Community Event 2015 or not.  Clearly we would love to see you in person at the conference ([Register Here](https://www.eclipsecon.org/europe2015/registration)) and if you can join us you will have the opportunity to test your entry out on the real track before the judging takes place.  This also gives you a slightly longer timeline to submt your entry as you will have from now until November 5.

If you cant join us for the conference you can [submit your entry by email](mailto:iot2015@osgi.org?subject="OSGi IoT Contest 2015 Entry").  The deadline for email submissions is midnight Pacific Time on Saturday October 31.

We have setup a Forum for you to ask any questions about the competition, be it logistics, technical, or whatever. Please [join the forum](/trains/900-forum.html) if you plan to make a submission or even if you are just interested in learning more.

## Why an OSGi IoT Contest?

Every year the OSGi Alliance organizes a contest for developers to demonstrate the power of OSGi in the IoT world. Being able to reliably run the same code in the cloud as on small devices is a very compelling proposition. For the developers it is also fun way to demonstrate their skills.

## What is the 2015 Contest about?

The 2015 contest is all about _trains_. We will have a LEGO® train track setup at the conference that will include multiple trains, signals, RFIDs, and switches. We will provide the whole infrastructure, you provide the brains to create extensions to our environment.  

We have two categories in this domain:

* Track Manager – The track manager is running in the cloud and is responsible for the overall track infrastructure. A track manager can control the switches, the signals, and it receives the RFID. It also dispatches the events so that the other participants know what is going on.
* Train Manager – The train manager is is responsible for navigating the train. A train manager is assigned a position and the software must then navigate through the track to that destination. This requires getting permission to use segments of the track, obeying the signals, and making sure the train does not speed.

## What do I need to do to enter the Contest?

You will have to develop a Track or Train Manager bundle using the [_Software Development Kit_ (SDK)](https://github.com/osgi/osgi.iot.contest.sdk). The SDK contains an emulator and a GUI that will enable you to write OSGi bundles for this environment. 

In the Exhibition area of the conference we will have a stand where the LEGO® train track will be on display.  Inegrated with this track layout will be an OSGi Cloud, provided by the [Paremus Service Fabric](http://www,paremus.com), and a number of Raspberry Pi's which will all be connected together across a network. 

We will take the bundles from the participants, upload them in the [Prosyst mPRM](http://www.prosyst.com) Device Management System that controls the Raspberry Pi's. The mPRM will be running in the Cloud and will be used to deploy the OSGi bundles to the Raspberry Pi's.  We then plan to run the code entered by the contest participants to see how they perform on the real track. We also plan to mix and match bundles from different entries to show how these different components can be used together. 

## Judging and the Prizes

The winner will be selected by a panel made up of OSGi Alliance representatives and technical experts.  They will be looking at general aspects including:
- Originality of idea
- Successful operation (did it work?)
- Interoperability (did it play nice with other components on the track?)

They will also be looking for specific aspects as follows:
- For a Track Manager: how it manages the signals, switches, and train management. 
- For a Train Manager: how it handles planning with unexpected events like missing RFID detections and blockages.

There are three prizes on offer, 1 for the winner and 1 each for two runners up:
* €200 Amazon Gift certificate for the winner
* €50 Amazon Gift certificate each for two runners up

## How do I start!

1. First, make sure you subscribe to the messages in the [forum](/trains/900-forum.html). This way we can keep you updated. This is also the place to make suggestions or ask any questions (logistics, rules, technical, etc). 
2. Follow the OSGi enRoute tutorial. You might want to start with the [quick start tutorial][qs] and, when you have a Raspberry Pi available, follow the [IoT Tutorial][iot]. This will give you a good understanding of what OSGi enRoute is all about and assist you with entering the contest.
3. Clone the https://github.com/osgi/osgi.iot.contest.sdk workspace as a git repository and open it up in Eclipse.
4. Read the [description of the architecture](/trains/200-architecture.html)
5. Join the [forum](/trains/900-forum.html)
6. Run the emulator by starting the `/osgi.enroute.trains.application/debug.bndrun` application (don't forget to resolve). If you don't know how to run a bndrun file you missed out a lot in your life and you did not follow the previous instruction to do the [quick start tutorial][qs] :-)
7. Play with the example Train & Train Managers. 
8. Create your own project in this workspace and write a Track Manager or Train Manager implementation. (Or both!) Make sure you name your project with a project name in your name space.
9. Test it in the GUI with the emulator. You can easily control the bundles you want to try this out with in the `/osgi.enroute.trains.application/debug.bndrun` file.
10. Repeat .....
 
If you have questions, don't hesitate to ask on the [forum](/trains/900-forum.html). We will really like to hear from you and the team from the OSGi Alliance and some of its Member companies, who have created this, will be pleased to help you out.


## More info

You are welcome to copy the existing code, it is all Apache Software License 2.0. However, this code does not handle some of the harder challenges such as missed RFID events or menacing trains :-). So feel free to use or implement better planning software, however please be aware that the track layout may be changed. You should also expect at least one other train to be in use at the same time on the track. 

* If you're really ambitious then you can include your own sensors such as a camera, gas sensor, or geiger counter in your entry.  However if you do so you must be prepared to bring these sensors with you to the conference so that we can jusge your entry. If you do plan on adding your own hardware please contact us [by email](mailto:iot2015@osgi.org).

* At the OSGi Community Event, you can bring your bundle(s) to test them against the real life track. For this you need to make an appointment so we can schedule it. Send a mail by no later than 9am Pacific Time on Friday October 30 to [book a test slot](mailto:iot2015@osgi.org?subject="OSGi IoT Test Slot") and we will send you a time.  Please note test slots will be allocated on a first come first served basis so we recommend you requesting a slot as soon as you can.

* If you are unable to join us at the conference then you can also submit your bundles via a Github repository. Just clone the [OSGi IoT 2015 Contest][repo] repository and send us the Github URL [by email](mailto:iot2015@osgi.org?subject="OSGi IoT Contest 2015 Entry") no later than midnight Pacific Time on October 31. Don't forget to provide instructions on how to use it and make sure it is buildable without errors and warnings in Gradle & Eclipse. 

* The contest will be held on Wednesday November 4 from 17.45 at the OSGi stand in the Exhibition area. There we will have several runs of your's and other peoples submissions and may use the bundles in any mix we see fit. During those runs we will introduce a number of variations of the track layout so be prepared. 

* The winner and two runners up will be announced during the Closing Session (15.00 to 15.45) of the conference.

## Important Dates & Deadlines

* October 1 – Contest launch date, SDK Available, sign up to the [forum](forum.html) asap
* October 31 (midnight Pacific Time) - submission deadline for entry's if not attending OSGi Community Event 2015
* November 3 & 4 – Testing on the 'real' track. Test slots available by advance appointment only [by email](mailto:iot2015@osgi.org?subject="OSGi IoT Test Slot")
* November 4 at 17.45 – The contest and juding commences. 
* November 5 between 15.00 to 15.45 – Announcement of the winner and two runners up at the conference Closing Session.

## Thanks

Many thanks to [iMinds](https://www.iminds.be/en), [Paremus](http://www.paremus.com) and [ProSyst](http://www.prosyst.com), along with other individuals from the OSGi Alliance, for their support in providing software and development time and resources for the creation of the demo and and contest.

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
