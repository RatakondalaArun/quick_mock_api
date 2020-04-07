// import 'dart:convert';
import 'dart:io';

import 'collections/mirror_api.dart';
import 'collections/user_api.dart';
import 'response_handlers.dart';

class RequestHandlers {
  ResponseHandlers responseHandlers = ResponseHandlers();

  MirrorApi _mirrorApi;
  UserApi _userApi;

  MirrorApi get mirror => _mirrorApi;
  UserApi get user => _userApi;

  RequestHandlers() {
    _mirrorApi = MirrorApi();
    _userApi = UserApi();
  }

  void handleRandom(HttpRequest request) {
    //returns some random response
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

  void handleOtherRequests(HttpRequest request) {
    //handle other requests
    print(
        'other requests(${request.method}) = ${request.uri.queryParametersAll}');
    responseHandlers.sendResponse(request.response,
        {'success': true, 'data': request.uri.queryParameters});
  }

  //returns data from GET method
  // Map _getGetMethodData(Uri uri) => uri.queryParameters;

  //returns data from POST method
  // Future<Map> _getPostMethodData(HttpRequest request) async {
  //   if (request.headers.contentType.toString() == 'application/json') {
  //     //handles json encoded data
  //     try {
  //       String content = await utf8.decoder.bind(request).join();
  //       Map data = jsonDecode(content) as Map;
  //       return data;
  //     } catch (e) {
  //       throw new InternalServerException();
  //     }
  //   } else if (request.headers.contentType.toString() ==
  //       'application/x-www-form-urlencoded') {
  //     //handles x-www-form-urlendoced data
  //     try {
  //       String content = await utf8.decoder.bind(request).join();
  //       Map data = Uri(query: content).queryParameters;
  //       return data;
  //     } catch (e) {
  //       throw new InternalServerException();
  //     }
  //   } else {
  //     //when format is not correct
  //     throw new BadRequestException();
  //   }
  // }
}
