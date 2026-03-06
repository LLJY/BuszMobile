//
//  Generated code. Do not modify.
//  source: frontline/frontline_service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import '../common/types.pbjson.dart' as $1;
import '../google/protobuf/empty.pbjson.dart' as $2;
import '../google/protobuf/timestamp.pbjson.dart' as $0;

@$core.Deprecated('Use messagePriorityDescriptor instead')
const MessagePriority$json = {
  '1': 'MessagePriority',
  '2': [
    {'1': 'MESSAGE_PRIORITY_UNSPECIFIED', '2': 0},
    {'1': 'MESSAGE_PRIORITY_LOW', '2': 1},
    {'1': 'MESSAGE_PRIORITY_NORMAL', '2': 2},
    {'1': 'MESSAGE_PRIORITY_HIGH', '2': 3},
    {'1': 'MESSAGE_PRIORITY_URGENT', '2': 4},
  ],
};

/// Descriptor for `MessagePriority`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List messagePriorityDescriptor = $convert.base64Decode(
    'Cg9NZXNzYWdlUHJpb3JpdHkSIAocTUVTU0FHRV9QUklPUklUWV9VTlNQRUNJRklFRBAAEhgKFE'
    '1FU1NBR0VfUFJJT1JJVFlfTE9XEAESGwoXTUVTU0FHRV9QUklPUklUWV9OT1JNQUwQAhIZChVN'
    'RVNTQUdFX1BSSU9SSVRZX0hJR0gQAxIbChdNRVNTQUdFX1BSSU9SSVRZX1VSR0VOVBAE');

@$core.Deprecated('Use announcementTypeDescriptor instead')
const AnnouncementType$json = {
  '1': 'AnnouncementType',
  '2': [
    {'1': 'ANNOUNCEMENT_TYPE_UNSPECIFIED', '2': 0},
    {'1': 'ANNOUNCEMENT_TYPE_INFO', '2': 1},
    {'1': 'ANNOUNCEMENT_TYPE_DELAY', '2': 2},
    {'1': 'ANNOUNCEMENT_TYPE_CANCELLATION', '2': 3},
    {'1': 'ANNOUNCEMENT_TYPE_DIVERSION', '2': 4},
    {'1': 'ANNOUNCEMENT_TYPE_EMERGENCY', '2': 5},
  ],
};

/// Descriptor for `AnnouncementType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List announcementTypeDescriptor = $convert.base64Decode(
    'ChBBbm5vdW5jZW1lbnRUeXBlEiEKHUFOTk9VTkNFTUVOVF9UWVBFX1VOU1BFQ0lGSUVEEAASGg'
    'oWQU5OT1VOQ0VNRU5UX1RZUEVfSU5GTxABEhsKF0FOTk9VTkNFTUVOVF9UWVBFX0RFTEFZEAIS'
    'IgoeQU5OT1VOQ0VNRU5UX1RZUEVfQ0FOQ0VMTEFUSU9OEAMSHwobQU5OT1VOQ0VNRU5UX1RZUE'
    'VfRElWRVJTSU9OEAQSHwobQU5OT1VOQ0VNRU5UX1RZUEVfRU1FUkdFTkNZEAU=');

@$core.Deprecated('Use getStopArrivalsRequestDescriptor instead')
const GetStopArrivalsRequest$json = {
  '1': 'GetStopArrivalsRequest',
  '2': [
    {'1': 'bus_stop_code', '3': 1, '4': 1, '5': 9, '10': 'busStopCode'},
    {'1': 'max_arrivals', '3': 2, '4': 1, '5': 5, '10': 'maxArrivals'},
    {'1': 'include_bus_locations', '3': 3, '4': 1, '5': 8, '10': 'includeBusLocations'},
  ],
};

/// Descriptor for `GetStopArrivalsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStopArrivalsRequestDescriptor = $convert.base64Decode(
    'ChZHZXRTdG9wQXJyaXZhbHNSZXF1ZXN0EiIKDWJ1c19zdG9wX2NvZGUYASABKAlSC2J1c1N0b3'
    'BDb2RlEiEKDG1heF9hcnJpdmFscxgCIAEoBVILbWF4QXJyaXZhbHMSMgoVaW5jbHVkZV9idXNf'
    'bG9jYXRpb25zGAMgASgIUhNpbmNsdWRlQnVzTG9jYXRpb25z');

@$core.Deprecated('Use getStopArrivalsResponseDescriptor instead')
const GetStopArrivalsResponse$json = {
  '1': 'GetStopArrivalsResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 11, '6': '.mybusz.frontline.StopArrivalsData', '10': 'data'},
  ],
};

/// Descriptor for `GetStopArrivalsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStopArrivalsResponseDescriptor = $convert.base64Decode(
    'ChdHZXRTdG9wQXJyaXZhbHNSZXNwb25zZRI2CgRkYXRhGAEgASgLMiIubXlidXN6LmZyb250bG'
    'luZS5TdG9wQXJyaXZhbHNEYXRhUgRkYXRh');

