---
title: Assignments - Some hints and tips
layout: default
summary: How to do the assignments
---

The OSGi IoT Contest 2015 has been set up to offer two clear categories for submissions that you can write:

* a Train Manager or 
* a Track Manager. 

That said, if you have ideas for other categories that you could write something for then that would be great, and you are welcome  to do so.

You're free to use any technology that you want, there are no real limits. (Though we prefer it when you keep the number of dependencies low). 

To keep our life workable you will have to write the code in OSGi enRoute. This means bnd(tools) and gradle. There are a number of tutorials on the enRoute.osgi.org web site. We hope you will enjoy it and welcome your feedback on your experience with this too.

Make sure you create a **unique name** for your project so we can run all of the examples from a single workspace.

**Beware** - The track is not fixed / hard coded. The Track Info service provides a description of the track. Be careful, this description might change so do not assume you know the track layout. If you're adventurous you can change the track layout in the application by changing the configurations in the applications' `configuration/configuration.json` resource.

Obviously we worked hard to make this whole SDK work well. However, we're human and make errors. Fortunately this is open source so it is easy to help improve this SDK. If you add some cool feature to the GUI, make the emulator more useful, or improve the documentation then we're more than interested to receive a Pull Request. We really do encourage contributions and improvements and look forward to hoepfully learning some new things from you.

As we already said, we're not perfect and therefore we want to warn you that we will probably update the SDK a few times in the coming period. Please poll the [forum][forum] regularly and pull from the repository.

Also, please don't work on your own. There is a [forum][forum] and we're sincerely hoping that we get a lot of discussions there. Don't for a second hesitate to ask a question whatever it is, even if you think its simple or stupid. We can assure you that if you have a question, there will be others with the same question. And there is no such thing as a stupid question except for the one that is not asked. (OK, there might be some exceptions to that rule. Don't ask us what the best OSGi Framework is.)

## Train Manager

The Train Manager can control the train, basically by setting the speed of the train. It must wait for an assignment to go to a specific segment, plan a route, and then move the train along the track.

This is easier said then done in reality. The real world doesnt always equal the emulator behavior. For example the RFID is not very reliable so you must make sure the train is not moving very fast when you pass it. So you could set it so that the train always goes very slow - but that will not impress the panel. Planning is also an interesting aspect because there could be blocked segments which you will have to avoid.

The example Train Manager works fine in a perfect world. However, it breaks when there are blocked segments, or if an RFID is missed, or if assignments are changed in mid-session. 

The example approach of the Train Manager is to use a single thread, get the events, and react to them. You might choose to turn this into a completely asynchronous approach with OSGi Promises. Or ... its up to you, the only limits are your imagination and skill. 

It is your task to turn this Train Manager into something more robust that can also live in a physical world where there are other trains, failures, and blockages. 

Technically speaking this means you must implement the Train Manager service. The easiest way to get started is to make a copy of the osgi.enroute.train.manager.examnple.provider project. This will give you a head start. However, we do have a soft spot for people that think they can do it better, so please write your own if you think you can improve it - you will get bonus points of you are successful!

## Track Manager

The Track Manager is in the Clouds. It is responsible for managing the signals, switches, and the access to the tracks. It's tasks are to ensure that trains do not derail because the switches are set wrong or that trains run into each other because the signals are set wrong. This can be a daunting task in the real (physical) world. Signals and switches can fail, events can be missed, RFIDs can disappear.

The example Train Manager is implementing its task in a simple way and will not work well in the real (physical) world because it assumes good weather :-). It is your task to turn the Train Manager in to a robust implementation that will keep the passengers safe and the trains keeping to their timetable!

As the Track Manager you must implement the Track* services. There are a number of these because they have different audiences. The easiest way to get started is to make a copy of the osgi.enroute.track.manager.example.provider project. We love people that think they know better so you can also ignore it. (Of course it is kind of a conditional love; you really then should deliver!)

## More

The Contest is primarily about Track and Train Managers. However, we've included the projects for the other parts as well, including the GUI and the code that runs on the Raspberry Pi's. This code will be updated since it is not ready yet and when time permits we will try to update the GUI a bit. One thing we'd like to do is add an editor for tracks. Any Volunteers? We would love to hear from you on the [forum][forum] and please do submit Pull Requests if you think you have got a better idea. 

This is not a quiz or school exam. We love OSGi and this Contest is just a way to show its relevance in the flourishing IoT market and to give you an opportunity to play with OSGi in a context that is a lot more exciting than a b***ng payroll app. We can assure you that if you have ideas on how we can improve our demo and teh Contest then we're more than willing to see if we can accommodate them.   

Have fun and keep us posted on the [forum][forum]!

[forum]: http://enroute.osgi.org/trains/900-forum.html
