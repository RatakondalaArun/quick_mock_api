import 'dart:convert';
import 'dart:io';

import 'exception/exceptions.dart';
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

  void handleInvalidPath(HttpRequest request) {
    responseHandlers.sendResponse(
        request.response,
        jsonEncode({
          'success': false,
          'status_code': 404,
          'message': 'path doesn\'t exist',
        }),
        statusCode: 404);
  }

  void _handleGetRequests(HttpRequest request) {
    print('Get request = ${request.uri.queryParametersAll}');
    responseHandlers.sendResponse(
        request.response, jsonEncode(request.uri.queryParameters));
    //todo:handle GET requests
  }

  void _handlePostRequests(HttpRequest request) async {
    print(request.headers.contentType.toString());
    try {
      Map data = await _getPostMethodData(request);
      responseHandlers.sendResponse(request.response, jsonEncode(data));
    } catch (e) {
      if (e is QuickMockApi) {
        responseHandlers.sendResponse(
            request.response,
            jsonEncode({
              'success': e.success,
              'message': e.message,
              'fix': e.fix,
              'status_code': e.statusCode
            }),
            statusCode: e.statusCode);
      } else {
        responseHandlers.sendResponse(request.response, 'Error occured',
            statusCode: 500);
      }
    }
  }

  void handleOtherRequests(HttpRequest request) {
    print(
        'other requests(${request.method}) = ${request.uri.queryParametersAll}');
    responseHandlers.sendResponse(request.response,
        jsonEncode({'success': true, 'data': request.uri.queryParameters}));

    //todo: handle other requests
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
        // responseHandlers.sendResponse(request.response, jsonEncode(data));
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
