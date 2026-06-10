import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swadesai_dhruvi/core/view_state.dart';
import 'package:swadesai_dhruvi/features/venues/domain/use_cases/venues_usecases.dart';
import 'package:swadesai_dhruvi/features/venues/presentation/bloc/venues_state.dart';

class VenuesCubit extends Cubit<VenuesState> {
  VenuesCubit(this._getVenuesUseCase) : super(const VenuesState());

  final GetVenuesUseCase _getVenuesUseCase;

  Future<void> loadVenues() async {
    emit(const VenuesState(status: ViewState.loading));
    try {
      final venues = await _getVenuesUseCase();
      emit(VenuesState(
        status: venues.isEmpty ? ViewState.empty : ViewState.success,
        venues: venues,
      ));
    } catch (_) {
      emit(const VenuesState(
        status: ViewState.error,
        errorMessage: 'Could not load venues.',
      ));
    }
  }
}
