---
title: The OSGi IoT Trains SDK Architecture
layout: default
summary: An overview of how the overall infrastructure is designed.
---

The OSGi IoT Trains SDK is a way to write software for a Lego® train track used in the OSGi IoT Contest. The SDK is an OSGi enRoute workspace with a number of projects. The SDK is a self contained environment that contains everything to run an emulator with custom or example bundles.

On the highest level the architecture is about a role play between a _Track Manager_ and a number of _Train Managers_. 


The track manager runs somewhere in the cloud and controls the overall track. It receives the RFID events from passing trains, it gets requests from trains to access certain track segments, it controls the signals, and it tells the trains to go to destinations.

![Top Level](/img/trains/track-train-relation.png){:width="50%"}.

These actors play on a _Lego®_ track. The actual track is defined in a configuration so can vary. However, a typical track looks like the following:

![Top Level](/img/trains/track.png)

## Terminology 

* *train* — A Train Manager controls the speed of the train. For this contest, the train will only move in one direction. The train is identified by an RFID. A detection station can pick up this RFID. This will require the Track Manager to send out an event. The Train Manager can use this event to find out its train's location.
* *track* — A connected set of _segments_ and _switches_.  The use of the term is slightly ambiguous since the overall railroad is informally called the track layout. However, in the formal sense a track is a set of adjacent segments. Such a track has a one letter name, e.g. C.
* *segment* — A segment is a piece of a _track_. It has a specific location and type. It can be curved, a switch, contains a signal, an RFID station, etc. It has a length (that can be zero). A segment is used to describe a track. Each segment has a name, e.g. A04.
* *switch* — A _switch_ is a segment that bifurcates or merges, depending on the direction of the train. A switch can be controlled by the track manager. Train Managers must request access to a track which the Track Manager must only grant if the switch is properly set. Switches are not part of a track, they have their own X identification.
* *signal* — A signal is either a red, yellow, or green indication that a track is free. A Track Manager controls the color of the signals. A Train Manager must not pass a red signal.  
* *rfid* — At strategic places along the tracks on a segment an RFID station is placed. When a train passes, the Track Manager is informed. Trains must go slowly when they are close to an RFID station; if they go too fast the detection can fail. RFID detection stations are numbered. 
* *assignment* — A command from the Track Manager to a Train Manager to move the train to a specific segment.
* *observation* — More or less an event.

## Service Model

The service model of the OSGi IoT Trains SDK is depicted in the following figure:

![Service Model](/img/trains/trains-service-diagram.png){:width="100%"}

### Legend

* Yellow triangle — Service. The triangle points to the provider of the service. Listeners connect to the side of the triangle and clients of the service to the straight part. See [services](/book/215-sos.html) 
* Orange rounded rectangle — Bundle
* Green Parallelogram — An IO device

## The Services

* `TrackInfo` — The Track Info service provides the general information that is needed by all actors. The application uses it to visualize the track, the train uses it to find out where it is by listening to the events. A primary function of this service is to provide the track layout. The track layout is configurable and can change.
* `TrackForTrain`— A service specifically targeted at the Train Managers. It provides access to the assignments of the train and it allows a Train Manager to register itself. 
* `TrackForSegment` — A service targeted at the segment controller. The track controller manages the hardware for the signals, switches, and RFIDs.
* `Train Controller` — This service allows the Train Manager to control the train by setting the speed.
* `Track Controller` — A track controller manages a number of segment controllers. The Track Controller interface is the interface for the Track Manager to tell what switches and signals should be set.
* `Segment Controller` — Low level service to control the hardware directly that manages the RFID, signals, and switches. 

## The Projects

* `osgi.enroute.trains.api` — Provides the service specifications for the infrastructure. The software architecture of this API is later explained.
* `osgi.enroute.trains.application` — The application project contains a web based graphic user interface. It can be used to run the emulator with the example Track and Train manager or a custom implementation.
* `osgi.enroute.trains.emulator.provider` —  This is an emulator of the track. It provides a Train Controller service and a number of Segment Controller services so that the  Train Manager and Track Manager can work as if they operate against the real world.
* `osgi.enroute.trains.segment.controller.provider` — Low level hardware controller.
* `osgi.enroute.trains.track.controller.provider` — Manages a number of segment controllers
* `osgi.enroute.trains.track.manager.example.provider` — Example Track Manager. This project can act as template for an entry in the contest.
* `osgi.enroute.trains.train.controller.provider` — Implements the hardware interface (Infrared control) for the Lego® train.
* `osgi.enroute.trains.train.manager.example.provider` — Example Train Manager. This project can act as template for an entry in the contest.
* `osgi.enroute.trains.util` — Utility classes for the trains. Contestants are free to write their code in any way they want. However, this project simplifies some of the track calculations. Among others, it provides a helper class that makes it easy to use the track, which is defined with DTOs, in an object oriented way.





