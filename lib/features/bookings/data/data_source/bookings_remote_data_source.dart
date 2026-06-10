import 'dart:convert';

import 'package:swadesai_dhruvi/core/network/api_client.dart';
import 'package:swadesai_dhruvi/core/network/api_endpoints.dart';
import 'package:swadesai_dhruvi/features/bookings/data/model/booking_model.dart';

class BookingsRemoteDataSource {
  BookingsRemoteDataSource(this._client);

  final ApiClient _client;

  /// GET /users/{id}/bookings
  Future<List<BookingModel>> getUserBookings(String userId) async {
    final response = await _client.get(
      ApiEndpoints.userBookings(userId),
      userId: userId,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load bookings (${response.statusCode})');
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((item) => BookingModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// DELETE /bookings/{id}
  Future<void> cancelBooking({
    required String bookingId,
    required String userId,
  }) async {
    final response = await _client.delete(
      ApiEndpoints.booking(bookingId),
      userId: userId,
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to cancel booking (${response.statusCode})');
    }
  }
}
