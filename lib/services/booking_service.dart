import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking_model.dart';

class BookingService {
  final SupabaseClient _client = Supabase.instance.client;

  Stream<List<Booking>> streamPendingBookings() {
    return _client
        .from('bookings')
        .stream(primaryKey: ['id'])
        .eq('status', BookingStatus.pending.name)
        .order('created_at')
        .map((rows) => rows.map((row) => Booking.fromMap(row, row['id'])).toList());
  }

  Future<bool> acceptBooking(
    String bookingId,
    String driverId,
    String driverName,
    String plateNumber,
  ) async {
    try {
      await _client
          .from('bookings')
          .update({
            'status': BookingStatus.accepted.name,
            'driver_id': driverId,
            'driver_name': driverName,
            'plate_number': plateNumber,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', bookingId)
          .eq('status', BookingStatus.pending.name);
      return true;
    } catch (e) {
      print('Error accepting booking: $e');
      return false;
    }
  }

  Future<bool> updateTripStatus(String bookingId, BookingStatus status) async {
    try {
      await _client
          .from('bookings')
          .update({
            'status': status.name,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', bookingId);
      return true;
    } catch (e) {
      print('Error updating status: $e');
      return false;
    }
  }

  Stream<Booking?> streamBooking(String bookingId) {
    return _client
        .from('bookings')
        .stream(primaryKey: ['id'])
        .eq('id', bookingId)
        .map((rows) => rows.isEmpty ? null : Booking.fromMap(rows.first, rows.first['id']));
  }

  Stream<Booking?> streamActiveBooking(String driverId) {
    const activeStatuses = ['accepted', 'pickedUp', 'droppedOff', 'paymentSent'];
    return _client
        .from('bookings')
        .stream(primaryKey: ['id'])
        .eq('driver_id', driverId)
        .map((rows) {
          final activeRows = rows.where((row) => activeStatuses.contains(row['status'])).toList()
            ..sort((a, b) => (b['created_at'] ?? '').compareTo(a['created_at'] ?? ''));
          return activeRows.isEmpty ? null : Booking.fromMap(activeRows.first, activeRows.first['id']);
        });
  }

  Future<bool> cancelBooking(String bookingId) async {
    return updateTripStatus(bookingId, BookingStatus.cancelled);
  }

  Future<List<Booking>> getDriverHistory(String driverId) async {
    final rows = await _client
        .from('bookings')
        .select()
        .eq('driver_id', driverId)
        .inFilter('status', ['completed', 'cancelled'])
        .order('created_at', ascending: false);
    return rows.map<Booking>((row) => Booking.fromMap(row, row['id'])).toList();
  }
}
