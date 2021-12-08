# Dartminator

Dartminator is a simple semestral project for the fall 2021 class of Distributed Algorithms at FEL CTU. It implements the Dijkstra-Scholten algorithm in Dart with the help of gRPC.

## [Dijkstra-Scholten](https://en.wikipedia.org/wiki/Dijkstra%E2%80%93Scholten_algorithm) 

The Dijkstra–Scholten algorithm is a tree-based algorithm which can be described by the following:

* The initiator of a computation is the root of the tree.
* Upon receiving a computational message:
    * If the receiving process is currently not in the computation: the process joins the tree by becoming a child of the sender of the message. (No acknowledgment message is sent at this point.)
    * If the receiving process is already in the computation: the process immediately sends an acknowledgment message to the sender of the message.
* When a process has no more children and has become idle, the process detaches itself from the tree by sending an acknowledgment message to its tree parent.
* Termination occurs when the initiator has no children and has become idle.


## Technical Information

Dartminator is written in Dart, using the SDK version ``2.14.4``. Dart can be compiled to native code and JavaScript but as Dartminator uses the local network for node discovery, **the JavaScript version will not work**.

Concurrency is achieved through [Isolates](https://api.dart.dev/stable/2.15.0/dart-isolate/Isolate-class.html). Similarly to threads in other languages, Isolates execute code in a separate thread and do not block execution on the main one. The only difference is complete isolation state and memory - isolates have to communicate through ports without sending any data with their own closures. This is mostly due to the compilation down to JavaScript, as concurrency in the browser is done with Web Workers.

gRPC is used for communication during the computation. Any node can try to connect to any other node that is not already connected. But the connection with already computing nodes will be terminated upon receiving an empty response. Otherwise, the connection is kept alive until the computation on the child node is complete.

The discovery of nodes is done with a broadcast message sent over the network. Every node has to respond and an attempt by the discoverer has to be made to add the new node to the computation.

## Running with Dart

The development version can be started with ``dart bin/main.dart`, if the Dart SDK is present on the system.

The code can be also compiled to a native module with ``dart compile exe bin/main.dart -o $NAME``, where $NAME is the name of the compiled file. Unfortunately, it is currently only possible to compile code for the host system, as [cross-compilation is not supported yet](https://github.com/dart-lang/sdk/issues/28617).