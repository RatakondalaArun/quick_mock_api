import 'dart:io';

import '../exception/exceptions.dart';
import '../mock/mock_user.dart';
import '../response_handlers.dart';

class UserApi {
  ResponseHandlers responseHandlers;

  UserApi() {
    responseHandlers = ResponseHandlers();
  }

  void handleGetuserWithId(HttpRequest request) {
    Map data = _getGetMethodData(request.uri);
    Map response = {};
    int id;

    try {
      try {
        //search if 'id' key exists in data
        if (data.containsKey('id')) {
          //may throw FormatExeption if id format is not in int
          id = int.parse(data['id']).abs();
          response = {
            'success': true,
            'status_code': 200,
            //generate a MockUser with id
            'data': MockUser.generateWithId(id).toMap(),
          };
        } else {
          //throw BadRequestException if key doesn't exist in data
          throw new BadRequestException();
        }
      } catch (e) {
        if (e is BadRequestException || e is FormatException) {
          //FormatException is also a BadRequestException
          throw new BadRequestException();
        } else {
          //other Exceptions will be considered as internal exceptions
          throw new InternalServerException();
        }
      }
    } catch (e) {
      response = e.toMap();
    }
    responseHandlers.sendResponse(
      request.response,
      response,
      statusCode: 200,
    );
  }

  void handleSingleUser(HttpRequest request) {
    responseHandlers.sendResponse(
      request.response,
      {
        'success': true,
        'status_code': 200,
        'data': MockUser.generateAsMap(),
      },
      statusCode: 200,
    );
  }

  void handlemultiUser(HttpRequest request) {
    int limit = 20;
    int statusCode = 200;
    Map data = {};

    if (request.uri.queryParameters.containsKey('limit')) {
      try {
        try {
          limit = int.parse(request.uri.queryParameters['limit']);
          if (limit > 100) limit = 100;
          if (limit < 1) limit = 1;
          data = {
            'success': true,
            'status_code': statusCode,
            'total_results': limit,
            'data': MockUser.generateAsMap(limit: limit),
          };
        } catch (e) {
          throw new BadRequestException();
        }
      } catch (e) {
        data = e.toMap();
        statusCode = e.statusCode;
      }
    } else {
      data = {
        'success': true,
        'status_code': statusCode,
        'total_results': limit,
        'data': MockUser.generateAsMap(limit: limit),
      };
    }
    responseHandlers.sendResponse(
      request.response,
      data,
      statusCode: statusCode,
    );
  }

  //returns data from GET method
  Map _getGetMethodData(Uri uri) => uri.queryParameters;
}
