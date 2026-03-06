//
//  Generated code. Do not modify.
//  source: common/types.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use etaSourceDescriptor instead')
const EtaSource$json = {
  '1': 'EtaSource',
  '2': [
    {'1': 'ETA_SOURCE_UNSPECIFIED', '2': 0},
    {'1': 'ETA_SOURCE_REALTIME', '2': 1},
    {'1': 'ETA_SOURCE_ML', '2': 2},
    {'1': 'ETA_SOURCE_SCHEDULED', '2': 3},
  ],
};

/// Descriptor for `EtaSource`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List etaSourceDescriptor = $convert.base64Decode(
    'CglFdGFTb3VyY2USGgoWRVRBX1NPVVJDRV9VTlNQRUNJRklFRBAAEhcKE0VUQV9TT1VSQ0VfUk'
    'VBTFRJTUUQARIRCg1FVEFfU09VUkNFX01MEAISGAoURVRBX1NPVVJDRV9TQ0hFRFVMRUQQAw==');

@$core.Deprecated('Use delayStatusDescriptor instead')
const DelayStatus$json = {
  '1': 'DelayStatus',
  '2': [
    {'1': 'DELAY_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'DELAY_STATUS_ON_TIME', '2': 1},
    {'1': 'DELAY_STATUS_SLIGHT_DELAY', '2': 2},
    {'1': 'DELAY_STATUS_HEAVY_DELAY', '2': 3},
  ],
};

/// Descriptor for `DelayStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List delayStatusDescriptor = $convert.base64Decode(
    'CgtEZWxheVN0YXR1cxIcChhERUxBWV9TVEFUVVNfVU5TUEVDSUZJRUQQABIYChRERUxBWV9TVE'
    'FUVVNfT05fVElNRRABEh0KGURFTEFZX1NUQVRVU19TTElHSFRfREVMQVkQAhIcChhERUxBWV9T'
    'VEFUVVNfSEVBVllfREVMQVkQAw==');

@$core.Deprecated('Use punctualityStatusDescriptor instead')
const PunctualityStatus$json = {
  '1': 'PunctualityStatus',
  '2': [
    {'1': 'PUNCTUALITY_STATUS_UNSPECIFIED', '2': 0},
    {'1': 'PUNCTUALITY_STATUS_EARLY', '2': 1},
    {'1': 'PUNCTUALITY_STATUS_ON_TIME', '2': 2},
    {'1': 'PUNCTUALITY_STATUS_LATE', '2': 3},
  ],
};

/// Descriptor for `PunctualityStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List punctualityStatusDescriptor = $convert.base64Decode(
    'ChFQdW5jdHVhbGl0eVN0YXR1cxIiCh5QVU5DVFVBTElUWV9TVEFUVVNfVU5TUEVDSUZJRUQQAB'
    'IcChhQVU5DVFVBTElUWV9TVEFUVVNfRUFSTFkQARIeChpQVU5DVFVBTElUWV9TVEFUVVNfT05f'
    'VElNRRACEhsKF1BVTkNUVUFMSVRZX1NUQVRVU19MQVRFEAM=');

@$core.Deprecated('Use stalenessCategoryDescriptor instead')
const StalenessCategory$json = {
  '1': 'StalenessCategory',
  '2': [
    {'1': 'STALENESS_UNSPECIFIED', '2': 0},
    {'1': 'STALENESS_LIVE', '2': 1},
    {'1': 'STALENESS_RECENT', '2': 2},
    {'1': 'STALENESS_STALE', '2': 3},
    {'1': 'STALENESS_OLD', '2': 4},
  ],
};

/// Descriptor for `StalenessCategory`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List stalenessCategoryDescriptor = $convert.base64Decode(
    'ChFTdGFsZW5lc3NDYXRlZ29yeRIZChVTVEFMRU5FU1NfVU5TUEVDSUZJRUQQABISCg5TVEFMRU'
    '5FU1NfTElWRRABEhQKEFNUQUxFTkVTU19SRUNFTlQQAhITCg9TVEFMRU5FU1NfU1RBTEUQAxIR'
    'Cg1TVEFMRU5FU1NfT0xEEAQ=');

@$core.Deprecated('Use geoPointDescriptor instead')
const GeoPoint$json = {
  '1': 'GeoPoint',
  '2': [
    {'1': 'latitude', '3': 1, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 2, '4': 1, '5': 1, '10': 'longitude'},
  ],
};

/// Descriptor for `GeoPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List geoPointDescriptor = $convert.base64Decode(
    'CghHZW9Qb2ludBIaCghsYXRpdHVkZRgBIAEoAVIIbGF0aXR1ZGUSHAoJbG9uZ2l0dWRlGAIgAS'
    'gBUglsb25naXR1ZGU=');

@$core.Deprecated('Use paginationRequestDescriptor instead')
const PaginationRequest$json = {
  '1': 'PaginationRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `PaginationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paginationRequestDescriptor = $convert.base64Decode(
    'ChFQYWdpbmF0aW9uUmVxdWVzdBISCgRwYWdlGAEgASgFUgRwYWdlEhsKCXBhZ2Vfc2l6ZRgCIA'
    'EoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use paginationResponseDescriptor instead')
