/// Tests for the [applyArrivalsDelta] function.
///
/// Verifies delta merge logic for the StreamStopArrivals streaming RPC:
/// - Updated arrivals replace matching services
/// - Removed services are dropped from the list
/// - New bus locations replace the location list
/// - Unmentioned services are preserved
/// - updatedAt is taken from the delta
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:busz_mobile/data/models/models.dart';
import 'package:busz_mobile/data/services/frontline_service.dart';

// =============================================================================
// Test Data
// =============================================================================

final _baseTime = DateTime(2026, 3, 4, 10, 0, 0);

const _bus100 = BusArrivalInfo(
  serviceNo: '100',
  direction: 1,
  color: '#FF0000',
  isFree: false,
  destination: 'Terminal A',
  plateNo: 'ABC1234',
  laterPlateNo: '',
  isDeparting: false,
  etaSource: 'ETA_SOURCE_REALTIME',
  delayStatus: 'DELAY_STATUS_ON_TIME',
  delayMinutes: 0,
);

const _bus200 = BusArrivalInfo(
  serviceNo: '200',
  direction: 1,
  color: '#00FF00',
  isFree: true,
  destination: 'Terminal B',
  plateNo: 'DEF5678',
  laterPlateNo: '',
  isDeparting: false,
  etaSource: 'ETA_SOURCE_SCHEDULE',
  delayStatus: 'DELAY_STATUS_LATE',
  delayMinutes: 3,
);

const _bus300 = BusArrivalInfo(
  serviceNo: '300',
  direction: 2,
  color: '#0000FF',
  isFree: false,
  destination: 'Depot',
  plateNo: 'GHI9012',
  laterPlateNo: '',
  isDeparting: true,
  etaSource: 'ETA_SOURCE_REALTIME',
  delayStatus: 'DELAY_STATUS_ON_TIME',
  delayMinutes: 0,
);

const _location1 = BusLocationInfo(
  plateNo: 'ABC1234',
  serviceNo: '100',
  direction: 1,
  latitude: 1.4927,
  longitude: 103.7414,
  speedKmh: 30.0,
  heading: 90.0,
  nextStopCode: '12346',
  nextStopName: 'Next Stop',
  etaToNextStopMinutes: 5,
);

const _location2 = BusLocationInfo(
  plateNo: 'DEF5678',
  serviceNo: '200',
  direction: 1,
  latitude: 1.5000,
  longitude: 103.7500,
  speedKmh: 40.0,
  heading: 180.0,
  nextStopCode: '12347',
  nextStopName: 'Another Stop',
  etaToNextStopMinutes: 3,
);

StopArrivalsData _makeBaseData() => StopArrivalsData(
  busStopCode: '12345',
  busStopName: 'Test Stop',
  buses: [_bus100, _bus200, _bus300],
  busLocations: [_location1, _location2],
  updatedAt: _baseTime,
);

// =============================================================================
// Tests
// =============================================================================

