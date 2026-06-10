class SlotAlreadyTakenException implements Exception {
  const SlotAlreadyTakenException([this.message = 'This slot was just booked by someone else.']);

  final String message;

  @override
  String toString() => message;
}

class NotFoundException implements Exception {
  const NotFoundException([this.message = 'Resource not found.']);

  final String message;

  @override
  String toString() => message;
}

class ValidationException implements Exception {
  const ValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}
