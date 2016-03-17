The Whiteboard Pattern is an abstract pattern used in many scenarios in
OSGi. It is based on using Services to represent extensions to some kind
of base functionality.

Motivating Example: GUI Panels
------------------------------

Suppose we are designing a GUI application consisting of multiple panels
within a "workspace"; for example, something like the Eclipse IDE
layout. We wish to make the application flexible and extensible, so that
we can add new panels later, or so that third parties can add panels.

As a first design, imagine a Workspace service having two methods,
`addPanel` and `removePanel`. A bundle wishing to provide a service
would have to track the Workspace service and call addPanel to add
itself to the GUI, and later call removePanel to remove itself. This
design suffers from a number of problems. First, the panel provider is
tightly coupled to our specific application through its dependency on
the Workspace service interface, meaning that the same panel cannot be
reused in some other application. Second, the provider must remember to
always unregister itself, but if it fails to do so then memory leaks can
occur.

Suppose instead we turn this around. A bundle wishing to provide a panel
simply publishes a service under the Panel interface. The application
workspace can track these services and add/remove the panels dynamically
as the Panel services come and go. Additionally the panel provider can
attach service properties such as minimum width, height, orientation,
z-order etc as hints to the application. Now the panel providers have no
dependency on the Workspace API, and can be reused in other
applications.

Further Examples
----------------

Suppose we are building an application to simulate a scientific
calculator. We would like to allow new functions (e.g. tangent) to be
added at a later time. The "wrong" way to do this is to define a
"CalculatorService" with `addFunction` and `removeFunction` methods. The
"right" way (i.e. whiteboard style) is to publish new functions under
the Function interface. These function services can now be reused in
other contexts, e.g. a spreadsheet application.

Summary
-------

The core of the Whiteboard Pattern is that extensions are published as
services, and these services are consumed by the base application. This
has the following benefits:

-   Decoupling and Reuse. The extensions do not depend on the base,
    making them easier to reuse.
-   Dynamics. The extensions do not need to track any base service, they
    simply publish/unpublish.
-   Ease of Coding. The extensions are easier to code, since it is
    always easier to publish a service than to consume a service.
    Extensions tend to me more numerous than base applications,
    therefore it makes sense to simplify life for extension developers
    (even if it results in a small increase in complexity for the base
    developers).

