enum VenueType { badminton, turf, multiSport }

class VenueEntity {
  const VenueEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.description,
    required this.pricePerHour,
  });

  final String id;
  final String name;
  final VenueType type;
  final String location;
  final String description;
  final int pricePerHour;
}
