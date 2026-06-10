class BookingEntity {
  const BookingEntity({
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
}