@$core.Deprecated('Use stopArrivalsDataDescriptor instead')
const StopArrivalsData$json = {
  '1': 'StopArrivalsData',
  '2': [
    {'1': 'bus_stop_code', '3': 1, '4': 1, '5': 9, '10': 'busStopCode'},
    {'1': 'bus_stop_name', '3': 2, '4': 1, '5': 9, '10': 'busStopName'},
    {'1': 'buses', '3': 3, '4': 3, '5': 11, '6': '.mybusz.frontline.BusArrival', '10': 'buses'},
    {'1': 'messages', '3': 4, '4': 3, '5': 9, '10': 'messages'},
    {'1': 'scrolling_message', '3': 5, '4': 1, '5': 9, '10': 'scrollingMessage'},
    {'1': 'updated_at', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
    {'1': 'bus_locations', '3': 7, '4': 3, '5': 11, '6': '.mybusz.frontline.BusPosition', '10': 'busLocations'},
  ],
};

/// Descriptor for `StopArrivalsData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopArrivalsDataDescriptor = $convert.base64Decode(
    'ChBTdG9wQXJyaXZhbHNEYXRhEiIKDWJ1c19zdG9wX2NvZGUYASABKAlSC2J1c1N0b3BDb2RlEi'
    'IKDWJ1c19zdG9wX25hbWUYAiABKAlSC2J1c1N0b3BOYW1lEjIKBWJ1c2VzGAMgAygLMhwubXli'
    'dXN6LmZyb250bGluZS5CdXNBcnJpdmFsUgVidXNlcxIaCghtZXNzYWdlcxgEIAMoCVIIbWVzc2'
    'FnZXMSKwoRc2Nyb2xsaW5nX21lc3NhZ2UYBSABKAlSEHNjcm9sbGluZ01lc3NhZ2USOQoKdXBk'
    'YXRlZF9hdBgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdBJCCg'
    '1idXNfbG9jYXRpb25zGAcgAygLMh0ubXlidXN6LmZyb250bGluZS5CdXNQb3NpdGlvblIMYnVz'
    'TG9jYXRpb25z');

@$core.Deprecated('Use busArrivalDescriptor instead')
const BusArrival$json = {
  '1': 'BusArrival',
  '2': [
    {'1': 'service_no', '3': 1, '4': 1, '5': 9, '10': 'serviceNo'},
    {'1': 'direction', '3': 14, '4': 1, '5': 5, '10': 'direction'},
    {'1': 'color', '3': 2, '4': 1, '5': 9, '10': 'color'},
    {'1': 'is_free', '3': 3, '4': 1, '5': 8, '10': 'isFree'},
    {'1': 'destination', '3': 4, '4': 1, '5': 9, '10': 'destination'},
    {'1': 'next_arrival', '3': 5, '4': 1, '5': 11, '6': '.mybusz.common.ArrivalTime', '10': 'nextArrival'},
    {'1': 'later_arrival', '3': 6, '4': 1, '5': 11, '6': '.mybusz.common.ArrivalTime', '10': 'laterArrival'},
    {'1': 'plate_no', '3': 7, '4': 1, '5': 9, '10': 'plateNo'},
    {'1': 'eta_source', '3': 8, '4': 1, '5': 14, '6': '.mybusz.common.EtaSource', '10': 'etaSource'},
    {'1': 'delay_status', '3': 9, '4': 1, '5': 14, '6': '.mybusz.common.DelayStatus', '10': 'delayStatus'},
    {'1': 'delay_minutes', '3': 10, '4': 1, '5': 5, '10': 'delayMinutes'},
    {'1': 'staleness', '3': 11, '4': 1, '5': 14, '6': '.mybusz.common.StalenessCategory', '10': 'staleness'},
    {'1': 'last_gps_update', '3': 12, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'lastGpsUpdate'},
    {'1': 'scheduled_time', '3': 13, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'scheduledTime'},
    {'1': 'is_departing', '3': 15, '4': 1, '5': 8, '10': 'isDeparting'},
    {'1': 'later_plate_no', '3': 16, '4': 1, '5': 9, '10': 'laterPlateNo'},
    {'1': 'punctuality_status', '3': 17, '4': 1, '5': 14, '6': '.mybusz.common.PunctualityStatus', '10': 'punctualityStatus'},
  ],
};

/// Descriptor for `BusArrival`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List busArrivalDescriptor = $convert.base64Decode(
    'CgpCdXNBcnJpdmFsEh0KCnNlcnZpY2Vfbm8YASABKAlSCXNlcnZpY2VObxIcCglkaXJlY3Rpb2'
    '4YDiABKAVSCWRpcmVjdGlvbhIUCgVjb2xvchgCIAEoCVIFY29sb3ISFwoHaXNfZnJlZRgDIAEo'
    'CFIGaXNGcmVlEiAKC2Rlc3RpbmF0aW9uGAQgASgJUgtkZXN0aW5hdGlvbhI9CgxuZXh0X2Fycm'
    'l2YWwYBSABKAsyGi5teWJ1c3ouY29tbW9uLkFycml2YWxUaW1lUgtuZXh0QXJyaXZhbBI/Cg1s'
    'YXRlcl9hcnJpdmFsGAYgASgLMhoubXlidXN6LmNvbW1vbi5BcnJpdmFsVGltZVIMbGF0ZXJBcn'
    'JpdmFsEhkKCHBsYXRlX25vGAcgASgJUgdwbGF0ZU5vEjcKCmV0YV9zb3VyY2UYCCABKA4yGC5t'
    'eWJ1c3ouY29tbW9uLkV0YVNvdXJjZVIJZXRhU291cmNlEj0KDGRlbGF5X3N0YXR1cxgJIAEoDj'
    'IaLm15YnVzei5jb21tb24uRGVsYXlTdGF0dXNSC2RlbGF5U3RhdHVzEiMKDWRlbGF5X21pbnV0'
    'ZXMYCiABKAVSDGRlbGF5TWludXRlcxI+CglzdGFsZW5lc3MYCyABKA4yIC5teWJ1c3ouY29tbW'
    '9uLlN0YWxlbmVzc0NhdGVnb3J5UglzdGFsZW5lc3MSQgoPbGFzdF9ncHNfdXBkYXRlGAwgASgL'
    'MhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFINbGFzdEdwc1VwZGF0ZRJBCg5zY2hlZHVsZW'
    'RfdGltZRgNIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDXNjaGVkdWxlZFRpbWUS'
    'IQoMaXNfZGVwYXJ0aW5nGA8gASgIUgtpc0RlcGFydGluZxIkCg5sYXRlcl9wbGF0ZV9ubxgQIA'
    'EoCVIMbGF0ZXJQbGF0ZU5vEk8KEnB1bmN0dWFsaXR5X3N0YXR1cxgRIAEoDjIgLm15YnVzei5j'
    'b21tb24uUHVuY3R1YWxpdHlTdGF0dXNSEXB1bmN0dWFsaXR5U3RhdHVz');

