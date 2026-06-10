import 'package:swadesai_dhruvi/features/bookings/domain/entity/booking_entity.dart';
import 'package:swadesai_dhruvi/features/bookings/domain/repository/bookings_repository.dart';

class GetUserBookingsUseCase {
  GetUserBookingsUseCase(this._repository);

  final BookingsRepository _repository;

  Future<List<BookingEntity>> call(String userId) =>
      _repository.getUserBookings(userId);
}

class CancelBookingUseCase {
  CancelBookingUseCase(this._repository);

  final BookingsRepository _repository;

  Future<void> call({
    required String bookingId,
    required String userId,
  }) =>
      _repository.cancelBooking(bookingId: bookingId, userId: userId);
}
