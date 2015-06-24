---
title: osgi.enroute.jsonrpc.api
layout: service
version: 1.0
summary:  A white-board approach to JSON RPC 
---

![JSON RPC Service Collaboration Overview](/img/services/osgi.enroute.jsonrpc.overview.png)

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