@$core.Deprecated('Use streamStopArrivalsRequestDescriptor instead')
const StreamStopArrivalsRequest$json = {
  '1': 'StreamStopArrivalsRequest',
  '2': [
    {'1': 'bus_stop_code', '3': 1, '4': 1, '5': 9, '10': 'busStopCode'},
    {'1': 'max_arrivals', '3': 2, '4': 1, '5': 5, '10': 'maxArrivals'},
    {'1': 'include_bus_locations', '3': 3, '4': 1, '5': 8, '10': 'includeBusLocations'},
  ],
};

/// Descriptor for `StreamStopArrivalsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamStopArrivalsRequestDescriptor = $convert.base64Decode(
    'ChlTdHJlYW1TdG9wQXJyaXZhbHNSZXF1ZXN0EiIKDWJ1c19zdG9wX2NvZGUYASABKAlSC2J1c1'
    'N0b3BDb2RlEiEKDG1heF9hcnJpdmFscxgCIAEoBVILbWF4QXJyaXZhbHMSMgoVaW5jbHVkZV9i'
    'dXNfbG9jYXRpb25zGAMgASgIUhNpbmNsdWRlQnVzTG9jYXRpb25z');

@$core.Deprecated('Use stopArrivalsUpdateDescriptor instead')
const StopArrivalsUpdate$json = {
  '1': 'StopArrivalsUpdate',
  '2': [
    {'1': 'full_update', '3': 1, '4': 1, '5': 11, '6': '.mybusz.frontline.StopArrivalsData', '9': 0, '10': 'fullUpdate'},
    {'1': 'delta_update', '3': 2, '4': 1, '5': 11, '6': '.mybusz.frontline.BusArrivalDelta', '9': 0, '10': 'deltaUpdate'},
    {'1': 'timestamp', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestamp'},
  ],
  '8': [
    {'1': 'update'},
  ],
};

/// Descriptor for `StopArrivalsUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopArrivalsUpdateDescriptor = $convert.base64Decode(
    'ChJTdG9wQXJyaXZhbHNVcGRhdGUSRQoLZnVsbF91cGRhdGUYASABKAsyIi5teWJ1c3ouZnJvbn'
    'RsaW5lLlN0b3BBcnJpdmFsc0RhdGFIAFIKZnVsbFVwZGF0ZRJGCgxkZWx0YV91cGRhdGUYAiAB'
    'KAsyIS5teWJ1c3ouZnJvbnRsaW5lLkJ1c0Fycml2YWxEZWx0YUgAUgtkZWx0YVVwZGF0ZRI4Cg'
    'l0aW1lc3RhbXAYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl0aW1lc3RhbXBC'
    'CAoGdXBkYXRl');

@$core.Deprecated('Use busArrivalDeltaDescriptor instead')
const BusArrivalDelta$json = {
  '1': 'BusArrivalDelta',
  '2': [
    {'1': 'updated', '3': 1, '4': 3, '5': 11, '6': '.mybusz.frontline.BusArrival', '10': 'updated'},
    {'1': 'removed_service_nos', '3': 2, '4': 3, '5': 9, '10': 'removedServiceNos'},
  ],
};

/// Descriptor for `BusArrivalDelta`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List busArrivalDeltaDescriptor = $convert.base64Decode(
    'Cg9CdXNBcnJpdmFsRGVsdGESNgoHdXBkYXRlZBgBIAMoCzIcLm15YnVzei5mcm9udGxpbmUuQn'
    'VzQXJyaXZhbFIHdXBkYXRlZBIuChNyZW1vdmVkX3NlcnZpY2Vfbm9zGAIgAygJUhFyZW1vdmVk'
    'U2VydmljZU5vcw==');

@$core.Deprecated('Use getBusPositionRequestDescriptor instead')
const GetBusPositionRequest$json = {
  '1': 'GetBusPositionRequest',
  '2': [
    {'1': 'plate_no', '3': 1, '4': 1, '5': 9, '10': 'plateNo'},
  ],
};

/// Descriptor for `GetBusPositionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBusPositionRequestDescriptor = $convert.base64Decode(
    'ChVHZXRCdXNQb3NpdGlvblJlcXVlc3QSGQoIcGxhdGVfbm8YASABKAlSB3BsYXRlTm8=');

@$core.Deprecated('Use getBusPositionResponseDescriptor instead')
const GetBusPositionResponse$json = {
  '1': 'GetBusPositionResponse',
  '2': [
    {'1': 'position', '3': 1, '4': 1, '5': 11, '6': '.mybusz.frontline.BusPosition', '10': 'position'},
  ],
};

/// Descriptor for `GetBusPositionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getBusPositionResponseDescriptor = $convert.base64Decode(
    'ChZHZXRCdXNQb3NpdGlvblJlc3BvbnNlEjkKCHBvc2l0aW9uGAEgASgLMh0ubXlidXN6LmZyb2'
    '50bGluZS5CdXNQb3NpdGlvblIIcG9zaXRpb24=');

