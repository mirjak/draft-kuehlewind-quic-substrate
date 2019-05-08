---
title: Use Cases and Requirements for QUIC as a Substrate
abbrev: QUIC Substarte
docname: draft-kuehlewind-quic-substrate-latest
date:
category: info

ipr: trust200902
keyword: Internet-Draft

stand_alone: yes
pi: [sortrefs, symrefs]

author:
  -
    ins: M. Kuehlewind
    name: Mirja Kuehlewind
    org: Ericsson
    email: mirja.kuehlewind@ericsson.com
  - 
    ins: Z. Sarker
    name: Zaheduzzaman Sarker
    org: Ericsson
    email: zaheduzzaman.sarker@ericsson.com
  
  
normative:

informative:

--- abstract

QUIC is a new, emerging transport protocol. Similarly to how TCP is used today
as encapsulation or tunneling protocol -- typically in association with a
secure protocol, for example TLS, SSH -- it is expected that QUIC will be used
as a substrate when widely deployed. Using QUIC instead of TCP in existing
scenarios can have a benefit of avoiding support for different protocols if the
inner protocol is also QUIC. Further, use of QUIC enables new opportunities for
the respective tunneling or encapsulation usage due to lower setup latency and
multi-streaming support.  This document summarizes current and future usage
scenarios to derive requirements for QUIC and to provide additional protocol
considerations.

--- middle

# Introduction

QUIC is a new transport protocol that was initially developed as an
optimization for HTTP traffic by supporting multiplexing and the integration of
security.  The latter enables a speed-up of the handshake to set up the
transport connection as well as the needed security context for encryption and
authentication at the same time.  Given the expectation that QUIC will be widely
used for HTTP, it also makes sense to enable use of QUIC for HTTP proxy
services.

However, QUIC is a general purpose transport protocol and it is expected that it
will be used in future for many other kinds of traffic, whenever the features
provided by QUIC (compared to TCP) are beneficial for the high-layer service.
Especially QUIC's multiplexing support and build-in encryption support can come
in handy for tunneling or proxying setups in general.

While today proxies are often operated in a transparent fashion, it is expected
that future in-network services will work in a cooperative way by being visible
and explicitly selected by at least one of the endpoints. This does not only
enable a client endpoint to make an explicit decision about the service requested to
a proxy, such as simple forwarding or more advanced services to optimize performance,
but also provides a secured communication channel between a middlepoint and the
endpoint.


# Usage Scenarios

## Use of Tunnels for Obfuscations and Content Selection

Tunnels are used in many scenarios within the core of the network as well as
from an client endpoint to a proxy middlepoint on the way towards the server. In many cases, when
the client explicitly decides to use the support of a proxy in order to get
connected to a server, this is because a direct connection may be impaired. For example, this
can be the case in enterprise network where traffic is firewalled
and web traffic needs to be routed over an explicitly provided HTTP proxy, or
other reasons exist for blocking of certain services: censorship, data exfiltration protection, etc.

In this usage scenario the client knows the proxy's address and explicitly
selects to connect to the proxy in order to instruct the proxy to forward its
traffic to a specific server. At a minimum, the client needs to communicate
directly with the proxy to provide the address of the server it wants to connect to,
e.g. using HTTP CONNECT.

Such a setup can also be realized with the use of an outer tunnel which would additionally
obfuscate the content of the tunnel traffic to any observer between the client
and the proxy. Usually the server is not aware of the proxy in the middle, so
the proxy needs to re-write the IP address of any traffic inside the tunnel to
ensure that the return traffic is also routed back to the proxy. This is also often
used to conceal the address/location of the client to the server, e.g. to access
local content that would not be accessible by the client at its current location 
otherwise.

In any of these tunneling scenarios, including those deployed today, the client
explicitly decides to make use of a proxy service while being fully transparent
for server, or even with the intention to hide the client's identity from the
server. This is explicitly part of the design as these services are targeting an
impaired or otherwise constrained network setup. Therefore, an explicit
communication channel between client and proxy is needed to at least
communicate the information about the target server's address, and potentially
other information needed to inform the behaviour of the proxy.


