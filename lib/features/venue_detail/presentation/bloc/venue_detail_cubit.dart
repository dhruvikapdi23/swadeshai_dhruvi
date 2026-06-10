import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:swadesai_dhruvi/core/view_state.dart';
import 'package:swadesai_dhruvi/features/venue_detail/domain/entity/booking_input.dart';
import 'package:swadesai_dhruvi/features/venue_detail/domain/entity/slot_entity.dart';
import 'package:swadesai_dhruvi/features/venue_detail/domain/use_cases/venue_detail_usecases.dart';
import 'package:swadesai_dhruvi/features/venue_detail/presentation/bloc/venue_detail_state.dart';

class VenueDetailCubit extends Cubit<VenueDetailState> {
  VenueDetailCubit({
    required GetVenueUseCase getVenueUseCase,
    required GetSlotsUseCase getSlotsUseCase,
    required CreateBookingUseCase createBookingUseCase,
    required this.venueId,
    required this.userId,
  })  : _getVenueUseCase = getVenueUseCase,
        _getSlotsUseCase = getSlotsUseCase,
        _createBookingUseCase = createBookingUseCase,
        super(VenueDetailState(
          selectedDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        ));

  final GetVenueUseCase _getVenueUseCase;
  final GetSlotsUseCase _getSlotsUseCase;
  final CreateBookingUseCase _createBookingUseCase;
  final String venueId;
  final String userId;

  Future<void> initialize() async {
    if (isClosed) return;
    emit(state.copyWith(status: ViewState.loading, clearError: true));
    try {
      final venue = await _getVenueUseCase(venueId);
      if (isClosed) return;
      emit(state.copyWith(venue: venue));
      await loadSlots(silent: true);
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(
        status: ViewState.error,
        errorMessage: 'Could not load venue.',
      ));
    }
  }

  Future<void> setDate(DateTime date) async {
    emit(state.copyWith(
      selectedDate: DateFormat('yyyy-MM-dd').format(date),
      clearFeedback: true,
    ));
    await loadSlots();
  }

  /// [silent] keeps current UI while refreshing — used for polling.
  Future<void> loadSlots({bool silent = false}) async {
    final date = state.selectedDate;
    if (date == null) return;

    if (isClosed) return;
    if (!silent) {
      emit(state.copyWith(status: ViewState.loading, clearError: true));
    }
    try {
      final slots = await _getSlotsUseCase(venueId: venueId, date: date);
      if (isClosed) return;
      emit(state.copyWith(
        slots: slots,
        status: slots.isEmpty ? ViewState.empty : ViewState.success,
      ));
    } catch (_) {
      if (isClosed) return;
      if (!silent) {
        emit(state.copyWith(
          status: ViewState.error,
          errorMessage: 'Could not load slots.',
        ));
      }
    }
  }

  /// Returns true when booking succeeded.
  Future<bool> bookSlot(SlotEntity slot) async {
    if (slot.status != SlotStatus.available || state.isBooking) return false;
    final date = state.selectedDate;
    if (date == null) return false;

    emit(state.copyWith(isBooking: true, clearFeedback: true));
    try {
      await _createBookingUseCase(BookingInput(
        userId: userId,
        venueId: venueId,
        slotId: slot.id,
        date: date,
      ));
      await loadSlots(silent: true);
      if (isClosed) return false;
      emit(state.copyWith(
        isBooking: false,
        bookingFeedback: 'Booking confirmed!',
      ));
      return true;
    } catch (error) {
      final msg = error.toString().replaceFirst('Exception: ', '');
      final isTaken = msg.toLowerCase().contains('taken') ||
          msg.toLowerCase().contains('booked') ||
          msg.contains('409');
      if (isTaken) {
        await loadSlots(silent: true);
        if (isClosed) return false;
        emit(state.copyWith(
          isBooking: false,
          bookingFeedback:
              'This slot was just booked by someone else. Pick another slot.',
        ));
      } else {
        if (isClosed) return false;
        emit(state.copyWith(isBooking: false, bookingFeedback: msg));
      }
      return false;
    }
  }
}