@$core.Deprecated('Use busPositionDescriptor instead')
const BusPosition$json = {
  '1': 'BusPosition',
  '2': [
    {'1': 'plate_no', '3': 1, '4': 1, '5': 9, '10': 'plateNo'},
    {'1': 'service_no', '3': 2, '4': 1, '5': 9, '10': 'serviceNo'},
    {'1': 'direction', '3': 10, '4': 1, '5': 5, '10': 'direction'},
    {'1': 'location', '3': 3, '4': 1, '5': 11, '6': '.mybusz.common.GeoPoint', '10': 'location'},
    {'1': 'speed_kmh', '3': 4, '4': 1, '5': 1, '10': 'speedKmh'},
    {'1': 'heading', '3': 5, '4': 1, '5': 1, '10': 'heading'},
    {'1': 'timestamp', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestamp'},
    {'1': 'next_stop_code', '3': 7, '4': 1, '5': 9, '10': 'nextStopCode'},
    {'1': 'next_stop_name', '3': 8, '4': 1, '5': 9, '10': 'nextStopName'},
    {'1': 'eta_to_next_stop_minutes', '3': 9, '4': 1, '5': 5, '10': 'etaToNextStopMinutes'},
  ],
};

/// Descriptor for `BusPosition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List busPositionDescriptor = $convert.base64Decode(
    'CgtCdXNQb3NpdGlvbhIZCghwbGF0ZV9ubxgBIAEoCVIHcGxhdGVObxIdCgpzZXJ2aWNlX25vGA'
    'IgASgJUglzZXJ2aWNlTm8SHAoJZGlyZWN0aW9uGAogASgFUglkaXJlY3Rpb24SMwoIbG9jYXRp'
    'b24YAyABKAsyFy5teWJ1c3ouY29tbW9uLkdlb1BvaW50Ughsb2NhdGlvbhIbCglzcGVlZF9rbW'
    'gYBCABKAFSCHNwZWVkS21oEhgKB2hlYWRpbmcYBSABKAFSB2hlYWRpbmcSOAoJdGltZXN0YW1w'
    'GAYgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdGltZXN0YW1wEiQKDm5leHRfc3'
    'RvcF9jb2RlGAcgASgJUgxuZXh0U3RvcENvZGUSJAoObmV4dF9zdG9wX25hbWUYCCABKAlSDG5l'
    'eHRTdG9wTmFtZRI2ChhldGFfdG9fbmV4dF9zdG9wX21pbnV0ZXMYCSABKAVSFGV0YVRvTmV4dF'
    'N0b3BNaW51dGVz');

@$core.Deprecated('Use streamServiceBusesRequestDescriptor instead')
const StreamServiceBusesRequest$json = {
  '1': 'StreamServiceBusesRequest',
  '2': [
    {'1': 'service_no', '3': 1, '4': 1, '5': 9, '10': 'serviceNo'},
    {'1': 'direction', '3': 2, '4': 1, '5': 5, '10': 'direction'},
  ],
};

/// Descriptor for `StreamServiceBusesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List streamServiceBusesRequestDescriptor = $convert.base64Decode(
    'ChlTdHJlYW1TZXJ2aWNlQnVzZXNSZXF1ZXN0Eh0KCnNlcnZpY2Vfbm8YASABKAlSCXNlcnZpY2'
    'VObxIcCglkaXJlY3Rpb24YAiABKAVSCWRpcmVjdGlvbg==');

@$core.Deprecated('Use serviceBusesUpdateDescriptor instead')
const ServiceBusesUpdate$json = {
  '1': 'ServiceBusesUpdate',
  '2': [
    {'1': 'service_no', '3': 1, '4': 1, '5': 9, '10': 'serviceNo'},
    {'1': 'direction', '3': 4, '4': 1, '5': 5, '10': 'direction'},
    {'1': 'buses', '3': 2, '4': 3, '5': 11, '6': '.mybusz.frontline.BusPosition', '10': 'buses'},
    {'1': 'timestamp', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestamp'},
  ],
};

/// Descriptor for `ServiceBusesUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceBusesUpdateDescriptor = $convert.base64Decode(
    'ChJTZXJ2aWNlQnVzZXNVcGRhdGUSHQoKc2VydmljZV9ubxgBIAEoCVIJc2VydmljZU5vEhwKCW'
    'RpcmVjdGlvbhgEIAEoBVIJZGlyZWN0aW9uEjMKBWJ1c2VzGAIgAygLMh0ubXlidXN6LmZyb250'
    'bGluZS5CdXNQb3NpdGlvblIFYnVzZXMSOAoJdGltZXN0YW1wGAMgASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIJdGltZXN0YW1w');

@$core.Deprecated('Use getServiceDetailsRequestDescriptor instead')
const GetServiceDetailsRequest$json = {
  '1': 'GetServiceDetailsRequest',
  '2': [
    {'1': 'service_no', '3': 1, '4': 1, '5': 9, '10': 'serviceNo'},
    {'1': 'direction', '3': 2, '4': 1, '5': 5, '10': 'direction'},
  ],
};

/// Descriptor for `GetServiceDetailsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getServiceDetailsRequestDescriptor = $convert.base64Decode(
    'ChhHZXRTZXJ2aWNlRGV0YWlsc1JlcXVlc3QSHQoKc2VydmljZV9ubxgBIAEoCVIJc2VydmljZU'
    '5vEhwKCWRpcmVjdGlvbhgCIAEoBVIJZGlyZWN0aW9u');

@$core.Deprecated('Use getServiceDetailsResponseDescriptor instead')
const GetServiceDetailsResponse$json = {
  '1': 'GetServiceDetailsResponse',
  '2': [
    {'1': 'service', '3': 1, '4': 1, '5': 11, '6': '.mybusz.common.ServiceInfo', '10': 'service'},
    {'1': 'polyline', '3': 2, '4': 1, '5': 9, '10': 'polyline'},
    {'1': 'stops', '3': 3, '4': 3, '5': 11, '6': '.mybusz.frontline.ServiceStopInfo', '10': 'stops'},
    {'1': 'origin', '3': 4, '4': 1, '5': 9, '10': 'origin'},
    {'1': 'destination', '3': 5, '4': 1, '5': 9, '10': 'destination'},
  ],
};

/// Descriptor for `GetServiceDetailsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getServiceDetailsResponseDescriptor = $convert.base64Decode(
    'ChlHZXRTZXJ2aWNlRGV0YWlsc1Jlc3BvbnNlEjQKB3NlcnZpY2UYASABKAsyGi5teWJ1c3ouY2'
    '9tbW9uLlNlcnZpY2VJbmZvUgdzZXJ2aWNlEhoKCHBvbHlsaW5lGAIgASgJUghwb2x5bGluZRI3'
    'CgVzdG9wcxgDIAMoCzIhLm15YnVzei5mcm9udGxpbmUuU2VydmljZVN0b3BJbmZvUgVzdG9wcx'
    'IWCgZvcmlnaW4YBCABKAlSBm9yaWdpbhIgCgtkZXN0aW5hdGlvbhgFIAEoCVILZGVzdGluYXRp'
    'b24=');