void main() {
  group('applyArrivalsDelta', () {
    test('replaces matching services with updated arrivals', () {
      final base = _makeBaseData();

      // Updated bus 100 with new destination and delay info
      const updatedBus100 = BusArrivalInfo(
        serviceNo: '100',
        direction: 1,
        color: '#FF0000',
        isFree: false,
        destination: 'Terminal X',
        plateNo: 'ABC1234',
        laterPlateNo: 'ZZZ9999',
        isDeparting: true,
        etaSource: 'ETA_SOURCE_REALTIME',
        delayStatus: 'DELAY_STATUS_EARLY',
        delayMinutes: -2,
      );

      final result = applyArrivalsDelta(
        current: base,
        updatedArrivals: [updatedBus100],
        removedServiceNos: [],
      );

      // Bus 100 should be replaced with updated values
      final bus100 = result.buses.firstWhere((b) => b.serviceNo == '100');
      expect(bus100.destination, 'Terminal X');
      expect(bus100.isDeparting, isTrue);
      expect(bus100.laterPlateNo, 'ZZZ9999');
      expect(bus100.delayMinutes, -2);

      // Total count unchanged (replacement, not addition)
      expect(result.buses, hasLength(3));
    });

    test('removes services listed in removedServiceNos', () {
      final base = _makeBaseData();

      final result = applyArrivalsDelta(
        current: base,
        updatedArrivals: [],
        removedServiceNos: ['200'],
      );

      expect(result.buses, hasLength(2));
      expect(result.buses.any((b) => b.serviceNo == '200'), isFalse);
      // 100 and 300 still present
      expect(result.buses.any((b) => b.serviceNo == '100'), isTrue);
      expect(result.buses.any((b) => b.serviceNo == '300'), isTrue);
    });

    test('replaces bus locations when non-empty list provided', () {
      final base = _makeBaseData();

      const newLocation = BusLocationInfo(
        plateNo: 'NEW1111',
        serviceNo: '100',
        direction: 1,
        latitude: 1.3000,
        longitude: 103.8000,
        speedKmh: 50.0,
        heading: 45.0,
        nextStopCode: '99999',
        nextStopName: 'New Stop',
        etaToNextStopMinutes: 2,
      );

      final result = applyArrivalsDelta(
        current: base,
        updatedArrivals: [],
        removedServiceNos: [],
        busLocations: [newLocation],
      );

      expect(result.busLocations, hasLength(1));
      expect(result.busLocations.first.plateNo, 'NEW1111');
    });

    test('preserves previous bus locations when null provided', () {
      final base = _makeBaseData();

      final result = applyArrivalsDelta(
        current: base,
        updatedArrivals: [],
        removedServiceNos: [],
        busLocations: null,
      );

      expect(result.busLocations, hasLength(2));
      expect(result.busLocations.first.plateNo, 'ABC1234');
    });

    test('preserves previous bus locations when empty list provided', () {
      final base = _makeBaseData();

      final result = applyArrivalsDelta(
        current: base,
        updatedArrivals: [],
        removedServiceNos: [],
        busLocations: [],
      );

      expect(result.busLocations, hasLength(2));
    });

    test('preserves services not mentioned in the update', () {
      final base = _makeBaseData();

      // Only update bus 100, don't mention 200 or 300
      const updatedBus100 = BusArrivalInfo(
        serviceNo: '100',
        direction: 1,
        color: '#FF0000',
        isFree: false,
        destination: 'Updated',
        plateNo: 'ABC1234',
        laterPlateNo: '',
        isDeparting: false,
        etaSource: 'ETA_SOURCE_REALTIME',
        delayStatus: 'DELAY_STATUS_ON_TIME',
        delayMinutes: 0,
      );

      final result = applyArrivalsDelta(
        current: base,
        updatedArrivals: [updatedBus100],
        removedServiceNos: [],
      );

      expect(result.buses, hasLength(3));
      // 200 and 300 should be unchanged
      final bus200 = result.buses.firstWhere((b) => b.serviceNo == '200');
      expect(bus200.destination, 'Terminal B');
      final bus300 = result.buses.firstWhere((b) => b.serviceNo == '300');
      expect(bus300.destination, 'Depot');
    });

    test('takes updatedAt from the delta', () {
      final base = _makeBaseData();
      final deltaTime = DateTime(2026, 3, 4, 10, 5, 0);

      final result = applyArrivalsDelta(
        current: base,
        updatedArrivals: [],
        removedServiceNos: [],
        updatedAt: deltaTime,
      );

      expect(result.updatedAt, deltaTime);
    });

    test('keeps previous updatedAt when delta provides null', () {
      final base = _makeBaseData();

      final result = applyArrivalsDelta(
        current: base,
        updatedArrivals: [],
        removedServiceNos: [],
        updatedAt: null,
      );

      expect(result.updatedAt, _baseTime);
    });

    test('adds new services that do not exist yet', () {
      final base = _makeBaseData();

      const newBus = BusArrivalInfo(
        serviceNo: '400',
        direction: 1,
        color: '#FFFF00',
        isFree: false,
        destination: 'New Route',
        plateNo: 'NEW4444',
        laterPlateNo: '',
        isDeparting: false,
        etaSource: 'ETA_SOURCE_SCHEDULE',
        delayStatus: 'DELAY_STATUS_ON_TIME',
        delayMinutes: 0,
      );

      final result = applyArrivalsDelta(
        current: base,
        updatedArrivals: [newBus],
        removedServiceNos: [],
      );

      expect(result.buses, hasLength(4));
      final bus400 = result.buses.firstWhere((b) => b.serviceNo == '400');
      expect(bus400.destination, 'New Route');
    });

    test('handles simultaneous add, remove, and update', () {
      final base = _makeBaseData();

      const updatedBus300 = BusArrivalInfo(
        serviceNo: '300',
        direction: 2,
        color: '#0000FF',
        isFree: false,
        destination: 'Updated Depot',
        plateNo: 'GHI9012',
        laterPlateNo: '',
        isDeparting: true,
        etaSource: 'ETA_SOURCE_REALTIME',
        delayStatus: 'DELAY_STATUS_ON_TIME',
        delayMinutes: 0,
      );

      const newBus500 = BusArrivalInfo(
        serviceNo: '500',
        direction: 1,
        color: '#FF00FF',
        isFree: true,
        destination: 'Express',
        plateNo: 'EXP5555',
        laterPlateNo: '',
        isDeparting: false,
        etaSource: 'ETA_SOURCE_REALTIME',
        delayStatus: 'DELAY_STATUS_ON_TIME',
        delayMinutes: 0,
      );

      final result = applyArrivalsDelta(
        current: base,
        updatedArrivals: [updatedBus300, newBus500],
        removedServiceNos: ['200'],
        updatedAt: DateTime(2026, 3, 4, 10, 10, 0),
      );

      // 100 preserved, 200 removed, 300 updated, 500 added = 3 services
      expect(result.buses, hasLength(3));
      expect(result.buses.any((b) => b.serviceNo == '100'), isTrue);
      expect(result.buses.any((b) => b.serviceNo == '200'), isFalse);
      expect(
        result.buses.firstWhere((b) => b.serviceNo == '300').destination,
        'Updated Depot',
      );
      expect(
        result.buses.firstWhere((b) => b.serviceNo == '500').destination,
        'Express',
      );
      expect(result.updatedAt, DateTime(2026, 3, 4, 10, 10, 0));
    });

    test('preserves busStopCode and busStopName from current', () {
      final base = _makeBaseData();

      final result = applyArrivalsDelta(
        current: base,
        updatedArrivals: [],
        removedServiceNos: [],
      );

      expect(result.busStopCode, '12345');
      expect(result.busStopName, 'Test Stop');
    });
  });
}
