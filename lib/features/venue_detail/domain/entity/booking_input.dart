class BookingInput {
  const BookingInput({
    required this.userId,
    required this.venueId,
    required this.slotId,
    required this.date,
  });

  final String userId;
  final String venueId;
  final String slotId;
  final String date;
}
