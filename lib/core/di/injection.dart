import 'package:swadesai_dhruvi/core/network/api_client.dart';
import 'package:swadesai_dhruvi/features/bookings/data/data_source/bookings_remote_data_source.dart';
import 'package:swadesai_dhruvi/features/bookings/data/repositories/bookings_repository_impl.dart';
import 'package:swadesai_dhruvi/features/bookings/domain/use_cases/bookings_usecases.dart';
import 'package:swadesai_dhruvi/features/venue_detail/data/data_source/venue_detail_remote_data_source.dart';
import 'package:swadesai_dhruvi/features/venue_detail/data/repositories/venue_detail_repository_impl.dart';
import 'package:swadesai_dhruvi/features/venue_detail/domain/use_cases/venue_detail_usecases.dart';
import 'package:swadesai_dhruvi/features/venues/data/data_source/venues_remote_data_source.dart';
import 'package:swadesai_dhruvi/features/venues/data/repositories/venues_repository_impl.dart';
import 'package:swadesai_dhruvi/features/venues/domain/use_cases/venues_usecases.dart';

/// Manual DI — wire repositories & use cases here (no get_it yet).
class Injection {
  Injection._();

  static final apiClient = ApiClient();

  // Venues
  static final venuesDataSource = VenuesRemoteDataSource(apiClient);
  static final venuesRepository = VenuesRepositoryImpl(venuesDataSource);
  static final getVenuesUseCase = GetVenuesUseCase(venuesRepository);

  // Venue detail (slots + book)
  static final venueDetailDataSource = VenueDetailRemoteDataSource(apiClient);
  static final venueDetailRepository = VenueDetailRepositoryImpl(venueDetailDataSource);
  static final getVenueUseCase = GetVenueUseCase(venueDetailRepository);
  static final getSlotsUseCase = GetSlotsUseCase(venueDetailRepository);
  static final createBookingUseCase = CreateBookingUseCase(venueDetailRepository);

  // My bookings
  static final bookingsDataSource = BookingsRemoteDataSource(apiClient);
  static final bookingsRepository = BookingsRepositoryImpl(bookingsDataSource);
  static final getUserBookingsUseCase = GetUserBookingsUseCase(bookingsRepository);
  static final cancelBookingUseCase = CancelBookingUseCase(bookingsRepository);
}
