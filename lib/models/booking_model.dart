enum BookingStatus {
  pending,    // Waiting for a driver
  accepted,   // Driver accepted, heading to pickup
  pickedUp,   // Passenger in tricycle
  completed,  // Arrived at destination
  cancelled   // Cancelled by passenger or driver
}

class Booking {
  final String id;
  final String passengerId;
  final String? driverId;
  final String pickupAddress;
  final String dropoffAddress;
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
      'passengerId': passengerId,
      'driverId': driverId,
      'pickupAddress': pickupAddress,
      'dropoffAddress': dropoffAddress,
      'fare': fare,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'driverName': driverName,
      'driverPhone': driverPhone,
      'plateNumber': plateNumber,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map, String documentId) {
    return Booking(
      id: documentId,
      passengerId: map['passengerId'] ?? '',
      driverId: map['driverId'],
      pickupAddress: map['pickupAddress'] ?? '',
      dropoffAddress: map['dropoffAddress'] ?? '',
      fare: (map['fare'] ?? 0.0).toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => BookingStatus.pending,
      ),
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      driverName: map['driverName'],
      driverPhone: map['driverPhone'],
      plateNumber: map['plateNumber'],
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
      fare: fare,
      status: status ?? this.status,
      createdAt: createdAt,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      plateNumber: plateNumber ?? this.plateNumber,
    );
  }
}
