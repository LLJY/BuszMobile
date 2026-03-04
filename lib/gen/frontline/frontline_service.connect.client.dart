//
//  Generated code. Do not modify.
//  source: frontline/frontline_service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "frontline_service.pb.dart" as frontlinefrontline_service;
import "frontline_service.connect.spec.dart" as specs;
import "../google/protobuf/empty.pb.dart" as googleprotobufempty;

extension type FrontlineServiceClient (connect.Transport _transport) {
  /// Bus Stop Arrivals (Main PIDS Display API)
  Future<frontlinefrontline_service.GetStopArrivalsResponse> getStopArrivals(
    frontlinefrontline_service.GetStopArrivalsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FrontlineService.getStopArrivals,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Stream<frontlinefrontline_service.StopArrivalsUpdate> streamStopArrivals(
    frontlinefrontline_service.StreamStopArrivalsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.FrontlineService.streamStopArrivals,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Bus Tracking
  Future<frontlinefrontline_service.GetBusPositionResponse> getBusPosition(
    frontlinefrontline_service.GetBusPositionRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FrontlineService.getBusPosition,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Stream<frontlinefrontline_service.ServiceBusesUpdate> streamServiceBuses(
    frontlinefrontline_service.StreamServiceBusesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.FrontlineService.streamServiceBuses,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Service Information
  Future<frontlinefrontline_service.GetServiceDetailsResponse> getServiceDetails(
    frontlinefrontline_service.GetServiceDetailsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FrontlineService.getServiceDetails,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<frontlinefrontline_service.GetServicesAtStopResponse> getServicesAtStop(
    frontlinefrontline_service.GetServicesAtStopRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FrontlineService.getServicesAtStop,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Search
  Future<frontlinefrontline_service.SearchBusStopsResponse> searchBusStops(
    frontlinefrontline_service.SearchBusStopsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FrontlineService.searchBusStops,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Future<frontlinefrontline_service.FindNearbyStopsResponse> findNearbyStops(
    frontlinefrontline_service.FindNearbyStopsRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FrontlineService.findNearbyStops,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  /// Announcements
  Future<frontlinefrontline_service.GetStopMessagesResponse> getStopMessages(
    frontlinefrontline_service.GetStopMessagesRequest input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).unary(
      specs.FrontlineService.getStopMessages,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }

  Stream<frontlinefrontline_service.Announcement> streamAnnouncements(
    googleprotobufempty.Empty input, {
    connect.Headers? headers,
    connect.AbortSignal? signal,
    Function(connect.Headers)? onHeader,
    Function(connect.Headers)? onTrailer,
  }) {
    return connect.Client(_transport).server(
      specs.FrontlineService.streamAnnouncements,
      input,
      signal: signal,
      headers: headers,
      onHeader: onHeader,
      onTrailer: onTrailer,
    );
  }
}
