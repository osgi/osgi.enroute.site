---
title: Assignments
layout: book
summary: How do the assignments
---

The contest has two possible categories for submissions. You either write a Train Manager or a Track Manager. That said, we do enjoy other submissions as well.

You're free to use any technology that you want, there are no real limits. (Though we prefer it when you keep the number of dependencies a low.) 

To keep our life workable you will have to write the code in OSGi enRoute. This means bnd(tools) and gradle. There are a number of tutorials on the enRoute.osgi.org web site. Hope you will enjoy it.

Make sure you create a unique name for your project so we can run all the examples from a single workspace.

The track is not hard coded. The Track Info service provides a description of the track. Be careful, this description might change so do not assume you know how the track looks like. If you're adventurous you can change the track layout in the application. In the applications' `configuration/configuration.json` resource you can the configurations.

Obviously we worked hard to make this whole SDK work well. However, we're human and make errors. Fortunately this is open source so it is easy to help improve this SDK. If you add some cool feature to the GUI, make the emulator more useful, or improve the documentation then we're more than interested to receive a Pull Request. Believe us experts, we're not that brilliant so we do look forward to learn from you.

Since we already said we're not brilliant we want to warn you that we probably update the SDK a few times in the coming period. Please poll the [forum][forum] regularly and pull from the repository.

Also, please don't work on your own. There is a [forum][forum] and we're sincerely hoping that we get a lot of discussions there. Don't for a second hesitate to ask a question there. We can assure you that if you have a question, there are others with the same question. And there is no such thing as a stupid question except for the one that is not asked. (OK, there might be some exceptions to that rule. Don't ask us what the best OSGi Framework is.)

## Train Manager

The Train Manager can control the train, it basically can set the speed of the train. It must wait for an assignment to go to a specific segment, plan a route, and then move the train along the track.


That is easier said then done. The RFID is not very reliable so you must make sure the train is not moving very fast when you pass it. So you can always go very slow but that will not impress the jury. Planning is also interesting because there could be blocked segments so you have to avoid those.

The example train manager works fine in a perfect world. However, it breaks when it there are blocked segments or an RFID is missed or assignments are changed in mid-session. 

The example approach of the train manager is to use a single thread, get the events, and react to them. You can turn this into a completely asynchronous approach with promises. Or ... Up to you.  

It is your task to turn this Train Manager into something more robust that can also live in a world with other trains, failures, and blockages. 

Technically speaking this means you must implement the Train Manager service. The easiest way to get started is to make a copy of the osgi.enroute.train.manager.examnple.provider project. This will give you a head start. That said, we do have a soft spot for people that think they can do it better!

## Track Manager

The Track Manager is in the clouds. It is responsible for managing the signals, switches, and the access to the tracks. It's task is that trains do not derail because the switches are set wrong or trains run into each other because the signals are set wrong. This can be a daunting task when every behaved but this is the real world. Signals and switches can fail. Events can be missed, RFIDs can disappear.

The example Train Manager is implementing its task in a simple way and will not work well in the real world because it assumes good weather. It is your task to turn the Train Manager in a robust implementation that will keep the passengers safe and without too much delay.

As the Track Manager you must implement the Track* services. There are a number of those because they have different audiences. The easiest way to get started is to make a copy of the osgi.enroute.track.manager.example.provider project. We love people that think they know better so you can also ignore it. (Of course it is kind of a conditional love; you really then should deliver!)

## More

The contest is about Track and Train Managers. However, we've included the projects for the other parts as well, including the GUI and the code that runs on the Raspberry's. This code will be updated since it is not ready yet and when time permits we will try to update the GUI a bit. One thing we'd like to do is add an editor for tracks. Volunteers?

Feel free to ask us about that and to submit Pull Requests if you think you got a better idea. This is not a quiz or school exam. We love OSGi and this contest is just a way to play with OSGi in a context that is a lot more exciting than a b***ng payroll app. We can assure you that if you have ideas in this context then we're more than willing to see if we can accommodate then=m.   

Have fun and keep us posted!

[forum]: http://enroute.osgi.org/trains/900-forum.html