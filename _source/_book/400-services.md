---
title: Service Catalog
layout: book
---

## Base Profile

* OSGi Core Framework — R6
* OSGi Compendium  — ConfigurationAdmin, Coordinator, EventAdmin, LogService, MetaTypeService,UserAdmin
* Logging — Extensive Java Logging and SLF4J (dynamic!) logging support. Both service based an statics.
* OSGi enRoute Support
* Requirements and Capabilities — Completely developed with the R&C model in mind
* Specifications in code — Extensive support to use Java classes and interfaces to also specifies non-Java aspects. E.g. license headers, forms, versioning, etc. Mostly through annotations.
* OSGi enRoute services
  * Authenticator and Authority — For extensible security
  * ConfigurationDone — To signal end of initialization at startup
  * DTOs — Extensive support for Data Transfer Objects (JSON, conversion, diffing, named access)
  * Launched — Provides access to startup parameters
  * LoggerAdmin — Administrative front end to logging. Can handle OSGi, SLF4J, and Java Logging
  * java.util.Timer — Scheduled tasks
  * java.util.concurrent.Executor — Background tasks
  