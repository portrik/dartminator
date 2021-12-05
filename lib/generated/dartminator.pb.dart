///
//  Generated code. Do not modify.
//  source: dartminator.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/any.pb.dart' as $1;
import 'google/protobuf/empty.pb.dart' as $2;

class ComputationArgument extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ComputationArgument', createEmptyInstance: create)
    ..aOM<$1.Any>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'argument', subBuilder: $1.Any.create)
    ..hasRequiredFields = false
  ;

  ComputationArgument._() : super();
  factory ComputationArgument({
    $1.Any? argument,
  }) {
    final _result = create();
    if (argument != null) {
      _result.argument = argument;
    }
    return _result;
  }
  factory ComputationArgument.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputationArgument.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputationArgument clone() => ComputationArgument()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputationArgument copyWith(void Function(ComputationArgument) updates) => super.copyWith((message) => updates(message as ComputationArgument)) as ComputationArgument; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ComputationArgument create() => ComputationArgument._();
  ComputationArgument createEmptyInstance() => create();
  static $pb.PbList<ComputationArgument> createRepeated() => $pb.PbList<ComputationArgument>();
  @$core.pragma('dart2js:noInline')
  static ComputationArgument getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputationArgument>(create);
  static ComputationArgument? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Any get argument => $_getN(0);
  @$pb.TagNumber(1)
  set argument($1.Any v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasArgument() => $_has(0);
  @$pb.TagNumber(1)
  void clearArgument() => clearField(1);
  @$pb.TagNumber(1)
  $1.Any ensureArgument() => $_ensure(0);
}

class ComputationResult extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ComputationResult', createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'done')
    ..aOM<$1.Any>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'result', subBuilder: $1.Any.create)
    ..hasRequiredFields = false
  ;

  ComputationResult._() : super();
  factory ComputationResult({
    $core.bool? done,
    $1.Any? result,
  }) {
    final _result = create();
    if (done != null) {
      _result.done = done;
    }
    if (result != null) {
      _result.result = result;
    }
    return _result;
  }
  factory ComputationResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputationResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputationResult clone() => ComputationResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputationResult copyWith(void Function(ComputationResult) updates) => super.copyWith((message) => updates(message as ComputationResult)) as ComputationResult; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ComputationResult create() => ComputationResult._();
  ComputationResult createEmptyInstance() => create();
  static $pb.PbList<ComputationResult> createRepeated() => $pb.PbList<ComputationResult>();
  @$core.pragma('dart2js:noInline')
  static ComputationResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputationResult>(create);
  static ComputationResult? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get done => $_getBF(0);
  @$pb.TagNumber(1)
  set done($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDone() => $_has(0);
  @$pb.TagNumber(1)
  void clearDone() => clearField(1);

  @$pb.TagNumber(2)
  $1.Any get result => $_getN(1);
  @$pb.TagNumber(2)
  set result($1.Any v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasResult() => $_has(1);
  @$pb.TagNumber(2)
  void clearResult() => clearField(2);
  @$pb.TagNumber(2)
  $1.Any ensureResult() => $_ensure(1);
}

enum ComputationHeartbeat_Content {
  result, 
  empty, 
  notSet
}

class ComputationHeartbeat extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, ComputationHeartbeat_Content> _ComputationHeartbeat_ContentByTag = {
    1 : ComputationHeartbeat_Content.result,
    2 : ComputationHeartbeat_Content.empty,
    0 : ComputationHeartbeat_Content.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ComputationHeartbeat', createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<ComputationResult>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'result', subBuilder: ComputationResult.create)
    ..aOM<$2.Empty>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'empty', subBuilder: $2.Empty.create)
    ..hasRequiredFields = false
  ;

  ComputationHeartbeat._() : super();
  factory ComputationHeartbeat({
    ComputationResult? result,
    $2.Empty? empty,
  }) {
    final _result = create();
    if (result != null) {
      _result.result = result;
    }
    if (empty != null) {
      _result.empty = empty;
    }
    return _result;
  }
  factory ComputationHeartbeat.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputationHeartbeat.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputationHeartbeat clone() => ComputationHeartbeat()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputationHeartbeat copyWith(void Function(ComputationHeartbeat) updates) => super.copyWith((message) => updates(message as ComputationHeartbeat)) as ComputationHeartbeat; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ComputationHeartbeat create() => ComputationHeartbeat._();
  ComputationHeartbeat createEmptyInstance() => create();
  static $pb.PbList<ComputationHeartbeat> createRepeated() => $pb.PbList<ComputationHeartbeat>();
  @$core.pragma('dart2js:noInline')
  static ComputationHeartbeat getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputationHeartbeat>(create);
  static ComputationHeartbeat? _defaultInstance;

  ComputationHeartbeat_Content whichContent() => _ComputationHeartbeat_ContentByTag[$_whichOneof(0)]!;
  void clearContent() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ComputationResult get result => $_getN(0);
  @$pb.TagNumber(1)
  set result(ComputationResult v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => clearField(1);
  @$pb.TagNumber(1)
  ComputationResult ensureResult() => $_ensure(0);

  @$pb.TagNumber(2)
  $2.Empty get empty => $_getN(1);
  @$pb.TagNumber(2)
  set empty($2.Empty v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasEmpty() => $_has(1);
  @$pb.TagNumber(2)
  void clearEmpty() => clearField(2);
  @$pb.TagNumber(2)
  $2.Empty ensureEmpty() => $_ensure(1);
}

