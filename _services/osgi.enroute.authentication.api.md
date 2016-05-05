---
title: osgi.enroute.authentication.api
layout: service
version: 1.0
summary: Providing an authenticated id based on variable user credentials.
---

![Authenticator Service Collaboration Overview](/img/services/osgi.enroute.authentication.overview.png)

## Introduction

It goes without saying that automated systems that are networked are highly vulnerable to external attacks. Malicious people are continuously scanning ports of every accessible IP number. One of the first lines of defense is to prevent unauthorized users from accessing the system in the first place. Before authorizing a user (or its role), it is first necessary to establish the user's identity. As usual, there are many ways to skin a cat. There are hundreds if not thousands of types of authentication; from the humble password verification, the iris scan, all the way to the multi-factor authentication mechanisms.

It is probably wishing thinking to try to create a single API that can handle this myriad of mechanisms, but let's have a try anyway.

This service API assumes the _credentials_ are collected remotely, usually a browser. Credentials are the information tokens that allow users to prove that they are who they say they are. Simple credentials are user id and a password. Since the password is only known to the user (hopefully) we can assume that the remote side is indeed manned by the proper principal. 

Modern authentication systems use a delegation model to minimize the need to keep credentials. For example, Mozilla's Persona uses a more complicated scheme to reduce the number of places where a user has to use a password. This scheme works as follows:

* The application Javascript requests a login token
* The user is providing its user Id and password to Mozilla's server over a protected connection
* The Mozilla server returns a unique token
* The application Javascript receives the token and ships it to its own server
* The application server contacts the Mozilla server, which returns the user id

In this model the user does not have to entrust its password with every site while still providing proper authentication. Schemes like OAuth extend this model further allowing the user to give limited access to its profile data to the visited site. The beauty of the scheme is that the user can always withdraw that authorization without talking to the specific site.

So, assuming we have these kind of schemes we need a mechanism to allow the remote party to provide some credentials to an authenticator module that knows what to do with these credentials. This authenticator should then provide us with a system wide unique id for that user. Well, unique within our system. In general this should be an id that can be used, for example, with the User Admin service.