@$core.Deprecated('Use serviceStopInfoDescriptor instead')
const ServiceStopInfo$json = {
  '1': 'ServiceStopInfo',
  '2': [
    {'1': 'bus_stop_code', '3': 1, '4': 1, '5': 9, '10': 'busStopCode'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'location', '3': 3, '4': 1, '5': 11, '6': '.mybusz.common.GeoPoint', '10': 'location'},
    {'1': 'sequence', '3': 4, '4': 1, '5': 5, '10': 'sequence'},
  ],
};

/// Descriptor for `ServiceStopInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceStopInfoDescriptor = $convert.base64Decode(
    'Cg9TZXJ2aWNlU3RvcEluZm8SIgoNYnVzX3N0b3BfY29kZRgBIAEoCVILYnVzU3RvcENvZGUSEg'
    'oEbmFtZRgCIAEoCVIEbmFtZRIzCghsb2NhdGlvbhgDIAEoCzIXLm15YnVzei5jb21tb24uR2Vv'
    'UG9pbnRSCGxvY2F0aW9uEhoKCHNlcXVlbmNlGAQgASgFUghzZXF1ZW5jZQ==');

@$core.Deprecated('Use getServicesAtStopRequestDescriptor instead')
const GetServicesAtStopRequest$json = {
  '1': 'GetServicesAtStopRequest',
  '2': [
    {'1': 'bus_stop_code', '3': 1, '4': 1, '5': 9, '10': 'busStopCode'},
  ],
};

/// Descriptor for `GetServicesAtStopRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getServicesAtStopRequestDescriptor = $convert.base64Decode(
    'ChhHZXRTZXJ2aWNlc0F0U3RvcFJlcXVlc3QSIgoNYnVzX3N0b3BfY29kZRgBIAEoCVILYnVzU3'
    'RvcENvZGU=');

@$core.Deprecated('Use getServicesAtStopResponseDescriptor instead')
const GetServicesAtStopResponse$json = {
  '1': 'GetServicesAtStopResponse',
  '2': [
    {'1': 'bus_stop_code', '3': 1, '4': 1, '5': 9, '10': 'busStopCode'},
    {'1': 'bus_stop_name', '3': 2, '4': 1, '5': 9, '10': 'busStopName'},
    {'1': 'services', '3': 3, '4': 3, '5': 11, '6': '.mybusz.frontline.ServiceAtStop', '10': 'services'},
  ],
};

/// Descriptor for `GetServicesAtStopResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getServicesAtStopResponseDescriptor = $convert.base64Decode(
    'ChlHZXRTZXJ2aWNlc0F0U3RvcFJlc3BvbnNlEiIKDWJ1c19zdG9wX2NvZGUYASABKAlSC2J1c1'
    'N0b3BDb2RlEiIKDWJ1c19zdG9wX25hbWUYAiABKAlSC2J1c1N0b3BOYW1lEjsKCHNlcnZpY2Vz'
    'GAMgAygLMh8ubXlidXN6LmZyb250bGluZS5TZXJ2aWNlQXRTdG9wUghzZXJ2aWNlcw==');

@$core.Deprecated('Use serviceAtStopDescriptor instead')
const ServiceAtStop$json = {
  '1': 'ServiceAtStop',
  '2': [
    {'1': 'service', '3': 1, '4': 1, '5': 11, '6': '.mybusz.common.ServiceInfo', '10': 'service'},
    {'1': 'destination', '3': 2, '4': 1, '5': 9, '10': 'destination'},
    {'1': 'next_arrival', '3': 3, '4': 1, '5': 11, '6': '.mybusz.common.ArrivalTime', '10': 'nextArrival'},
  ],
};

/// Descriptor for `ServiceAtStop`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceAtStopDescriptor = $convert.base64Decode(
    'Cg1TZXJ2aWNlQXRTdG9wEjQKB3NlcnZpY2UYASABKAsyGi5teWJ1c3ouY29tbW9uLlNlcnZpY2'
    'VJbmZvUgdzZXJ2aWNlEiAKC2Rlc3RpbmF0aW9uGAIgASgJUgtkZXN0aW5hdGlvbhI9CgxuZXh0'
    'X2Fycml2YWwYAyABKAsyGi5teWJ1c3ouY29tbW9uLkFycml2YWxUaW1lUgtuZXh0QXJyaXZhbA'
    '==');

