enum BookingStatus {
  pending,    // Waiting for a driver
  accepted,   // Driver accepted, heading to pickup
  pickedUp,   // Passenger in tricycle
  droppedOff, // Passenger reached destination
  paymentSent,// Cash payment acknowledged
  completed,  // Arrived at destination
  cancelled   // Cancelled by passenger or driver
}

class Booking {
  final String id;
  final String passengerId;
  final String? driverId;
  final String pickupAddress;
  final String dropoffAddress;
  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;
  final double distanceKm;
  final double fare;
  final BookingStatus status;
  final DateTime createdAt;
  final String? driverName;
  final String? driverPhone;
  final String? plateNumber;

  Booking({
    required this.id,
    required this.passengerId,
    this.driverId,
    required this.pickupAddress,
    required this.dropoffAddress,
    this.pickupLat = 0,
    this.pickupLng = 0,
    this.dropoffLat = 0,
    this.dropoffLng = 0,
    this.distanceKm = 0,
    required this.fare,
    required this.status,
    required this.createdAt,
    this.driverName,
    this.driverPhone,
    this.plateNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'passenger_id': passengerId,
      'driver_id': driverId,
      'pickup_address': pickupAddress,
      'dropoff_address': dropoffAddress,
      'pickup_lat': pickupLat,
      'pickup_lng': pickupLng,
      'dropoff_lat': dropoffLat,
      'dropoff_lng': dropoffLng,
      'distance_km': distanceKm,
      'fare': fare,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'driver_name': driverName,
      'driver_phone': driverPhone,
      'plate_number': plateNumber,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map, String documentId) {
    final statusValue = (map['status'] ?? 'pending').toString();
    return Booking(
      id: documentId.isNotEmpty ? documentId : map['id'] ?? '',
      passengerId: map['passenger_id'] ?? map['passengerId'] ?? '',
      driverId: map['driver_id'] ?? map['driverId'],
      pickupAddress: map['pickup_address'] ?? map['pickupAddress'] ?? '',
      dropoffAddress: map['dropoff_address'] ?? map['dropoffAddress'] ?? '',
      pickupLat: (map['pickup_lat'] ?? 0).toDouble(),
      pickupLng: (map['pickup_lng'] ?? 0).toDouble(),
      dropoffLat: (map['dropoff_lat'] ?? 0).toDouble(),
      dropoffLng: (map['dropoff_lng'] ?? 0).toDouble(),
      distanceKm: (map['distance_km'] ?? 0).toDouble(),
      fare: (map['fare'] ?? 0.0).toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == statusValue,
        orElse: () => BookingStatus.pending,
      ),
      createdAt: DateTime.parse(map['created_at'] ?? map['createdAt'] ?? DateTime.now().toIso8601String()),
      driverName: map['driver_name'] ?? map['driverName'],
      driverPhone: map['driver_phone'] ?? map['driverPhone'],
      plateNumber: map['plate_number'] ?? map['plateNumber'],
    );
  }

  /// Returns a copy of this booking with the given fields replaced.
  Booking copyWith({
    String? driverId,
    String? driverName,
    String? driverPhone,
    String? plateNumber,
    BookingStatus? status,
  }) {
    return Booking(
      id: id,
      passengerId: passengerId,
      driverId: driverId ?? this.driverId,
      pickupAddress: pickupAddress,
      dropoffAddress: dropoffAddress,
      pickupLat: pickupLat,
      pickupLng: pickupLng,
      dropoffLat: dropoffLat,
      dropoffLng: dropoffLng,
      distanceKm: distanceKm,
      fare: fare,
      status: status ?? this.status,
      createdAt: createdAt,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      plateNumber: plateNumber ?? this.plateNumber,
    );
  }
}
