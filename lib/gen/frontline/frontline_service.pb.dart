//
//  Generated code. Do not modify.
//  source: frontline/frontline_service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../common/types.pb.dart' as $1;
import '../common/types.pbenum.dart' as $1;
import '../google/protobuf/empty.pb.dart' as $2;
import '../google/protobuf/timestamp.pb.dart' as $0;
import 'frontline_service.pbenum.dart';

export 'frontline_service.pbenum.dart';

class GetStopArrivalsRequest extends $pb.GeneratedMessage {
  factory GetStopArrivalsRequest() => create();
  GetStopArrivalsRequest._() : super();
  factory GetStopArrivalsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetStopArrivalsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetStopArrivalsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'busStopCode')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'maxArrivals', $pb.PbFieldType.O3)
    ..aOB(3, _omitFieldNames ? '' : 'includeBusLocations')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetStopArrivalsRequest clone() => GetStopArrivalsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetStopArrivalsRequest copyWith(void Function(GetStopArrivalsRequest) updates) => super.copyWith((message) => updates(message as GetStopArrivalsRequest)) as GetStopArrivalsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStopArrivalsRequest create() => GetStopArrivalsRequest._();
  GetStopArrivalsRequest createEmptyInstance() => create();
  static $pb.PbList<GetStopArrivalsRequest> createRepeated() => $pb.PbList<GetStopArrivalsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetStopArrivalsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetStopArrivalsRequest>(create);
  static GetStopArrivalsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get busStopCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set busStopCode($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBusStopCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearBusStopCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get maxArrivals => $_getIZ(1);
  @$pb.TagNumber(2)
  set maxArrivals($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMaxArrivals() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxArrivals() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get includeBusLocations => $_getBF(2);
  @$pb.TagNumber(3)
  set includeBusLocations($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIncludeBusLocations() => $_has(2);
  @$pb.TagNumber(3)
  void clearIncludeBusLocations() => clearField(3);
}

class GetStopArrivalsResponse extends $pb.GeneratedMessage {
  factory GetStopArrivalsResponse() => create();
  GetStopArrivalsResponse._() : super();
  factory GetStopArrivalsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetStopArrivalsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetStopArrivalsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOM<StopArrivalsData>(1, _omitFieldNames ? '' : 'data', subBuilder: StopArrivalsData.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetStopArrivalsResponse clone() => GetStopArrivalsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetStopArrivalsResponse copyWith(void Function(GetStopArrivalsResponse) updates) => super.copyWith((message) => updates(message as GetStopArrivalsResponse)) as GetStopArrivalsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStopArrivalsResponse create() => GetStopArrivalsResponse._();
  GetStopArrivalsResponse createEmptyInstance() => create();
  static $pb.PbList<GetStopArrivalsResponse> createRepeated() => $pb.PbList<GetStopArrivalsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetStopArrivalsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetStopArrivalsResponse>(create);
  static GetStopArrivalsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  StopArrivalsData get data => $_getN(0);
  @$pb.TagNumber(1)
  set data(StopArrivalsData v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => clearField(1);
  @$pb.TagNumber(1)
  StopArrivalsData ensureData() => $_ensure(0);
}

class StopArrivalsData extends $pb.GeneratedMessage {
  factory StopArrivalsData() => create();
  StopArrivalsData._() : super();
  factory StopArrivalsData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StopArrivalsData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StopArrivalsData', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'busStopCode')
    ..aOS(2, _omitFieldNames ? '' : 'busStopName')
    ..pc<BusArrival>(3, _omitFieldNames ? '' : 'buses', $pb.PbFieldType.PM, subBuilder: BusArrival.create)
    ..pPS(4, _omitFieldNames ? '' : 'messages')
    ..aOS(5, _omitFieldNames ? '' : 'scrollingMessage')
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'updatedAt', subBuilder: $0.Timestamp.create)
    ..pc<BusPosition>(7, _omitFieldNames ? '' : 'busLocations', $pb.PbFieldType.PM, subBuilder: BusPosition.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StopArrivalsData clone() => StopArrivalsData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StopArrivalsData copyWith(void Function(StopArrivalsData) updates) => super.copyWith((message) => updates(message as StopArrivalsData)) as StopArrivalsData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopArrivalsData create() => StopArrivalsData._();
  StopArrivalsData createEmptyInstance() => create();
  static $pb.PbList<StopArrivalsData> createRepeated() => $pb.PbList<StopArrivalsData>();
  @$core.pragma('dart2js:noInline')
  static StopArrivalsData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StopArrivalsData>(create);
  static StopArrivalsData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get busStopCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set busStopCode($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBusStopCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearBusStopCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get busStopName => $_getSZ(1);
  @$pb.TagNumber(2)
  set busStopName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBusStopName() => $_has(1);
  @$pb.TagNumber(2)
  void clearBusStopName() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<BusArrival> get buses => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$core.String> get messages => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get scrollingMessage => $_getSZ(4);
  @$pb.TagNumber(5)
  set scrollingMessage($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasScrollingMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearScrollingMessage() => clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get updatedAt => $_getN(5);
  @$pb.TagNumber(6)
  set updatedAt($0.Timestamp v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasUpdatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpdatedAt() => clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureUpdatedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.List<BusPosition> get busLocations => $_getList(6);
}

class BusArrival extends $pb.GeneratedMessage {
  factory BusArrival() => create();
  BusArrival._() : super();
  factory BusArrival.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BusArrival.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BusArrival', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceNo')
    ..aOS(2, _omitFieldNames ? '' : 'color')
    ..aOB(3, _omitFieldNames ? '' : 'isFree')
    ..aOS(4, _omitFieldNames ? '' : 'destination')
    ..aOM<$1.ArrivalTime>(5, _omitFieldNames ? '' : 'nextArrival', subBuilder: $1.ArrivalTime.create)
    ..aOM<$1.ArrivalTime>(6, _omitFieldNames ? '' : 'laterArrival', subBuilder: $1.ArrivalTime.create)
    ..aOS(7, _omitFieldNames ? '' : 'plateNo')
    ..e<$1.EtaSource>(8, _omitFieldNames ? '' : 'etaSource', $pb.PbFieldType.OE, defaultOrMaker: $1.EtaSource.ETA_SOURCE_UNSPECIFIED, valueOf: $1.EtaSource.valueOf, enumValues: $1.EtaSource.values)
    ..e<$1.DelayStatus>(9, _omitFieldNames ? '' : 'delayStatus', $pb.PbFieldType.OE, defaultOrMaker: $1.DelayStatus.DELAY_STATUS_UNSPECIFIED, valueOf: $1.DelayStatus.valueOf, enumValues: $1.DelayStatus.values)
    ..a<$core.int>(10, _omitFieldNames ? '' : 'delayMinutes', $pb.PbFieldType.O3)
    ..e<$1.StalenessCategory>(11, _omitFieldNames ? '' : 'staleness', $pb.PbFieldType.OE, defaultOrMaker: $1.StalenessCategory.STALENESS_UNSPECIFIED, valueOf: $1.StalenessCategory.valueOf, enumValues: $1.StalenessCategory.values)
    ..aOM<$0.Timestamp>(12, _omitFieldNames ? '' : 'lastGpsUpdate', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(13, _omitFieldNames ? '' : 'scheduledTime', subBuilder: $0.Timestamp.create)
    ..a<$core.int>(14, _omitFieldNames ? '' : 'direction', $pb.PbFieldType.O3)
    ..aOB(15, _omitFieldNames ? '' : 'isDeparting')
    ..aOS(16, _omitFieldNames ? '' : 'laterPlateNo')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BusArrival clone() => BusArrival()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BusArrival copyWith(void Function(BusArrival) updates) => super.copyWith((message) => updates(message as BusArrival)) as BusArrival;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BusArrival create() => BusArrival._();
  BusArrival createEmptyInstance() => create();
  static $pb.PbList<BusArrival> createRepeated() => $pb.PbList<BusArrival>();
  @$core.pragma('dart2js:noInline')
  static BusArrival getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BusArrival>(create);
  static BusArrival? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceNo => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceNo($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasServiceNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceNo() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get color => $_getSZ(1);
  @$pb.TagNumber(2)
  set color($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasColor() => $_has(1);
  @$pb.TagNumber(2)
  void clearColor() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isFree => $_getBF(2);
  @$pb.TagNumber(3)
  set isFree($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsFree() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsFree() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get destination => $_getSZ(3);
  @$pb.TagNumber(4)
  set destination($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDestination() => $_has(3);
  @$pb.TagNumber(4)
  void clearDestination() => clearField(4);

  @$pb.TagNumber(5)
  $1.ArrivalTime get nextArrival => $_getN(4);
  @$pb.TagNumber(5)
  set nextArrival($1.ArrivalTime v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasNextArrival() => $_has(4);
  @$pb.TagNumber(5)
  void clearNextArrival() => clearField(5);
  @$pb.TagNumber(5)
  $1.ArrivalTime ensureNextArrival() => $_ensure(4);

  @$pb.TagNumber(6)
  $1.ArrivalTime get laterArrival => $_getN(5);
  @$pb.TagNumber(6)
  set laterArrival($1.ArrivalTime v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasLaterArrival() => $_has(5);
  @$pb.TagNumber(6)
  void clearLaterArrival() => clearField(6);
  @$pb.TagNumber(6)
  $1.ArrivalTime ensureLaterArrival() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get plateNo => $_getSZ(6);
  @$pb.TagNumber(7)
  set plateNo($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasPlateNo() => $_has(6);
  @$pb.TagNumber(7)
  void clearPlateNo() => clearField(7);

  @$pb.TagNumber(8)
  $1.EtaSource get etaSource => $_getN(7);
  @$pb.TagNumber(8)
  set etaSource($1.EtaSource v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasEtaSource() => $_has(7);
  @$pb.TagNumber(8)
  void clearEtaSource() => clearField(8);

  @$pb.TagNumber(9)
  $1.DelayStatus get delayStatus => $_getN(8);
  @$pb.TagNumber(9)
  set delayStatus($1.DelayStatus v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasDelayStatus() => $_has(8);
  @$pb.TagNumber(9)
  void clearDelayStatus() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get delayMinutes => $_getIZ(9);
  @$pb.TagNumber(10)
  set delayMinutes($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasDelayMinutes() => $_has(9);
  @$pb.TagNumber(10)
  void clearDelayMinutes() => clearField(10);

  @$pb.TagNumber(11)
  $1.StalenessCategory get staleness => $_getN(10);
  @$pb.TagNumber(11)
  set staleness($1.StalenessCategory v) { setField(11, v); }
  @$pb.TagNumber(11)
  $core.bool hasStaleness() => $_has(10);
  @$pb.TagNumber(11)
  void clearStaleness() => clearField(11);

  @$pb.TagNumber(12)
  $0.Timestamp get lastGpsUpdate => $_getN(11);
  @$pb.TagNumber(12)
  set lastGpsUpdate($0.Timestamp v) { setField(12, v); }
  @$pb.TagNumber(12)
  $core.bool hasLastGpsUpdate() => $_has(11);
  @$pb.TagNumber(12)
  void clearLastGpsUpdate() => clearField(12);
  @$pb.TagNumber(12)
  $0.Timestamp ensureLastGpsUpdate() => $_ensure(11);

  @$pb.TagNumber(13)
  $0.Timestamp get scheduledTime => $_getN(12);
  @$pb.TagNumber(13)
  set scheduledTime($0.Timestamp v) { setField(13, v); }
  @$pb.TagNumber(13)
  $core.bool hasScheduledTime() => $_has(12);
  @$pb.TagNumber(13)
  void clearScheduledTime() => clearField(13);
  @$pb.TagNumber(13)
  $0.Timestamp ensureScheduledTime() => $_ensure(12);

  @$pb.TagNumber(14)
  $core.int get direction => $_getIZ(13);
  @$pb.TagNumber(14)
  set direction($core.int v) { $_setSignedInt32(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasDirection() => $_has(13);
  @$pb.TagNumber(14)
  void clearDirection() => clearField(14);

  @$pb.TagNumber(15)
  $core.bool get isDeparting => $_getBF(14);
  @$pb.TagNumber(15)
  set isDeparting($core.bool v) { $_setBool(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasIsDeparting() => $_has(14);
  @$pb.TagNumber(15)
  void clearIsDeparting() => clearField(15);

  @$pb.TagNumber(16)
  $core.String get laterPlateNo => $_getSZ(15);
  @$pb.TagNumber(16)
  set laterPlateNo($core.String v) { $_setString(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasLaterPlateNo() => $_has(15);
  @$pb.TagNumber(16)
  void clearLaterPlateNo() => clearField(16);
}

class StreamStopArrivalsRequest extends $pb.GeneratedMessage {
  factory StreamStopArrivalsRequest() => create();
  StreamStopArrivalsRequest._() : super();
  factory StreamStopArrivalsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StreamStopArrivalsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StreamStopArrivalsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'busStopCode')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'maxArrivals', $pb.PbFieldType.O3)
    ..aOB(3, _omitFieldNames ? '' : 'includeBusLocations')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StreamStopArrivalsRequest clone() => StreamStopArrivalsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StreamStopArrivalsRequest copyWith(void Function(StreamStopArrivalsRequest) updates) => super.copyWith((message) => updates(message as StreamStopArrivalsRequest)) as StreamStopArrivalsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamStopArrivalsRequest create() => StreamStopArrivalsRequest._();
  StreamStopArrivalsRequest createEmptyInstance() => create();
  static $pb.PbList<StreamStopArrivalsRequest> createRepeated() => $pb.PbList<StreamStopArrivalsRequest>();
  @$core.pragma('dart2js:noInline')
  static StreamStopArrivalsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StreamStopArrivalsRequest>(create);
  static StreamStopArrivalsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get busStopCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set busStopCode($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBusStopCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearBusStopCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get maxArrivals => $_getIZ(1);
  @$pb.TagNumber(2)
  set maxArrivals($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMaxArrivals() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxArrivals() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get includeBusLocations => $_getBF(2);
  @$pb.TagNumber(3)
  set includeBusLocations($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIncludeBusLocations() => $_has(2);
  @$pb.TagNumber(3)
  void clearIncludeBusLocations() => clearField(3);
}

enum StopArrivalsUpdate_Update {
  fullUpdate, 
  deltaUpdate, 
  notSet
}

class StopArrivalsUpdate extends $pb.GeneratedMessage {
  factory StopArrivalsUpdate() => create();
  StopArrivalsUpdate._() : super();
  factory StopArrivalsUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StopArrivalsUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, StopArrivalsUpdate_Update> _StopArrivalsUpdate_UpdateByTag = {
    1 : StopArrivalsUpdate_Update.fullUpdate,
    2 : StopArrivalsUpdate_Update.deltaUpdate,
    0 : StopArrivalsUpdate_Update.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StopArrivalsUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<StopArrivalsData>(1, _omitFieldNames ? '' : 'fullUpdate', subBuilder: StopArrivalsData.create)
    ..aOM<BusArrivalDelta>(2, _omitFieldNames ? '' : 'deltaUpdate', subBuilder: BusArrivalDelta.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'timestamp', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StopArrivalsUpdate clone() => StopArrivalsUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StopArrivalsUpdate copyWith(void Function(StopArrivalsUpdate) updates) => super.copyWith((message) => updates(message as StopArrivalsUpdate)) as StopArrivalsUpdate;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopArrivalsUpdate create() => StopArrivalsUpdate._();
  StopArrivalsUpdate createEmptyInstance() => create();
  static $pb.PbList<StopArrivalsUpdate> createRepeated() => $pb.PbList<StopArrivalsUpdate>();
  @$core.pragma('dart2js:noInline')
  static StopArrivalsUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StopArrivalsUpdate>(create);
  static StopArrivalsUpdate? _defaultInstance;

  StopArrivalsUpdate_Update whichUpdate() => _StopArrivalsUpdate_UpdateByTag[$_whichOneof(0)]!;
  void clearUpdate() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  StopArrivalsData get fullUpdate => $_getN(0);
  @$pb.TagNumber(1)
  set fullUpdate(StopArrivalsData v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasFullUpdate() => $_has(0);
  @$pb.TagNumber(1)
  void clearFullUpdate() => clearField(1);
  @$pb.TagNumber(1)
  StopArrivalsData ensureFullUpdate() => $_ensure(0);

  @$pb.TagNumber(2)
  BusArrivalDelta get deltaUpdate => $_getN(1);
  @$pb.TagNumber(2)
  set deltaUpdate(BusArrivalDelta v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasDeltaUpdate() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeltaUpdate() => clearField(2);
  @$pb.TagNumber(2)
  BusArrivalDelta ensureDeltaUpdate() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Timestamp get timestamp => $_getN(2);
  @$pb.TagNumber(3)
  set timestamp($0.Timestamp v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureTimestamp() => $_ensure(2);
}

class BusArrivalDelta extends $pb.GeneratedMessage {
  factory BusArrivalDelta() => create();
  BusArrivalDelta._() : super();
  factory BusArrivalDelta.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BusArrivalDelta.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BusArrivalDelta', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..pc<BusArrival>(1, _omitFieldNames ? '' : 'updated', $pb.PbFieldType.PM, subBuilder: BusArrival.create)
    ..pPS(2, _omitFieldNames ? '' : 'removedServiceNos')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BusArrivalDelta clone() => BusArrivalDelta()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BusArrivalDelta copyWith(void Function(BusArrivalDelta) updates) => super.copyWith((message) => updates(message as BusArrivalDelta)) as BusArrivalDelta;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BusArrivalDelta create() => BusArrivalDelta._();
  BusArrivalDelta createEmptyInstance() => create();
  static $pb.PbList<BusArrivalDelta> createRepeated() => $pb.PbList<BusArrivalDelta>();
  @$core.pragma('dart2js:noInline')
  static BusArrivalDelta getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BusArrivalDelta>(create);
  static BusArrivalDelta? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<BusArrival> get updated => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$core.String> get removedServiceNos => $_getList(1);
}

class GetBusPositionRequest extends $pb.GeneratedMessage {
  factory GetBusPositionRequest() => create();
  GetBusPositionRequest._() : super();
  factory GetBusPositionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetBusPositionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetBusPositionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'plateNo')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetBusPositionRequest clone() => GetBusPositionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetBusPositionRequest copyWith(void Function(GetBusPositionRequest) updates) => super.copyWith((message) => updates(message as GetBusPositionRequest)) as GetBusPositionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBusPositionRequest create() => GetBusPositionRequest._();
  GetBusPositionRequest createEmptyInstance() => create();
  static $pb.PbList<GetBusPositionRequest> createRepeated() => $pb.PbList<GetBusPositionRequest>();
  @$core.pragma('dart2js:noInline')
  static GetBusPositionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetBusPositionRequest>(create);
  static GetBusPositionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get plateNo => $_getSZ(0);
  @$pb.TagNumber(1)
  set plateNo($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPlateNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlateNo() => clearField(1);
}

class GetBusPositionResponse extends $pb.GeneratedMessage {
  factory GetBusPositionResponse() => create();
  GetBusPositionResponse._() : super();
  factory GetBusPositionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetBusPositionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetBusPositionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOM<BusPosition>(1, _omitFieldNames ? '' : 'position', subBuilder: BusPosition.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetBusPositionResponse clone() => GetBusPositionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetBusPositionResponse copyWith(void Function(GetBusPositionResponse) updates) => super.copyWith((message) => updates(message as GetBusPositionResponse)) as GetBusPositionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetBusPositionResponse create() => GetBusPositionResponse._();
  GetBusPositionResponse createEmptyInstance() => create();
  static $pb.PbList<GetBusPositionResponse> createRepeated() => $pb.PbList<GetBusPositionResponse>();
  @$core.pragma('dart2js:noInline')
  static GetBusPositionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetBusPositionResponse>(create);
  static GetBusPositionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  BusPosition get position => $_getN(0);
  @$pb.TagNumber(1)
  set position(BusPosition v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPosition() => $_has(0);
  @$pb.TagNumber(1)
  void clearPosition() => clearField(1);
  @$pb.TagNumber(1)
  BusPosition ensurePosition() => $_ensure(0);
}

class BusPosition extends $pb.GeneratedMessage {
  factory BusPosition() => create();
  BusPosition._() : super();
  factory BusPosition.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BusPosition.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BusPosition', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'plateNo')
    ..aOS(2, _omitFieldNames ? '' : 'serviceNo')
    ..aOM<$1.GeoPoint>(3, _omitFieldNames ? '' : 'location', subBuilder: $1.GeoPoint.create)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'speedKmh', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'heading', $pb.PbFieldType.OD)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'timestamp', subBuilder: $0.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'nextStopCode')
    ..aOS(8, _omitFieldNames ? '' : 'nextStopName')
    ..a<$core.int>(9, _omitFieldNames ? '' : 'etaToNextStopMinutes', $pb.PbFieldType.O3)
    ..a<$core.int>(10, _omitFieldNames ? '' : 'direction', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  BusPosition clone() => BusPosition()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  BusPosition copyWith(void Function(BusPosition) updates) => super.copyWith((message) => updates(message as BusPosition)) as BusPosition;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BusPosition create() => BusPosition._();
  BusPosition createEmptyInstance() => create();
  static $pb.PbList<BusPosition> createRepeated() => $pb.PbList<BusPosition>();
  @$core.pragma('dart2js:noInline')
  static BusPosition getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BusPosition>(create);
  static BusPosition? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get plateNo => $_getSZ(0);
  @$pb.TagNumber(1)
  set plateNo($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPlateNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlateNo() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get serviceNo => $_getSZ(1);
  @$pb.TagNumber(2)
  set serviceNo($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasServiceNo() => $_has(1);
  @$pb.TagNumber(2)
  void clearServiceNo() => clearField(2);

  @$pb.TagNumber(3)
  $1.GeoPoint get location => $_getN(2);
  @$pb.TagNumber(3)
  set location($1.GeoPoint v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasLocation() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocation() => clearField(3);
  @$pb.TagNumber(3)
  $1.GeoPoint ensureLocation() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.double get speedKmh => $_getN(3);
  @$pb.TagNumber(4)
  set speedKmh($core.double v) { $_setDouble(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSpeedKmh() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpeedKmh() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get heading => $_getN(4);
  @$pb.TagNumber(5)
  set heading($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasHeading() => $_has(4);
  @$pb.TagNumber(5)
  void clearHeading() => clearField(5);

  @$pb.TagNumber(6)
  $0.Timestamp get timestamp => $_getN(5);
  @$pb.TagNumber(6)
  set timestamp($0.Timestamp v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasTimestamp() => $_has(5);
  @$pb.TagNumber(6)
  void clearTimestamp() => clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureTimestamp() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get nextStopCode => $_getSZ(6);
  @$pb.TagNumber(7)
  set nextStopCode($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasNextStopCode() => $_has(6);
  @$pb.TagNumber(7)
  void clearNextStopCode() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get nextStopName => $_getSZ(7);
  @$pb.TagNumber(8)
  set nextStopName($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasNextStopName() => $_has(7);
  @$pb.TagNumber(8)
  void clearNextStopName() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get etaToNextStopMinutes => $_getIZ(8);
  @$pb.TagNumber(9)
  set etaToNextStopMinutes($core.int v) { $_setSignedInt32(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasEtaToNextStopMinutes() => $_has(8);
  @$pb.TagNumber(9)
  void clearEtaToNextStopMinutes() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get direction => $_getIZ(9);
  @$pb.TagNumber(10)
  set direction($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasDirection() => $_has(9);
  @$pb.TagNumber(10)
  void clearDirection() => clearField(10);
}

class StreamServiceBusesRequest extends $pb.GeneratedMessage {
  factory StreamServiceBusesRequest() => create();
  StreamServiceBusesRequest._() : super();
  factory StreamServiceBusesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StreamServiceBusesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StreamServiceBusesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceNo')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'direction', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StreamServiceBusesRequest clone() => StreamServiceBusesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StreamServiceBusesRequest copyWith(void Function(StreamServiceBusesRequest) updates) => super.copyWith((message) => updates(message as StreamServiceBusesRequest)) as StreamServiceBusesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StreamServiceBusesRequest create() => StreamServiceBusesRequest._();
  StreamServiceBusesRequest createEmptyInstance() => create();
  static $pb.PbList<StreamServiceBusesRequest> createRepeated() => $pb.PbList<StreamServiceBusesRequest>();
  @$core.pragma('dart2js:noInline')
  static StreamServiceBusesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StreamServiceBusesRequest>(create);
  static StreamServiceBusesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceNo => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceNo($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasServiceNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceNo() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get direction => $_getIZ(1);
  @$pb.TagNumber(2)
  set direction($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDirection() => $_has(1);
  @$pb.TagNumber(2)
  void clearDirection() => clearField(2);
}

class ServiceBusesUpdate extends $pb.GeneratedMessage {
  factory ServiceBusesUpdate() => create();
  ServiceBusesUpdate._() : super();
  factory ServiceBusesUpdate.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceBusesUpdate.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServiceBusesUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceNo')
    ..pc<BusPosition>(2, _omitFieldNames ? '' : 'buses', $pb.PbFieldType.PM, subBuilder: BusPosition.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'timestamp', subBuilder: $0.Timestamp.create)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'direction', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServiceBusesUpdate clone() => ServiceBusesUpdate()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServiceBusesUpdate copyWith(void Function(ServiceBusesUpdate) updates) => super.copyWith((message) => updates(message as ServiceBusesUpdate)) as ServiceBusesUpdate;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceBusesUpdate create() => ServiceBusesUpdate._();
  ServiceBusesUpdate createEmptyInstance() => create();
  static $pb.PbList<ServiceBusesUpdate> createRepeated() => $pb.PbList<ServiceBusesUpdate>();
  @$core.pragma('dart2js:noInline')
  static ServiceBusesUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceBusesUpdate>(create);
  static ServiceBusesUpdate? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceNo => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceNo($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasServiceNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceNo() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<BusPosition> get buses => $_getList(1);

  @$pb.TagNumber(3)
  $0.Timestamp get timestamp => $_getN(2);
  @$pb.TagNumber(3)
  set timestamp($0.Timestamp v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureTimestamp() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get direction => $_getIZ(3);
  @$pb.TagNumber(4)
  set direction($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDirection() => $_has(3);
  @$pb.TagNumber(4)
  void clearDirection() => clearField(4);
}

class GetServiceDetailsRequest extends $pb.GeneratedMessage {
  factory GetServiceDetailsRequest() => create();
  GetServiceDetailsRequest._() : super();
  factory GetServiceDetailsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetServiceDetailsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetServiceDetailsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'serviceNo')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'direction', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetServiceDetailsRequest clone() => GetServiceDetailsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetServiceDetailsRequest copyWith(void Function(GetServiceDetailsRequest) updates) => super.copyWith((message) => updates(message as GetServiceDetailsRequest)) as GetServiceDetailsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetServiceDetailsRequest create() => GetServiceDetailsRequest._();
  GetServiceDetailsRequest createEmptyInstance() => create();
  static $pb.PbList<GetServiceDetailsRequest> createRepeated() => $pb.PbList<GetServiceDetailsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetServiceDetailsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetServiceDetailsRequest>(create);
  static GetServiceDetailsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get serviceNo => $_getSZ(0);
  @$pb.TagNumber(1)
  set serviceNo($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasServiceNo() => $_has(0);
  @$pb.TagNumber(1)
  void clearServiceNo() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get direction => $_getIZ(1);
  @$pb.TagNumber(2)
  set direction($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDirection() => $_has(1);
  @$pb.TagNumber(2)
  void clearDirection() => clearField(2);
}

class GetServiceDetailsResponse extends $pb.GeneratedMessage {
  factory GetServiceDetailsResponse() => create();
  GetServiceDetailsResponse._() : super();
  factory GetServiceDetailsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetServiceDetailsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetServiceDetailsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOM<$1.ServiceInfo>(1, _omitFieldNames ? '' : 'service', subBuilder: $1.ServiceInfo.create)
    ..aOS(2, _omitFieldNames ? '' : 'polyline')
    ..pc<ServiceStopInfo>(3, _omitFieldNames ? '' : 'stops', $pb.PbFieldType.PM, subBuilder: ServiceStopInfo.create)
    ..aOS(4, _omitFieldNames ? '' : 'origin')
    ..aOS(5, _omitFieldNames ? '' : 'destination')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetServiceDetailsResponse clone() => GetServiceDetailsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetServiceDetailsResponse copyWith(void Function(GetServiceDetailsResponse) updates) => super.copyWith((message) => updates(message as GetServiceDetailsResponse)) as GetServiceDetailsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetServiceDetailsResponse create() => GetServiceDetailsResponse._();
  GetServiceDetailsResponse createEmptyInstance() => create();
  static $pb.PbList<GetServiceDetailsResponse> createRepeated() => $pb.PbList<GetServiceDetailsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetServiceDetailsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetServiceDetailsResponse>(create);
  static GetServiceDetailsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.ServiceInfo get service => $_getN(0);
  @$pb.TagNumber(1)
  set service($1.ServiceInfo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasService() => $_has(0);
  @$pb.TagNumber(1)
  void clearService() => clearField(1);
  @$pb.TagNumber(1)
  $1.ServiceInfo ensureService() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get polyline => $_getSZ(1);
  @$pb.TagNumber(2)
  set polyline($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPolyline() => $_has(1);
  @$pb.TagNumber(2)
  void clearPolyline() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<ServiceStopInfo> get stops => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get origin => $_getSZ(3);
  @$pb.TagNumber(4)
  set origin($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasOrigin() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrigin() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get destination => $_getSZ(4);
  @$pb.TagNumber(5)
  set destination($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDestination() => $_has(4);
  @$pb.TagNumber(5)
  void clearDestination() => clearField(5);
}

class ServiceStopInfo extends $pb.GeneratedMessage {
  factory ServiceStopInfo() => create();
  ServiceStopInfo._() : super();
  factory ServiceStopInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceStopInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServiceStopInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'busStopCode')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOM<$1.GeoPoint>(3, _omitFieldNames ? '' : 'location', subBuilder: $1.GeoPoint.create)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'sequence', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServiceStopInfo clone() => ServiceStopInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServiceStopInfo copyWith(void Function(ServiceStopInfo) updates) => super.copyWith((message) => updates(message as ServiceStopInfo)) as ServiceStopInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceStopInfo create() => ServiceStopInfo._();
  ServiceStopInfo createEmptyInstance() => create();
  static $pb.PbList<ServiceStopInfo> createRepeated() => $pb.PbList<ServiceStopInfo>();
  @$core.pragma('dart2js:noInline')
  static ServiceStopInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceStopInfo>(create);
  static ServiceStopInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get busStopCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set busStopCode($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBusStopCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearBusStopCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $1.GeoPoint get location => $_getN(2);
  @$pb.TagNumber(3)
  set location($1.GeoPoint v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasLocation() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocation() => clearField(3);
  @$pb.TagNumber(3)
  $1.GeoPoint ensureLocation() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.int get sequence => $_getIZ(3);
  @$pb.TagNumber(4)
  set sequence($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSequence() => $_has(3);
  @$pb.TagNumber(4)
  void clearSequence() => clearField(4);
}

class GetServicesAtStopRequest extends $pb.GeneratedMessage {
  factory GetServicesAtStopRequest() => create();
  GetServicesAtStopRequest._() : super();
  factory GetServicesAtStopRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetServicesAtStopRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetServicesAtStopRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'busStopCode')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetServicesAtStopRequest clone() => GetServicesAtStopRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetServicesAtStopRequest copyWith(void Function(GetServicesAtStopRequest) updates) => super.copyWith((message) => updates(message as GetServicesAtStopRequest)) as GetServicesAtStopRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetServicesAtStopRequest create() => GetServicesAtStopRequest._();
  GetServicesAtStopRequest createEmptyInstance() => create();
  static $pb.PbList<GetServicesAtStopRequest> createRepeated() => $pb.PbList<GetServicesAtStopRequest>();
  @$core.pragma('dart2js:noInline')
  static GetServicesAtStopRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetServicesAtStopRequest>(create);
  static GetServicesAtStopRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get busStopCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set busStopCode($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBusStopCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearBusStopCode() => clearField(1);
}

class GetServicesAtStopResponse extends $pb.GeneratedMessage {
  factory GetServicesAtStopResponse() => create();
  GetServicesAtStopResponse._() : super();
  factory GetServicesAtStopResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetServicesAtStopResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetServicesAtStopResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'busStopCode')
    ..aOS(2, _omitFieldNames ? '' : 'busStopName')
    ..pc<ServiceAtStop>(3, _omitFieldNames ? '' : 'services', $pb.PbFieldType.PM, subBuilder: ServiceAtStop.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetServicesAtStopResponse clone() => GetServicesAtStopResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetServicesAtStopResponse copyWith(void Function(GetServicesAtStopResponse) updates) => super.copyWith((message) => updates(message as GetServicesAtStopResponse)) as GetServicesAtStopResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetServicesAtStopResponse create() => GetServicesAtStopResponse._();
  GetServicesAtStopResponse createEmptyInstance() => create();
  static $pb.PbList<GetServicesAtStopResponse> createRepeated() => $pb.PbList<GetServicesAtStopResponse>();
  @$core.pragma('dart2js:noInline')
  static GetServicesAtStopResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetServicesAtStopResponse>(create);
  static GetServicesAtStopResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get busStopCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set busStopCode($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBusStopCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearBusStopCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get busStopName => $_getSZ(1);
  @$pb.TagNumber(2)
  set busStopName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBusStopName() => $_has(1);
  @$pb.TagNumber(2)
  void clearBusStopName() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<ServiceAtStop> get services => $_getList(2);
}

class ServiceAtStop extends $pb.GeneratedMessage {
  factory ServiceAtStop() => create();
  ServiceAtStop._() : super();
  factory ServiceAtStop.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServiceAtStop.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ServiceAtStop', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOM<$1.ServiceInfo>(1, _omitFieldNames ? '' : 'service', subBuilder: $1.ServiceInfo.create)
    ..aOS(2, _omitFieldNames ? '' : 'destination')
    ..aOM<$1.ArrivalTime>(3, _omitFieldNames ? '' : 'nextArrival', subBuilder: $1.ArrivalTime.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServiceAtStop clone() => ServiceAtStop()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServiceAtStop copyWith(void Function(ServiceAtStop) updates) => super.copyWith((message) => updates(message as ServiceAtStop)) as ServiceAtStop;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ServiceAtStop create() => ServiceAtStop._();
  ServiceAtStop createEmptyInstance() => create();
  static $pb.PbList<ServiceAtStop> createRepeated() => $pb.PbList<ServiceAtStop>();
  @$core.pragma('dart2js:noInline')
  static ServiceAtStop getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServiceAtStop>(create);
  static ServiceAtStop? _defaultInstance;

  @$pb.TagNumber(1)
  $1.ServiceInfo get service => $_getN(0);
  @$pb.TagNumber(1)
  set service($1.ServiceInfo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasService() => $_has(0);
  @$pb.TagNumber(1)
  void clearService() => clearField(1);
  @$pb.TagNumber(1)
  $1.ServiceInfo ensureService() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get destination => $_getSZ(1);
  @$pb.TagNumber(2)
  set destination($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDestination() => $_has(1);
  @$pb.TagNumber(2)
  void clearDestination() => clearField(2);

  @$pb.TagNumber(3)
  $1.ArrivalTime get nextArrival => $_getN(2);
  @$pb.TagNumber(3)
  set nextArrival($1.ArrivalTime v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasNextArrival() => $_has(2);
  @$pb.TagNumber(3)
  void clearNextArrival() => clearField(3);
  @$pb.TagNumber(3)
  $1.ArrivalTime ensureNextArrival() => $_ensure(2);
}

class SearchBusStopsRequest extends $pb.GeneratedMessage {
  factory SearchBusStopsRequest() => create();
  SearchBusStopsRequest._() : super();
  factory SearchBusStopsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SearchBusStopsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SearchBusStopsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'query')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SearchBusStopsRequest clone() => SearchBusStopsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SearchBusStopsRequest copyWith(void Function(SearchBusStopsRequest) updates) => super.copyWith((message) => updates(message as SearchBusStopsRequest)) as SearchBusStopsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchBusStopsRequest create() => SearchBusStopsRequest._();
  SearchBusStopsRequest createEmptyInstance() => create();
  static $pb.PbList<SearchBusStopsRequest> createRepeated() => $pb.PbList<SearchBusStopsRequest>();
  @$core.pragma('dart2js:noInline')
  static SearchBusStopsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchBusStopsRequest>(create);
  static SearchBusStopsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get limit => $_getIZ(1);
  @$pb.TagNumber(2)
  set limit($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLimit() => $_has(1);
  @$pb.TagNumber(2)
  void clearLimit() => clearField(2);
}

class SearchBusStopsResponse extends $pb.GeneratedMessage {
  factory SearchBusStopsResponse() => create();
  SearchBusStopsResponse._() : super();
  factory SearchBusStopsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SearchBusStopsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SearchBusStopsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..pc<SearchResult>(1, _omitFieldNames ? '' : 'results', $pb.PbFieldType.PM, subBuilder: SearchResult.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SearchBusStopsResponse clone() => SearchBusStopsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SearchBusStopsResponse copyWith(void Function(SearchBusStopsResponse) updates) => super.copyWith((message) => updates(message as SearchBusStopsResponse)) as SearchBusStopsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchBusStopsResponse create() => SearchBusStopsResponse._();
  SearchBusStopsResponse createEmptyInstance() => create();
  static $pb.PbList<SearchBusStopsResponse> createRepeated() => $pb.PbList<SearchBusStopsResponse>();
  @$core.pragma('dart2js:noInline')
  static SearchBusStopsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchBusStopsResponse>(create);
  static SearchBusStopsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<SearchResult> get results => $_getList(0);
}

class SearchResult extends $pb.GeneratedMessage {
  factory SearchResult() => create();
  SearchResult._() : super();
  factory SearchResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SearchResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SearchResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOM<$1.BusStopInfo>(1, _omitFieldNames ? '' : 'busStop', subBuilder: $1.BusStopInfo.create)
    ..pPS(2, _omitFieldNames ? '' : 'serviceNos')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'relevanceScore', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SearchResult clone() => SearchResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SearchResult copyWith(void Function(SearchResult) updates) => super.copyWith((message) => updates(message as SearchResult)) as SearchResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchResult create() => SearchResult._();
  SearchResult createEmptyInstance() => create();
  static $pb.PbList<SearchResult> createRepeated() => $pb.PbList<SearchResult>();
  @$core.pragma('dart2js:noInline')
  static SearchResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchResult>(create);
  static SearchResult? _defaultInstance;

  @$pb.TagNumber(1)
  $1.BusStopInfo get busStop => $_getN(0);
  @$pb.TagNumber(1)
  set busStop($1.BusStopInfo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasBusStop() => $_has(0);
  @$pb.TagNumber(1)
  void clearBusStop() => clearField(1);
  @$pb.TagNumber(1)
  $1.BusStopInfo ensureBusStop() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.String> get serviceNos => $_getList(1);

  @$pb.TagNumber(3)
  $core.double get relevanceScore => $_getN(2);
  @$pb.TagNumber(3)
  set relevanceScore($core.double v) { $_setDouble(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRelevanceScore() => $_has(2);
  @$pb.TagNumber(3)
  void clearRelevanceScore() => clearField(3);
}

class FindNearbyStopsRequest extends $pb.GeneratedMessage {
  factory FindNearbyStopsRequest() => create();
  FindNearbyStopsRequest._() : super();
  factory FindNearbyStopsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FindNearbyStopsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FindNearbyStopsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOM<$1.GeoPoint>(1, _omitFieldNames ? '' : 'location', subBuilder: $1.GeoPoint.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'radiusMeters', $pb.PbFieldType.OD)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'limit', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FindNearbyStopsRequest clone() => FindNearbyStopsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FindNearbyStopsRequest copyWith(void Function(FindNearbyStopsRequest) updates) => super.copyWith((message) => updates(message as FindNearbyStopsRequest)) as FindNearbyStopsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindNearbyStopsRequest create() => FindNearbyStopsRequest._();
  FindNearbyStopsRequest createEmptyInstance() => create();
  static $pb.PbList<FindNearbyStopsRequest> createRepeated() => $pb.PbList<FindNearbyStopsRequest>();
  @$core.pragma('dart2js:noInline')
  static FindNearbyStopsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FindNearbyStopsRequest>(create);
  static FindNearbyStopsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $1.GeoPoint get location => $_getN(0);
  @$pb.TagNumber(1)
  set location($1.GeoPoint v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLocation() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocation() => clearField(1);
  @$pb.TagNumber(1)
  $1.GeoPoint ensureLocation() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get radiusMeters => $_getN(1);
  @$pb.TagNumber(2)
  set radiusMeters($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRadiusMeters() => $_has(1);
  @$pb.TagNumber(2)
  void clearRadiusMeters() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get limit => $_getIZ(2);
  @$pb.TagNumber(3)
  set limit($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLimit() => $_has(2);
  @$pb.TagNumber(3)
  void clearLimit() => clearField(3);
}

class FindNearbyStopsResponse extends $pb.GeneratedMessage {
  factory FindNearbyStopsResponse() => create();
  FindNearbyStopsResponse._() : super();
  factory FindNearbyStopsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FindNearbyStopsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FindNearbyStopsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..pc<NearbyStopResult>(1, _omitFieldNames ? '' : 'stops', $pb.PbFieldType.PM, subBuilder: NearbyStopResult.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FindNearbyStopsResponse clone() => FindNearbyStopsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FindNearbyStopsResponse copyWith(void Function(FindNearbyStopsResponse) updates) => super.copyWith((message) => updates(message as FindNearbyStopsResponse)) as FindNearbyStopsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FindNearbyStopsResponse create() => FindNearbyStopsResponse._();
  FindNearbyStopsResponse createEmptyInstance() => create();
  static $pb.PbList<FindNearbyStopsResponse> createRepeated() => $pb.PbList<FindNearbyStopsResponse>();
  @$core.pragma('dart2js:noInline')
  static FindNearbyStopsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FindNearbyStopsResponse>(create);
  static FindNearbyStopsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<NearbyStopResult> get stops => $_getList(0);
}

class NearbyStopResult extends $pb.GeneratedMessage {
  factory NearbyStopResult() => create();
  NearbyStopResult._() : super();
  factory NearbyStopResult.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory NearbyStopResult.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'NearbyStopResult', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOM<$1.BusStopInfo>(1, _omitFieldNames ? '' : 'busStop', subBuilder: $1.BusStopInfo.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'distanceMeters', $pb.PbFieldType.OD)
    ..pPS(3, _omitFieldNames ? '' : 'serviceNos')
    ..aOM<$1.ArrivalTime>(4, _omitFieldNames ? '' : 'nextArrival', subBuilder: $1.ArrivalTime.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  NearbyStopResult clone() => NearbyStopResult()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  NearbyStopResult copyWith(void Function(NearbyStopResult) updates) => super.copyWith((message) => updates(message as NearbyStopResult)) as NearbyStopResult;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NearbyStopResult create() => NearbyStopResult._();
  NearbyStopResult createEmptyInstance() => create();
  static $pb.PbList<NearbyStopResult> createRepeated() => $pb.PbList<NearbyStopResult>();
  @$core.pragma('dart2js:noInline')
  static NearbyStopResult getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<NearbyStopResult>(create);
  static NearbyStopResult? _defaultInstance;

  @$pb.TagNumber(1)
  $1.BusStopInfo get busStop => $_getN(0);
  @$pb.TagNumber(1)
  set busStop($1.BusStopInfo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasBusStop() => $_has(0);
  @$pb.TagNumber(1)
  void clearBusStop() => clearField(1);
  @$pb.TagNumber(1)
  $1.BusStopInfo ensureBusStop() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get distanceMeters => $_getN(1);
  @$pb.TagNumber(2)
  set distanceMeters($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDistanceMeters() => $_has(1);
  @$pb.TagNumber(2)
  void clearDistanceMeters() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.String> get serviceNos => $_getList(2);

  @$pb.TagNumber(4)
  $1.ArrivalTime get nextArrival => $_getN(3);
  @$pb.TagNumber(4)
  set nextArrival($1.ArrivalTime v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasNextArrival() => $_has(3);
  @$pb.TagNumber(4)
  void clearNextArrival() => clearField(4);
  @$pb.TagNumber(4)
  $1.ArrivalTime ensureNextArrival() => $_ensure(3);
}

class GetStopMessagesRequest extends $pb.GeneratedMessage {
  factory GetStopMessagesRequest() => create();
  GetStopMessagesRequest._() : super();
  factory GetStopMessagesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetStopMessagesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetStopMessagesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'busStopCode')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetStopMessagesRequest clone() => GetStopMessagesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetStopMessagesRequest copyWith(void Function(GetStopMessagesRequest) updates) => super.copyWith((message) => updates(message as GetStopMessagesRequest)) as GetStopMessagesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStopMessagesRequest create() => GetStopMessagesRequest._();
  GetStopMessagesRequest createEmptyInstance() => create();
  static $pb.PbList<GetStopMessagesRequest> createRepeated() => $pb.PbList<GetStopMessagesRequest>();
  @$core.pragma('dart2js:noInline')
  static GetStopMessagesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetStopMessagesRequest>(create);
  static GetStopMessagesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get busStopCode => $_getSZ(0);
  @$pb.TagNumber(1)
  set busStopCode($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBusStopCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearBusStopCode() => clearField(1);
}

class GetStopMessagesResponse extends $pb.GeneratedMessage {
  factory GetStopMessagesResponse() => create();
  GetStopMessagesResponse._() : super();
  factory GetStopMessagesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetStopMessagesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetStopMessagesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..pc<StopMessage>(1, _omitFieldNames ? '' : 'messages', $pb.PbFieldType.PM, subBuilder: StopMessage.create)
    ..aOS(2, _omitFieldNames ? '' : 'scrollingMessage')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetStopMessagesResponse clone() => GetStopMessagesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetStopMessagesResponse copyWith(void Function(GetStopMessagesResponse) updates) => super.copyWith((message) => updates(message as GetStopMessagesResponse)) as GetStopMessagesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetStopMessagesResponse create() => GetStopMessagesResponse._();
  GetStopMessagesResponse createEmptyInstance() => create();
  static $pb.PbList<GetStopMessagesResponse> createRepeated() => $pb.PbList<GetStopMessagesResponse>();
  @$core.pragma('dart2js:noInline')
  static GetStopMessagesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetStopMessagesResponse>(create);
  static GetStopMessagesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<StopMessage> get messages => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get scrollingMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set scrollingMessage($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasScrollingMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearScrollingMessage() => clearField(2);
}

class StopMessage extends $pb.GeneratedMessage {
  factory StopMessage() => create();
  StopMessage._() : super();
  factory StopMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StopMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StopMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'messageId')
    ..aOS(2, _omitFieldNames ? '' : 'messageKey')
    ..aOS(3, _omitFieldNames ? '' : 'defaultText')
    ..e<MessagePriority>(4, _omitFieldNames ? '' : 'priority', $pb.PbFieldType.OE, defaultOrMaker: MessagePriority.MESSAGE_PRIORITY_UNSPECIFIED, valueOf: MessagePriority.valueOf, enumValues: MessagePriority.values)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'expiresAt', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StopMessage clone() => StopMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StopMessage copyWith(void Function(StopMessage) updates) => super.copyWith((message) => updates(message as StopMessage)) as StopMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StopMessage create() => StopMessage._();
  StopMessage createEmptyInstance() => create();
  static $pb.PbList<StopMessage> createRepeated() => $pb.PbList<StopMessage>();
  @$core.pragma('dart2js:noInline')
  static StopMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StopMessage>(create);
  static StopMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get messageId => $_getSZ(0);
  @$pb.TagNumber(1)
  set messageId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMessageId() => $_has(0);
  @$pb.TagNumber(1)
  void clearMessageId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get messageKey => $_getSZ(1);
  @$pb.TagNumber(2)
  set messageKey($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessageKey() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessageKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get defaultText => $_getSZ(2);
  @$pb.TagNumber(3)
  set defaultText($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDefaultText() => $_has(2);
  @$pb.TagNumber(3)
  void clearDefaultText() => clearField(3);

  @$pb.TagNumber(4)
  MessagePriority get priority => $_getN(3);
  @$pb.TagNumber(4)
  set priority(MessagePriority v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasPriority() => $_has(3);
  @$pb.TagNumber(4)
  void clearPriority() => clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get expiresAt => $_getN(4);
  @$pb.TagNumber(5)
  set expiresAt($0.Timestamp v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasExpiresAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearExpiresAt() => clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureExpiresAt() => $_ensure(4);
}

class Announcement extends $pb.GeneratedMessage {
  factory Announcement() => create();
  Announcement._() : super();
  factory Announcement.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Announcement.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Announcement', package: const $pb.PackageName(_omitMessageNames ? '' : 'mybusz.frontline'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'announcementId')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'body')
    ..e<AnnouncementType>(4, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: AnnouncementType.ANNOUNCEMENT_TYPE_UNSPECIFIED, valueOf: AnnouncementType.valueOf, enumValues: AnnouncementType.values)
    ..aOM<$0.Timestamp>(5, _omitFieldNames ? '' : 'timestamp', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(6, _omitFieldNames ? '' : 'expiresAt', subBuilder: $0.Timestamp.create)
    ..pPS(7, _omitFieldNames ? '' : 'affectedServiceNos')
    ..pPS(8, _omitFieldNames ? '' : 'affectedStopCodes')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Announcement clone() => Announcement()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Announcement copyWith(void Function(Announcement) updates) => super.copyWith((message) => updates(message as Announcement)) as Announcement;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Announcement create() => Announcement._();
  Announcement createEmptyInstance() => create();
  static $pb.PbList<Announcement> createRepeated() => $pb.PbList<Announcement>();
  @$core.pragma('dart2js:noInline')
  static Announcement getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Announcement>(create);
  static Announcement? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get announcementId => $_getSZ(0);
  @$pb.TagNumber(1)
  set announcementId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAnnouncementId() => $_has(0);
  @$pb.TagNumber(1)
  void clearAnnouncementId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get body => $_getSZ(2);
  @$pb.TagNumber(3)
  set body($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasBody() => $_has(2);
  @$pb.TagNumber(3)
  void clearBody() => clearField(3);

  @$pb.TagNumber(4)
  AnnouncementType get type => $_getN(3);
  @$pb.TagNumber(4)
  set type(AnnouncementType v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasType() => $_has(3);
  @$pb.TagNumber(4)
  void clearType() => clearField(4);

  @$pb.TagNumber(5)
  $0.Timestamp get timestamp => $_getN(4);
  @$pb.TagNumber(5)
  set timestamp($0.Timestamp v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasTimestamp() => $_has(4);
  @$pb.TagNumber(5)
  void clearTimestamp() => clearField(5);
  @$pb.TagNumber(5)
  $0.Timestamp ensureTimestamp() => $_ensure(4);

  @$pb.TagNumber(6)
  $0.Timestamp get expiresAt => $_getN(5);
  @$pb.TagNumber(6)
  set expiresAt($0.Timestamp v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasExpiresAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearExpiresAt() => clearField(6);
  @$pb.TagNumber(6)
  $0.Timestamp ensureExpiresAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.List<$core.String> get affectedServiceNos => $_getList(6);

  @$pb.TagNumber(8)
  $core.List<$core.String> get affectedStopCodes => $_getList(7);
}

class FrontlineServiceApi {
  $pb.RpcClient _client;
  FrontlineServiceApi(this._client);

  $async.Future<GetStopArrivalsResponse> getStopArrivals($pb.ClientContext? ctx, GetStopArrivalsRequest request) =>
    _client.invoke<GetStopArrivalsResponse>(ctx, 'FrontlineService', 'GetStopArrivals', request, GetStopArrivalsResponse())
  ;
  $async.Future<StopArrivalsUpdate> streamStopArrivals($pb.ClientContext? ctx, StreamStopArrivalsRequest request) =>
    _client.invoke<StopArrivalsUpdate>(ctx, 'FrontlineService', 'StreamStopArrivals', request, StopArrivalsUpdate())
  ;
  $async.Future<GetBusPositionResponse> getBusPosition($pb.ClientContext? ctx, GetBusPositionRequest request) =>
    _client.invoke<GetBusPositionResponse>(ctx, 'FrontlineService', 'GetBusPosition', request, GetBusPositionResponse())
  ;
  $async.Future<ServiceBusesUpdate> streamServiceBuses($pb.ClientContext? ctx, StreamServiceBusesRequest request) =>
    _client.invoke<ServiceBusesUpdate>(ctx, 'FrontlineService', 'StreamServiceBuses', request, ServiceBusesUpdate())
  ;
  $async.Future<GetServiceDetailsResponse> getServiceDetails($pb.ClientContext? ctx, GetServiceDetailsRequest request) =>
    _client.invoke<GetServiceDetailsResponse>(ctx, 'FrontlineService', 'GetServiceDetails', request, GetServiceDetailsResponse())
  ;
  $async.Future<GetServicesAtStopResponse> getServicesAtStop($pb.ClientContext? ctx, GetServicesAtStopRequest request) =>
    _client.invoke<GetServicesAtStopResponse>(ctx, 'FrontlineService', 'GetServicesAtStop', request, GetServicesAtStopResponse())
  ;
  $async.Future<SearchBusStopsResponse> searchBusStops($pb.ClientContext? ctx, SearchBusStopsRequest request) =>
    _client.invoke<SearchBusStopsResponse>(ctx, 'FrontlineService', 'SearchBusStops', request, SearchBusStopsResponse())
  ;
  $async.Future<FindNearbyStopsResponse> findNearbyStops($pb.ClientContext? ctx, FindNearbyStopsRequest request) =>
    _client.invoke<FindNearbyStopsResponse>(ctx, 'FrontlineService', 'FindNearbyStops', request, FindNearbyStopsResponse())
  ;
  $async.Future<GetStopMessagesResponse> getStopMessages($pb.ClientContext? ctx, GetStopMessagesRequest request) =>
    _client.invoke<GetStopMessagesResponse>(ctx, 'FrontlineService', 'GetStopMessages', request, GetStopMessagesResponse())
  ;
  $async.Future<Announcement> streamAnnouncements($pb.ClientContext? ctx, $2.Empty request) =>
    _client.invoke<Announcement>(ctx, 'FrontlineService', 'StreamAnnouncements', request, Announcement())
  ;
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
