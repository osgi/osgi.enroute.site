---
title: What is a Data Transfer Object (DTO)?
summary: The DTO design pattern
layout: toc-guide-page
lprev: 400-patterns.html 
lnext: 450-Designing-APIs.html 
author: enRoute@paremus.com
sponsor: OSGi™ Alliance   
---

Whenever two parts of a software system want to communicate they need to exchange data. Data Transfer Objects (DTOs) are all about how this data is represented. If you know C then a DTO is a `struct`. If you don't know C then a DTO is an object without methods, it is pure data.

Data Transfer Objects have only public fields, and these fields may have one of a limited set of types. This limits the risk of unnecessary coupling between modules, allows DTOs to be easily serialized (even though they are not `java.io.Serializable`), and makes DTOs easy to transform using the OSGi Converter. DTOs are therefore excellent candidates for service API parameters and return values, they can be used remotely, or outside of Java, and can be represented using JSON, YAML or any format of your choice. 


## A DTO's structure

Data Transfer Objects are public (static) classes with no methods, other than the compiler supplied default constructor, having only public fields limited to the easily serializable types: i.e. A DTO is equivalent to a _struct_ in C. It is suggested (although not required) that a DTO type extend the `DTO` base class.

For example:

        public class BundleDTO extends DTO {
                public long   id;
                public long   lastModified;
                public int    state;
                public String symbolicName;
                public String version;
        }

the _Types_ that can be used in DTOs is limited to:

* Primitive types
* Wrapper classes for the primitive types
* String
* enum
* Version
* Data Transfer Objects
* List
* Set
* Map
* array

The List, Set, Map and array aggregates must only hold objects of the listed types.

The object graph from a Data Transfer Object must be a tree (i.e. not have any cycles) to simplify serialization and deserialization. The DTO class also has some other specific requirements:

* **public** – Only public classes with public members work as DTO. 
* **static** – Fields must **not** be static but inner classes **must** be static. 
* **no-arg constructor** – To allow instantiation before setting the fields
* **extend** – DTOs can extend another DTO
* **no generics** – DTOs should never have a variable generic signature because this makes serialization really hard.


### Equals and HashCode

The DTO class has no `equals` nor a `hashCode` method. This makes them unsuitable as keys or for use in sets. The reason is that it is not the 
data (the DTO) that defines what is the primary key of the data, it is the actual usage scenario that defines the fields of interest. 
That is, one object can use the `id` field of the object as primary key but another object tracks by `symbolicName` and `version`.

You will therefore often find that DTOs are the values in maps but never a key. One field is then the key.  

It is rare but allowed to add `equals` and `hashCode` methods.


### DTOs and Threads 

A Data Transfer Object is a representation of a runtime object at the point in time the Data Transfer Object was created. Data Transfer Objects do not track state changes in the represented runtime object. Since Data Transfer Objects are simply fields with no method behavior, modifications to Data Transfer Objects are inherently not thread safe. Care must be taken to safely publish Data Transfer Objects for use by other threads as well as proper synchronization if a Data Transfer Object is mutated by one of the threads.


## Where next?

The use of DTO's is introduced in the [Microservies Tutorial](../tutorial/030-tutorial_microservice.html) via their use as `Person` and `Address` data objects. 

The org.osgi.dto package defines the basic rules and the abstract base DTO class which Data Transfer Objects must extend. 

For further information see:

* [Data Transfer Objects](https://osgi.org/hudson/job/build.core/lastSuccessfulBuild/artifact/osgi.specs/generated/html/core/framework.dto.html) - link to the DTO Speciofication. 
* [Converter](https://osgi.org/hudson/job/build.cmpn/lastSuccessfulBuild/artifact/osgi.specs/generated/html/cmpn/util.converter.html) - link to the Converter specification

