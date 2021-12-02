///
//  Generated code. Do not modify.
//  source: dartminator.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use computationalMessageDescriptor instead')
const ComputationalMessage$json = const {
  '1': 'ComputationalMessage',
  '2': const [
    const {'1': 'algorithm_name', '3': 1, '4': 1, '5': 9, '10': 'algorithmName'},
    const {'1': 'argument', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Any', '10': 'argument'},
  ],
};

/// Descriptor for `ComputationalMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computationalMessageDescriptor = $convert.base64Decode('ChRDb21wdXRhdGlvbmFsTWVzc2FnZRIlCg5hbGdvcml0aG1fbmFtZRgBIAEoCVINYWxnb3JpdGhtTmFtZRIwCghhcmd1bWVudBgCIAEoCzIULmdvb2dsZS5wcm90b2J1Zi5BbnlSCGFyZ3VtZW50');
@$core.Deprecated('Use computationFinishedDescriptor instead')
const ComputationFinished$json = const {
  '1': 'ComputationFinished',
  '2': const [
    const {'1': 'done', '3': 1, '4': 1, '5': 8, '10': 'done'},
    const {'1': 'result', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Any', '10': 'result'},
  ],
};

/// Descriptor for `ComputationFinished`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computationFinishedDescriptor = $convert.base64Decode('ChNDb21wdXRhdGlvbkZpbmlzaGVkEhIKBGRvbmUYASABKAhSBGRvbmUSLAoGcmVzdWx0GAIgASgLMhQuZ29vZ2xlLnByb3RvYnVmLkFueVIGcmVzdWx0');
@$core.Deprecated('Use acknowledgementDescriptor instead')
const Acknowledgement$json = const {
  '1': 'Acknowledgement',
  '2': const [
    const {'1': 'finished', '3': 1, '4': 1, '5': 11, '6': '.ComputationFinished', '9': 0, '10': 'finished'},
    const {'1': 'nothing', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Empty', '9': 0, '10': 'nothing'},
  ],
  '8': const [
    const {'1': 'response'},
  ],
};

/// Descriptor for `Acknowledgement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acknowledgementDescriptor = $convert.base64Decode('Cg9BY2tub3dsZWRnZW1lbnQSMgoIZmluaXNoZWQYASABKAsyFC5Db21wdXRhdGlvbkZpbmlzaGVkSABSCGZpbmlzaGVkEjIKB25vdGhpbmcYAiABKAsyFi5nb29nbGUucHJvdG9idWYuRW1wdHlIAFIHbm90aGluZ0IKCghyZXNwb25zZQ==');
