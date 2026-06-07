import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';

class BookingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream pending bookings for drivers to see
  Stream<List<Booking>> streamPendingBookings() {
    return _db
        .collection('bookings')
        .where('status', isEqualTo: BookingStatus.pending.name)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Booking.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Accept a booking
  Future<bool> acceptBooking(String bookingId, String driverId, String driverName, String plateNumber) async {
    try {
      await _db.collection('bookings').doc(bookingId).update({
        'status': BookingStatus.accepted.name,
        'driverId': driverId,
        'driverName': driverName,
        'plateNumber': plateNumber,
      });
      return true;
    } catch (e) {
      print("Error accepting booking: $e");
      return false;
    }
  }

  // Update trip status (e.g., pickedUp, completed)
  Future<bool> updateTripStatus(String bookingId, BookingStatus status) async {
    try {
      await _db.collection('bookings').doc(bookingId).update({
        'status': status.name,
      });
      return true;
    } catch (e) {
      print("Error updating status: $e");
      return false;
    }
  }

  // Stream current active booking for the driver.
  // Uses a single where clause to avoid requiring a composite Firestore index.
  // Status filtering is done client-side.
  Stream<Booking?> streamActiveBooking(String driverId) {
    return _db
        .collection('bookings')
        .where('driverId', isEqualTo: driverId)
        .snapshots()
        .map((snapshot) {
      final activeStatuses = {
        BookingStatus.accepted.name,
        BookingStatus.pickedUp.name,
      };
      final activeDocs = snapshot.docs.where((doc) {
        return activeStatuses.contains(doc.data()['status']);
      }).toList();

      if (activeDocs.isNotEmpty) {
        return Booking.fromMap(activeDocs.first.data(), activeDocs.first.id);
      }
      return null;
    });
  }
}
