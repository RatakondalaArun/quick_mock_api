import 'dart:convert';

abstract class QuickMockApiException implements Exception {
  final int statusCode;
  final String fix;
  final String message;
  final bool success;
  QuickMockApiException(this.statusCode, this.fix, this.message, this.success);
  String toJson() => jsonEncode(toMap());
  Map toMap();
}

class InternalServerException implements QuickMockApiException {
  final int statusCode = 500;
  final String fix = 'internal server error';
  final String message = 'Internal server error';
  final bool success = false;
  InternalServerException() : super();

  @override
  Map toMap() => {
        'success': success,
        'message': message,
        'fix': fix,
        'status_code': statusCode
      };

  @override
  String toJson() => jsonEncode(toMap());
}

class BadRequestException implements QuickMockApiException {
  final int statusCode = 400;
  final String fix = 'encode to a JSON string or x-www-form-urlendoced';
  final String message =
      'Bad Request, post data is not in \'application/json\' or x-www-form-urlendoced  format';
  final bool success = false;
  BadRequestException() : super();

  @override
  Map toMap() => {
        'success': success,
        'message': message,
        'fix': fix,
        'status_code': statusCode
      };

  @override
  String toJson() => jsonEncode(toMap());
}
