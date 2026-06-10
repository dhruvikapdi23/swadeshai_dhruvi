import 'package:swadesai_dhruvi/features/bookings/domain/entity/booking_entity.dart';

class BookingModel {
  const BookingModel({
    required this.id,
    required this.userId,
    required this.venueId,
    required this.slotId,
    required this.slotStart,
    required this.slotEnd,
    required this.venueName,
  });

  final String id;
  final String userId;
  final String venueId;
  final String slotId;
  final DateTime slotStart;
  final DateTime slotEnd;
  final String venueName;

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      venueId: json['venueId'] as String? ?? '',
      slotId: json['slotId'] as String? ?? '',
      slotStart: DateTime.parse(json['slotStart'] as String),
      slotEnd: DateTime.parse(json['slotEnd'] as String),
      venueName: json['venueName'] as String? ?? '',
    );
  }

  BookingEntity toEntity() => BookingEntity(
        id: id,
        userId: userId,
        venueId: venueId,
        slotId: slotId,
        slotStart: slotStart,
        slotEnd: slotEnd,
        venueName: venueName,
      );
}
