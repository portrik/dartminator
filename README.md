# Dartminator

Dartminator is a simple semestral project for the fall 2021 class of Distributed Algorithms at FEL CTU. This project implements the Dijkstra-Scholten algorithm in Dart with the help of gRPC on a local network. 

## [Dijkstra-Scholten](https://en.wikipedia.org/wiki/Dijkstra%E2%80%93Scholten_algorithm) 

The Dijkstra–Scholten algorithm is a tree-based algorithm which can be described by the following:

* The initiator of a computation is the root of the tree.
* Upon receiving a computational message:
    * If the receiving process is currently not in the computation: the process joins the tree by becoming a child of the sender of the message. (No acknowledgment message is sent at this point.)
    * If the receiving process is already in the computation: the process immediately sends an acknowledgment message to the sender of the message.
* When a process has no more children and has become idle, the process detaches itself from the tree by sending an acknowledgment message to its tree parent.
* Termination occurs when the initiator has no children and has become idle.


## Technical Description

Dartminator is written in Dart, using the latest SDK version (``2.15.1``). Dart can be compiled to native code and JavaScript but as Dartminator uses the local network for node discovery, **the JavaScript version will not work**.

Each node can implement a different type of computation. These nodes can live on the same network and will check the computation type upon discovery.

Concurrency is achieved through [Isolates](https://api.dart.dev/stable/2.15.0/dart-isolate/Isolate-class.html). Similarly to threads in other languages, Isolates execute code in a separate thread and do not block execution on the main one. The only difference is complete isolation state and memory - isolates have to communicate through ports without sending any data with their own closures. This is mostly due to the compilation down to JavaScript, as concurrency in the browser is done with Web Workers.

gRPC is used for communication during the computation. Any node can try to connect to any other node that is not already connected. But the connection with already computing nodes will be terminated upon receiving an empty response, as per the Dijkstra-Scholten algorithm. Otherwise, the connection is kept alive until the computation on the child node is complete. To circumvent the passive connection checks of gRPC, a heartbeat stream is used to check to health of a connection. The child node periodically returns an empty heartbeat to the parent. In case of delay, due to connectivity problems or node death, the connection is terminated and the computation is reassigned.

The discovery of nodes is done with a broadcast message sent over the network. Every node has to respond and an attempt by the discoverer has to be made to add the new node to the computation. Self-requests and requests for a different computation type are discarded.

The computation is orchestrated by the implementation of the ```Computation``` class. This class contains both the algorithm of the computation and an argument assigning mechanism. For example, a computation working over a shared file system will assign a single file to a node to process. Moreover, the Dartminator nodes are implemented as generics. This means that nodes with different computations may be deployed on the same network without clashing.

### Structure

The program is divided into two parts: ```bin``` and ```lib```.

The ```bin``` directory contains the main file from which the node is started and controlled.

The ```lib``` directory contains all of the necessary source files. It contains both hand-written files and files generated by the gRPC from the Protocol Buffers definition file stored in the ```protos``` directory. The generated files are stored inside the ```lib/generated``` directory.

The ```lib/cli.dart``` file contains all of the functions pertaining to the interaction with CLI.

The ```lib/computation.dart``` file contains the abstract definition of ```Computation``` and an example implementation of ```TestComputation```.

The ```lib/constants.dart``` file contains constant values used throughout the node.

The ```lib/logger.dart``` file contains a customized implementation of a logger.

## How to Run

### Prerequisites

1. Have the latest version of Dart installed
   * Up-to-date information can be found in [the official documentation](https://dart.dev/get-dart)
   * MacOS installation is recommended through ```brew tap dart-lang/dart``` and ```brew install dart```
   * Windows installation is recommended through Chocolatey by running ```choco install dart-sdk```
   * Linux installation is recommended either through ```sudo apt-get install dart``` or through a .deb package available on the [Dart website](https://dart.dev/get-dart)
2. Install dependencies by running ```dart pub get```

### Running the node

The development version can be started with ```dart bin/main.dart```. This will start a node with the default values and will listen for incoming computation requests. This behavior can be changed with the CLI options specified below.

The code can be also compiled to a native module with ```dart compile exe bin/main.dart -o $NAME```, where $NAME is the name of the compiled file. This file can be then run directly with the same options as the development version only with performance benefits. Unfortunately, it is currently only possible to compile code for the host system, as [cross-compilation is not supported yet](https://github.com/dart-lang/sdk/issues/28617).


### Example commands

| Command                                        | Description                                                                                                                       |
| ---------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| ```dart bin/main.dart```                       | Starts the node with default values. The node will then listen for computations until it is terminated.                           |
| ```dart bin/main.dart -n Ferda -p 8081 -m 4``` | Starts the node with custom name, port and max children count. The node will then listen for computations until it is terminated. |
| ```dart bin/main.dart -s```                    | Starts the node and initiates the computation. After the computation finishes, the node will terminate.                           |

## CLI Options

| Argument                              | Description                                                                                                                                                                    |
| ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| ```-h``` / ```--help```               | Prints out the help information.                                                                                                                                               |
| ```-s``` / ```--start```              | Starts the computation on this node.                                                                                                                                           |
| ```-n [NAME]``` / ```--name [NAME]``` | Sets a custom name of the node. NAME has to be a non-empty string. By default, the name is a randomly generated name from the [faker package](https://pub.dev/packages/faker). |
| ```-p [PORT]``` / ```--port [PORT]``` | Sets a custom port over which the nodes will connect to each other. PORT has to be a number of an unused port. By default ```8080```.                                          |
| ```-m [MAX]``` / ```--max [MAX]```    | Sets a maximum number of children a node can have. MAX has to be a non-negative number. By default ```2```.                                                                    |
| ```---grpc [PORT]```                  | Sets a custom port for gRPC communication. By default ```50051```.                                                                                                             |
| ```--grpc-timeout [SECONDS]```        | Sets a custom timeout of a gRPC connection. By default ```100```.                                                                                                              |
| ```--search-length [SECONDS]```       | Sets a custom length of the search for child nodes. By default ```1```.                                                                                                        |
| ```--heartbeat-timeout [SECONDS]```   | Sets a custom timeout between each heartbeat. Should be lower thant the gRPC timeout. By default ```1```.                                                                      |