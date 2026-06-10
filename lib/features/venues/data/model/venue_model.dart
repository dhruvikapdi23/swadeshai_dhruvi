import 'package:swadesai_dhruvi/features/venues/domain/entity/venue_entity.dart';

class VenueModel {
  const VenueModel({
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

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: _parseType(json['type'] as String),
      location: json['location'] as String,
      description: json['description'] as String,
      pricePerHour: json['pricePerHour'] as int,
    );
  }

  VenueEntity toEntity() => VenueEntity(
        id: id,
        name: name,
        type: type,
        location: location,
        description: description,
        pricePerHour: pricePerHour,
      );

  static VenueType _parseType(String value) => switch (value) {
        'badminton' => VenueType.badminton,
        'turf' => VenueType.turf,
        _ => VenueType.multiSport,
      };
}
