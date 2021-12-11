/// Timeout for the child node search.
const childSearchTimeout = Duration(seconds: 1);

/// Port to run gRPC on.
const grpcPort = 50051;

/// Timeout of a gRPC call.
const grpcCallTimeout = Duration(seconds: 100);

/// Timeout between sending heartbeats.
const calculationTimeout = Duration(seconds: 1);