const PaginationResponse$json = {
  '1': 'PaginationResponse',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
    {'1': 'total_items', '3': 3, '4': 1, '5': 5, '10': 'totalItems'},
    {'1': 'total_pages', '3': 4, '4': 1, '5': 5, '10': 'totalPages'},
  ],
};

/// Descriptor for `PaginationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paginationResponseDescriptor = $convert.base64Decode(
    'ChJQYWdpbmF0aW9uUmVzcG9uc2USEgoEcGFnZRgBIAEoBVIEcGFnZRIbCglwYWdlX3NpemUYAi'
    'ABKAVSCHBhZ2VTaXplEh8KC3RvdGFsX2l0ZW1zGAMgASgFUgp0b3RhbEl0ZW1zEh8KC3RvdGFs'
    'X3BhZ2VzGAQgASgFUgp0b3RhbFBhZ2Vz');

@$core.Deprecated('Use arrivalTimeDescriptor instead')
const ArrivalTime$json = {
  '1': 'ArrivalTime',
  '2': [
    {'1': 'time', '3': 1, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'time'},
    {'1': 'is_live', '3': 2, '4': 1, '5': 8, '10': 'isLive'},
  ],
};

/// Descriptor for `ArrivalTime`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List arrivalTimeDescriptor = $convert.base64Decode(
    'CgtBcnJpdmFsVGltZRIuCgR0aW1lGAEgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcF'
    'IEdGltZRIXCgdpc19saXZlGAIgASgIUgZpc0xpdmU=');

@$core.Deprecated('Use serviceInfoDescriptor instead')
const ServiceInfo$json = {
  '1': 'ServiceInfo',
  '2': [
    {'1': 'service_no', '3': 1, '4': 1, '5': 9, '10': 'serviceNo'},
    {'1': 'direction', '3': 6, '4': 1, '5': 5, '10': 'direction'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'color', '3': 3, '4': 1, '5': 9, '10': 'color'},
    {'1': 'is_free', '3': 4, '4': 1, '5': 8, '10': 'isFree'},
    {'1': 'is_active', '3': 5, '4': 1, '5': 8, '10': 'isActive'},
    {'1': 'first_stop_code', '3': 7, '4': 1, '5': 9, '10': 'firstStopCode'},
    {'1': 'last_stop_code', '3': 8, '4': 1, '5': 9, '10': 'lastStopCode'},
    {'1': 'last_stop_name', '3': 9, '4': 1, '5': 9, '10': 'lastStopName'},
  ],
};

/// Descriptor for `ServiceInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serviceInfoDescriptor = $convert.base64Decode(
    'CgtTZXJ2aWNlSW5mbxIdCgpzZXJ2aWNlX25vGAEgASgJUglzZXJ2aWNlTm8SHAoJZGlyZWN0aW'
    '9uGAYgASgFUglkaXJlY3Rpb24SEgoEbmFtZRgCIAEoCVIEbmFtZRIUCgVjb2xvchgDIAEoCVIF'
    'Y29sb3ISFwoHaXNfZnJlZRgEIAEoCFIGaXNGcmVlEhsKCWlzX2FjdGl2ZRgFIAEoCFIIaXNBY3'
    'RpdmUSJgoPZmlyc3Rfc3RvcF9jb2RlGAcgASgJUg1maXJzdFN0b3BDb2RlEiQKDmxhc3Rfc3Rv'
    'cF9jb2RlGAggASgJUgxsYXN0U3RvcENvZGUSJAoObGFzdF9zdG9wX25hbWUYCSABKAlSDGxhc3'
    'RTdG9wTmFtZQ==');

@$core.Deprecated('Use busStopInfoDescriptor instead')
const BusStopInfo$json = {
  '1': 'BusStopInfo',
  '2': [
    {'1': 'code', '3': 1, '4': 1, '5': 9, '10': 'code'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'location', '3': 3, '4': 1, '5': 11, '6': '.mybusz.common.GeoPoint', '10': 'location'},
    {'1': 'bus_stop_id', '3': 4, '4': 1, '5': 5, '10': 'busStopId'},
  ],
};

/// Descriptor for `BusStopInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List busStopInfoDescriptor = $convert.base64Decode(
    'CgtCdXNTdG9wSW5mbxISCgRjb2RlGAEgASgJUgRjb2RlEhIKBG5hbWUYAiABKAlSBG5hbWUSMw'
    'oIbG9jYXRpb24YAyABKAsyFy5teWJ1c3ouY29tbW9uLkdlb1BvaW50Ughsb2NhdGlvbhIeCgti'
    'dXNfc3RvcF9pZBgEIAEoBVIJYnVzU3RvcElk');

@$core.Deprecated('Use busInfoDescriptor instead')
const BusInfo$json = {
  '1': 'BusInfo',
  '2': [
    {'1': 'plate_no', '3': 1, '4': 1, '5': 9, '10': 'plateNo'},
    {'1': 'current_service_no', '3': 2, '4': 1, '5': 9, '10': 'currentServiceNo'},
  ],
};

/// Descriptor for `BusInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List busInfoDescriptor = $convert.base64Decode(
    'CgdCdXNJbmZvEhkKCHBsYXRlX25vGAEgASgJUgdwbGF0ZU5vEiwKEmN1cnJlbnRfc2VydmljZV'
    '9ubxgCIAEoCVIQY3VycmVudFNlcnZpY2VObw==');

