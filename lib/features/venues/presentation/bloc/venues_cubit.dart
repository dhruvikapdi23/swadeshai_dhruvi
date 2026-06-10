import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swadesai_dhruvi/core/di/injection.dart';
import 'package:swadesai_dhruvi/core/network/api_client.dart';
import 'package:swadesai_dhruvi/core/view_state.dart';
import 'package:swadesai_dhruvi/features/venues/domain/use_cases/venues_usecases.dart';
import 'package:swadesai_dhruvi/features/venues/presentation/bloc/venues_state.dart';

class VenuesCubit extends Cubit<VenuesState> {
  VenuesCubit(this._getVenuesUseCase) : super(const VenuesState());

  final GetVenuesUseCase _getVenuesUseCase;

  Future<void> loadVenues() async {
    if (isClosed) return;
    emit(const VenuesState(status: ViewState.loading));
    try {
      final venues = await _getVenuesUseCase();
      if (isClosed) return;
      emit(VenuesState(
        status: venues.isEmpty ? ViewState.empty : ViewState.success,
        venues: venues,
      ));
    } catch (error) {
      if (isClosed) return;
      emit(VenuesState(
        status: ViewState.error,
        errorMessage: mapApiError(error, Injection.apiClient.baseUrl),
      ));
    }
  }
}
