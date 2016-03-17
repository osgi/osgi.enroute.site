Background & How to Get Involved
--------------------------------

During the BOF at the OSGi Community Event 2012 there were a number of
people from the Community who expressed an interest in a co-ordinated
effort to OSGi enable Open Source libraries that were not already OSGi
friendly and to share these from a common repository.

An [<https://groups.google.com/forum/?fromgroups>\#!forum/osgi-community
OSGi Community mail list] has been set up for people to discuss these
activities and this page provides useful links for resources to support
that activity.

Library Migration Effort
------------------------

The [Migration](Migration "wikilink") pages on this wiki provide some
initial pointers on best practices concerning the migration of third
party libraries.

Please use the
[<https://groups.google.com/forum/?fromgroups>\#!forum/osgi-community
OSGi Community mail list] if you have any questions or want any advice.

A GitHub Repository has been created for out community efforts and this
can be found at <https://github.com/bndtools/bundled>. The contents of
our community repository may be navigated via
[JPM4j](http://www.jpm4j.org). To view an example of some migrated
libraries - see <https://jpm4j.org/#/search?q=g:osgi%20a:bnd>.\*.

Further detail on jpm4J capabilities will be provided in due course.

### Libraries

The initial intent was to compile a list of the Top 50 or so OSS
libraries according to popularity/activity via information provided by
third parties. However to-date - there has been no information
forthcoming to-date.

Hence, it is suggested that we assemble our own list of third party
libraries. To **adopt a Library** from this list - flag intent via the
[<https://groups.google.com/forum/?fromgroups>\#!forum/osgi-community
OSGi Community mail list] and insert your names against the
[libraries](http://wiki.osgi.org/wiki/LibrarySupport).

If you have already migrated any libraries to OSGi and would like to
contribute them to this effort then please propose these on the
[<https://groups.google.com/forum/?fromgroups>\#!forum/osgi-community
OSGi Community mail list].

### Semantic Versioning

While OSGi has always advocated [Semantic
Versioning](http://www.osgi.org/wiki/uploads/Links/SemanticVersioning.pdf).
The value of semantic versioning is now being realised by the non-OSGi
community; i.e. [SemVer](http://semver.org) which is a compatible subset
of OSGi semantic versioning.

Package versions are highly politicised. The OSGi Alliance specification
RFC180 is currently attempting to address this but the RFC is not
finalised yet. As a community we cannot really make a repository until
we have a clear idea how we handle package versions.

It is proposed that libraries produced by our community effort should
pursue semantic versioning. This may be controversial, but we must bite
this particular bullet if we want those that follow us to benefit from
the power of semantic versioning and the tooling that supports this;
e.g. [Bndtools](http://bndtools.org).

-   Use artifact version for packages: — This initially looks logical
    but then with semantic versioning over time it becomes awkward
    because some packages move versions others dont. I.e. you start out
    with 1.0.7 because that happens to be the maven version but then
    over time when the bundle is at 1.0.18, the package is still at
    1.0.9. Though these version spaces are completely separated, people
    are likely to become confused because they look so similar.

-   Specification Version - Enterprise developers tend to want to use
    specification versions. But the same problem occurs over time;
    package versions become very confusing because they look similar to
    the spec versions but actually deviate from them.

There is probably no ideal solution. The suggestion is that we adopt
special range, e.g. 100.0.0, that clearly indicates there is no relation
to the bundle version. This then provides a fresh start to increment
versions semantically.

### The Pros and Cons of Semantic Versioning

A page has been set up as a reference for the [Pros and Cons of using or
not using Semantic
Versioning](http://wiki.osgi.org/wiki/Semantic_Versioning_Pros_and_Cons).
Please use the
[<https://groups.google.com/forum/?fromgroups>\#!forum/osgi-community
mail list] to discuss this further.

### Other Activities

There is also some other activity going on around the [SpringSource
Enterprise Bundle Repository
(EBR)](http://ebr.springsource.com/repository/app/).

SpringSource/VMware is looking to submit an Eclipse project proposal
with some other vendors to build a collection of bundle manifest
templates for third party JARs from open source projects which do not
yet ship with OSGi manifests. This is motivated by the need to supersede
the EBR, which hosts over 1000 bundles, with a community-based
alternative. The desire is to accumulate well-defined manifest templates
in an Eclipse project managed by a broad set of committers and to enable
the corresponding bundles to be constructed easily. Ideally we would
also like to see the resultant bundles hosted in a Maven or Ivy
repository to provide more predictability. This group will be notified
of proress as SpringSource/VMware move towards creating a project
proposal, hopefully in the next few weeks.

The goal over the medium term will be to align both these efforts as
much as it practical.

Questions
---------

Please sign up to the
[<https://groups.google.com/forum/?fromgroups>\#!forum/osgi-community
OSGi Community mail list] to ask any questions.

Our Sponsors
------------

We'd like to thank the following sponsors

[aQute](http://www.aQute.biz) [Paremus](http://www.Paremus.com)

