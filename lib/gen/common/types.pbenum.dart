//
//  Generated code. Do not modify.
//  source: common/types.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class EtaSource extends $pb.ProtobufEnum {
  static const EtaSource ETA_SOURCE_UNSPECIFIED = EtaSource._(0, _omitEnumNames ? '' : 'ETA_SOURCE_UNSPECIFIED');
  static const EtaSource ETA_SOURCE_REALTIME = EtaSource._(1, _omitEnumNames ? '' : 'ETA_SOURCE_REALTIME');
  static const EtaSource ETA_SOURCE_ML = EtaSource._(2, _omitEnumNames ? '' : 'ETA_SOURCE_ML');
  static const EtaSource ETA_SOURCE_SCHEDULED = EtaSource._(3, _omitEnumNames ? '' : 'ETA_SOURCE_SCHEDULED');

  static const $core.List<EtaSource> values = <EtaSource> [
    ETA_SOURCE_UNSPECIFIED,
    ETA_SOURCE_REALTIME,
    ETA_SOURCE_ML,
    ETA_SOURCE_SCHEDULED,
  ];

  static final $core.Map<$core.int, EtaSource> _byValue = $pb.ProtobufEnum.initByValue(values);
  static EtaSource? valueOf($core.int value) => _byValue[value];

  const EtaSource._($core.int v, $core.String n) : super(v, n);
}

class DelayStatus extends $pb.ProtobufEnum {
  static const DelayStatus DELAY_STATUS_UNSPECIFIED = DelayStatus._(0, _omitEnumNames ? '' : 'DELAY_STATUS_UNSPECIFIED');
  static const DelayStatus DELAY_STATUS_ON_TIME = DelayStatus._(1, _omitEnumNames ? '' : 'DELAY_STATUS_ON_TIME');
  static const DelayStatus DELAY_STATUS_SLIGHT_DELAY = DelayStatus._(2, _omitEnumNames ? '' : 'DELAY_STATUS_SLIGHT_DELAY');
  static const DelayStatus DELAY_STATUS_HEAVY_DELAY = DelayStatus._(3, _omitEnumNames ? '' : 'DELAY_STATUS_HEAVY_DELAY');

  static const $core.List<DelayStatus> values = <DelayStatus> [
    DELAY_STATUS_UNSPECIFIED,
    DELAY_STATUS_ON_TIME,
    DELAY_STATUS_SLIGHT_DELAY,
    DELAY_STATUS_HEAVY_DELAY,
  ];

  static final $core.Map<$core.int, DelayStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DelayStatus? valueOf($core.int value) => _byValue[value];

  const DelayStatus._($core.int v, $core.String n) : super(v, n);
}

class StalenessCategory extends $pb.ProtobufEnum {
  static const StalenessCategory STALENESS_UNSPECIFIED = StalenessCategory._(0, _omitEnumNames ? '' : 'STALENESS_UNSPECIFIED');
  static const StalenessCategory STALENESS_LIVE = StalenessCategory._(1, _omitEnumNames ? '' : 'STALENESS_LIVE');
  static const StalenessCategory STALENESS_RECENT = StalenessCategory._(2, _omitEnumNames ? '' : 'STALENESS_RECENT');
  static const StalenessCategory STALENESS_STALE = StalenessCategory._(3, _omitEnumNames ? '' : 'STALENESS_STALE');
  static const StalenessCategory STALENESS_OLD = StalenessCategory._(4, _omitEnumNames ? '' : 'STALENESS_OLD');

  static const $core.List<StalenessCategory> values = <StalenessCategory> [
    STALENESS_UNSPECIFIED,
    STALENESS_LIVE,
    STALENESS_RECENT,
    STALENESS_STALE,
    STALENESS_OLD,
  ];

  static final $core.Map<$core.int, StalenessCategory> _byValue = $pb.ProtobufEnum.initByValue(values);
  static StalenessCategory? valueOf($core.int value) => _byValue[value];

  const StalenessCategory._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
