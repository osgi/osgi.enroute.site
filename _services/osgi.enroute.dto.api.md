---
title: osgi.enroute.dto.api
layout: service
version: 1.0
summary:  Support for converting objects to other objects or JSON.
---

![DTO Class Overview](/img/services/osgi.enroute.dto.overview.png)

One of the key ideas in enRoute (and more and more in the OSGi) is to base this on DTOs (Data Transfer Objects). These are objects with public fields. The primary reason is that what you store in your database is PUBLIC because one day some other process is going to read it. I.e. you can change your field in your object but the database doesn't care. One of the biggest misconceptions in Java/Object oriented world is that your instance variables of entities are private. This causes the enormous torture of object relational mapping.

A DTO has no methods ... The reason is that DTOs are pure data. The problem with methods is that they tend to change over time when your data moves between processes (to another system, or to a database). Since the semantics of a method are open, you have no clue. The semantics of the simple DTO data types are well defined. The code that works with this data is your application. But key is to realize that your DTO is the public specification of your data so you have to be very careful to evolve over time. This process is very much in the open for DTOs while it tends to be obscured by beans.

Once you accept that DTOs work so well because in your application you have full type safety, refactoring, and navigation. You just must realize however that their structure is constrained by the past. Most enterprise applications have a large number of fields per entity that are relatively simple. (Interesting, technical software has much fewer but much more complex types as fields; Java is unfortunately for the enterprise much better suited for technical apps than enterprise apps. An enterprise language without a currency type???? But I am deviating.)

In enRoute the DTO is the cornerstone. The REST API allows you to return them, you can easily convert them to maps, from maps, and copy them (See the DTOs service). The idea is that you drive as much code as possible from the public non-static fields of these DTOs. For example, you can annotate those fields with validation info, gui info, and if you need, persistence info. Yes, you miss some of the fancy stuff that JPA provides with primary/foreign keys; With DTOs you will have to manage that yourself. This, however, is well compensated with the simplicity of the approach.

The mongo driver that I made available is highly suited for this approach. You define a collection and associate with a type. Methods on the API allow you to do retrieve and store, if necessary partial.

The only thing you have to be careful is to make sure you do not hang on to dtos or share them. They are expendable objects, a copy from the DB etc.

Inside the OSGi DTOs have become highly popular because they cut out the middle man (beans). We use them in many places no as a reification of a specification.
