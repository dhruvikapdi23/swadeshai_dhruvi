enum SlotStatus { available, booked }

class SlotEntity {
  const SlotEntity({
    required this.id,
    required this.venueId,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  final String id;
  final String venueId;
  final DateTime startTime;
  final DateTime endTime;
  final SlotStatus status;
}
