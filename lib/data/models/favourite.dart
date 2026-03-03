/// Model for a user's favourite bus stop.
library;

/// A bus stop saved as a favourite by the user.
///
/// Persisted locally via [SharedPreferences] as JSON.
class FavouriteStop {
  /// The unique bus stop code identifier.
  final String busStopCode;

  /// The display name of the bus stop.
  final String busStopName;

  /// Optional user-defined nickname for the stop.
  final String? customAlias;

  /// Latitude of the bus stop, if available.
  final double? latitude;

  /// Longitude of the bus stop, if available.
  final double? longitude;

  /// Bus service numbers that serve this stop (for display).
  final List<String> serviceNos;

  /// Position in the user's favourites list (for manual reordering).
  final int sortOrder;

  /// When this stop was added to favourites.
  final DateTime addedAt;

  const FavouriteStop({
    required this.busStopCode,
    required this.busStopName,
    this.customAlias,
    this.latitude,
    this.longitude,
    required this.serviceNos,
    required this.sortOrder,
    required this.addedAt,
  });

  /// Creates a [FavouriteStop] from a JSON map.
  factory FavouriteStop.fromJson(Map<String, dynamic> json) {
    return FavouriteStop(
      busStopCode: json['busStopCode'] as String,
      busStopName: json['busStopName'] as String,
      customAlias: json['customAlias'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      serviceNos: (json['serviceNos'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      sortOrder: json['sortOrder'] as int,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  /// Serializes this [FavouriteStop] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'busStopCode': busStopCode,
      'busStopName': busStopName,
      'customAlias': customAlias,
      'latitude': latitude,
      'longitude': longitude,
      'serviceNos': serviceNos,
      'sortOrder': sortOrder,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  /// Creates a copy with the given fields replaced.
  FavouriteStop copyWith({
    String? busStopCode,
    String? busStopName,
    String? Function()? customAlias,
    double? Function()? latitude,
    double? Function()? longitude,
    List<String>? serviceNos,
    int? sortOrder,
    DateTime? addedAt,
  }) {
    return FavouriteStop(
      busStopCode: busStopCode ?? this.busStopCode,
      busStopName: busStopName ?? this.busStopName,
      customAlias: customAlias != null ? customAlias() : this.customAlias,
      latitude: latitude != null ? latitude() : this.latitude,
      longitude: longitude != null ? longitude() : this.longitude,
      serviceNos: serviceNos ?? this.serviceNos,
      sortOrder: sortOrder ?? this.sortOrder,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavouriteStop && other.busStopCode == busStopCode;
  }

  @override
  int get hashCode => busStopCode.hashCode;

  @override
  String toString() =>
      'FavouriteStop($busStopCode: ${customAlias ?? busStopName})';
}
