---
title: osgi.enroute.jsonrpc.api
layout: service
version: 1.0
summary:  A white-board approach to JSON RPC 
---

![JSON RPC Service Collaboration Overview](/img/services/osgi.enroute.jsonrpc.overview.png)

When you have an application that is split in a Javascript _front-end_ and an OSGi _back_end_ part that are tightly coupled then JSON RPC is the ideal way to let the front- and back-end communicate.
 
The JSON RPC service is an alternative to a REST API. It is more suitable than a REST API when you have an application that runs partly in a browser and partly in the back-end server. The tight coupling between these two parts quickly makes the required activities in REST feel cumbersome an unnecessary. This process is: designing a URI, writing the Javascript to create that URI with the parameters, calling the REST API, at the backend decoding the API, etc. Since in a single page application the back-end and the front-end are of the same version there is no need for the backward compatibility that REST can provide. Using a direct procedure call is then much easier.

## Example

You can find a fully functioning example in the [examples repository][example];

The JSON RPC implementation in OSGi enRoute consists of a back-end (Java/OSGi) and a front-end part (Javascript/Angular). The following is an example of a back-end service that will provide an endpoint to the front-end named `exampleEndpoint`:

	@Component(name="osgi.enroute.examples.jsonrpc", property=JSONRPC.ENDPOINT + "=exampleEndpoint")
	public class JsonrpcApplication implements JSONRPC {
	
		@Override public Object getDescriptor() throws Exception {
			return "Welcome!";
		}
		
		public String toUpper(String string) {
			return string.toUpperCase();
		}
	}

On the Javascript side we need to configure the `en$jsonrpcProvider` (Since we commonly use the $routeProvider to configure the routes in this place it is also shown since the routes should not be active until the endpoint is initialized) :
	
	var resolveBefore = {};

	MODULE.config(function($routeProvider, en$jsonrpcProvider) {
		resolveBefore.exampleEndpoint = en$jsonrpcProvider.endpoint("exampleEndpoint");
		$routeProvider.when('/', {
			controller 	: Controller,
			templateUrl : '/osgi.enroute.examples.jsonrpc/main/htm/home.htm',
			resolve 	: resolveBefore
		});
	});
	
Since the endpoint is the object we need to call our methods on we use the same promise to get our endpoint:

	MODULE.run(function($rootScope, en$jsonrpc) {
		resolveBefore.exampleEndpoint().then(function(exampleEndpoint) {
			$rootScope.exampleEndpoint = exampleEndpoint;
		});
	});

Last but not least, the Controller that reacts to the '/' route.
 
	var Controller = function($scope, en$jsonrpc) {
		$scope.upper = function(s) {
			$scope.exampleEndpoint.toUpper(s).then(function(d) {
				alert({msg: d, type:"info"});
			});
		}
		$scope.welcome = $scope.exampleEndpoint.descriptor
	}
	
This example will report errors on the Javascript console. It is possible to register an error function durin the configuration of the en$jsonrpcProvider:

	en$jsonrpcProvider.setNotification({
		error : function(err) { alert(err); }
	})

## Description 
[JSON RPC][jsonrpc] is a protocol that is used to call procedures on another machine. It uses Javascript Object Representation Notation (JSON) to encode the parameters and return types, hence its name. JSON RPC is intended to be used when the front-end (usually Javascript) and the back-end are tightly connected like in for example the case of a single-page web-application. Since the front-end and the back-end evolve simultaneously there is no need to be backward compatible. If the back-end changes then the front-end changes. 

### Creating an Endpoint

To create a JSON RPC  end point, you must register an OSGi service that has the OSGi service property  `JSONRPC.ENDPOINT` set to the endpoint name. An endpoint name must match the bundle symbolic name syntax. For example:

	@Component(name="osgi.enroute.examples.jsonrpc", property=JSONRPC.ENDPOINT + "=exampleEndpoint")
	public class JsonrpcApplication implements JSONRPC {
	    public Object getDescriptor() { ... }
	}
 
The `getDescriptor` method is called for each new client. It is possible to return any JSON serializable object; this object will be available in the front-end. In general, these are DTO types. The `toUpper` method can be called from the front-end.  The parameters must also be serializable using JSON. 

The purpose of this method is to provide caller specific back-end information to the front-end. For examples, user preferences, security information, or any other information that the front-end needs before it can function. This information is transferred before any method is called for that client.

The front-end is slightly more complicated because the front-end need to query the back-end for the descriptor and the procedure names. Since Javascript is asynchronous we must ensure that we delay all activity until we've made that round trip. This creates a tricky race condition with a page that is opened and that calls a remote procedure before the round trip has finished. Since this is a common problem, Angular provides a mechanism to prevent any controllers from being created by the [`$routeProvider`][routeProvider] before a given promise is resolved. It requires an object with any number of functions on it, where each function returns a promise. In the following example this object is called `resolveBefore`. We can pass it to the `routeProvider` when setting up the routing table. It can be passed as the `resolve` field of the configuration object.