## Advanced Support of User Agents

Depending on the traffic that is sent "over" the proxy, it is also possible that
the proxy can perform additional support services if requested by the client.
Today, Performance Enhancing Proxies (PEPs) usually work transparently by either
fully or partially terminating the transport connection or even intercepting the
end-to-end encryption. However, for many of these support services, termination
is actually not needed or even problematic, but often the only or at least
easiest solution if no direct communication with the client is available.
Enabling these services based on an explicit tunnel setup between the client and
the proxy provides such a communication channel and makes it possible to
exchange information in a private and authenticated way.

It is expected that in-network functions are usually provided close to the
client, e.g. hosted by the access network provider. Having this direct relation between
the endpoint and the network service is also necessary in order to discover the
service, as the assumption is that a client knows how to address the proxy
service and which service is offered (besides forwarding). Such a setup is
especially valuable in access networks with challenging link environments such as
satellite or cellular networks. While end-to-end functions need to be designed
to handle all kind of network conditions, direct support from the network can
help to optimize for the specific characteristics of the access network such as use
of link-specific congestion control or local repair mechanisms.

Further, if not provided by the server directly, a network support function can
also assist the client to adapt the traffic based on device characteristics and
capabilities or user preferences. Again, especially if the access network is
constrained, this can benefit both, the network provider to save resources and
the client to receive the desired service quicker or less impaired. Such a
service could even be extended to include caching or pre-fetching depending on
the trust relationship between the client and the proxy.

Depending on the function provided, the proxy may need to access or alter the
traffic or content. Alternatively, if the information provided by the client or proxy
can be trusted, it might in some cases also be possible for each of the entities
to act based on these information without the need to access the content or some
of the traffic metadata directly. Especially transport layer optimizations do not need
access to the actual user content. Network functions should generally minimize
dependencies to higher layer characteristics as those may change frequently.

Similar as in the previous usage scenario, in this setup the client explicitly
selects the proxy and specifies the requested support function. Often the server
may not need to be aware of it, however, depending on the optimization function,
server cooperation could be beneficial as well. However, the client and the proxy
need a direct and secured communication channel in order to request and configure
a service and exchange or expose the needed information and metadata. 


## Frontend Support for Load Balancing and Migration/Mobility 

In this usage scenario the application service provider aims for flexibility in
server selection, therefore the client communicates with a reverse proxy that may
or may not be under the authority of the service provider. Such proxy assist the client
to access and select the content requested. Today such a proxy would terminate the
connection, including the security association, and as such appear as the communication
endpoint to the client. Terminating not only the transport connection but also the 
security association is especially problematic if the proxy provider under the direct
authority of the services provided but a contracted third party.

A similar setup may be used to perform load balancing or migration for mobility support
of both, the server or client, where a frontend proxy can redirect the traffic
to a different backend server. Today this realized fully transparent to the client 
and the client is not aware of the network setup behind the proxy, however, such a setup
may as well benefit in future from an explicit tunneling or proxying approach.

In this usage scenario the client interact with a proxy that is located close to the 
server and potentially even under the same administrative domain or at least has some 
trust relationship with the application service provider. The server is aware of this 
setup and may have an own communication channel with the proxy or tunnel endpoint as well,
in order to advise it about server selection. However, the client is usually not aware of
any specifics about the setup behind the substrate endpoint.


# Requirements

To use QUIC as a substrate, it could be beneficial if unreliable transmission is
supported as well as having a way to potentially influence or disable congestion
control if the inner tunnel traffic is known to be congestion controlled.

Communication between the client and proxy is more likely to be realized as a
separate protocol on top of QUIC or HTTP. However, a QUIC extensibility
mechanism could be used to indicate to the receiver that QUIC is used as a
substrate and potentially additional information about which protocol is used for
communication between these entities. A similar mechanism could be realized in HTTP 
instead. In both cases it is important that the QUIC connection cannot be identified
as a substrate by an observer on the path.

# Acknowledgments

