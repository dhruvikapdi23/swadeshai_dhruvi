import 'package:equatable/equatable.dart';
import 'package:swadesai_dhruvi/core/view_state.dart';
import 'package:swadesai_dhruvi/features/bookings/domain/entity/booking_entity.dart';

class MyBookingsState extends Equatable {
  const MyBookingsState({
    this.status = ViewState.idle,
    this.bookings = const [],
    this.errorMessage,
    this.cancellingId,
  });

  final ViewState status;
  final List<BookingEntity> bookings;
  final String? errorMessage;
  final String? cancellingId;

  MyBookingsState copyWith({
    ViewState? status,
    List<BookingEntity>? bookings,
    String? errorMessage,
    String? cancellingId,
    bool clearCancelling = false,
  }) {
    return MyBookingsState(
      status: status ?? this.status,
      bookings: bookings ?? this.bookings,
      errorMessage: errorMessage ?? this.errorMessage,
      cancellingId: clearCancelling ? null : (cancellingId ?? this.cancellingId),
    );
  }

  @override
  List<Object?> get props => [status, bookings, errorMessage, cancellingId];
}
