import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swadesai_dhruvi/core/view_state.dart';
import 'package:swadesai_dhruvi/features/bookings/domain/use_cases/bookings_usecases.dart';
import 'package:swadesai_dhruvi/features/bookings/presentation/bloc/my_bookings_state.dart';

class MyBookingsCubit extends Cubit<MyBookingsState> {
  MyBookingsCubit({
    required GetUserBookingsUseCase getUserBookingsUseCase,
    required CancelBookingUseCase cancelBookingUseCase,
    required this.userId,
  })  : _getUserBookingsUseCase = getUserBookingsUseCase,
        _cancelBookingUseCase = cancelBookingUseCase,
        super(const MyBookingsState());

  final GetUserBookingsUseCase _getUserBookingsUseCase;
  final CancelBookingUseCase _cancelBookingUseCase;
  final String userId;

  Future<void> loadBookings() async {
    if (isClosed) return;
    emit(const MyBookingsState(status: ViewState.loading));
    try {
      final bookings = await _getUserBookingsUseCase(userId);
      if (isClosed) return;
      emit(MyBookingsState(
        status: bookings.isEmpty ? ViewState.empty : ViewState.success,
        bookings: bookings,
      ));
    } catch (_) {
      if (isClosed) return;
      emit(const MyBookingsState(
        status: ViewState.error,
        errorMessage: 'Could not load bookings.',
      ));
    }
  }

  Future<bool> cancelBooking(String bookingId) async {
    if (isClosed) return false;
    emit(state.copyWith(cancellingId: bookingId));
    try {
      await _cancelBookingUseCase(bookingId: bookingId, userId: userId);
      await loadBookings();
      return true;
    } catch (_) {
      if (isClosed) return false;
      emit(state.copyWith(
        clearCancelling: true,
        errorMessage: 'Could not cancel booking.',
      ));
      return false;
    }
  }
}
