///
//  Generated code. Do not modify.
//  source: dartminator.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use computationArgumentDescriptor instead')
const ComputationArgument$json = const {
  '1': 'ComputationArgument',
  '2': const [
    const {'1': 'argument', '3': 1, '4': 1, '5': 9, '10': 'argument'},
  ],
};

/// Descriptor for `ComputationArgument`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computationArgumentDescriptor = $convert.base64Decode('ChNDb21wdXRhdGlvbkFyZ3VtZW50EhoKCGFyZ3VtZW50GAEgASgJUghhcmd1bWVudA==');
@$core.Deprecated('Use computationResultDescriptor instead')
const ComputationResult$json = const {
  '1': 'ComputationResult',
  '2': const [
    const {'1': 'done', '3': 1, '4': 1, '5': 8, '10': 'done'},
    const {'1': 'result', '3': 2, '4': 1, '5': 9, '10': 'result'},
  ],
};

/// Descriptor for `ComputationResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computationResultDescriptor = $convert.base64Decode('ChFDb21wdXRhdGlvblJlc3VsdBISCgRkb25lGAEgASgIUgRkb25lEhYKBnJlc3VsdBgCIAEoCVIGcmVzdWx0');
@$core.Deprecated('Use computationHeartbeatDescriptor instead')
const ComputationHeartbeat$json = const {
  '1': 'ComputationHeartbeat',
  '2': const [
    const {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.ComputationResult', '9': 0, '10': 'result'},
    const {'1': 'empty', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Empty', '9': 0, '10': 'empty'},
  ],
  '8': const [
    const {'1': 'content'},
  ],
};

/// Descriptor for `ComputationHeartbeat`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List computationHeartbeatDescriptor = $convert.base64Decode('ChRDb21wdXRhdGlvbkhlYXJ0YmVhdBIsCgZyZXN1bHQYASABKAsyEi5Db21wdXRhdGlvblJlc3VsdEgAUgZyZXN1bHQSLgoFZW1wdHkYAiABKAsyFi5nb29nbGUucHJvdG9idWYuRW1wdHlIAFIFZW1wdHlCCQoHY29udGVudA==');
