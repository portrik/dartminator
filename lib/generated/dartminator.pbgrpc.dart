///
//  Generated code. Do not modify.
//  source: dartminator.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'dartminator.pb.dart' as $0;
export 'dartminator.pb.dart';

class NodeClient extends $grpc.Client {
  static final _$initiate =
      $grpc.ClientMethod<$0.ComputationArgument, $0.ComputationHeartbeat>(
          '/Node/Initiate',
          ($0.ComputationArgument value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.ComputationHeartbeat.fromBuffer(value));

  NodeClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseStream<$0.ComputationHeartbeat> initiate(
      $0.ComputationArgument request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$initiate, $async.Stream.fromIterable([request]),
        options: options);
  }
}

abstract class NodeServiceBase extends $grpc.Service {
  $core.String get $name => 'Node';

  NodeServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.ComputationArgument, $0.ComputationHeartbeat>(
            'Initiate',
            initiate_Pre,
            false,
            true,
            ($core.List<$core.int> value) =>
                $0.ComputationArgument.fromBuffer(value),
            ($0.ComputationHeartbeat value) => value.writeToBuffer()));
  }

  $async.Stream<$0.ComputationHeartbeat> initiate_Pre($grpc.ServiceCall call,
      $async.Future<$0.ComputationArgument> request) async* {
    yield* initiate(call, await request);
  }

  $async.Stream<$0.ComputationHeartbeat> initiate(
      $grpc.ServiceCall call, $0.ComputationArgument request);
}
