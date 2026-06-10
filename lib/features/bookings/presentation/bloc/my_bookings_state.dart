import 'package:equatable/equatable.dart';
import 'package:swadesai_dhruvi/core/view_state.dart';
import 'package:swadesai_dhruvi/features/bookings/domain/entity/booking_entity.dart';

class MyBookingsState extends Equatable {
  const MyBookingsState({
    this.status = ViewState.idle,
    this.bookings = const [],
    this.errorMessage,
  });

  final ViewState status;
  final List<BookingEntity> bookings;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, bookings, errorMessage];
}
