///
//  Generated code. Do not modify.
//  source: dartminator.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/any.pb.dart' as $2;
import 'google/protobuf/empty.pb.dart' as $1;

class ComputationalMessage extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ComputationalMessage', createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'algorithmName')
    ..aOM<$2.Any>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'argument', subBuilder: $2.Any.create)
    ..hasRequiredFields = false
  ;

  ComputationalMessage._() : super();
  factory ComputationalMessage({
    $core.String? algorithmName,
    $2.Any? argument,
  }) {
    final _result = create();
    if (algorithmName != null) {
      _result.algorithmName = algorithmName;
    }
    if (argument != null) {
      _result.argument = argument;
    }
    return _result;
  }
  factory ComputationalMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputationalMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputationalMessage clone() => ComputationalMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputationalMessage copyWith(void Function(ComputationalMessage) updates) => super.copyWith((message) => updates(message as ComputationalMessage)) as ComputationalMessage; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ComputationalMessage create() => ComputationalMessage._();
  ComputationalMessage createEmptyInstance() => create();
  static $pb.PbList<ComputationalMessage> createRepeated() => $pb.PbList<ComputationalMessage>();
  @$core.pragma('dart2js:noInline')
  static ComputationalMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputationalMessage>(create);
  static ComputationalMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get algorithmName => $_getSZ(0);
  @$pb.TagNumber(1)
  set algorithmName($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAlgorithmName() => $_has(0);
  @$pb.TagNumber(1)
  void clearAlgorithmName() => clearField(1);

  @$pb.TagNumber(2)
  $2.Any get argument => $_getN(1);
  @$pb.TagNumber(2)
  set argument($2.Any v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasArgument() => $_has(1);
  @$pb.TagNumber(2)
  void clearArgument() => clearField(2);
  @$pb.TagNumber(2)
  $2.Any ensureArgument() => $_ensure(1);
}

class ComputationFinished extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ComputationFinished', createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'done')
    ..aOM<$2.Any>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'result', subBuilder: $2.Any.create)
    ..hasRequiredFields = false
  ;

  ComputationFinished._() : super();
  factory ComputationFinished({
    $core.bool? done,
    $2.Any? result,
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
  factory ComputationFinished.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ComputationFinished.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ComputationFinished clone() => ComputationFinished()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ComputationFinished copyWith(void Function(ComputationFinished) updates) => super.copyWith((message) => updates(message as ComputationFinished)) as ComputationFinished; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ComputationFinished create() => ComputationFinished._();
  ComputationFinished createEmptyInstance() => create();
  static $pb.PbList<ComputationFinished> createRepeated() => $pb.PbList<ComputationFinished>();
  @$core.pragma('dart2js:noInline')
  static ComputationFinished getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ComputationFinished>(create);
  static ComputationFinished? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get done => $_getBF(0);
  @$pb.TagNumber(1)
  set done($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDone() => $_has(0);
  @$pb.TagNumber(1)
  void clearDone() => clearField(1);

  @$pb.TagNumber(2)
  $2.Any get result => $_getN(1);
  @$pb.TagNumber(2)
  set result($2.Any v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasResult() => $_has(1);
  @$pb.TagNumber(2)
  void clearResult() => clearField(2);
  @$pb.TagNumber(2)
  $2.Any ensureResult() => $_ensure(1);
}

enum Acknowledgement_Response {
  finished, 
  nothing, 
  notSet
}

class Acknowledgement extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, Acknowledgement_Response> _Acknowledgement_ResponseByTag = {
    1 : Acknowledgement_Response.finished,
    2 : Acknowledgement_Response.nothing,
    0 : Acknowledgement_Response.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Acknowledgement', createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<ComputationFinished>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'finished', subBuilder: ComputationFinished.create)
    ..aOM<$1.Empty>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'nothing', subBuilder: $1.Empty.create)
    ..hasRequiredFields = false
  ;

  Acknowledgement._() : super();
  factory Acknowledgement({
    ComputationFinished? finished,
    $1.Empty? nothing,
  }) {
    final _result = create();
    if (finished != null) {
      _result.finished = finished;
    }
    if (nothing != null) {
      _result.nothing = nothing;
    }
    return _result;
  }
  factory Acknowledgement.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Acknowledgement.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Acknowledgement clone() => Acknowledgement()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Acknowledgement copyWith(void Function(Acknowledgement) updates) => super.copyWith((message) => updates(message as Acknowledgement)) as Acknowledgement; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Acknowledgement create() => Acknowledgement._();
  Acknowledgement createEmptyInstance() => create();
  static $pb.PbList<Acknowledgement> createRepeated() => $pb.PbList<Acknowledgement>();
  @$core.pragma('dart2js:noInline')
  static Acknowledgement getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Acknowledgement>(create);
  static Acknowledgement? _defaultInstance;

  Acknowledgement_Response whichResponse() => _Acknowledgement_ResponseByTag[$_whichOneof(0)]!;
  void clearResponse() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ComputationFinished get finished => $_getN(0);
  @$pb.TagNumber(1)
  set finished(ComputationFinished v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasFinished() => $_has(0);
  @$pb.TagNumber(1)
  void clearFinished() => clearField(1);
  @$pb.TagNumber(1)
  ComputationFinished ensureFinished() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Empty get nothing => $_getN(1);
  @$pb.TagNumber(2)
  set nothing($1.Empty v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasNothing() => $_has(1);
  @$pb.TagNumber(2)
  void clearNothing() => clearField(2);
  @$pb.TagNumber(2)
  $1.Empty ensureNothing() => $_ensure(1);
}

