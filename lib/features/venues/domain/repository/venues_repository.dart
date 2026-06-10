import 'package:swadesai_dhruvi/features/venues/domain/entity/venue_entity.dart';

abstract class VenuesRepository {
  Future<List<VenueEntity>> getVenues();
}
