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
    this.isBooking = false,
    this.bookingFeedback,
  });

  final ViewState status;
  final VenueEntity? venue;
  final List<SlotEntity> slots;
  final String? selectedDate;
  final String? errorMessage;
  final bool isBooking;
  final String? bookingFeedback;

  int get availableCount => slots.where((s) => s.status == SlotStatus.available).length;

  VenueDetailState copyWith({
    ViewState? status,
    VenueEntity? venue,
    List<SlotEntity>? slots,
    String? selectedDate,
    String? errorMessage,
    bool? isBooking,
    String? bookingFeedback,
    bool clearError = false,
    bool clearFeedback = false,
  }) {
    return VenueDetailState(
      status: status ?? this.status,
      venue: venue ?? this.venue,
      slots: slots ?? this.slots,
      selectedDate: selectedDate ?? this.selectedDate,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isBooking: isBooking ?? this.isBooking,
      bookingFeedback: clearFeedback ? null : (bookingFeedback ?? this.bookingFeedback),
    );
  }

  @override
  List<Object?> get props =>
      [status, venue, slots, selectedDate, errorMessage, isBooking, bookingFeedback];
}