@$core.Deprecated('Use searchBusStopsRequestDescriptor instead')
const SearchBusStopsRequest$json = {
  '1': 'SearchBusStopsRequest',
  '2': [
    {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
    {'1': 'limit', '3': 2, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `SearchBusStopsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchBusStopsRequestDescriptor = $convert.base64Decode(
    'ChVTZWFyY2hCdXNTdG9wc1JlcXVlc3QSFAoFcXVlcnkYASABKAlSBXF1ZXJ5EhQKBWxpbWl0GA'
    'IgASgFUgVsaW1pdA==');

@$core.Deprecated('Use searchBusStopsResponseDescriptor instead')
const SearchBusStopsResponse$json = {
  '1': 'SearchBusStopsResponse',
  '2': [
    {'1': 'results', '3': 1, '4': 3, '5': 11, '6': '.mybusz.frontline.SearchResult', '10': 'results'},
  ],
};

/// Descriptor for `SearchBusStopsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchBusStopsResponseDescriptor = $convert.base64Decode(
    'ChZTZWFyY2hCdXNTdG9wc1Jlc3BvbnNlEjgKB3Jlc3VsdHMYASADKAsyHi5teWJ1c3ouZnJvbn'
    'RsaW5lLlNlYXJjaFJlc3VsdFIHcmVzdWx0cw==');

@$core.Deprecated('Use searchResultDescriptor instead')
const SearchResult$json = {
  '1': 'SearchResult',
  '2': [
    {'1': 'bus_stop', '3': 1, '4': 1, '5': 11, '6': '.mybusz.common.BusStopInfo', '10': 'busStop'},
    {'1': 'service_nos', '3': 2, '4': 3, '5': 9, '10': 'serviceNos'},
    {'1': 'relevance_score', '3': 3, '4': 1, '5': 1, '10': 'relevanceScore'},
  ],
};

/// Descriptor for `SearchResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchResultDescriptor = $convert.base64Decode(
    'CgxTZWFyY2hSZXN1bHQSNQoIYnVzX3N0b3AYASABKAsyGi5teWJ1c3ouY29tbW9uLkJ1c1N0b3'
    'BJbmZvUgdidXNTdG9wEh8KC3NlcnZpY2Vfbm9zGAIgAygJUgpzZXJ2aWNlTm9zEicKD3JlbGV2'
    'YW5jZV9zY29yZRgDIAEoAVIOcmVsZXZhbmNlU2NvcmU=');

@$core.Deprecated('Use findNearbyStopsRequestDescriptor instead')
const FindNearbyStopsRequest$json = {
  '1': 'FindNearbyStopsRequest',
  '2': [
    {'1': 'location', '3': 1, '4': 1, '5': 11, '6': '.mybusz.common.GeoPoint', '10': 'location'},
    {'1': 'radius_meters', '3': 2, '4': 1, '5': 1, '10': 'radiusMeters'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

/// Descriptor for `FindNearbyStopsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findNearbyStopsRequestDescriptor = $convert.base64Decode(
    'ChZGaW5kTmVhcmJ5U3RvcHNSZXF1ZXN0EjMKCGxvY2F0aW9uGAEgASgLMhcubXlidXN6LmNvbW'
    '1vbi5HZW9Qb2ludFIIbG9jYXRpb24SIwoNcmFkaXVzX21ldGVycxgCIAEoAVIMcmFkaXVzTWV0'
    'ZXJzEhQKBWxpbWl0GAMgASgFUgVsaW1pdA==');

@$core.Deprecated('Use findNearbyStopsResponseDescriptor instead')
const FindNearbyStopsResponse$json = {
  '1': 'FindNearbyStopsResponse',
  '2': [
    {'1': 'stops', '3': 1, '4': 3, '5': 11, '6': '.mybusz.frontline.NearbyStopResult', '10': 'stops'},
  ],
};

/// Descriptor for `FindNearbyStopsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List findNearbyStopsResponseDescriptor = $convert.base64Decode(
    'ChdGaW5kTmVhcmJ5U3RvcHNSZXNwb25zZRI4CgVzdG9wcxgBIAMoCzIiLm15YnVzei5mcm9udG'
    'xpbmUuTmVhcmJ5U3RvcFJlc3VsdFIFc3RvcHM=');

@$core.Deprecated('Use nearbyStopResultDescriptor instead')
const NearbyStopResult$json = {
  '1': 'NearbyStopResult',
  '2': [
    {'1': 'bus_stop', '3': 1, '4': 1, '5': 11, '6': '.mybusz.common.BusStopInfo', '10': 'busStop'},
    {'1': 'distance_meters', '3': 2, '4': 1, '5': 1, '10': 'distanceMeters'},
    {'1': 'service_nos', '3': 3, '4': 3, '5': 9, '10': 'serviceNos'},
    {'1': 'next_arrival', '3': 4, '4': 1, '5': 11, '6': '.mybusz.common.ArrivalTime', '10': 'nextArrival'},
  ],
};

/// Descriptor for `NearbyStopResult`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List nearbyStopResultDescriptor = $convert.base64Decode(
    'ChBOZWFyYnlTdG9wUmVzdWx0EjUKCGJ1c19zdG9wGAEgASgLMhoubXlidXN6LmNvbW1vbi5CdX'
    'NTdG9wSW5mb1IHYnVzU3RvcBInCg9kaXN0YW5jZV9tZXRlcnMYAiABKAFSDmRpc3RhbmNlTWV0'
    'ZXJzEh8KC3NlcnZpY2Vfbm9zGAMgAygJUgpzZXJ2aWNlTm9zEj0KDG5leHRfYXJyaXZhbBgEIA'
    'EoCzIaLm15YnVzei5jb21tb24uQXJyaXZhbFRpbWVSC25leHRBcnJpdmFs');

@$core.Deprecated('Use getStopMessagesRequestDescriptor instead')
const GetStopMessagesRequest$json = {
  '1': 'GetStopMessagesRequest',
  '2': [
    {'1': 'bus_stop_code', '3': 1, '4': 1, '5': 9, '10': 'busStopCode'},
  ],
};

/// Descriptor for `GetStopMessagesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStopMessagesRequestDescriptor = $convert.base64Decode(
    'ChZHZXRTdG9wTWVzc2FnZXNSZXF1ZXN0EiIKDWJ1c19zdG9wX2NvZGUYASABKAlSC2J1c1N0b3'
    'BDb2Rl');

@$core.Deprecated('Use getStopMessagesResponseDescriptor instead')
const GetStopMessagesResponse$json = {
  '1': 'GetStopMessagesResponse',
  '2': [
    {'1': 'messages', '3': 1, '4': 3, '5': 11, '6': '.mybusz.frontline.StopMessage', '10': 'messages'},
    {'1': 'scrolling_message', '3': 2, '4': 1, '5': 9, '10': 'scrollingMessage'},
  ],
};

/// Descriptor for `GetStopMessagesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getStopMessagesResponseDescriptor = $convert.base64Decode(
    'ChdHZXRTdG9wTWVzc2FnZXNSZXNwb25zZRI5CghtZXNzYWdlcxgBIAMoCzIdLm15YnVzei5mcm'
    '9udGxpbmUuU3RvcE1lc3NhZ2VSCG1lc3NhZ2VzEisKEXNjcm9sbGluZ19tZXNzYWdlGAIgASgJ'
    'UhBzY3JvbGxpbmdNZXNzYWdl');

@$core.Deprecated('Use stopMessageDescriptor instead')
const StopMessage$json = {
  '1': 'StopMessage',
  '2': [
    {'1': 'message_id', '3': 1, '4': 1, '5': 9, '10': 'messageId'},
    {'1': 'message_key', '3': 2, '4': 1, '5': 9, '10': 'messageKey'},
    {'1': 'default_text', '3': 3, '4': 1, '5': 9, '10': 'defaultText'},
    {'1': 'priority', '3': 4, '4': 1, '5': 14, '6': '.mybusz.frontline.MessagePriority', '10': 'priority'},
    {'1': 'expires_at', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'expiresAt'},
  ],
};

/// Descriptor for `StopMessage`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List stopMessageDescriptor = $convert.base64Decode(
    'CgtTdG9wTWVzc2FnZRIdCgptZXNzYWdlX2lkGAEgASgJUgltZXNzYWdlSWQSHwoLbWVzc2FnZV'
    '9rZXkYAiABKAlSCm1lc3NhZ2VLZXkSIQoMZGVmYXVsdF90ZXh0GAMgASgJUgtkZWZhdWx0VGV4'
    'dBI9Cghwcmlvcml0eRgEIAEoDjIhLm15YnVzei5mcm9udGxpbmUuTWVzc2FnZVByaW9yaXR5Ug'
    'hwcmlvcml0eRI5CgpleHBpcmVzX2F0GAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFt'
    'cFIJZXhwaXJlc0F0');

