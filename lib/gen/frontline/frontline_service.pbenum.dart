//
//  Generated code. Do not modify.
//  source: frontline/frontline_service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class MessagePriority extends $pb.ProtobufEnum {
  static const MessagePriority MESSAGE_PRIORITY_UNSPECIFIED = MessagePriority._(0, _omitEnumNames ? '' : 'MESSAGE_PRIORITY_UNSPECIFIED');
  static const MessagePriority MESSAGE_PRIORITY_LOW = MessagePriority._(1, _omitEnumNames ? '' : 'MESSAGE_PRIORITY_LOW');
  static const MessagePriority MESSAGE_PRIORITY_NORMAL = MessagePriority._(2, _omitEnumNames ? '' : 'MESSAGE_PRIORITY_NORMAL');
  static const MessagePriority MESSAGE_PRIORITY_HIGH = MessagePriority._(3, _omitEnumNames ? '' : 'MESSAGE_PRIORITY_HIGH');
  static const MessagePriority MESSAGE_PRIORITY_URGENT = MessagePriority._(4, _omitEnumNames ? '' : 'MESSAGE_PRIORITY_URGENT');

  static const $core.List<MessagePriority> values = <MessagePriority> [
    MESSAGE_PRIORITY_UNSPECIFIED,
    MESSAGE_PRIORITY_LOW,
    MESSAGE_PRIORITY_NORMAL,
    MESSAGE_PRIORITY_HIGH,
    MESSAGE_PRIORITY_URGENT,
  ];

  static final $core.Map<$core.int, MessagePriority> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MessagePriority? valueOf($core.int value) => _byValue[value];

  const MessagePriority._($core.int v, $core.String n) : super(v, n);
}

class AnnouncementType extends $pb.ProtobufEnum {
  static const AnnouncementType ANNOUNCEMENT_TYPE_UNSPECIFIED = AnnouncementType._(0, _omitEnumNames ? '' : 'ANNOUNCEMENT_TYPE_UNSPECIFIED');
  static const AnnouncementType ANNOUNCEMENT_TYPE_INFO = AnnouncementType._(1, _omitEnumNames ? '' : 'ANNOUNCEMENT_TYPE_INFO');
  static const AnnouncementType ANNOUNCEMENT_TYPE_DELAY = AnnouncementType._(2, _omitEnumNames ? '' : 'ANNOUNCEMENT_TYPE_DELAY');
  static const AnnouncementType ANNOUNCEMENT_TYPE_CANCELLATION = AnnouncementType._(3, _omitEnumNames ? '' : 'ANNOUNCEMENT_TYPE_CANCELLATION');
  static const AnnouncementType ANNOUNCEMENT_TYPE_DIVERSION = AnnouncementType._(4, _omitEnumNames ? '' : 'ANNOUNCEMENT_TYPE_DIVERSION');
  static const AnnouncementType ANNOUNCEMENT_TYPE_EMERGENCY = AnnouncementType._(5, _omitEnumNames ? '' : 'ANNOUNCEMENT_TYPE_EMERGENCY');

  static const $core.List<AnnouncementType> values = <AnnouncementType> [
    ANNOUNCEMENT_TYPE_UNSPECIFIED,
    ANNOUNCEMENT_TYPE_INFO,
    ANNOUNCEMENT_TYPE_DELAY,
    ANNOUNCEMENT_TYPE_CANCELLATION,
    ANNOUNCEMENT_TYPE_DIVERSION,
    ANNOUNCEMENT_TYPE_EMERGENCY,
  ];

  static final $core.Map<$core.int, AnnouncementType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static AnnouncementType? valueOf($core.int value) => _byValue[value];

  const AnnouncementType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
