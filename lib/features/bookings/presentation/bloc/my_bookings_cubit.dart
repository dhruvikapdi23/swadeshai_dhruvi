import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swadesai_dhruvi/features/bookings/domain/use_cases/bookings_usecases.dart';
import 'package:swadesai_dhruvi/features/bookings/presentation/bloc/my_bookings_state.dart';

class MyBookingsCubit extends Cubit<MyBookingsState> {
  MyBookingsCubit({
    required GetUserBookingsUseCase getUserBookingsUseCase,
    required CancelBookingUseCase cancelBookingUseCase,
  }) : super(const MyBookingsState());
}