@$core.Deprecated('Use announcementDescriptor instead')
const Announcement$json = {
  '1': 'Announcement',
  '2': [
    {'1': 'announcement_id', '3': 1, '4': 1, '5': 9, '10': 'announcementId'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'body', '3': 3, '4': 1, '5': 9, '10': 'body'},
    {'1': 'type', '3': 4, '4': 1, '5': 14, '6': '.mybusz.frontline.AnnouncementType', '10': 'type'},
    {'1': 'timestamp', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestamp'},
    {'1': 'expires_at', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'expiresAt'},
    {'1': 'affected_service_nos', '3': 7, '4': 3, '5': 9, '10': 'affectedServiceNos'},
    {'1': 'affected_stop_codes', '3': 8, '4': 3, '5': 9, '10': 'affectedStopCodes'},
  ],
};

/// Descriptor for `Announcement`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List announcementDescriptor = $convert.base64Decode(
    'CgxBbm5vdW5jZW1lbnQSJwoPYW5ub3VuY2VtZW50X2lkGAEgASgJUg5hbm5vdW5jZW1lbnRJZB'
    'IUCgV0aXRsZRgCIAEoCVIFdGl0bGUSEgoEYm9keRgDIAEoCVIEYm9keRI2CgR0eXBlGAQgASgO'
    'MiIubXlidXN6LmZyb250bGluZS5Bbm5vdW5jZW1lbnRUeXBlUgR0eXBlEjgKCXRpbWVzdGFtcB'
    'gFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXRpbWVzdGFtcBI5CgpleHBpcmVz'
    'X2F0GAYgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJZXhwaXJlc0F0EjAKFGFmZm'
    'VjdGVkX3NlcnZpY2Vfbm9zGAcgAygJUhJhZmZlY3RlZFNlcnZpY2VOb3MSLgoTYWZmZWN0ZWRf'
    'c3RvcF9jb2RlcxgIIAMoCVIRYWZmZWN0ZWRTdG9wQ29kZXM=');

const $core.Map<$core.String, $core.dynamic> FrontlineServiceBase$json = {
  '1': 'FrontlineService',
  '2': [
    {'1': 'GetStopArrivals', '2': '.mybusz.frontline.GetStopArrivalsRequest', '3': '.mybusz.frontline.GetStopArrivalsResponse'},
    {'1': 'StreamStopArrivals', '2': '.mybusz.frontline.StreamStopArrivalsRequest', '3': '.mybusz.frontline.StopArrivalsUpdate', '6': true},
    {'1': 'GetBusPosition', '2': '.mybusz.frontline.GetBusPositionRequest', '3': '.mybusz.frontline.GetBusPositionResponse'},
    {'1': 'StreamServiceBuses', '2': '.mybusz.frontline.StreamServiceBusesRequest', '3': '.mybusz.frontline.ServiceBusesUpdate', '6': true},
    {'1': 'GetServiceDetails', '2': '.mybusz.frontline.GetServiceDetailsRequest', '3': '.mybusz.frontline.GetServiceDetailsResponse'},
    {'1': 'GetServicesAtStop', '2': '.mybusz.frontline.GetServicesAtStopRequest', '3': '.mybusz.frontline.GetServicesAtStopResponse'},
    {'1': 'SearchBusStops', '2': '.mybusz.frontline.SearchBusStopsRequest', '3': '.mybusz.frontline.SearchBusStopsResponse'},
    {'1': 'FindNearbyStops', '2': '.mybusz.frontline.FindNearbyStopsRequest', '3': '.mybusz.frontline.FindNearbyStopsResponse'},
    {'1': 'GetStopMessages', '2': '.mybusz.frontline.GetStopMessagesRequest', '3': '.mybusz.frontline.GetStopMessagesResponse'},
    {'1': 'StreamAnnouncements', '2': '.google.protobuf.Empty', '3': '.mybusz.frontline.Announcement', '6': true},
  ],
};

