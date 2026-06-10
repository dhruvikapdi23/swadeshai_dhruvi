import 'package:swadesai_dhruvi/features/bookings/data/data_source/bookings_remote_data_source.dart';
import 'package:swadesai_dhruvi/features/bookings/domain/entity/booking_entity.dart';
import 'package:swadesai_dhruvi/features/bookings/domain/repository/bookings_repository.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  BookingsRepositoryImpl(this._dataSource);

  final BookingsRemoteDataSource _dataSource;

  @override
  Future<List<BookingEntity>> getUserBookings(String userId) async {
    final models = await _dataSource.getUserBookings(userId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> cancelBooking({
    required String bookingId,
    required String userId,
  }) =>
      _dataSource.cancelBooking(bookingId: bookingId, userId: userId);
}
