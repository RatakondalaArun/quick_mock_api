class QuickMockApi implements Exception {
  final int statusCode;
  final String fix;
  final String message;
  final bool success;
  QuickMockApi(this.statusCode, this.fix, this.message, this.success);
}

class InternalServerException implements QuickMockApi {
  final int statusCode = 500;
  final String fix = 'internal server error';
  final String message = 'Internal server error';
  final bool success = false;
  InternalServerException() : super();

  Map toMap() => {
        'success': success,
        'message': message,
        'fix': fix,
        'status_code': statusCode
      };
}

class BadRequestException implements QuickMockApi {
  final int statusCode = 400;
  final String fix = 'encode to a JSON string or x-www-form-urlendoced';
  final String message =
      'Bad Request, post data is not in \'application/json\' or x-www-form-urlendoced  format';
  final bool success = false;
  BadRequestException() : super();

  Map toMap() => {
        'success': success,
        'message': message,
        'fix': fix,
        'status_code': statusCode
      };
}
