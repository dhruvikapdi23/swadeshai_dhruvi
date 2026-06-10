import 'package:swadesai_dhruvi/features/venue_detail/domain/entity/slot_entity.dart';

class SlotModel {
  const SlotModel({
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

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      id: json['id'] as String,
      venueId: json['venueId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      status: (json['status'] as String) == 'booked'
          ? SlotStatus.booked
          : SlotStatus.available,
    );
  }

  SlotEntity toEntity() => SlotEntity(
        id: id,
        venueId: venueId,
        startTime: startTime,
        endTime: endTime,
        status: status,
      );
}
