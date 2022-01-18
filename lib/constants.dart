/// Timeout for the child node search.
var childSearchTimeout = Duration(seconds: 1);

/// Port to run gRPC on.
var grpcPort = 50051;

/// Timeout of a gRPC call.
var grpcCallTimeout = Duration(seconds: 10);

/// Timeout between sending heartbeats.
var heartbeatTimeout = Duration(seconds: 1);