The common pattern therefore looks as follows:

	var resolveBefore = {};

	MODULE.config(function($routeProvider, en$jsonrpcProvider) {
		resolveBefore.exampleEndpoint = en$jsonrpcProvider.endpoint("exampleEndpoint");
		$routeProvider.when('/', {
			controller 	: Controller,
			templateUrl : '/osgi.enroute.examples.jsonrpc/main/htm/home.htm',
			resolve 	: resolveBefore
		});
	});

## en$jsonrpcProvider

The `en$jsonrpcProvider` must be configured during Angular configuration (`MODULE.config( function )`). It provides the following methods:

* `endpoint( string [, target ] )` – Create an endpoint. Returns a function that will return a promise when called. If the target object is provided it will also be configured to contain all the endpoint functions. 
* `url( url )` – Set the base URL, default is `/jsonrpc/2.0`.
* `setNotification( { error: function(msg) } )` – Provide an error function when a JSON RPC method fails, i.e. an exception is thrown on the other side or the protocol fails.
* `route([ path ] )` – Add a diagnostics window to the application at `path`. The default path is `/enroute/jsonrpc`. This diagnostic window will show the history of the last calls and it will show the endpoints. 

## en$jsonRpc

* `ping()` – Check if the server is alive
* `endpoint( string [, target ] )` – Create a new endpoint. Returns a function that will return a promise when called. If the target object is provided it will also be configured to contain all the endpoint functions. 
	The promise that is returned from the function that is returned from the `endpoint(name)` (sic!) method on the `en$jsonrpcProvider` is resolved with an `endpoint` object. An endpoint object has the following fields:
	* `descriptor`  – The content that is received from the back-end `getDescriptor()` method.  
	* `<function>` – functions that proxy all public methods declared in the JSONRPC service.
* `getEndpoint(name)` – Return a named endpoint

## References

* [JSON RPC Specification][jsonrpc]
* [The JSON RPC Example][example]
* [The resolve function of the Angular Route Provider][routeProvider]


[jsonrpc]: http://www.jsonrpc.org/specification
[example]: https://github.com/osgi/osgi.enroute.examples/tree/master/osgi.enroute.examples.jsonrpc.application
[routeProvider]: https://docs.angularjs.org/api/ngRoute/provider/$routeProvider 


## Discussion

*   **What is the goal of the method `public Object getDescriptor()` in the JSONRPC interface?**

    At startup, the Javascript has to talk to the back end to get the method names so it can add them to the Javascript object that acts as proxy. This requires a round trip to the back end. Since this is expensive, the getDescriptor can contribute a pay load that hikes a ride on the round trip. In some applications I use this to provide the permissions to the Javascript code. The data, whatever you provide from the Java code, is put in the Endpoint.descriptor. However, it is basically up to you how to use it. 

*   **Why is there a JSONRPC interface anyway that one must implement. Wouldn't it be simpler to extend any service that has the jsonrpc endpoint property set? One could still check whether it implements JSONRPC and use the getDescriptor method in that case?**

    The reason for the interface is security. The JSONRPC is a service that called from outside. This requires that you defend against intrusions since it is the perfect attack vector. So despite the comfort and ease of use of being able to use RPCs this is NOT a normal service. The JSONRPC interface is just to make sure you acknowledge that you realize you’re in a dangerous area.

*   **Shouldn’t `JSONRPC.ENDPOINT` be something more name spaced instead of `endpoint`, i.e. `osgi.enroute.jsonrpc.endpoint`** 

    This is not necessary as long as we have an interface associated with it, then the property is easy to scope within the interface. I.e. the properties can be assumed to be scoped with an interface. Of course of this would be change to not require an interface the property becomes global and would require scoping.

*   **I'm not quite understanding the `resolveBefore` variable that you use in the client code example. I just use something like this in my controller:**

        $scope.ff = {};
        en$jsonrpc.endpoint("be.iminds.iot.firefly").then(
               function(ff){
                   $scope.ff = ff;
               }
        );
       
    **And from then on I call methods on $scope.ff  ...  Probably there is something wrong with this?** 
    
    It is related to the roundtrip. Because the Javascript needs the roundtrip to the backend to get the method names, the endpoint is not usable until this happens. The resolveBefore variable is used in the routing table to make sure the view and controller are not activated until the variable is resolved. I do agree the way is a bit strange (I think it is function returning a promise? Would have to look). Initially I had to do something like you did but this was very awkward because you have to do it in ALL controllers. Then a new version of Angular introduced a facility to provide this promise to the router. And I sure hope you use the router :-)





---------------
[jsonrpc]: http://www.jsonrpc.org/specification 

    
