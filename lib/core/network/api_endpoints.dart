abstract final class ApiEndpoints {
  static const authRegister = '/auth/register';
  static const authLogin = '/auth/login';
  static const venues = '/venues';
  static String venueSlots(String venueId) => '/venues/$venueId/slots';
  static const bookings = '/bookings';
  static String userBookings(String userId) => '/users/$userId/bookings';
  static String booking(String bookingId) => '/bookings/$bookingId';
}
