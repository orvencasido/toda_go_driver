import 'package:cloud_firestore/cloud_firestore.dart';

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
      'createdAt': Timestamp.fromDate(createdAt),
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
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      driverName: map['driverName'],
      driverPhone: map['driverPhone'],
      plateNumber: map['plateNumber'],
    );
  }
}
