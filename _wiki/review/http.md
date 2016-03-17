Current State of Support
------------------------

The OSGi Specifications currently only contain limited specification
support for creating Web Applications in an OSGi context:

-   Http Service Specification based on Servlet API 2.1. Apart from
    requiring an old Servlet API version and being silent about how more
    recent versions are supported the main problem with this
    specification is that a provider of servlets and resources has to
    grab the Http Service first before being able to register servlets
    and resources. That is there is no whiteboard pattern support.
-   Web Applications Specification basically just defines how existing
    web applications may be enhanced with OSGi Manifest headers and
    deployed into the OSGi Framework as-is. This is fine for moving
    existing web applications with minimal changes into the OSGi
    framework.

Missing Pieces
--------------

In particular we have some missing pieces to bridge this gap:

-   [Servlet Filter Support](#Servlet_Filter_Support "wikilink"). Since
    current Http Service specification is based on Servlet API 2.1 and
    Filters have only been added in Servlet API 2.x, the current Http
    Service specification does not support Filters.
-   [Whiteboard support for the Http
    Service](#Http_Whiteboard_Support "wikilink"): Register servlets and
    HttpContext services using service registration properties to mix,
    match, and register. A concrete example of such white board support
    is the [Apache Felix Http
    Whiteboard](http://felix.apache.org/site/apache-felix-http-service.html#ApacheFelixHTTPService-UsingtheWhiteboard)
    bundle.
-   Improve the Http Service specification to update to at least Servlet
    API 2.5 if not Servlet API 3.0. Such an update should define how new
    functionality should be supported and how an updated Http Service
    reacts to an older Servlet API (such as 2.3 or 2.4) being present.
    Also it must be defined how registration aliases map on path methods
    available from the Servlet API, such as
    `HttpServletRequest.getContextPath()`,
    `HttpServletRequest.getPathInfo()`, etc.
-   Maybe provide suggestions on how to integrate with existing
    frameworks such as JSF, GWT, Vaadin, Struts, etc.
-   Maybe consider approaches taken by [Apache
    Sling](http://sling.apache.org) or [Pax
    Web](http://http://team.ops4j.org/wiki/display/paxweb/Pax+Web)
-   Device detection (see for example the [WURFL
    database](http://wurfl.sourceforge.net/), but mind the license)
-   [Improve configuration](#Configuration "wikilink")

Requirements have been gathered in [RFP-150 Http Service
Updates](https://www.osgi.org/bugzilla/attachment.cgi?id=35)

Servlet Filter Support
----------------------

Extend the HttpService interface with two methods (taken from
[ExtHttpService](https://svn.apache.org/repos/asf/felix/trunk/http/api/src/main/java/org/apache/felix/http/api/ExtHttpService.java))

`public void registerFilter(Filter filter, String pattern, Dictionary initParams, int ranking, HttpContext context)`  
`       throws ServletException;`  
`public void unregisterFilter(Filter filter);`

The `unregister` method must take the Filter instance because unlike
servlets multiple filters may register with the same pattern.

Http Whiteboard Support
-----------------------

Define a number of service registration properties (taken from
[HttpWhiteboardConstants](https://svn.apache.org/repos/asf/felix/trunk/http/whiteboard/src/main/java/org/apache/felix/http/whiteboard/HttpWhiteboardConstants.java)):

contextId  
The service registration property indicating the name of a `HttpContext`
service.

If the property is set to a non-empty string for an `HttpContext`
service it indicates the name by which it may be referred to by
`Servlet` and `Filter` services. This is also a required registration
property for `HttpService` services to be accepted by the Http
Whiteboard registration.

If the property is set for a `Servlet` or `Filter` services it indicates
the name of a registered `HttpContext` which is to be used for the
registration with the Http Service. If the property is not set for a
`Servlet` or `Filter` services or its value is the empty string, a
default HttpContext is used which does no security handling and has no
MIME type support and which returns resources from the servlet's or the
filter's bundle.

The value of this service registration property is a single string.

context.shared  
The service registration property indicating whether a `HttpContext`
service registered with the `contextId` service registration property is
shared across bundles or not. By default `HttpContext` services are only
available to `Servlet` and `Filter` services registered by the same
bundle.

If this property is set to `true` for `HttpContext` service, it may be
referred to by `Servlet` or `Filter` services from different bundles.

**Recommendation:** Shared `HttpContext` services should either not
implement the `getResource` at all or be registered as service factories
to ensure no access to foreign bundle resources is not allowed through
this backdoor.

The value of this service registration is a single boolean or string.
Only if the boolean value is `true` (either by `Boolean.booleanValue()`
or by `Boolean.valueOf(String)`) will the `HttpContext` be shared.

alias  
The service registration property indicating the registration alias for
a `Servlet` service. This value is used as the alias parameter for the
`HttpService.registerServlet` call.

A `Servlet` service registered with this service property may also
provide a `contextId` property which referrs to a `HttpContext` service.
If such a service is not registered (yet), the servlet will not be
registered with the Http Service. Once the `HttpContext` service becomes
available, the servlet is registered.

The value of this service registration property is a single string
starting with a slash.

pattern  
The service registration property indicating the URL pattern for a
`Filter` service. This value is used as the pattern parameter for the
`ExtHttpService.registerFilter` call.

A `Filter` service registered with this service property may also
provide a `contextId` property which referrs to a `HttpContext` service.
If such a service is not registered (yet), the filter will not be
registered with the Http Service. Once the `HttpContext` service becomes
available, the filter is registered.

The value of this service registration property is a single string being
a regular expression.

**Note:** `Filter` services are only supported if the Http Service
implements the `org.apache.felix.http.api.ExtHttpService` interface.

init.  
Prefix for service registration properties being used as init parameters
for the `Servlet` and `Filter` initialization

Configuration
-------------

The Http Service specification currently only defines two framework
properties to configure the Http Service: =org.osgi.service.http.port=
and =org.osgi.service.http.port.secure=.

We should improve predefined configurability with the following
properties:

org.osgi.service.http.host  
The interface to bind the HTTP Service to. If this property is not
defined the service binds to all available interfaces.

org.osgi.service.http.context\_path  
The Servlet Context Path to use for the Http Service. If this property
is not configured it defaults to "/". This must be a valid path starting
with a slash and not ending with a slash (unless it is the root context)

<Category:Service>

