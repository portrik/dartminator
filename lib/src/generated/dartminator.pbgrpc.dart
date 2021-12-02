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
import 'google/protobuf/empty.pb.dart' as $1;
export 'dartminator.pb.dart';

class NodeClient extends $grpc.Client {
  static final _$initiateComputation =
      $grpc.ClientMethod<$0.ComputationalMessage, $0.Acknowledgement>(
          '/Node/InitiateComputation',
          ($0.ComputationalMessage value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.Acknowledgement.fromBuffer(value));
  static final _$sendComputationEnd =
      $grpc.ClientMethod<$0.Acknowledgement, $1.Empty>(
          '/Node/SendComputationEnd',
          ($0.Acknowledgement value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Empty.fromBuffer(value));

  NodeClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.Acknowledgement> initiateComputation(
      $0.ComputationalMessage request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$initiateComputation, request, options: options);
  }

  $grpc.ResponseFuture<$1.Empty> sendComputationEnd($0.Acknowledgement request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$sendComputationEnd, request, options: options);
  }
}

abstract class NodeServiceBase extends $grpc.Service {
  $core.String get $name => 'Node';

  NodeServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ComputationalMessage, $0.Acknowledgement>(
        'InitiateComputation',
        initiateComputation_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ComputationalMessage.fromBuffer(value),
        ($0.Acknowledgement value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Acknowledgement, $1.Empty>(
        'SendComputationEnd',
        sendComputationEnd_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Acknowledgement.fromBuffer(value),
        ($1.Empty value) => value.writeToBuffer()));
  }

  $async.Future<$0.Acknowledgement> initiateComputation_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.ComputationalMessage> request) async {
    return initiateComputation(call, await request);
  }

  $async.Future<$1.Empty> sendComputationEnd_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Acknowledgement> request) async {
    return sendComputationEnd(call, await request);
  }

  $async.Future<$0.Acknowledgement> initiateComputation(
      $grpc.ServiceCall call, $0.ComputationalMessage request);
  $async.Future<$1.Empty> sendComputationEnd(
      $grpc.ServiceCall call, $0.Acknowledgement request);
}