@$core.Deprecated('Use frontlineServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> FrontlineServiceBase$messageJson = {
  '.mybusz.frontline.GetStopArrivalsRequest': GetStopArrivalsRequest$json,
  '.mybusz.frontline.GetStopArrivalsResponse': GetStopArrivalsResponse$json,
  '.mybusz.frontline.StopArrivalsData': StopArrivalsData$json,
  '.mybusz.frontline.BusArrival': BusArrival$json,
  '.mybusz.common.ArrivalTime': $1.ArrivalTime$json,
  '.google.protobuf.Timestamp': $0.Timestamp$json,
  '.mybusz.frontline.BusPosition': BusPosition$json,
  '.mybusz.common.GeoPoint': $1.GeoPoint$json,
  '.mybusz.frontline.StreamStopArrivalsRequest': StreamStopArrivalsRequest$json,
  '.mybusz.frontline.StopArrivalsUpdate': StopArrivalsUpdate$json,
  '.mybusz.frontline.BusArrivalDelta': BusArrivalDelta$json,
  '.mybusz.frontline.GetBusPositionRequest': GetBusPositionRequest$json,
  '.mybusz.frontline.GetBusPositionResponse': GetBusPositionResponse$json,
  '.mybusz.frontline.StreamServiceBusesRequest': StreamServiceBusesRequest$json,
  '.mybusz.frontline.ServiceBusesUpdate': ServiceBusesUpdate$json,
  '.mybusz.frontline.GetServiceDetailsRequest': GetServiceDetailsRequest$json,
  '.mybusz.frontline.GetServiceDetailsResponse': GetServiceDetailsResponse$json,
  '.mybusz.common.ServiceInfo': $1.ServiceInfo$json,
  '.mybusz.frontline.ServiceStopInfo': ServiceStopInfo$json,
  '.mybusz.frontline.GetServicesAtStopRequest': GetServicesAtStopRequest$json,
  '.mybusz.frontline.GetServicesAtStopResponse': GetServicesAtStopResponse$json,
  '.mybusz.frontline.ServiceAtStop': ServiceAtStop$json,
  '.mybusz.frontline.SearchBusStopsRequest': SearchBusStopsRequest$json,
  '.mybusz.frontline.SearchBusStopsResponse': SearchBusStopsResponse$json,
  '.mybusz.frontline.SearchResult': SearchResult$json,
  '.mybusz.common.BusStopInfo': $1.BusStopInfo$json,
  '.mybusz.frontline.FindNearbyStopsRequest': FindNearbyStopsRequest$json,
  '.mybusz.frontline.FindNearbyStopsResponse': FindNearbyStopsResponse$json,
  '.mybusz.frontline.NearbyStopResult': NearbyStopResult$json,
  '.mybusz.frontline.GetStopMessagesRequest': GetStopMessagesRequest$json,
  '.mybusz.frontline.GetStopMessagesResponse': GetStopMessagesResponse$json,
  '.mybusz.frontline.StopMessage': StopMessage$json,
  '.google.protobuf.Empty': $2.Empty$json,
  '.mybusz.frontline.Announcement': Announcement$json,
};

/// Descriptor for `FrontlineService`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List frontlineServiceDescriptor = $convert.base64Decode(
    'ChBGcm9udGxpbmVTZXJ2aWNlEmYKD0dldFN0b3BBcnJpdmFscxIoLm15YnVzei5mcm9udGxpbm'
    'UuR2V0U3RvcEFycml2YWxzUmVxdWVzdBopLm15YnVzei5mcm9udGxpbmUuR2V0U3RvcEFycml2'
    'YWxzUmVzcG9uc2USaQoSU3RyZWFtU3RvcEFycml2YWxzEisubXlidXN6LmZyb250bGluZS5TdH'
    'JlYW1TdG9wQXJyaXZhbHNSZXF1ZXN0GiQubXlidXN6LmZyb250bGluZS5TdG9wQXJyaXZhbHNV'
    'cGRhdGUwARJjCg5HZXRCdXNQb3NpdGlvbhInLm15YnVzei5mcm9udGxpbmUuR2V0QnVzUG9zaX'
    'Rpb25SZXF1ZXN0GigubXlidXN6LmZyb250bGluZS5HZXRCdXNQb3NpdGlvblJlc3BvbnNlEmkK'
    'ElN0cmVhbVNlcnZpY2VCdXNlcxIrLm15YnVzei5mcm9udGxpbmUuU3RyZWFtU2VydmljZUJ1c2'
    'VzUmVxdWVzdBokLm15YnVzei5mcm9udGxpbmUuU2VydmljZUJ1c2VzVXBkYXRlMAESbAoRR2V0'
    'U2VydmljZURldGFpbHMSKi5teWJ1c3ouZnJvbnRsaW5lLkdldFNlcnZpY2VEZXRhaWxzUmVxdW'
    'VzdBorLm15YnVzei5mcm9udGxpbmUuR2V0U2VydmljZURldGFpbHNSZXNwb25zZRJsChFHZXRT'
    'ZXJ2aWNlc0F0U3RvcBIqLm15YnVzei5mcm9udGxpbmUuR2V0U2VydmljZXNBdFN0b3BSZXF1ZX'
    'N0GisubXlidXN6LmZyb250bGluZS5HZXRTZXJ2aWNlc0F0U3RvcFJlc3BvbnNlEmMKDlNlYXJj'
    'aEJ1c1N0b3BzEicubXlidXN6LmZyb250bGluZS5TZWFyY2hCdXNTdG9wc1JlcXVlc3QaKC5teW'
    'J1c3ouZnJvbnRsaW5lLlNlYXJjaEJ1c1N0b3BzUmVzcG9uc2USZgoPRmluZE5lYXJieVN0b3Bz'
    'EigubXlidXN6LmZyb250bGluZS5GaW5kTmVhcmJ5U3RvcHNSZXF1ZXN0GikubXlidXN6LmZyb2'
    '50bGluZS5GaW5kTmVhcmJ5U3RvcHNSZXNwb25zZRJmCg9HZXRTdG9wTWVzc2FnZXMSKC5teWJ1'
    'c3ouZnJvbnRsaW5lLkdldFN0b3BNZXNzYWdlc1JlcXVlc3QaKS5teWJ1c3ouZnJvbnRsaW5lLk'
    'dldFN0b3BNZXNzYWdlc1Jlc3BvbnNlEk8KE1N0cmVhbUFubm91bmNlbWVudHMSFi5nb29nbGUu'
    'cHJvdG9idWYuRW1wdHkaHi5teWJ1c3ouZnJvbnRsaW5lLkFubm91bmNlbWVudDAB');

