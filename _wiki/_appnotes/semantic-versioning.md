---
title: Semantic Versioning Debate
summary: A point of reference for the discussion taking place on the OSGi Community mailing list
---

This page is provided as a point of reference for the discussion taking
place on the
[<https://groups.google.com/forum/?fromgroups>\#!forum/osgi-community
OSGi Community mail list] about the Pros and Cons of adopting Semantic
Versioning for the Community effort to OSGi enable Open Source
libraries.

Please get involved in the discussion and post any comments on the mail
list before editing this page.

To Semantically Version or Not
------------------------------

To paraphrase from Shakespeare "To Semantically Version: That is the
question" (Act III, Scene I - Hamlet). Ok so the debate about Semantic
Versioning has been ongoing for some time, not quite back to
Shakespeare's day.

Is there a right or wrong answer?  Possibly not.

Semantic Versioning offers a lot of advantages in an OSGi world, however
there is already lots of code out there that doesn't support it, and it
does require additional overhead to implement it (unless you are using
Bndtools).  That said moving forward should we just pretend it doesn't
exist or does it make sense to include it in new activities we do?

Perhaps the pragmatic approach is to try and find a way where the user
can decide whether they do or don't want to consume it? Is that
possible?

Pros of Semantically Versioning Packages
----------------------------------------

1.  Code volumes currently doubling every 7 years. So lets start doing
    things 'right' today and we'll soon have refactored most of what the
    community need. Legacy should never be an argument for not moving
    forwards.
2.  Its not about EBR, Spring or BluePrint - its about high quality OSGi
    libraries for consumption by all frameworks.
3.  While minimising difference between various efforts is desirable,
    shouldn't this be achieve by aligning on the most appropriate
    solution not defaulting to the lowest common denominator?
4.  While a poll wasn't taken at the BoF I'll suggest that for those
    willing to do the work - bndtools is their tool of choice and they
    are very likely to be comfortable leveraging the bndtools' semantic
    versioning capabilities. These individuals will be doing the work.
5.  Looks like we'll be in good company as the Maven community seem to
    be considering adopting a subset of semantic versioning.

Cons of Semantically Versioning Packages
----------------------------------------

From a Pro perspective.

1.  Effort is required to do the right thing. Isn't that always the
    case? It will only happen if the community collectively step up to
    the challenge.
2.  This will be an ongoing effort until downstream projects adopt
    Semantic Versioning.

Pros of NOT Semantically Versioning Packages
--------------------------------------------

There are many good reasons to export packages of a migrated 3rd party
bundle using the bundle version as a package version:

1.  This approach actually delivers semantic versioning in most cases.
    The working assumption that breaking changes occur on major version
    boundaries works pretty well for most open source projects. Also
    callback interfaces, which are more sensitive to change, tend to be
    managed pretty carefully.
2.  It's simple to understand and trivial to automate.
3.  This approach has been proven ok by the SpringSource Enterprise
    Bundle Repository (EBR) which holds multiple versions of hundreds of
    3rd party JARs converted to bundles. There has not been a single bug
    report about the need for a package version to diverge from the
    bundle version.
4.  This approach has also been validated in the Eclipse Virgo project
    which makes major use of 3rd party bundles. Again there has never
    been a request for package versions to diverge from bundle versions,
    nor have any significant problems arisen because of this policy.
5.  Apparently a good proportion of the upstream projects with bundle in
    the EBR are now including OSGi manifests in their JARs. As each
    project does this, it is free to step up to full semantic versioning
    of packages if it chooses to do so. However, this is rare and most
    projects stick with a single version for all exported packages.
6.  Even though a general policy of versioning exported packages by
    bundle version would be fine for at least 99% of cases, if examples
    are found which need finer grained package versioning, then this can
    be adopted on a per project basis.

Cons of Semantically Versioning Packages
----------------------------------------

1.  It's labour intensive and risky for those maintaining the bundle
    manifest templates as they need to analyse or guess when semantic
    changes have occurred when a new version of a JAR is shipped by an
    upstream project.
2.  "Proper" semantic versioning was tried out in relation to the
    servlet spec packages and servlet 2.6 (semantic package version for
    servlet 3.0) was introduced as a consequence. This has caused
    problems for users, required backward compatibility mapping bundles
    to be defined, and the OSGi Alliance is now considering how best to
    overcome the problem without forcing projects to specify imports of
    servlet packages at v2.6. We can and should learn from this mistake.
    Semantically versioning the packages of 3rd party bundles will hit
    the same problems only worse.
3.  Artificial package version numbers (100+) are highly non-intuitive
    for consumers of these packages.
4.  This approach will cause compatibility issues for bundles which
    already have their packages exported at the bundle version, e.g. in
    the SpringSource EBR. More backward compatibility mapping bundles
    may be required.
5.  Adopting a semantic versioning approach with package versions like
    100.x is necessarily disconnected from the upstream project's
    version numbering and is likely to put off upstream projects from
    including OSGi manifests.


Using Bundle Version for Packages
-----------------------------------------

There are many good reasons to export packages of a migrated 3rd party
bundle using the bundle version as a package version:

There are many good reasons to export packages of a migrated 3rd party
bundle using the bundle version as a package version:

1.  It's simple to understand and trivial to automate.
2.  It's less labour intensive and risky for those maintaining the
    bundle manifest templates as they don't need to analyse or guess
    when semantic changes have occurred when a new version of a JAR is
    shipped by an upstream project.
3.  This approach has been proven ok by the SpringSource Enterprise
    Bundle Repository (EBR) which holds multiple versions of hundreds of
    3rd party JARs converted to bundles. There has not been a single bug
    report about the need for a package version to diverge from the
    bundle version.
4.  This approach has also been validated in the Eclipse Virgo project
    which makes major use of 3rd party bundles. Again there has never
    been a request for package versions to diverge from bundle versions,
    nor have any significant problems arisen because of this policy.
5.  Apparently a good proportion of the upstream projects with bundle in
    the EBR are now including OSGi manifests in their JARs. As each
    project does this, it is free to step up to full semantic versioning
    of packages if it chooses to do so. However, this is rare and most
    projects stick with a single version for all exported packages.
    Adopting a semantic versioning approach with package versions like
    100.x is likely to put off upstream projects from including OSGi
    manifests.
6.  "Proper" semantic versioning was tried out in relation to the
    servlet spec packages and servlet 2.6 (semantic package version for
    servlet 3.0) was introduced as a consequence. This has caused
    problems for users, required backward compatibility mapping bundles
    to be defined, and the OSGi Alliance is now considering how best to
    overcome the problem without forcing projects to specify imports of
    servlet packages at v2.6. We can and should learn from this mistake.
7.  The working assumption that breaking changes occur on major version
    boundaries works pretty well for most open source projects. Also
    callback interfaces, which are more sensitive to change, tend to be
    managed pretty carefully.
8.  Even though a general policy of versioning exported packages by
    bundle version would be fine for at least 99% of cases, if examples
    are found which need finer grained package versioning, then this can
    be adopted on a per project basis.


