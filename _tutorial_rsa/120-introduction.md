---
title: Introduction to the Chat Tutorial
layout: tutorial
lprev: 100-prerequisites.html
lnext: 140-api.html
summary: Introduction what we will build in this chat tutorial
---

![Chat Service](/img/tutorial_rsa/rsa-service-0.png)


## What you will Learn

The purpose of this tutorial is to become familiar with _distributed OSGi_. In this tutorial you will design a simple Chat service that uses a service to represent a member in a chat group. Using Gogo shell commands we will play with this service locally. We will then export the Chat service and enable distributed OSGi so we can chat to members outside our framework. For this we need a Zookeeper server for discovering our peers. From within Bndtools we start a Zookeeper server for this purpose.

As bonus, we create a small Web application that acts as GUI.

## The Problem

A chat service like Skype, Facebook Messenger, WhatsApp, etc. It allows you to send a message to someone else and then that person can reply. The core problem is to find the communication _endpoint_ on which our chat partner resides. This requires some kind of _discovery_ process. Once we found the endpoint, we use some transport mechanism to send the message. This message then can contain our address so that the other side can respond using the same process.

## The Solution

In this example we use the OSGi service registry for the discover and transport. This works perfectly for local services but using distributed OSGi we can allow others on other computers to participate as well.   


