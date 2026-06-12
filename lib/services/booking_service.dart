import 'dart:async';
import '../models/booking_model.dart';

/// Simple in-memory booking store — local replacement for Cloud Firestore.
/// Shared static state so passenger and driver services see the same data
/// when running in the same process (e.g., during development/testing).
class BookingService {
  static final Map<String, Booking> _bookings = {};
  static final Map<String, List<void Function(Booking?)>> _singleListeners = {};
  static final List<void Function()> _collectionListeners = [];

  // ── Internal helpers ────────────────────────────────────────────────────────

  void _notifySingle(String bookingId, Booking? booking) {
    for (final cb in List.of(_singleListeners[bookingId] ?? [])) {
      cb(booking);
    }
  }

  void _notifyCollection() {
    for (final cb in List.of(_collectionListeners)) {
      cb();
    }
  }

  // ── Stream pending bookings (for driver to see available requests) ───────────

  Stream<List<Booking>> streamPendingBookings() {
    late StreamController<List<Booking>> controller;
    void Function()? listener;
    controller = StreamController<List<Booking>>(
      onListen: () {
        // Emit current state immediately
        controller.add(_pendingList());
        listener = () => controller.add(_pendingList());
        _collectionListeners.add(listener!);
      },
      onCancel: () {
        if (listener != null) _collectionListeners.remove(listener);
        controller.close();
      },
    );
    return controller.stream;
  }

  List<Booking> _pendingList() {
    return _bookings.values
        .where((b) => b.status == BookingStatus.pending)
        .toList();
  }

  // ── Accept a booking ────────────────────────────────────────────────────────

  Future<bool> acceptBooking(
    String bookingId,
    String driverId,
    String driverName,
    String plateNumber,
  ) async {
    try {
      final booking = _bookings[bookingId];
      if (booking == null) return false;
      final updated = booking.copyWith(
        status: BookingStatus.accepted,
        driverId: driverId,
        driverName: driverName,
        plateNumber: plateNumber,
      );
      _bookings[bookingId] = updated;
      _notifySingle(bookingId, updated);
      _notifyCollection();
      return true;
    } catch (e) {
      print('Error accepting booking: $e');
      return false;
    }
  }

  // ── Update trip status ──────────────────────────────────────────────────────

  Future<bool> updateTripStatus(String bookingId, BookingStatus status) async {
    try {
      final booking = _bookings[bookingId];
      if (booking == null) return false;
      final updated = booking.copyWith(status: status);
      _bookings[bookingId] = updated;
      _notifySingle(bookingId, updated);
      _notifyCollection();
      return true;
    } catch (e) {
      print('Error updating status: $e');
      return false;
    }
  }

  // ── Stream a single booking by ID ──────────────────────────────────────────

  Stream<Booking?> streamBooking(String bookingId) async* {
    yield _bookings[bookingId];
    await for (final booking in _singleBookingUpdates(bookingId)) {
      yield booking;
    }
  }

  Stream<Booking?> _singleBookingUpdates(String bookingId) {
    late StreamController<Booking?> controller;
    void Function(Booking?)? listener;
    controller = StreamController<Booking?>(
      onListen: () {
        listener = (b) => controller.add(b);
        _singleListeners.putIfAbsent(bookingId, () => []);
        _singleListeners[bookingId]!.add(listener!);
      },
      onCancel: () {
        if (listener != null) _singleListeners[bookingId]?.remove(listener);
        controller.close();
      },
    );
    return controller.stream;
  }

  // ── Stream active booking for a specific driver ─────────────────────────────

  Stream<Booking?> streamActiveBooking(String driverId) {
    final activeStatuses = {
      BookingStatus.accepted,
      BookingStatus.pickedUp,
    };

    late StreamController<Booking?> controller;
    void Function()? listener;
    controller = StreamController<Booking?>(
      onListen: () {
        controller.add(_activeBookingFor(driverId, activeStatuses));
        listener = () =>
            controller.add(_activeBookingFor(driverId, activeStatuses));
        _collectionListeners.add(listener!);
      },
      onCancel: () {
        if (listener != null) _collectionListeners.remove(listener);
        controller.close();
      },
    );
    return controller.stream;
  }

  Booking? _activeBookingFor(
      String driverId, Set<BookingStatus> activeStatuses) {
    try {
      return _bookings.values.firstWhere(
        (b) => b.driverId == driverId && activeStatuses.contains(b.status),
      );
    } catch (_) {
      return null;
    }
  }

  // ── Cancel a booking ────────────────────────────────────────────────────────

  Future<bool> cancelBooking(String bookingId) async {
    return updateTripStatus(bookingId, BookingStatus.cancelled);
  }

  // ── Create a booking (used by passenger side in shared context) ─────────────

  Future<String?> createBooking(Booking booking) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final stored = booking.copyWith(); // copy fields
      _bookings[id] = Booking(
        id: id,
        passengerId: stored.passengerId,
        driverId: stored.driverId,
        pickupAddress: stored.pickupAddress,
        dropoffAddress: stored.dropoffAddress,
        fare: stored.fare,
        status: stored.status,
        createdAt: stored.createdAt,
        driverName: stored.driverName,
        driverPhone: stored.driverPhone,
        plateNumber: stored.plateNumber,
      );
      _notifyCollection();
      return id;
    } catch (e) {
      print('Error creating booking: $e');
      return null;
    }
  }
}
