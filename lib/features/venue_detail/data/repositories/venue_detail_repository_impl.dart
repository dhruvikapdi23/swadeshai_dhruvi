import 'package:swadesai_dhruvi/features/venue_detail/data/data_source/venue_detail_remote_data_source.dart';
import 'package:swadesai_dhruvi/features/venue_detail/domain/entity/booking_input.dart';
import 'package:swadesai_dhruvi/features/venue_detail/domain/entity/slot_entity.dart';
import 'package:swadesai_dhruvi/features/venue_detail/domain/repository/venue_detail_repository.dart';
import 'package:swadesai_dhruvi/features/venues/domain/entity/venue_entity.dart';

class VenueDetailRepositoryImpl implements VenueDetailRepository {
  VenueDetailRepositoryImpl(this._dataSource);

  final VenueDetailRemoteDataSource _dataSource;

  @override
  Future<VenueEntity> getVenue(String venueId) async {
    final model = await _dataSource.getVenue(venueId);
    return model.toEntity();
  }

  @override
  Future<List<SlotEntity>> getSlots({
    required String venueId,
    required String date,
  }) async {
    final models = await _dataSource.getSlots(venueId: venueId, date: date);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> createBooking(BookingInput input) =>
      _dataSource.createBooking(input);
}
