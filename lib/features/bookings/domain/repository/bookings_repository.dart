import 'package:swadesai_dhruvi/features/bookings/domain/entity/booking_entity.dart';

abstract class BookingsRepository {
  Future<List<BookingEntity>> getUserBookings(String userId);

  Future<void> cancelBooking({
    required String bookingId,
    required String userId,
  });
}
