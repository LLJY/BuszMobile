//
//  Generated code. Do not modify.
//  source: frontline/frontline_service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../google/protobuf/empty.pb.dart' as $2;
import 'frontline_service.pb.dart' as $3;
import 'frontline_service.pbjson.dart';

export 'frontline_service.pb.dart';

abstract class FrontlineServiceBase extends $pb.GeneratedService {
  $async.Future<$3.GetStopArrivalsResponse> getStopArrivals($pb.ServerContext ctx, $3.GetStopArrivalsRequest request);
  $async.Future<$3.StopArrivalsUpdate> streamStopArrivals($pb.ServerContext ctx, $3.StreamStopArrivalsRequest request);
  $async.Future<$3.GetBusPositionResponse> getBusPosition($pb.ServerContext ctx, $3.GetBusPositionRequest request);
  $async.Future<$3.ServiceBusesUpdate> streamServiceBuses($pb.ServerContext ctx, $3.StreamServiceBusesRequest request);
  $async.Future<$3.GetServiceDetailsResponse> getServiceDetails($pb.ServerContext ctx, $3.GetServiceDetailsRequest request);
  $async.Future<$3.GetServicesAtStopResponse> getServicesAtStop($pb.ServerContext ctx, $3.GetServicesAtStopRequest request);
  $async.Future<$3.SearchBusStopsResponse> searchBusStops($pb.ServerContext ctx, $3.SearchBusStopsRequest request);
  $async.Future<$3.FindNearbyStopsResponse> findNearbyStops($pb.ServerContext ctx, $3.FindNearbyStopsRequest request);
  $async.Future<$3.GetStopMessagesResponse> getStopMessages($pb.ServerContext ctx, $3.GetStopMessagesRequest request);
  $async.Future<$3.Announcement> streamAnnouncements($pb.ServerContext ctx, $2.Empty request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'GetStopArrivals': return $3.GetStopArrivalsRequest();
      case 'StreamStopArrivals': return $3.StreamStopArrivalsRequest();
      case 'GetBusPosition': return $3.GetBusPositionRequest();
      case 'StreamServiceBuses': return $3.StreamServiceBusesRequest();
      case 'GetServiceDetails': return $3.GetServiceDetailsRequest();
      case 'GetServicesAtStop': return $3.GetServicesAtStopRequest();
      case 'SearchBusStops': return $3.SearchBusStopsRequest();
      case 'FindNearbyStops': return $3.FindNearbyStopsRequest();
      case 'GetStopMessages': return $3.GetStopMessagesRequest();
      case 'StreamAnnouncements': return $2.Empty();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'GetStopArrivals': return this.getStopArrivals(ctx, request as $3.GetStopArrivalsRequest);
      case 'StreamStopArrivals': return this.streamStopArrivals(ctx, request as $3.StreamStopArrivalsRequest);
      case 'GetBusPosition': return this.getBusPosition(ctx, request as $3.GetBusPositionRequest);
      case 'StreamServiceBuses': return this.streamServiceBuses(ctx, request as $3.StreamServiceBusesRequest);
      case 'GetServiceDetails': return this.getServiceDetails(ctx, request as $3.GetServiceDetailsRequest);
      case 'GetServicesAtStop': return this.getServicesAtStop(ctx, request as $3.GetServicesAtStopRequest);
      case 'SearchBusStops': return this.searchBusStops(ctx, request as $3.SearchBusStopsRequest);
      case 'FindNearbyStops': return this.findNearbyStops(ctx, request as $3.FindNearbyStopsRequest);
      case 'GetStopMessages': return this.getStopMessages(ctx, request as $3.GetStopMessagesRequest);
      case 'StreamAnnouncements': return this.streamAnnouncements(ctx, request as $2.Empty);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => FrontlineServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => FrontlineServiceBase$messageJson;
}

