import 'package:equatable/equatable.dart';
import 'package:swadesai_dhruvi/core/view_state.dart';
import 'package:swadesai_dhruvi/features/venues/domain/entity/venue_entity.dart';

class VenuesState extends Equatable {
  const VenuesState({
    this.status = ViewState.idle,
    this.venues = const [],
    this.errorMessage,
  });

  final ViewState status;
  final List<VenueEntity> venues;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, venues, errorMessage];
}
