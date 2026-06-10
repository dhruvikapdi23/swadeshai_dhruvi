import 'package:equatable/equatable.dart';
import 'package:swadesai_dhruvi/core/view_state.dart';
import 'package:swadesai_dhruvi/features/venue_detail/domain/entity/slot_entity.dart';
import 'package:swadesai_dhruvi/features/venues/domain/entity/venue_entity.dart';

class VenueDetailState extends Equatable {
  const VenueDetailState({
    this.status = ViewState.idle,
    this.venue,
    this.slots = const [],
    this.selectedDate,
    this.errorMessage,
  });

  final ViewState status;
  final VenueEntity? venue;
  final List<SlotEntity> slots;
  final String? selectedDate;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, venue, slots, selectedDate, errorMessage];
}
