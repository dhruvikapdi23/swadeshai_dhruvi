import 'dart:convert';

import 'package:swadesai_dhruvi/core/network/api_client.dart';
import 'package:swadesai_dhruvi/core/network/api_endpoints.dart';
import 'package:swadesai_dhruvi/features/venues/data/model/venue_model.dart';

class VenuesRemoteDataSource {
  VenuesRemoteDataSource(this._client);

  final ApiClient _client;

  /// GET /venues
  Future<List<VenueModel>> getVenues() async {
    final response = await _client.get(ApiEndpoints.venues);
    if (response.statusCode != 200) {
      throw Exception('Failed to load venues (${response.statusCode})');
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((item) => VenueModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
