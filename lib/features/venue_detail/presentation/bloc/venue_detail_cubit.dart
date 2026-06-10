import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swadesai_dhruvi/features/venue_detail/domain/use_cases/venue_detail_usecases.dart';
import 'package:swadesai_dhruvi/features/venue_detail/presentation/bloc/venue_detail_state.dart';

class VenueDetailCubit extends Cubit<VenueDetailState> {
  VenueDetailCubit({
    required GetVenueUseCase getVenueUseCase,
    required GetSlotsUseCase getSlotsUseCase,
    required CreateBookingUseCase createBookingUseCase,
  }) : super(const VenueDetailState());
}
