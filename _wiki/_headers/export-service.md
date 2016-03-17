---
title: Export-Service
summary: Deprecated header to indicate a service was provided when the bundle ran
---

The `Export-Service` was originally a manifest header that would declare
which services a bundle exported statically. It has been deprecated
(along with its inverse, [Import-Service]) as services are now consumed
dynamically rather than requiring static registration.

See the chapter 135.4 of the OSGi compendium spec (osgi.service
Namespace) about the solution that should be used instead of
*Export-Service*.

[Import-Service]: import-service.html
