import 'package:swadesai_dhruvi/features/venue_detail/domain/entity/booking_input.dart';
import 'package:swadesai_dhruvi/features/venue_detail/domain/entity/slot_entity.dart';
import 'package:swadesai_dhruvi/features/venue_detail/domain/repository/venue_detail_repository.dart';
import 'package:swadesai_dhruvi/features/venues/domain/entity/venue_entity.dart';

class GetVenueUseCase {
  GetVenueUseCase(this._repository);

  final VenueDetailRepository _repository;

  Future<VenueEntity> call(String venueId) => _repository.getVenue(venueId);
}

class GetSlotsUseCase {
  GetSlotsUseCase(this._repository);

  final VenueDetailRepository _repository;

  Future<List<SlotEntity>> call({
    required String venueId,
    required String date,
  }) =>
      _repository.getSlots(venueId: venueId, date: date);
}

class CreateBookingUseCase {
  CreateBookingUseCase(this._repository);

  final VenueDetailRepository _repository;

  Future<void> call(BookingInput input) => _repository.createBooking(input);
}
