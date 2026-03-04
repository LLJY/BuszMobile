//
//  Generated code. Do not modify.
//  source: frontline/frontline_service.proto
//

import "package:connectrpc/connect.dart" as connect;
import "frontline_service.pb.dart" as frontlinefrontline_service;
import "../google/protobuf/empty.pb.dart" as googleprotobufempty;

abstract final class FrontlineService {
  /// Fully-qualified name of the FrontlineService service.
  static const name = 'mybusz.frontline.FrontlineService';

  /// Bus Stop Arrivals (Main PIDS Display API)
  static const getStopArrivals = connect.Spec(
    '/$name/GetStopArrivals',
    connect.StreamType.unary,
    frontlinefrontline_service.GetStopArrivalsRequest.new,
    frontlinefrontline_service.GetStopArrivalsResponse.new,
  );

  static const streamStopArrivals = connect.Spec(
    '/$name/StreamStopArrivals',
    connect.StreamType.server,
    frontlinefrontline_service.StreamStopArrivalsRequest.new,
    frontlinefrontline_service.StopArrivalsUpdate.new,
  );

  /// Bus Tracking
  static const getBusPosition = connect.Spec(
    '/$name/GetBusPosition',
    connect.StreamType.unary,
    frontlinefrontline_service.GetBusPositionRequest.new,
    frontlinefrontline_service.GetBusPositionResponse.new,
  );

  static const streamServiceBuses = connect.Spec(
    '/$name/StreamServiceBuses',
    connect.StreamType.server,
    frontlinefrontline_service.StreamServiceBusesRequest.new,
    frontlinefrontline_service.ServiceBusesUpdate.new,
  );

  /// Service Information
  static const getServiceDetails = connect.Spec(
    '/$name/GetServiceDetails',
    connect.StreamType.unary,
    frontlinefrontline_service.GetServiceDetailsRequest.new,
    frontlinefrontline_service.GetServiceDetailsResponse.new,
  );

  static const getServicesAtStop = connect.Spec(
    '/$name/GetServicesAtStop',
    connect.StreamType.unary,
    frontlinefrontline_service.GetServicesAtStopRequest.new,
    frontlinefrontline_service.GetServicesAtStopResponse.new,
  );

  /// Search
  static const searchBusStops = connect.Spec(
    '/$name/SearchBusStops',
    connect.StreamType.unary,
    frontlinefrontline_service.SearchBusStopsRequest.new,
    frontlinefrontline_service.SearchBusStopsResponse.new,
  );

  static const findNearbyStops = connect.Spec(
    '/$name/FindNearbyStops',
    connect.StreamType.unary,
    frontlinefrontline_service.FindNearbyStopsRequest.new,
    frontlinefrontline_service.FindNearbyStopsResponse.new,
  );

  /// Announcements
  static const getStopMessages = connect.Spec(
    '/$name/GetStopMessages',
    connect.StreamType.unary,
    frontlinefrontline_service.GetStopMessagesRequest.new,
    frontlinefrontline_service.GetStopMessagesResponse.new,
  );

  static const streamAnnouncements = connect.Spec(
    '/$name/StreamAnnouncements',
    connect.StreamType.server,
    googleprotobufempty.Empty.new,
    frontlinefrontline_service.Announcement.new,
  );
}
