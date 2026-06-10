import 'package:swadesai_dhruvi/features/venues/domain/entity/venue_entity.dart';
import 'package:swadesai_dhruvi/features/venues/domain/repository/venues_repository.dart';

class GetVenuesUseCase {
  GetVenuesUseCase(this._repository);

  final VenuesRepository _repository;

  Future<List<VenueEntity>> call() => _repository.getVenues();
}
