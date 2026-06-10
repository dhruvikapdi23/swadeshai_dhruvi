import 'package:swadesai_dhruvi/features/venue_detail/domain/entity/booking_input.dart';
import 'package:swadesai_dhruvi/features/venue_detail/domain/entity/slot_entity.dart';
import 'package:swadesai_dhruvi/features/venues/domain/entity/venue_entity.dart';

abstract class VenueDetailRepository {
  Future<VenueEntity> getVenue(String venueId);

  Future<List<SlotEntity>> getSlots({
    required String venueId,
    required String date,
  });

  Future<void> createBooking(BookingInput input);
}
