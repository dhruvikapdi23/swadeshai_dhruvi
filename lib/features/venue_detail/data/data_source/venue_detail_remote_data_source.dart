import 'dart:convert';

import 'package:swadesai_dhruvi/core/network/api_client.dart';
import 'package:swadesai_dhruvi/core/network/api_endpoints.dart';
import 'package:swadesai_dhruvi/features/venue_detail/data/model/slot_model.dart';
import 'package:swadesai_dhruvi/features/venue_detail/domain/entity/booking_input.dart';
import 'package:swadesai_dhruvi/features/venues/data/model/venue_model.dart';

class VenueDetailRemoteDataSource {
  VenueDetailRemoteDataSource(this._client);

  final ApiClient _client;

  /// GET /venues/{id} — single venue (optional; list item may suffice).
  Future<VenueModel> getVenue(String venueId) async {
    final response = await _client.get('${ApiEndpoints.venues}/$venueId');
    if (response.statusCode != 200) {
      throw Exception('Failed to load venue (${response.statusCode})');
    }
    return VenueModel.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  /// GET /venues/{id}/slots?date=YYYY-MM-DD
  Future<List<SlotModel>> getSlots({
    required String venueId,
    required String date,
  }) async {
    final response = await _client.get(
      ApiEndpoints.venueSlots(venueId),
      queryParameters: {'date': date},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load slots (${response.statusCode})');
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((item) => SlotModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// POST /bookings
  Future<void> createBooking(BookingInput input) async {
    final response = await _client.post(
      ApiEndpoints.bookings,
      userId: input.userId,
      body: {
        'venueId': input.venueId,
        'slotId': input.slotId,
        'date': input.date,
      },
    );
    if (response.statusCode == 409) {
      final body = jsonDecode(response.body) as Map<String, dynamic>?;
      throw Exception(
        body?['error'] as String? ??
            'This slot was just booked by someone else. Please pick another.',
      );
    }
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Booking failed (${response.statusCode})');
    }
  }
}
