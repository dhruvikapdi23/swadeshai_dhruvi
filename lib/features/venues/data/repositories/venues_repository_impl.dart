import 'package:swadesai_dhruvi/features/venues/data/data_source/venues_remote_data_source.dart';
import 'package:swadesai_dhruvi/features/venues/domain/entity/venue_entity.dart';
import 'package:swadesai_dhruvi/features/venues/domain/repository/venues_repository.dart';

class VenuesRepositoryImpl implements VenuesRepository {
  VenuesRepositoryImpl(this._dataSource);

  final VenuesRemoteDataSource _dataSource;

  @override
  Future<List<VenueEntity>> getVenues() async {
    final models = await _dataSource.getVenues();
    return models.map((model) => model.toEntity()).toList();
  }
}
