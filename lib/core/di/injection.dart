import 'package:swadesai_dhruvi/core/network/api_client.dart';
import 'package:swadesai_dhruvi/core/services/fcm_service.dart';
import 'package:swadesai_dhruvi/core/services/session_service.dart';
import 'package:swadesai_dhruvi/features/auth/data/data_source/users_remote_data_source.dart';
import 'package:swadesai_dhruvi/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:swadesai_dhruvi/features/auth/domain/use_cases/auth_usecases.dart';
import 'package:swadesai_dhruvi/features/bookings/data/data_source/bookings_remote_data_source.dart';
import 'package:swadesai_dhruvi/features/bookings/data/repositories/bookings_repository_impl.dart';
import 'package:swadesai_dhruvi/features/bookings/domain/use_cases/bookings_usecases.dart';
import 'package:swadesai_dhruvi/features/venue_detail/data/data_source/venue_detail_remote_data_source.dart';
import 'package:swadesai_dhruvi/features/venue_detail/data/repositories/venue_detail_repository_impl.dart';
import 'package:swadesai_dhruvi/features/venue_detail/domain/use_cases/venue_detail_usecases.dart';
import 'package:swadesai_dhruvi/features/venues/data/data_source/venues_remote_data_source.dart';
import 'package:swadesai_dhruvi/features/venues/data/repositories/venues_repository_impl.dart';
import 'package:swadesai_dhruvi/features/venues/domain/use_cases/venues_usecases.dart';

class Injection {
  Injection._();

  static final sessionService = SessionService();
  static final fcmService = FcmService();
  static final apiClient = ApiClient(session: sessionService);

  static final usersDataSource = UsersRemoteDataSource(apiClient);
  static final authRepository = AuthRepositoryImpl(usersDataSource);
  static final registerUseCase = RegisterUseCase(authRepository);
  static final loginUseCase = LoginUseCase(authRepository);

  static final venuesDataSource = VenuesRemoteDataSource(apiClient);
  static final venuesRepository = VenuesRepositoryImpl(venuesDataSource);
  static final getVenuesUseCase = GetVenuesUseCase(venuesRepository);

  static final venueDetailDataSource = VenueDetailRemoteDataSource(apiClient);
  static final venueDetailRepository = VenueDetailRepositoryImpl(venueDetailDataSource);
  static final getVenueUseCase = GetVenueUseCase(venueDetailRepository);
  static final getSlotsUseCase = GetSlotsUseCase(venueDetailRepository);
  static final createBookingUseCase = CreateBookingUseCase(venueDetailRepository);

  static final bookingsDataSource = BookingsRemoteDataSource(apiClient);
  static final bookingsRepository = BookingsRepositoryImpl(bookingsDataSource);
  static final getUserBookingsUseCase = GetUserBookingsUseCase(bookingsRepository);
  static final cancelBookingUseCase = CancelBookingUseCase(bookingsRepository);
}
