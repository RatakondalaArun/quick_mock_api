import 'dart:convert';
import 'dart:io';

import 'exception/exceptions.dart';
import 'mock/mock_user.dart';
import 'response_handlers.dart';

class RequestHandlers {
  ResponseHandlers responseHandlers = ResponseHandlers();

  void handleApiMirror(HttpRequest request) {
    //returns same data that user send
    //check request method
    if (request.method == 'GET') {
      //method == GET gather data from uri
      _handleGetRequests(request);
    } else {
      //method == POST gather data form stream
      _handlePostRequests(request);
    }
    //encode to json and then send it to Responsehandlers
  }

  void handleRandom(HttpRequest request) {
    //returns some random response
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

  void handleInvalidPath(HttpRequest request) {
    responseHandlers.sendResponse(
        request.response,
        {
          'success': false,
          'status_code': 404,
          'message': 'path doesn\'t exist'
        },
        statusCode: 404);
  }

  void _handleGetRequests(HttpRequest request) {
    //handle GET requests
    print('Get request = ${request.uri.queryParametersAll}');
    responseHandlers.sendResponse(
        request.response, _getGetMethodData(request.uri));
  }

  void _handlePostRequests(HttpRequest request) async {
    print(request.headers.contentType.toString());
    try {
      Map data = await _getPostMethodData(request);
      responseHandlers.sendResponse(request.response, data);
    } catch (e) {
      if (e is QuickMockApiException) {
        responseHandlers.sendResponse(
            request.response,
            {
              'success': e.success,
              'message': e.message,
              'fix': e.fix,
              'status_code': e.statusCode
            },
            statusCode: e.statusCode);
      } else {
        responseHandlers.sendResponse(request.response, 'Error occured',
            statusCode: 500);
      }
    }
  }

  void handleOtherRequests(HttpRequest request) {
    //handle other requests
    print(
        'other requests(${request.method}) = ${request.uri.queryParametersAll}');
    responseHandlers.sendResponse(request.response,
        {'success': true, 'data': request.uri.queryParameters});
  }

  //returns data from GET method
  Map _getGetMethodData(Uri uri) => uri.queryParameters;

  //returns data from POST method
  Future<Map> _getPostMethodData(HttpRequest request) async {
    if (request.headers.contentType.toString() == 'application/json') {
      //handles json encoded data
      try {
        String content = await utf8.decoder.bind(request).join();
        Map data = jsonDecode(content) as Map;
        return data;
      } catch (e) {
        throw new InternalServerException();
      }
    } else if (request.headers.contentType.toString() ==
        'application/x-www-form-urlencoded') {
      //handles x-www-form-urlendoced data
      try {
        String content = await utf8.decoder.bind(request).join();
        Map data = Uri(query: content).queryParameters;
        return data;
      } catch (e) {
        throw new InternalServerException();
      }
    } else {
      //when format is not correct
      throw new BadRequestException();
    }
  }
}
