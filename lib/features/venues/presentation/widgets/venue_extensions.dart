import 'package:swadesai_dhruvi/features/venues/domain/entity/venue_entity.dart';

extension VenueDisplay on VenueEntity {
  String get emoji => switch (type) {
        VenueType.badminton => '🏸',
        VenueType.turf => '⚽',
        VenueType.multiSport => '🏟️',
      };

  String get typeLabel => switch (type) {
        VenueType.badminton => 'Badminton',
        VenueType.turf => 'Turf',
        VenueType.multiSport => 'Multi-sport',
      };
}
